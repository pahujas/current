#!/usr/bin/perl
use XML::LibXML;
use XML::LibXML::NodeList;
use XML::LibXML::Reader;
use XML::LibXML::Simple ();
use Getopt::Std;
use Data::Dumper;
use PLSTAF;

our ($opt_l);
getopt('d:s');
my $document = $opt_d;
my $tlschema = "$ENV{vrun}"."/schema/testlist.xsd";
my $resschema = "$ENV{vrun}"."/schema/resource.xsd";
print "schemafile: $tlschema\n";

my $parser = XML::LibXML->new;
my $doc = $parser->parse_file($document);
my $root = $doc->documentElement();
print "doc is $document\n";
@tmp = $root->getElementsByTagName('schemalocation');
$schemafile = $tmp[0]->getFirstChild->getData;
print "schema is $schemafile\n";
my $schema = XML::LibXML::Schema->new(location => $schemafile);
eval { $schema->validate($doc) };
die $@ if $@;
print "$document validated successfully\n";
my $ref = XML::LibXML::Simple::XMLin($document);
my $rc = STAF::Register("My Program");
if ($rc != $STAF::kOk) {
    print "Error registering with STAF, RC: $STAF::RC\n";
    exit $rc;
}



if (0) {
#my %result = $doc->findvalue('//hostmachines');
my $hosts = $doc->findnodes('//host');
my $vms = $doc->findnodes('//host//vm');
my $vmsize = $vms->size();
my %vmstring = $vms->string_value();

my $size = $hosts->size();
print "size is $size\n";
print "vms are $vmsize\n";
print "vmstring is %vmstring\n";
}
