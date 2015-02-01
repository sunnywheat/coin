#!/usr/bin/perl

use strict;
use warnings;

open(IFile, "coin.in");
my @string;
my @state;

while(my $line = <IFile>)
{
    chomp($line);
    push @string, split(//, $line);
}

close(IFile);

my @re_string = reverse(@string);
my $num_of_h = 0;
my $num_of_t = 0;
my $num_fairtocheat;
my $num_cheattofair;

foreach my $i (1..$#string-1)
{
    if($string[$i] eq 'H' && $string[$i+1] eq 'H' && $string[$i-1] eq 'H')
    {
        $num_of_h++;
        $state[$i] = 'C';
    }
    elsif($string[$i] eq 'T' && $string[$i+1] eq 'H' && $string[$i-1] eq 'H')
    {
        $num_of_t++;
        $state[$i] = 'C';
    }
    else
    {
        $state[$i] = 'F';
    }    
}
if($string[-1] eq 'H' && $string[-2] eq 'H')
{
    $num_of_h++;
    push @state, 'C';
}
elsif($string[-1] eq 'T' && $string[-2] eq 'T')
{
    $num_of_t++;
    push @state, 'C';
}
else
{
    push @state, 'F';
}
$state[0] = 'F';

foreach my $i (0..$#state-1)
{
    if($state[$i] eq 'F' && $state[$i+1] eq 'C')
    {
        $num_fairtocheat++;
    }
    if($state[$i] eq 'C' && $state[$i+1] eq 'F')
    {
        $num_cheattofair++;
    }
}

#print "@state\n";

my $fair_h = 0.5;
my $cheat_h = $num_of_h/($num_of_h+$num_of_t);
my $fairtocheat = $num_fairtocheat/($#string+1-$num_of_h-$num_of_t);
my $cheattofair = $num_cheattofair/($num_of_h+$num_of_t);
#my $cheattofair = 0.2;
my $pro;

foreach my $i (0..2)
{
if($string[0] eq 'H')
{
    if($fair_h > $cheat_h)
    {
        $pro = log10($fair_h);
        $state[0] = 'F';
    }
    else
    {
        $pro = log10($cheat_h);
        $state[0] = 'C'
    }
}
if($string[0] eq 'T')
{
    if($fair_h > $cheat_h)
    {
        $pro = log10($cheat_h);
        $state[0] = 'C';
    }
    else
    {
        $pro = log10($fair_h);
        $state[0] = 'F';
    }
}



foreach my $i (1..$#string)
{
    if($string[$i] eq 'H' && $state[$i-1] eq 'F')
    {
        my $pro1 = $pro+log10($fair_h)+log10((1-$fairtocheat)); # F to F
        my $pro2 = $pro+log10($cheat_h)+log10($fairtocheat); # F to C
        $pro = max($pro1, $pro2);
        if($pro == $pro1)
        {
            $state[$i] = 'F';
        }
        if($pro == $pro2)
        {
            $state[$i] = 'C';
        }
    }
    if($string[$i] eq 'H' && $state[$i-1] eq 'C')
    {
        my $pro1 = $pro+log10($cheat_h)+log10((1-$cheattofair)); # C to C
        my $pro2 = $pro+log10($fair_h)+log10($cheattofair); # C to F
        $pro = max($pro1, $pro2);
        if($pro == $pro1)
        {
            $state[$i] = 'C';
        }
        if($pro == $pro2)
        {
            $state[$i] = 'F';
        }
    }
    if($string[$i] eq 'T' && $state[$i-1] eq 'F')
    {
        my $pro1 = $pro+log10((1-$fair_h))+log10((1-$fairtocheat)); # F to F
        my $pro2 = $pro+log10((1-$cheat_h))+log10($fairtocheat); # F to C
        $pro = max($pro1, $pro2);
        if($pro == $pro1)
        {
            $state[$i] = 'F';
        }
        if($pro == $pro2)
        {
            $state[$i] = 'C';
        }
    }
    if($string[$i] eq 'T' && $state[$i-1] eq 'C')
    {
        my $pro1 = $pro+log10((1-$cheat_h))+log10((1-$cheattofair)); # C to C
        my $pro2 = $pro+log10((1-$fair_h))+log10($cheattofair); # C to F
        $pro = max($pro1, $pro2);
        if($pro == $pro1)
        {
            $state[$i] = 'C';
        }
        if($pro == $pro2)
        {
            $state[$i] = 'F';
        }
    }
}

print "$pro\n";
my $pro_old = $pro;


my $num_cheathead = 0;
my $num_cheattail = 0;
my $num_cheat = 0;
my $num_fair = 0;
$num_fairtocheat = 0;
$num_cheattofair = 0;

foreach my $i (0..$#state-1)
{
    if($state[$i] eq 'F' && $state[$i+1] eq 'C')
    {
        $num_fairtocheat++;
    }
    if($state[$i] eq 'C' && $state[$i+1] eq 'F')
    {
        $num_cheattofair++;
    }
}

foreach my $i (0..$#state)
{
    if($state[$i] eq 'C' && $string[$i] eq 'H')
    {
        $num_cheathead++;
    }
    if($state[$i] eq 'C' && $string[$i] eq 'T')
    {
        $num_cheattail++;
    }
}
$num_cheat = $num_cheathead+$num_cheattail;
$num_fair = $#string+1-$num_cheat;
$cheat_h = $num_cheathead/$num_cheat;
$fairtocheat = $num_fairtocheat/$num_fair;
$cheattofair = $num_cheattofair/$num_cheat;
}




sub max
{
    my $max = shift(@_);
    for my $item(@_)
    {
        $max = $item if $max < $item;
    }
    return $max;
}

sub log10
{
    my $n = shift;
    if($n == 0)
    {
        return -100000000000000;
    }
    else
    {
        return log($n)/log(10);
    }
}
