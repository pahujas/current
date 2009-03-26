#!/usr/bin/perl
#################################################################
## Contains: Init(),
#################################################################
use FindBin;
use lib "$FindBin::Bin/lib";
use Event;

package Vdriver;
require Exporter;
@Util::ISA = qw /Exporter/;
@Util::EXPORT_OK = qw /version Init/;
my $version = '0.1';

#################################################################
## Function: Return version number
#################################################################

sub version()
{
   return $version;
}

#########################################################################
## Function: Init()
## Input: handle
## Output: Indicate stuff is ready
#########################################################################

sub Init
{
  my ($handle) = @_;
  my $type = 'RESOURCE';
  my $subtype = 'WAIT';

  # Register with event service
  my $property = "THISTEST=$handle->{handle}";
  my $cmd1 = Event::generate($handle, $type, $subtype, $property);
  my (@handles, @events, @tdsid, @subtypes);
  my $count = 0;
  my $state;
  
 while (($state ne 'GOOD') && ($count != 20)) {
        $state = _chkstuff(\@handles, \@events, \@tdsid, \@subtypes);
  	my ($hl, $evnt, $tds, $sub) = _getstuff($handle);
	@handles = @$hl;
	@events = @$evnt;
	@tdsid = @$tds;
        @subtypes = @$sub;
	$count++;
   } 
 return $state;
}

#########################################################################
## Internal Function: Check if Event is ready
## Output: Indicate stuff is ready
#########################################################################

sub _chkstuff
{ 
  my ($hl, $ev, $td, $sub) = @_;
  my $result = 'BAD';
  my @subtype = @$sub;
  my $size = scalar (@subtype);
  foreach my $item (@subtype) {
    if ($item eq ready) {
      $result = 'GOOD';
    }
  }
  return $result;
}

#########################################################################
## Internal Function: check all eventids 
## Output: return all eventids and other properties
#########################################################################

sub _getstuff
{
  my ($handle) = @_;
  my @handles;
  my @eventids;
  my @tdsids;
  my @subtypes;
  my $i = 0;
  my $cmd2 = Event::list($handle, 'EVENTIDS LONG');
  my $mc = STAF::STAFUnmarshall($cmd2->{result});
  
  while (defined ($mc->{rootObject}[$i]->{generatedBy}->{handle})) {
     push (@handles, $mc->{rootObject}[$i]->{generatedBy}->{handle});
     push (@eventids, $mc->{rootObject}[$i]->{eventID});
     push (@tdsids, $mc->{rootObject}[$i]->{propertyMap}->{THISTEST});
     push (@subtypes, $mc->{rootObject}[$i]->{subtype});
     #print Dumper($mc->{rootObject});
     $i++;
  }
 return (\@handles, \@eventids, \@tdsids, \@subtypes); 
}


1;
