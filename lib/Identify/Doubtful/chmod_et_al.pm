package Identify::Doubtful::chmod_et_al;
use strict;
our $VERSION     = '0.01';
our @ISA         = qw(Exporter);
our @EXPORT_OK = qw(
    fh_detect_chmod_et_al
);
use Carp;
use Identify::Doubtful::Regexp::chmod_et_al ( qw| $qr_chmod_et_al | );
#use IO::File;

sub fh_detect_chmod_et_al {
    my $IN = shift;
    my @matches = ();
    while (my $l = <$IN>) {
        chomp $l;
        next if $l =~ m/^#/; # skip comments
        my @these;
        (@these) = $l =~ $qr_chmod_et_al; 
        if (@these) {
            #my $lineinfo = { line => $., matches => \@these };
            # TODO:  The regex in $qr_chmod_et_al is capturing 11 items.
            # Re-inspect it to use clustering.  In the meantime, use only the
            # first item match, since that is the entire line.
            my $lineinfo = { line => $., matches => [ $these[0] ] };
            push @matches, $lineinfo;
        }
    }
    $IN->close() or croak "unable to close filehandle";
    return \@matches;
}

1;
