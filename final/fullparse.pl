#!/usr/bin/perl
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";
use XMLLib;
use Logger;
use PLSTAF;
use Data::Dumper;
use Getopt::Long;

my $help =<<EOFHELP;
Usage details:

$0 -tl testlist -tb resourcefile -w workload

--testlist or -tl  specify testlist filename
--resource or -rs   specify resource filename
EOFHELP

my ($resource, $testlist);

GetOptions (
		"resource|rs=s" => \$resource,
                "testlist|tl=s" => \$testlist,
		"help|h" => sub {print $help; exit 0},
	 );

unless (defined($resource) && defined($testlist)) {
	print STDERR "$0: Incomplete Options\n";
	print STDERR "$help\n";
	exit -1;
};

sub fullparse
{
	my ($filename) = @_;
   	if ((length($filename) == 0) || !(-e $filename && -r $filename && -T $filename)) {
	      Logger::trace(0, "\n'$filename' doesnt exist or is not readable:\n$@\n");
	 } else {
		my $parser = XML::LibXML->new ();
		my $dom = $parser->parse_file($filename);
		my $root = $dom->documentElement();
		my @testblock = $root->getElementsByTagName('testcase-container');
		my @ctrlblock = $root->getElementsByTagName('controller-container');
		my @tests = $testblock[0]->getElementsByTagName('testcase');
		my @ctrls = $ctrlblock[0]->getElementsByTagName('controller');
		print Dumper($tests[0]->toString());
	 	# tests,ctrl broken down. 	
	}
	
}

#main
fullparse($testlist);
