package Identify::Doubtful::Regexp::chmod_et_al;
use 5.12.0;
our $VERSION     = '0.01';
our @ISA         = qw(Exporter);
our @EXPORT_OK = qw(
    $qr_chmod_et_al
);
use Carp;

my $qrstring = qr/[^,]+/;
my $qrcomma = qr/\s*,\s*/;
my $qrarrayref = qr/\[[^]]+\]/;
my $qrfalse = qr/(?:0|''|"")/;
my $qrfatarrow = qr/\s+=>\s+/;
my $funcs = qr/mkdir/;
my $qropenparen = qr/\s*\(\s*/;
my $qrclosparen = qr/\s*\)\s*/;
my $qrmf = qr/[0-7]/;
my $qrmodes = qr/\b(?:20${qrmf}${qrmf}|02${qrmf}${qrmf}|00${qrmf}${qrmf}|0${qrmf}${qrmf}|2${qrmf}${qrmf}|00|0)\b/;
my $qrspaceoropenparen = qr/(?:\s+|$qropenparen)/;
my $qropenbrack = qr/\s*\[\s*/;
my $qrclosbrack = qr/\s*\]\s*/;
my $qropencurly = qr/\s*\{\s*/;
my $qrcloscurly = qr/\s*\}\s*/;

#  my $cnt = chmod 0755, "foo", "bar";
#  mkdir FILENAME,MASK

my $qrmkdir = qr/
    mkdir
    ${qrspaceoropenparen}
    [^,]+
    ${qrcomma}
    ${qrmodes}
    (?:$qrclosparen)?
/x;

my $qrchmod = qr/
    chmod
    ${qrspaceoropenparen}
    ${qrmodes}
    ${qrcomma}
    [^,]+
    (?:,[^,]+)*
    (?:$qrclosparen)?
/x;

my $qrmkpath = qr/
    mkpath
    ${qrspaceoropenparen}
    [^,]+
    ${qrcomma}
    [01]
    ${qrcomma}
    ${qrmodes}
    (?:$qrclosparen)?
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
    (?:$qrclosparen)?
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
    (?:$qrclosparen)?
/x;

########################################

our $qr_chmod_et_al;

$qr_chmod_et_al = qr/
    ( # This should be the only capture!
    ${qrmkdir} # mkdir
    |
    ${qrchmod} # chmod
    |
    ${qrmkpath} # mkpath interface 1
    |
    ${qrmkpath2} # mkpath interface 2
    |
    ${qrmakepath} # make_path
    )
/x;

1;

