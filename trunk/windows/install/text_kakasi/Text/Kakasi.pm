#
# $Id$

package Text::Kakasi;

=head1 NAME

Text::Kakasi - kakasi library module for perl

=head1 SYNOPSIS

  use Text::Kakasi;

  $res = Text::Kakasi::getopt_argv('kakasi', '-ieuc', '-w');
  $str = Text::Kakasi::do_kakasi('���ܸ��ʸ����');

=head1 DESCRIPTION

���Υ⥸�塼��ϡ��ⶶ͵������κ������줿���եȥ�����KAKASI��
perl�����Ѥ��뤿��Τ�ΤǤ���

=over 4

=item getopt_argv($arg1, $arg2, ...)

KAKASI��Ϳ����٤����ץ�������ꤷ���������Ԥ��ޤ������ץ����ϡ�
kakasi���ޥ�ɤ��Ѥ������Τ˽स�ޤ���
�ޤ������ֺǽ�Υ��ץ����ϥץ����Υե�����̾�Ǥ���
getopt_argv��ƤӽФ��ȡ�����ե����뤬open����ޤ�������ϡ�
close_kanwadic��ƤӽФ��ޤǥ����ץ󤵤줿�ޤޤˤʤ�ޤ���

�㤨�С����Τ褦�ʰ�����kakasi��¹Ԥ����Ȥ���Ʊ�����̤����뤿��ˤϡ�

$ kakasi C<-ieuc> C<-w>

���Τ褦�ʰ�����getopt_argv��ƤӽФ��ޤ���

getopt_argv('kakasi', 'C<-ieuc>', 'C<-w>');

=item do_kakasi($str)

������Ϳ����줿ʸ������Ф��ƽ�����Ԥ�����̤�ʸ����Ȥ����֤��ޤ���

=item close_kanwadic()

�����ץ󤷤Ƥ�������ե������close���ޤ���
�С������0.10�Ǥϡ�2��ʾ�getopt_argv���٤�ƤӽФ����ˤϡ�����
����close_kanwadic��ƤӽФ�ɬ�פ�����ޤ�������0.11�ܹԤǤ�getopt_argv
������ɬ�פ������close����Τǡ����δؿ���ɬ������ƤӽФ�ɬ�פ�
����ޤ���

=back

=head1 COPYRIGHT

Copyright (C) 1998, 1999, 2000 NOKUBI Takatsugu <knok@daionet.gr.jp>

���Υ⥸�塼��ϴ�����̵�ݾڤǤ���

�ޤ������Υ⥸�塼���GNU General Public Licence�Τ�ȤǺ����ա�
���Ѥ�ǧ����Ƥ��ޤ����ܺ٤ˤĤ��Ƥ���°��COPYING�Ȥ����ե������
���Ȥ��Ʋ�������

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

=cut

require Exporter;
require DynaLoader;

@ISA = qw(Exporter DynaLoader);

@EXPORT_OK = qw(getopt_argv do_kakasi close_kanwadict);
%EXPORT_TAGS = (all => [qw(getopt_argv do_kakasi close_kanwadict)]);

$VERSION = '1.05';

bootstrap Text::Kakasi $VERSION;

1;
__END__
