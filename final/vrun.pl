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

#Validate input xml files against schema
my ($tbstate, $tlstate);
my $tbschema = "$FindBin::Bin/schema/resource.xsd";
my $tlschema = "$FindBin::Bin/schema/testlist.xsd";

die "testlist xml not well formed\n" 
	unless(XMLLib::validate_format($testlist) == 0);  

die "resource xml not well formed\n" 
	unless(XMLLib::validate_format($resource) == 0);  

die "testlist validation against schema failed\n" 
	unless(XMLLib::validate_schema($testlist, $tlschema) == 0);  

die "resource validation against schema failed\n" 
	unless(XMLLib::validate_schema($resource, $tbschema) == 0) ;
  
#Get a staf handle
my $handle = STAF::STAFHandle->new('vrun');

print "[HARNESS BEGINS]\n";
my $parser = XML::LibXML->new();
$parser->keep_blanks(0);
my $tree = $parser->parse_file($testlist);
my $root = $tree->getDocumentElement;
my $testkey = 'testcase';
my @tests = $root->getElementsByTagName("$testkey");
print "Number of tests: " . scalar (@tests) . "\n";

foreach my $test (@tests) {
	my ($t, $s, $c)  = XMLLib::breaktest($test);
	print "test: ". Dumper(\%$t). "\n";
}
