#!/usr/bin/env perl -w
# usage: gc2ms.pl graph-instance.param > graph-instance.dimacs
# then: open-wbo graph-instance.dimacs

my $v = 0;
my $c = 0;
my $e = '';
my $f = '';
my $h = 1000000;

while (<>) {
  if (/letting n [^\d]+(\d+)/) {
    $v = 1+$1;
    $c = 1+$v; # 1 for 1 in C, $v-1 + 1 for "connected"
  } elsif (/letting . be([}{,\s\d]+)/) {
    $e = $1;
    $e =~ s/\s//g;
    $f = $e;
    $e =~ s/{(.*)}/$1,/;
    while ($e) {
      # print "$e\n";
      $e =~ /^\{(\d+),(\d+)/ and push @E, $1, $2;
      $e =~ s/^\{\d+,\d+\},//;
      $c += 2;
      # print "@E\n";
    }
    # print "@E\n";
    # print "$f\n";
    $c += $v-1; # maximising |W|
  }
}

#  print "@E\n";
print <<"E1";
p wcnf $v $c $h
c E = $f
c find W : set of vertices
c find C : set of vertices
c i in C is represented by literal  i (1..n)
c i in W is represented by literal -i (1..n)
c literal $v represents the Boolean "connected"
c such that 1 in C
$h 1 0
c such that forAll e in E . min(e) in C <-> max(e) in C
c when {1,2} is in E, we add the following two hard clauses:
c 1 <- 2
c 1 -> 2
E1

while (@E) {
  my $u = pop @E;
  my $v = pop @E;
  print "$h -$u $v 0\n";
  print "$h $u -$v 0\n";
}

print <<'E2';
c such that connected = (|C| = |V|)
c 1 AND 2 AND 3 ... n <-> connected
c -1 -2 -3 ... -n n+1
c 1 AND 2 AND 3 ... n <- n+1
E2

print "$h "; for my $u (1..$v-1) { print "-$u "; } print "$v 0\n";
for my $u (1..$v-1) { print "$h $u -$v 0\n"; }

print <<'E3';
c weighted clauses for maximising |W|:
E3
for (1..$v-1) { print "1 -$_ 0\n"; }
