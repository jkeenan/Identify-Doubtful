package Identify::Doubtful::Regexp::chmod_et_al;
use 5.12.0;
our $VERSION     = '0.01';
our @ISA         = qw(Exporter);
our @EXPORT_OK = qw(
    $qr_chmod_et_al
);
use Carp;
#use IO::File;

my $qrstring = qr/[^,]+/;
my $qrcomma = qr/\s*,\s*/;
my $qrarrayref = qr/\[[^]]+\]/;
my $qrfalse = qr/(?:0|''|"")/;
my $qrfatarrow = qr/\s+=>\s+/;
my $funcs = qr/(?:chmod|mkdir)/;
my $qropenparen = qr/\s*\(\s*/;
my $qrclosparen = qr/\s*\)\s*/;
my $qrmodes = qr/\b(2000|0200|0000|000|200|00|0)\b/;
my $qrspaceoropenparen = qr/(?:\s+|$qropenparen)/;
my $qropenbrack = qr/\s*\[\s*/;
my $qrclosbrack = qr/\s*\]\s*/;
my $qropencurly = qr/\s*\{\s*/;
my $qrcloscurly = qr/\s*\}\s*/;

my $qrcm = qr/
    ${funcs}
    ${qrspaceoropenparen}
    [^,]+
    ${qrcomma}
    ${qrmodes}
    ($qrclosparen)?
/x;

my $qrmkpath = qr/
    mkpath
    ${qrspaceoropenparen}
    [^,]+
    ${qrcomma}
    [01]
    ${qrcomma}
    ${qrmodes}
    ($qrclosparen)?
/x;

my $qrmkpath2 = qr/
    mkpath
    ${qrspaceoropenparen}
    ${qropenbrack}
    [^,]+
    (?:,[^,]+)*
    ${qrclosbrack}
    ${qrcomma}
    [01]
    ${qrcomma}
    ${qrmodes}
    ($qrclosparen)?
/x;

=pod

    make_path('foo/bar/baz', '/zug/zwang', { verbose => 1, mode => 0711 });

    q|make_path($somedir, { verbose => 1, mode => 0000 })|,

=cut

my $qrmakepath = qr/
    make_path
    ${qrspaceoropenparen}
    [^,]+
    (?:,[^,]+)*
    ${qrcomma}
    ${qropencurly}
    (?:[^,]+${qrcomma})*
    mode${qrfatarrow}${qrmodes}
    ${qrcloscurly}
    ($qrclosparen)?
/x;

our $qr_chmod_et_al = qr/
    ( # chmod or mkdir
    ${qrcm}
    | # mkpath
    ${qrmkpath}
    | # mkpath interface 2
    ${qrmkpath2}
    | # make_path
    ${qrmakepath}
    )
/x;


1;
# The preceding line will help the module return a true value

