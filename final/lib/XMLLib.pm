#!/usr/bin/perl
use XML::LibXML;

## Get XML File, get subtree of xml, search the tree and subtree
## push xml tree/subtree to hash, push hash to staf,

package XMLLib;
require Exporter;
@Util::ISA = qw /Exporter/;
@Util::EXPORT_OK = qw /version toString xmltohash breaktest validate_format validate_schema/;

my $version = '0.1';

# This subroutine returns version number
# Input Parameters:
# ----------------
#
# Output:
# ------
# Returns current version of library

sub version()
{
   return $version;
}


# This subroutine checks if the XML is well formed or not
# Input Parameters:
# ----------------
# filename		: Name of  the input XML file
#
# Output:
# ------
# If the XML is well formed, it returns 1 else 0.

sub validate_format {
   my $valid = 0;

   my ($filename) = @_;   
   if ((length($filename) == 0) || !(-e $filename && -r $filename && -T $filename)) {
      Logger::trace(0, "\n'$filename' doesnt exist or is not readable:\n$@\n");
      $valid = -1;
   } else {
      my $parser = XML::LibXML->new ();
      eval {
         $parser->parse_file( $filename );
      };
      if( $@ ) {
         Logger::trace(0, "\nERROR in '$filename':\n$@\n");
         $valid = -1;
      }
   }

   return $valid;
}


# This subroutine validates the input XML file  against the schema
# Input Parameters:
# ----------------
# filename		: Name of  the input XML file
# schema		: Name of the schema file (.xsd file)
#
# Output:
# ------
# If the XML is valid, it returns 1 else 0.

sub validate_schema {
   my $valid = 0;

   my ($filename, $schema_filename) = @_;

   if ((length($schema_filename) == 0) || 
       !(-e $schema_filename && -r $schema_filename && -T $schema_filename)) {
      Logger::trace(0, "\n'$schema_filename' doesnt exist or is not readable:\n$@\n");
      $valid = -1;
   } else {
      my $xmlschema = XML::LibXML::Schema-> new( location => $schema_filename );
      my $parser=XML::LibXML-> new;
      my $doc=$parser-> parse_file( $filename );
      eval {
         $xmlschema-> validate( $doc );
      };
      if ($@) {
         Logger::trace(0, "\nError in '$filename':\n" . $@);
         $valid = -1;
      }
   }

   return $valid;
}


# Function to get xml in string format
# Input Parameters:
# ----------------
# XML filename
#
# Output:
# ------
# XMLstring in DOM format

sub toString
{
	my ($xmlfile, $key) = @_;
	my $parser = XML::LibXML->new();
	my $document = $parser->parse_file($xmlfile);
	my $doctostring = $document->toString();
	return $doctostring;
}

## Function to get key from xml
## Input: XMLstring, Expressing to parse xml
## Output: Filtered output in xyz format

sub keyfromxml 
{
	my ($dom, $expr) = @_;
	
}


#########################################################################
## Function to split testcase into test, setup, clean
## Input: XML node
## Output: test, setup, clean block hash
#########################################################################
sub breaktest
{
	my ($testelement) = @_;
	my $elem = shift;
	my %testcase = ();
	my %tcsetup = ();
	my %tcclean = ();
	return unless ( ref($elem) =~ /Element/ );
	my @subnodes = $elem->childNodes;
	foreach my $node (@subnodes) {
		$name = $node->nodeName;
		$type = $node->nodeType;
		if ($name eq setup) {
			 %tcsetup = _setup($node);
		 } elsif($name eq clean) {
			 %tcclean = clean($node);
		 } else {
			$data = $node->getFirstChild->getData;
			$testcase{$name} = $data;
		}	
	}
	return (\%testcase, \%tcsetup, \%tcclean);

}

#########################################################################
## Internal Function to get setup block
## Input: XML node
## Output: setup block hash
#########################################################################
sub _setup
{
	my $node = shift;
	my %setup = ();
	my @children = $node->childNodes;
	foreach my $child (@children) {
	my $childname = $child->nodeName;
	my $childdata = $child->getFirstChild->getData;
	$setup{$childname} = $childdata;
	}
 return %setup;
}

#########################################################################
## Function to get clean block
## Input: XML node
## Output: clean block hash
#########################################################################
sub _clean
{
	my $node = shift;
	my %clean = ();
	my @children = $node->childNodes;
	foreach my $child (@children) {
	my $childname = $child->nodeName;
	my $childdata = $child->getFirstChild->getData;
	$clean{$childname} = $childdata;
	}
 return %clean;
}

1;
