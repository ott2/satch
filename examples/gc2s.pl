#!/usr/bin/env perl -w
# generate SAT instance which checks if the input graph is connected
# the instance is satisfiable iff the graph is disconnected
# usage: gc2ms.pl graph-instance.param > graph-instance.dimacs
# then: open-wbo graph-instance.dimacs
#
# input format:
# letting n be 4
# letting E be {{1,2},{2,3},{3,1}}
# $ comment lines are ignored
# integers 1 to n are regarded as vertex names
# E contains all the edges in the graph as a set
# The parser is quite primitive; E has to be on one line

my $v = 0;       # number of SAT variables
my $c = 0;       # number of clauses
my $f = '';      # given edge list for printing

while (<>) {
  if (/^\s*\$/) {
    next;
  } elsif (/letting n [^\d]+(\d+)/) {
    $v = $1;
    $c += 2; # 1 for 1 in C, 1 for |C| < |V|
  } elsif (/letting [GE] be([}{,\s\d]+)/) {
    my $e = $1;
    $e =~ s/\s//g;
    $f = $e; # keep a copy of the given edges to print in output
    $e =~ s/[}{\s]//g;
    @E = split ',', $e;
    $c += scalar(@E);
  }
}

print <<"END";
p cnf $v $c
c E = $f
c find W : set of vertices
c find C : set of vertices
c i in C is represented by literal  i (1..n)
c i in W is represented by literal -i (1..n)
c such that 1 in C
1 0
c such that forAll e in E . min(e) in C <-> max(e) in C
c when {1,2} is in E, we add the following two clauses:
c 1 -> 2
c 1 <- 2
END

while (@E) {
  my $v = pop @E;
  my $u = pop @E;
  ($u,$v) = sort($u,$v);
  print "-$u $v 0\n";
  print "$u -$v 0\n";
}

print <<'END';
c satisfiable iff the graph is disconnected
c such that (|C| < |V|)
c -1 -2 -3 ... -n
END

for my $u (1..$v) { print "-$u " } print "0\n";

