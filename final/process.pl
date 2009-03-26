use PLSTAF;
use Data::Dumper;


my $handle = STAF::STAFHandle->new('runner');
my $program = "perl hello.pl -c 51";
my $request = "start shell command $program ";
for (my $i = 0; $i < 5; $i++) {
  my $rc = STAF::Submit2($STAF::STAFHandle::kReqQueueRetain,"local", "process", "$request");
}

# get list of running process
my $rc1 = $handle->submit("local","process","list");
my $mc = STAF::STAFUnmarshall($rc1->{result});
my $i = 0;
while (defined($mc->{rootObject}[$i]->{handle})) {
	my $hl = "$mc->{rootObject}[$i]->{handle}";
	print "available handle: $hl\n";
	free($hl);
	$i++;
}


sub free
{
  my ($hl) = @_;
  my $rc = STAF::Submit("local","process","FREE Handle $hl");
  if ($rc->{rc} != $STAF::kOk) {
	    print "Error submitting Free request, RC: $STAF::RC\n";
	    $return = 1;
   } else {
   print "Freed handle $hl\n";
   $return = 0;
  }
 return $return;
}
