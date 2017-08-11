package Identify::Doubtful::rmtree;
use strict;
our $VERSION     = '0.01';
our @ISA         = qw(Exporter);
our @EXPORT_OK = qw(
    fh_detect_some_unsafe
);
#detect_some_unsafe
use Carp;
use IO::File;


#sub detect_some_unsafe {
#    my $file = shift;
#
#    my $IN = IO::File->new($file, 'r');
#    unless (defined $IN) {
#        carp "Unable to open '$file'";
#        return;
#    }
#    return fh_detect_some_unsafe($IN);
#}

sub fh_detect_some_unsafe {
    my $IN = shift;

    my $qrstring = qr/[^,]+/;
    my $qrcomma = qr/\s*,\s*/;
    my $qrarrayref = qr/\[[^]]+\]/;
    my $qrfalse = qr/(?:0|''|"")/;
    my $qrfatarrow = qr/\s+=>\s+/;
    my @bads = ();
    while (my $l = <$IN>) {
        chomp $l;
        next if $l =~ m/^#/; # skip comments
        my @these;
        (@these) = $l =~ m/rmtree\s*\(\s*(?:
          $qrstring         # no commas, i.e., single string
          |
          $qrarrayref      # sequence of characters between open and close brackets
                              # i.e., array ref 
          |
          $qrarrayref$qrcomma$qrstring$qrcomma$qrfalse # 3-arg, 1st arg arrayref, 3rd arg false
          |
          $qrstring$qrcomma$qrstring$qrcomma$qrfalse   # 3-arg, 1st arg string, 3rd arg false
        )\s*\)/gx;
        if (@these) {
            my $lineinfo = { line => $., matches => \@these };
            push @bads, $lineinfo;
        }
        elsif ($l =~ m/(?:rm|remove_)tree.*?\{\s*(.*?)\s*\}/x) {
            my $hashelements = $1;
            if (
                ($hashelements !~ m/safe/)
                    or
                ($hashelements =~ m/safe(?:$qrfatarrow|$qrcomma)$qrfalse/)
            ) {
                my $lineinfo = { line => $., matches => [ $hashelements] };
                push @bads, $lineinfo;
            }
        }
    }
    $IN->close() or croak "unable to close";
    return \@bads;
}

1;
# The preceding line will help the module return a true value

