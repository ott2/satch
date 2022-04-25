use Time::HiRes qw( time );

use strict;
use warnings;
# Quick and dirty script to run all existing graphs sequencially
# on a list of MaxSAT methods to see how they scale.

my $methods = {
    'open-wbo 1' => 'open-wbo -algorithm=1',
    'open-wbo 5' => 'open-wbo -algorithm=5',
    'maxhs'      => 'maxhs'
    #'evalmaxsat' => ''
};

# get al wdimacs files that are either connected or disconnected
my @graphs;
foreach my $file (glob("dis/*.wdimacs"), glob("con/*.wdimacs")){
    my $basename = $file =~ s/\.wdimacs//gr;
    push @graphs, $basename;
}

# foreach method, execute it for all graphs
foreach my $key (keys %$methods) {
    # foreach file
    foreach my $graph (@graphs) {
        my $begin_time = time();
        # execute the command
        my $out = qx/$methods->{$key} $graph.wdimacs/;
        #
        my $end_time = time();
        my $elapsed = sprintf("%.2f", $end_time - $begin_time);
        print "$key, $graph.wdimacs, $elapsed \n";
    }

}
