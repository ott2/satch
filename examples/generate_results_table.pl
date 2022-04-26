use Time::HiRes qw( time );

use strict;
use warnings;
# Quick and dirty script to run all existing graphs sequencially
# on a list of MaxSAT methods to see how they scale.
#

# From the basename of a file extract number of vertices and seed
sub data_from_basename {
    my $basename = shift;
    $basename =~ m/graph-(\d*)-(\d*)/g;
    return $1, $2;
}

my $methods = {
    'open-wbo 1' => 'open-wbo -algorithm=1',
    'open-wbo 5' => 'open-wbo -algorithm=5',
    'maxhs'      => 'maxhs',
    'EvalMaxSAT' => 'EvalMaxSAT_bin'
    #'evalmaxsat' => ''
};

# get al wdimacs files that are either connected or disconnected
my @graphs;
foreach my $file (glob("dis/*.wdimacs"), glob("con/*.wdimacs")){
    my $basename = $file =~ s/\.wdimacs//gr;
    push @graphs, $basename;
}

my @results;
# foreach method, execute it for all graphs
foreach my $key (keys %$methods) {
    # foreach file
    foreach my $graph (@graphs) {
        my ($vertices, $seed) = data_from_basename($graph);

        # execute and time the command
        my $begin_time = time();
        my $out = qx/$methods->{$key} $graph.wdimacs/;
        my $end_time = time();
        my $elapsed = sprintf("%.2f", $end_time - $begin_time);

        # store results
        push @results, {"key" => $key,
                        "vertices" => $vertices,
                        "seed" => $seed,
                        "file" => "$graph.wdimacs",
                        "time" => $elapsed};
    }
}

# sort correctly to plot
@results = sort {
    $a->{"key"} cmp $b->{"key"} ||
    $a->{"vertices"} <=> $b->{"vertices"}
} @results;

# finally print results
foreach my $result (@results){
    print "$result->{'key'}, $result->{'file'}, $result->{'time'} \n";
}
