#!/usr/bin/perl
use Getopt::Long;


my $help=<<EOFHELP;

$0: Usage
-c or --count specify count of hellos
-h or --help  print this message

EOFHELP

GetOptions (
             "count|c=s" => \$total,
             "help|h" => sub {print $help; exit;},
           );

unless (defined($total)) {
    print STDERR "$0: Incomplete options\n";
    exit;
}

for my $i (1..$total) {
	print "hello\n";
}
