# -*- coding: utf-8 -*-
#
# Copyright (C) 2005-2006 Edgewall Software
# Copyright (C) 2005 Christopher Lenz <cmlenz@gmx.de>
# All rights reserved.
#
# This software is licensed as described in the file COPYING, which
# you should have received as part of this distribution. The terms
# are also available at http://trac.edgewall.org/wiki/TracLicense.
#
# This software consists of voluntary contributions made by many
# individuals. For the exact contribution history, see the revision
# history and logs, available at http://trac.edgewall.org/log/.
#
# Author: Christopher Lenz <cmlenz@gmx.de>

from trac.core import TracError
from trac.versioncontrol import Changeset, Node, Repository, Authorizer, \
                                NoSuchChangeset


_kindmap = {'D': Node.DIRECTORY, 'F': Node.FILE}
_actionmap = {'A': Changeset.ADD, 'C': Changeset.COPY,
              'D': Changeset.DELETE, 'E': Changeset.EDIT,
              'M': Changeset.MOVE}

CACHE_REPOSITORY_DIR = 'repository_dir'
CACHE_YOUNGEST_REV = 'youngest_rev'

CACHE_METADATA_KEYS = (CACHE_REPOSITORY_DIR, CACHE_YOUNGEST_REV)


class CachedRepository(Repository):

    def __init__(self, db, repos, authz, log):
        Repository.__init__(self, repos.name, authz, log)
        self.db = db
        self.repos = repos
        self.sync()

    def close(self):
        self.repos.close()

    def get_changeset(self, rev):
        return CachedChangeset(self.repos.normalize_rev(rev), self.db,
                               self.authz)

    def get_changesets(self, start, stop):
        cursor = self.db.cursor()
        cursor.execute("SELECT rev FROM revision "
                       "WHERE time >= %s AND time < %s "
                       "ORDER BY time", (start, stop))
        for rev, in cursor:
            try:
                if self.authz.has_permission_for_changeset(rev):
                    yield self.get_changeset(rev)
            except NoSuchChangeset:
                pass # skip changesets currently being resync'ed

    def sync(self):
        cursor = self.db.cursor()

        cursor.execute("SELECT name, value FROM system WHERE name IN (%s)" %
                       ','.join(["'%s'" % key for key in CACHE_METADATA_KEYS]))
        metadata = {}
        for name, value in cursor:
            metadata[name] = value
        
        # -- check that we're populating the cache for the correct repository
        repository_dir = metadata.get(CACHE_REPOSITORY_DIR)
        if repository_dir:
            if repository_dir != self.name:
                raise TracError("The 'repository_dir' has changed, "
                                "a 'trac-admin resync' operation is needed.")
        elif repository_dir is None: # no 'repository_dir' stored yet
            cursor.execute("INSERT INTO system (name,value) VALUES (%s,%s)",
                           (CACHE_REPOSITORY_DIR, self.name,))
        else: # 'repository_dir' cleared by a resync
            cursor.execute("UPDATE system SET value=%s WHERE name=%s",
                           (self.name,CACHE_REPOSITORY_DIR))

        # -- retrieve the youngest revision cached so far
        if CACHE_YOUNGEST_REV not in metadata:
            # ''upgrade'' using the legacy `get_youngest_rev_in_cache` method
            self.youngest = self.repos.get_youngest_rev_in_cache(self.db) or ''
            cursor.execute("INSERT INTO system (name, value) VALUES (%s, %s)",
                           (CACHE_YOUNGEST_REV, self.youngest))
            self.log.info('Upgraded cache metadata (youngest_rev=%s)' %
                          self.youngest_rev)
        else:
            self.youngest = metadata[CACHE_YOUNGEST_REV]

        if self.youngest:
            self.youngest = self.repos.normalize_rev(self.youngest)
        else:
            self.youngest = None

        # -- retrieve the youngest revision in the repository
        self.repos.clear()
        repos_youngest = self.repos.youngest_rev

        # -- compare them and try to resync if different
        self.log.info("Check for sync [%s] vs. cached [%s]" %
                      (self. youngest, repos_youngest))
        if self.youngest != repos_youngest:
            if self.youngest:
                next_youngest = self.repos.next_rev(self.youngest)
            else:
                next_youngest = None
                try:
                    next_youngest = self.repos.oldest_rev
                    next_youngest = self.repos.normalize_rev(next_youngest)
                except TracError:
                    pass

            if next_youngest is None: # nothing to cache yet
                return

            # 0. first check if there's no (obvious) resync in progress
            cursor.execute("SELECT rev FROM revision WHERE rev=%s",
                           (str(next_youngest),))
            for rev, in cursor:
                # already there, but in progress, so keep ''previous''
                # notion of 'youngest'
                self.repos.clear(youngest_rev=self.youngest)
                return

            # 1. prepare for resyncing
            #    (there still might be a race condition at this point)

            authz = self.repos.authz
            self.repos.authz = Authorizer() # remove permission checking

            kindmap = dict(zip(_kindmap.values(), _kindmap.keys()))
            actionmap = dict(zip(_actionmap.values(), _actionmap.keys()))

            try:
                while next_youngest is not None:
                    
                    # 1.1 Attempt to resync the 'revision' table
                    self.log.info("Trying to sync revision [%s]" %
                                  next_youngest)
                    cset = self.repos.get_changeset(next_youngest)
                    try:
                        cursor.execute("INSERT INTO revision "
                                       " (rev,time,author,message) "
                                       "VALUES (%s,%s,%s,%s)",
                                       (str(next_youngest), cset.date,
                                        cset.author, cset.message))
                    except Exception, e: # *another* 1.1. resync attempt won 
                        self.log.warning('Revision %s already cached: %s' %
                                         (next_youngest, e))
                        # also potentially in progress, so keep ''previous''
                        # notion of 'youngest'
                        self.repos.clear(youngest_rev=self.youngest)
                        return

                    # 1.2. now *only* one process was able to get there
                    #      (i.e. there *shouldn't* be any race condition here)

                    for path,kind,action,bpath,brev in cset.get_changes():
                        self.log.debug("Caching node change in [%s]: %s"
                                       % (next_youngest,
                                          (path,kind,action,bpath,brev)))
                        kind = kindmap[kind]
                        action = actionmap[action]
                        cursor.execute("INSERT INTO node_change "
                                       " (rev,path,node_type,change_type, "
                                       "  base_path,base_rev) "
                                       "VALUES (%s,%s,%s,%s,%s,%s)",
                                       (str(next_youngest),
                                        path, kind, action, bpath, brev))

                    # 1.3. iterate (1.1 should always succeed now)
                    self.youngest = next_youngest                    
                    next_youngest = self.repos.next_rev(next_youngest)

                    # 1.4. update 'youngest_rev' metadata (minimize failures at 0.)
                    cursor.execute("UPDATE system SET value=%s WHERE name=%s",
                                   (str(self.youngest), CACHE_YOUNGEST_REV))
                    self.db.commit()
            finally:
                # 3. restore permission checking (after 1.)
                self.repos.authz = authz

    def get_node(self, path, rev=None):
        return self.repos.get_node(path, rev)

    def has_node(self, path, rev):
        return self.repos.has_node(path, rev)

    def get_oldest_rev(self):
        return self.repos.oldest_rev

    def get_youngest_rev(self):
        return self.youngest

    def previous_rev(self, rev):
        return self.repos.previous_rev(rev)

    def next_rev(self, rev, path=''):
        return self.repos.next_rev(rev, path)

    def rev_older_than(self, rev1, rev2):
        return self.repos.rev_older_than(rev1, rev2)

    def get_path_history(self, path, rev=None, limit=None):
        return self.repos.get_path_history(path, rev, limit)

    def normalize_path(self, path):
        return self.repos.normalize_path(path)

    def normalize_rev(self, rev):
        return self.repos.normalize_rev(rev)

    def get_changes(self, old_path, old_rev, new_path, new_rev, ignore_ancestry=1):
        return self.repos.get_changes(old_path, old_rev, new_path, new_rev, ignore_ancestry)


class CachedChangeset(Changeset):

    def __init__(self, rev, db, authz):
        self.db = db
        self.authz = authz
        cursor = self.db.cursor()
        cursor.execute("SELECT time,author,message FROM revision "
                       "WHERE rev=%s", (rev,))
        row = cursor.fetchone()
        if row:
            date, author, message = row
            Changeset.__init__(self, rev, message, author, int(date))
        else:
            raise NoSuchChangeset(rev)

    def get_changes(self):
        cursor = self.db.cursor()
        cursor.execute("SELECT path,node_type,change_type,base_path,base_rev "
                       "FROM node_change WHERE rev=%s "
                       "ORDER BY path", (self.rev,))
        for path, kind, change, base_path, base_rev in cursor:
            if not self.authz.has_permission(path):
                # FIXME: what about the base_path?
                continue
            kind = _kindmap[kind]
            change = _actionmap[change]
            yield path, kind, change, base_path, base_rev

    def get_properties(self):
        return []
