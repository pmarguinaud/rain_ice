#!/usr/bin/perl -w
#
use File::Copy;
use File::stat;
use FileHandle;
use strict;

my $test = 'RAIN_ICE';

my @f = ("$test.IN", "$test.OUT");

my $count1 = 20;

my $count = do { my $fh = 'FileHandle'->new ("<$test.COUNT"); local $/ = undef; <$fh> };

for my $f (@f)
  {
    my $g = "$f.$count1";
    my $st = stat ($f);
    my $size = $st->size () / $count;
 
    die "size=$size" unless (int ($size) == $size);

    $size *= $count1;
  
    &copy ($f, $g);

    truncate ($g, $size);
    
  }

'FileHandle'->new (">$test.COUNT.$count1")->print ("$count1\n");

for my $f ("$test.IN", "$test.OUT", "$test.COUNT")
  {
    my $g = "$f.$count1";
    rename ($g, $f);
  }


