#!/usr/bin/perl
# md5sum.pl
# Created Mon Sep 28 13:30:59 AKDT 2009
# by Raymond E. Marcil <marcilr@gmail.com>
#
# Generate md5sum of string.
#

use strict;
use Digest::MD5  qw(md5_hex);
my $md5_data = "test";
my $md5_hash = md5_hex( $md5_data );
$md5_hash =~ tr/a-z/A-Z/;
print "$md5_hash\n";
