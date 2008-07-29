# -*- coding: utf-8 -*-
#
# Copyright (C) 2006 Edgewall Software
# All rights reserved.
#
# This software is licensed as described in the file COPYING, which
# you should have received as part of this distribution. The terms
# are also available at http://trac.edgewall.org/wiki/TracLicense.
#
# This software consists of voluntary contributions made by many
# individuals. For the exact contribution history, see the revision
# history and logs, available at http://trac.edgewall.org/log/.

import unittest

from trac.core import *
from trac.test import EnvironmentStub
from trac.mimeview.api import get_mimetype, _html_splitlines, \
                              Mimeview, IContentConverter

class GetMimeTypeTestCase(unittest.TestCase):

    def test_from_suffix_using_MIME_MAP(self):
        self.assertEqual('text/plain', get_mimetype('README', None))
        self.assertEqual('text/plain', get_mimetype('README.txt', None))
        
    def test_from_suffix_using_mimetypes(self):
        self.assertEqual('application/x-python-code',
                         get_mimetype('test.pyc', None))
        
    def test_from_content_using_CONTENT_RE(self):
        self.assertEqual('text/x-python',
                         get_mimetype('xxx', """
#!/usr/bin/python
# This is a python script
"""))
        self.assertEqual('text/x-ksh',
                         get_mimetype('xxx', """
#!/bin/ksh
# This is a shell script
"""))
        self.assertEqual('text/x-python',
                         get_mimetype('xxx', """
# -*- Python -*-
# This is a python script
"""))
        self.assertEqual('text/x-ruby',
                         get_mimetype('xxx', """
# -*- mode: ruby -*-
# This is a ruby script
"""))

    def test_from_content_using_is_binary(self):
        self.assertEqual('application/octet-stream',
                         get_mimetype('xxx', "abc\0xyz"))
        

class Converter0(Component):
    implements(IContentConverter)
    def get_supported_conversions(self):
        yield ('key0', 'Format 0', 'c0', 'text/x-sample', 'text/html', 8)

class Converter2(Component):
    implements(IContentConverter)
    def get_supported_conversions(self):
        yield ('key2', 'Format 2', 'c2', 'text/x-sample', 'text/html', 2)

class Converter1(Component):
    implements(IContentConverter)
    def get_supported_conversions(self):
        yield ('key1', 'Format 1', 'c1', 'text/x-sample', 'text/html', 4)

class MimeviewTestCase(unittest.TestCase):

    def setUp(self):
        self.env = EnvironmentStub(default_data=True)

    def test_html_splitlines_without_markup(self):
        lines = ['line 1', 'line 2']
        self.assertEqual(lines, list(_html_splitlines(lines)))

    def test_html_splitlines_with_markup(self):
        lines = ['<p><b>Hi', 'How are you</b></p>']
        result = list(_html_splitlines(lines))
        self.assertEqual('<p><b>Hi</b></p>', result[0])
        self.assertEqual('<p><b>How are you</b></p>', result[1])

    def test_html_splitlines_with_multiline(self):
        """
        Regression test for http://trac.edgewall.org/ticket/2655
        """
        lines = ['<span class="p_tripledouble">"""',
                'a <a href="http://google.com">http://google.com</a>/',
                'Test', 'Test', '"""</span>']
        result = list(_html_splitlines(lines))
        self.assertEqual('<span class="p_tripledouble">"""</span>', result[0])
        self.assertEqual('<span class="p_tripledouble">a '
                         '<a href="http://google.com">http://google.com</a>/'
                         '</span>', result[1])
        self.assertEqual('<span class="p_tripledouble">Test</span>', result[2])
        self.assertEqual('<span class="p_tripledouble">Test</span>', result[3])
        self.assertEqual('<span class="p_tripledouble">"""</span>', result[4])

    def test_get_supported_conversions(self):
        mimeview = Mimeview(self.env)
        conversions = mimeview.get_supported_conversions('text/x-sample')
        self.assertEqual(Converter0(self.env), conversions[0][-1])
        self.assertEqual(Converter1(self.env), conversions[1][-1])
        self.assertEqual(Converter2(self.env), conversions[2][-1])

def suite():
    suite = unittest.TestSuite()
    suite.addTest(unittest.makeSuite(GetMimeTypeTestCase, 'test'))
    suite.addTest(unittest.makeSuite(MimeviewTestCase, 'test'))
    return suite

if __name__ == '__main__':
    unittest.main(defaultTest='suite')
