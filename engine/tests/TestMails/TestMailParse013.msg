Received: from palm.lyris.net [216.91.57.210] by ajw.com [127.0.0.1] with SMTP (MDaemon.v2.7.SP4.R) for <Archive@ajw.com>; Mon, 06 Jan 2003 05:00:43 -0500
Mime-Version: 1.0
X-Sender: rRR@pop.rrrrr.net
Message-Id: <LYRIS-57933-146278-2003.01.06-02.00.42--alan#ajw.com@news.palmos.com>
In-Reply-To: <LYRIS-54343-146225-2003.01.06-00.00.02--rrr#nnnnnnnnn.com@news.palmos.com>
Date: Mon, 6 Jan 2003 02:00:37 -0800
To: "Armlet Forum" <armlet-forum@news.palmos.com>
From: RN <rrr@nnnnnnnnn.com>
Subject: (Archive Copy) RE: CW v9 and armlets...
Content-Type: text/plain; charset="us-ascii" ; format="flowed"
List-Unsubscribe: <mailto:leave-armlet-forum-55555S@news.palmos.com>
List-Owner: <mailto:owner-armlet-forum@news.palmos.com>
Reply-To: "Armlet Forum" <armlet-forum@news.palmos.com>
X-Message-Id: <p05111a00ba3efa6a0686@[192.168.1.100]>
Sender: bounce-armlet-forum-55555@news.palmos.com
X-Palm-Dev-Forum: armlet-forum
X-MDArchive-Copy: 1
X-MDaemon-Deliver-To: Archive@ajw.com
X-Return-Path: bounce-armlet-forum-55555@news.palmos.com
X-MBF-FILE: MDaemon Gateway to RFC822 (RFC822.MBF v1.0)

On Sun, 5 Jan 2003 22:46:10 -0800,
"BF" <bfffffffff@sss.rr.com> wrote:
>I tried many variations of your code to setup r10 for writable global
>variables.  Unfortunately I can't get it to compile under CW9.  Here are
>the errors, followed by the code.  Of course the code below won't run,
>but I don't understand why I can't get your sample to build:
>  ... [ examples and errors deleted] ...

Maybe the  "asm { mov r10, r4; }"  is required before the return
to balance the register usage?

I can only get the code to compile with thumb mode on (default) and
optimizations off.  When it does compile, it seems to work just fine
(e.g. a 40k armlet functions correctly while using lots of read/write
global variables and callbacks...)

>It looks like the variable R5 and the register r5 aren't related.

( Heh!  :-)  I just kept renaming the variable until it matched the
register that the disassembly said the compiler was actually using
(for my sanity).   But I would like to find some clean syntax that
will safely survive compiler optimizations (the code I posted
obviously won't!).

I'm almost ready to try using gcc-arm-elf to build my armlet
entry point and concatenate that in front of the CW v9 output.
Messy...

RN
HHHHHH
    <http://www.hhhhhh.com/rrr/hhhhhh>

-- 
For information on using the Palm Developer Forums, or to unsubscribe, please see http://www.palmos.com/dev/support/forums/


