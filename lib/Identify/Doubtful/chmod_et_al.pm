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

#sub fh_detect_some_unsafe {
#    my $IN = shift;
#
#    my $qrstring = qr/[^,]+/;
#    my $qrcomma = qr/\s*,\s*/;
#    my $qrarrayref = qr/\[[^]]+\]/;
#    my $qrfalse = qr/(?:0|''|"")/;
#    my $qrfatarrow = qr/\s+=>\s+/;
#    my @bads = ();
#    while (my $l = <$IN>) {
#        chomp $l;
#        next if $l =~ m/^#/; # skip comments
#        my @these;
#        (@these) = $l =~ m/rmtree\s*\(\s*(?:
#          $qrstring         # no commas, i.e., single string
#          |
#          $qrarrayref      # sequence of characters between open and close brackets
#                              # i.e., array ref 
#          |
#          $qrarrayref$qrcomma$qrstring$qrcomma$qrfalse # 3-arg, 1st arg arrayref, 3rd arg false
#          |
#          $qrstring$qrcomma$qrstring$qrcomma$qrfalse   # 3-arg, 1st arg string, 3rd arg false
#        )\s*\)/gx;
#        if (@these) {
#            my $lineinfo = { line => $., matches => \@these };
#            push @bads, $lineinfo;
#        }
#        elsif ($l =~ m/(?:rm|remove_)tree.*?\{\s*(.*?)\s*\}/x) {
#            my $hashelements = $1;
#            if (
#                ($hashelements !~ m/safe/)
#                    or
#                ($hashelements =~ m/safe(?:$qrfatarrow|$qrcomma)$qrfalse/)
#            ) {
#                my $lineinfo = { line => $., matches => [ $hashelements] };
#                push @bads, $lineinfo;
#            }
#        }
#    }
#    $IN->close() or croak "unable to close";
#    return \@bads;
#}

1;
# The preceding line will help the module return a true value

