#!/usr/bin/env perl -w
# generate MaxSAT instance which checks if the input graph is connected
# usage: gc2ms.pl graph-instance.param > graph-instance.dimacs
# then: open-wbo graph-instance.dimacs
#
# input format:
# letting n be 4
# letting E be {{1,2},{2,3},{3,1}}
# integers 1 to n are regarded as vertex names
# E contains all the edges in the graph as a set
# The parser is quite primitive; E has to be on one line

my $v = 0;       # number of MaxSAT variables
my $c = 0;       # number of clauses
my $f = '';      # given edge list for printing
my $h = 1000000; # weight of "hard" clauses: should exceed largest vertex label

while (<>) {
  if (/^\$/) {
    next;
  } elsif (/letting n [^\d]+(\d+)/) {
    $v = 1+$1;
    $c = 1+$v; # 1 for 1 in C, $v-1 + 1 for "connected"
  } elsif (/letting [GE] be([}{,\s\d]+)/) {
    my $e = $1;
    $e =~ s/\s//g;
    $f = $e; # keep a copy of the given edges to print in output
    $e =~ s/{(.*)}/$1,/; # set up edges in the set for easy iteration
    while ($e) {
      $e =~ /^\{(\d+),(\d+)/ and push @E, $1, $2;
      $e =~ s/^\{\d+,\d+\},//;
      $c += 2;
    }
    $c += $v-1; # also count the "maximising |W|" clauses
  }
}

print <<"END";
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
c when {1,2} is in E, we add the following two clauses:
c hard: 1 -> 2
c hard: 1 <- 2
END

while (@E) {
  my $v = pop @E;
  my $u = pop @E;
  ($u,$v) = sort($u,$v);
  print "$h -$u $v 0\n";
  print "$h $u -$v 0\n";
}

print <<'END';
c such that connected = (|C| = |V|)
c hard: 1 AND 2 AND 3 ... AND n <-> connected
END

print "c hard: 1 AND 2 AND 3 ... AND n -> n+1\n";
print "$h "; for my $u (1..$v-1) { print "-$u " } print "$v 0\n";
print "c hard: 1 AND 2 AND 3 ... AND n <- n+1\n";
for my $u (1..$v-1) { print "$h $u -$v 0\n" }

print "c weighted clauses for maximising |W|:\n";
for (1..$v-1) { print "1 -$_ 0\n" }

