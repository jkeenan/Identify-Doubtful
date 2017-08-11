package Identify::Doubtful;
use strict;
our $VERSION     = '0.01';
our @ISA         = qw(Exporter);
our @EXPORT_OK = qw(
    match_file_against_regex
);
use Carp;
use IO::File;


sub match_file_against_regex {
    my $file = shift;
    my $matching_sub  = shift;

    my $IN = IO::File->new($file, 'r');
    unless (defined $IN) {
        carp "Unable to open '$file'";
        return;
    }
    return $matching_sub->($IN);
}

1;

