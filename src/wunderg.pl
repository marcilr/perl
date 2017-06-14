#!/usr/bin/perl -w
# wunderg.pl
# pod at tail
#
# The Dynamic Duo --or-- Holy Getopt::Long, Pod::UsageMan!
# by ybiC on May 26, 2000 at 07:58 UTC
# http://www.perlmonks.org/?node_id=14909
#
use strict;                  # avoid d'oh! bugs
use Getopt::Long;            # support options+arguments
use Pod::Usage;              # avoid redundant &Usage()
use Weather::Underground;    # fetch weather from www.wunderground.com


my $wunderg_VER = '0.02.05';
my $site        = 'http://www.wunderground.com/members/signup.php';
my $opt_debug   = 0;
my ($opt_help, $opt_man, $opt_versions);


GetOptions(
  'debug=i'   => \$opt_debug,
  'help!'     => \$opt_help,
  'man!'      => \$opt_man,
  'versions!' => \$opt_versions,
) or pod2usage(-verbose => 1) && exit;

pod2usage(-verbose => 1) && exit if ($opt_debug !~ /^[01]$/);
pod2usage(-verbose => 1) && exit if defined $opt_help;
pod2usage(-verbose => 2) && exit if defined $opt_man;
# Check this last to avoid parsing options as Places,
#   and so don't override $opt_man verbose level
my @places  = @ARGV;
pod2usage(-verbose => 1) && exit unless @places;


print "\n", my $time = localtime, "\n$site\n\n";

for (@places){
  my $weather = Weather::Underground ->new(
    place => $_,
    debug => $opt_debug,
  ) or die "Error creating object:\n$@\n";

my $arrayref = $weather->getweather()
    or die "Error fetching:\n$@\n";

  for(@$arrayref){
    print "$_->{place}\n" if exists($_->{place});
    while (my ($key, $value) = each %{$_}) {
      print "  $key = $value\n"
        unless ($key eq 'celsius' or $key eq 'place');
        # celcius matches misspelling in W::U
        # fixed in W::U v2.02
    }
  }
  print "\n";
}


BEGIN{
  # allow to run from cron:
  # but doesn't work 8^(
  $ENV{HTTP_PROXY} = 'http://proxy:port/'; 
}


END{
  if(defined $opt_versions){
    print
      "\nModules, Perl, OS, Program info:\n",
      "  Weather::Underground  $Weather::Underground::VERSION\n",
      "  Pod::Usage            $Pod::Usage::VERSION\n",
      "  Getopt::Long          $Getopt::Long::VERSION\n",
      "  strict                $strict::VERSION\n",
      "  Perl                  $]\n",
      "  OS                    $^O\n",
      "  wunderg.pl            $wunderg_VER\n",
      "  $0\n",
      "  $site\n",
      "\n\n";
  }
}


=head1 NAME

 wunderg.pl

=head1 SYNOPSIS

 wunderg.pl Paris,France Omaha,NE 'London, United Kingdom'

=head1 DESCRIPTION

 Fetch and print weather conditions for one or more cities.

 Weather::Underground appears to read http_proxy environment variable,
 so wunderg.pl works behind a proxy (non-auth proxy, at least).

 Switches that don't define a value can be done in long or short form.
 eg:
   wunderg.pl --man
   wunderg.pl -m

=head1 ARGUMENTS

 Place
 --help      print Options and Arguments instead of fetching weather d
+ata
 --man       print complete man page instead of fetching weather data

 Place can be individual name:
   City
   State
   Country

 Place can be combinations like:
   City,State
   City,Country

 Note that if Place contains any spaces it must be surrounded with sin
+gle
  or double quotes:
   'London,United Kingdom'
   'San Jose,CA'
   'Omaha, Nebraska'

=head1 OPTIONS

 --versions   print Modules, Perl, OS, Program info
 --debug 0    don't print debugging information (default)
 --debug 1    print debugging information

=head1 AUTHOR

ybiC

=head1 CREDITS

 Core loop derived directly from Weather::Underground pod.
 Thanks to merlyn for pointing out this cool weather module,
   gellyfish for tip to use regex match for valid $opt_debug values,
   belg4mit for cleaner syntax for printing "Place" key,
   danger for tip+fix for 5.6.1 warning on 'unless defined(places)'
 Oh yeah, and to some guy named vroom.

 You don't have to subscribe to www.wunderground.com to fetch their da
+ta.
 But it's only $5USD/year, so why not?

=head1 TESTED

 Weather::Underground  2.01
 Pod::Usage            1.14
 Getopt::Long          2.2602
 Perl    5.00503
 Debian  2.2r5

=head1 BUGS

None that I know of.

=head1 TODO

   Test from cron
   Test on Cygwin
   Test on ActivePerl
   Make it run from cron when behind proxy
   Use printf() to line up weather output in columns
   Print modules... info on error
   

=head1 UPDATES

 2002-03-29   17:30 CST
   Replace 'unless defined(@places)' with 'unless(@places)'
    to avoid warning on 5.6.1
   Perlish idiom instead of looping through hash twice
   Post to PerlMonks

 2002-03-29   12:05 CST
   Initial working code

=cut

