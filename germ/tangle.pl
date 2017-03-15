#!/usr/bin/env perl

use strict;
use autodie;
use Fcntl 'SEEK_SET';
use File::Basename 'dirname';
use File::Path 'make_path';

open (my $pamphlet, "<", shift @ARGV);

while(@ARGV) {
    my $chunk_name = shift @ARGV;
    if(@ARGV) {
        my $name = shift @ARGV;
        make_path(dirname($name));
        open (my $output, ">", $name);
        select $output;
    } else {
        select STDOUT;
    }
    dump_chunk($pamphlet, $chunk_name);
}
sub dump_chunk {
    my $pamphlet = shift;
    my $chunk_name = shift;
    my $pos = tell($pamphlet);
    seek($pamphlet, 0, SEEK_SET);
    dump_chunk_from_current_line($pamphlet, $chunk_name);
    seek($pamphlet, $pos, SEEK_SET);
}
sub dump_chunk_from_current_line {
    my $pamphlet = shift;
    my $chunk_name = shift;
    my $in_chunk = 0;

    while(<$pamphlet>) {
        $in_chunk &&= !/^\\end\{chunk}$/;
        print_current_line($pamphlet) if($in_chunk);
        $in_chunk ||= /^\\begin\{chunk}\{\Q$chunk_name\E}$/;
    }
}
sub print_current_line {
    my $pamphlet = shift;

    if(/^\\getchunk\{([^}]*)}$/) {
        dump_chunk($pamphlet, $1);
    } else {
        print;
    }
}
