package Identify::Doubtful::chmod_et_al;
use strict;
our $VERSION     = '0.01';
our @ISA         = qw(Exporter);
our @EXPORT_OK = qw(
    fh_detect_chmod_et_al
);
use Carp;
use Regexp::Functions::chmod_et_al ( qw| $qr_chmod_et_al | );

sub fh_detect_chmod_et_al {
    my $IN = shift;
    my @matches = ();
    while (my $l = <$IN>) {
        chomp $l;
        next if $l =~ m/^#/; # skip comments
        my @these;
        (@these) = $l =~ $qr_chmod_et_al; 
        if (@these) {
            my $lineinfo = { line => $., matches => \@these };
            push @matches, $lineinfo;
        }
    }
    $IN->close() or croak "unable to close filehandle";
    return \@matches;
}

1;
