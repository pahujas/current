#!/usr/bin/perl

#################################################################
## Event service functions
#################################################################

package Event;
require Exporter;
@Util::ISA = qw /Exporter/;
@Util::EXPORT_OK = qw /version register unregister generate ack list/;

my $version = '0.1';

#################################################################
## Function: Return version number
#################################################################

sub version()
{
   return $version;
}

#########################################################################
## Function to register as event listener
## Input: handle, type, subtype
## Output: return code, result info [rc 0=Success]
#########################################################################

sub register
{
   my ($handle, $type, $subtype) = @_;
   my $register = "REGISTER TYPE $type SUBTYPE $subtype";
   my $result = $handle->submit("local", "event", "$register");
   return ($result);
}

sub unregister
{
  my ($handle, $type, $subtype) = @_;
  my $unregister = "UNREGISTER TYPE $type SUBTYPE $subtype";
  my $result = $handle->submit("local", "event", "$unregister");
  return ($result);
}

sub generate
{
  my ($handle, $type, $subtype, $property) = @_;
  my $generate = "GENERATE TYPE $type SUBTYPE $subtype PROPERTY $property";
  my $result = $handle->submit("local", "event", "$generate");
  return ($result);
}

sub ack
{
  my ($handle, $eventid) = @_;
  my $ack = "ACKNOWLEDGE EVENTID $eventid";
  my $result = $handle->submit("local", "event", "$ack");
  return ($result);
}

sub list
{
  my ($handle, $cmd) = @_;
  my $listcmd = "LIST $cmd";
  my $result = $handle->submit("local", "event", "$listcmd");
  return ($result);
}

sub reset
{
  my ($handle, $cmd) = @_;
  my $listcmd = "RESET $cmd";
  my $result = $handle->submit("local", "event", "$listcmd");
  return ($result);
}

1;
