# t/002-chmod-et-al.t
use 5.12.0;
use warnings;
use Identify::Doubtful::Regexp::chmod_et_al qw( $qr_chmod_et_al );
use Test::More ( qw| no_plan | );

my @strings = (
    q|chmod 0000, $somedir|,
    q|chmod 000,  $somedir|,
    q|chmod 00,   $somedir|,
    q|chmod 0,    $somedir|,
    q|chmod 0200, $somedir|,
    q|chmod 200,  $somedir|,
    q|chmod 0000, $somedir, $someotherdir|,
    q|chmod 000,  $somedir, $someotherdir|,
    q|chmod 00,   $somedir, $someotherdir|,
    q|chmod 0,    $somedir, $someotherdir|,
    q|chmod 0200, $somedir, $someotherdir|,
    q|chmod 200,  $somedir, $someotherdir|,
    q|chmod 0000, $somedir,$someotherdir|,
    q|chmod 000,  $somedir,$someotherdir|,
    q|chmod 00,   $somedir,$someotherdir|,
    q|chmod 0,    $somedir,$someotherdir|,
    q|chmod 0200, $somedir,$someotherdir|,
    q|chmod 200,  $somedir,$someotherdir|,
    q|chmod 0000,	$somedir,$someotherdir|,
    q|chmod 000,	$somedir,$someotherdir|,
    q|chmod 00,	$somedir,$someotherdir|,
    q|chmod 0,	$somedir,$someotherdir|,
    q|chmod 0200,	$somedir,$someotherdir|,
    q|chmod 200,	$somedir,$someotherdir|,
    q|chmod 0000, $somedir, '/foo/bar/baz'|,
    q|chmod 000,  $somedir, '/foo/bar/baz'|,
    q|chmod 00,   $somedir, '/foo/bar/baz'|,
    q|chmod 0,    $somedir, '/foo/bar/baz'|,
    q|chmod 0200, $somedir, '/foo/bar/baz'|,
    q|chmod 200,  $somedir, '/foo/bar/baz'|,
    q|chmod(0000, $somedir, '/foo/bar/baz')|,
    q|chmod(000,  $somedir, '/foo/bar/baz')|,
    q|chmod(00,   $somedir, '/foo/bar/baz')|,
    q|chmod(0,    $somedir, '/foo/bar/baz')|,
    q|chmod(0200, $somedir, '/foo/bar/baz')|,
    q|chmod(200,  $somedir, '/foo/bar/baz')|,
    q|chmod ( 0000, $somedir, '/foo/bar/baz' )|,
    q|chmod ( 000,  $somedir, '/foo/bar/baz' )|,
    q|chmod ( 00,   $somedir, '/foo/bar/baz' )|,
    q|chmod ( 0,    $somedir, '/foo/bar/baz' )|,
    q|chmod ( 0200, $somedir, '/foo/bar/baz' )|,
    q|chmod ( 200,  $somedir, '/foo/bar/baz' )|,
    q|mkdir $somedir, 0000|,
    q|mkdir $somedir, 000|,
    q|mkdir $somedir, 00|,
    q|mkdir $somedir, 0|,
    q|mkdir $somedir, 0200|,
    q|mkdir $somedir, 200|,
    q|mkdir	$somedir, 0000|,
    q|mkdir	$somedir, 000|,
    q|mkdir	$somedir, 00|,
    q|mkdir	$somedir, 0|,
    q|mkdir	$somedir, 0200|,
    q|mkdir	$somedir, 200|,
    q|mkdir $somedir,0000|,
    q|mkdir $somedir,000|,
    q|mkdir $somedir,00|,
    q|mkdir $somedir,0|,
    q|mkdir $somedir,0200|,
    q|mkdir $somedir,200|,
    q|mkdir '/foo/bar/baz', 0000|,
    q|mkdir '/foo/bar/baz', 000|,
    q|mkdir '/foo/bar/baz', 00|,
    q|mkdir '/foo/bar/baz', 0|,
    q|mkdir '/foo/bar/baz', 0200|,
    q|mkdir '/foo/bar/baz', 200|,
    q|mkdir	'/foo/bar/baz', 0000|,
    q|mkdir	'/foo/bar/baz', 000|,
    q|mkdir	'/foo/bar/baz', 00|,
    q|mkdir	'/foo/bar/baz', 0|,
    q|mkdir	'/foo/bar/baz', 0200|,
    q|mkdir	'/foo/bar/baz', 200|,
    q|mkdir '/foo/bar/baz',0000|,
    q|mkdir '/foo/bar/baz',000|,
    q|mkdir '/foo/bar/baz',00|,
    q|mkdir '/foo/bar/baz',0|,
    q|mkdir '/foo/bar/baz',0200|,
    q|mkdir '/foo/bar/baz',200|,
    q|mkpath($somedir, 1, 0000)|,
    q|mkpath($somedir, 1, 000)|,
    q|mkpath($somedir, 1, 00)|,
    q|mkpath($somedir, 1, 0)|,
    q|mkpath($somedir, 1, 0200)|,
    q|mkpath($somedir, 1, 2000)|,
    q|mkpath($somedir,1,0000)|,
    q|mkpath($somedir,1,000)|,
    q|mkpath($somedir,1,00)|,
    q|mkpath($somedir,1,0)|,
    q|mkpath($somedir,1,0200)|,
    q|mkpath($somedir,1,2000)|,
    q|mkpath('/foo/bar/baz', 1, 0000)|,
    q|mkpath('/foo/bar/baz', 1, 000)|,
    q|mkpath('/foo/bar/baz', 1, 00)|,
    q|mkpath('/foo/bar/baz', 1, 0)|,
    q|mkpath('/foo/bar/baz', 1, 0200)|,
    q|mkpath('/foo/bar/baz', 1, 2000)|,
    q|mkpath('/foo/bar/baz',1,0000)|,
    q|mkpath('/foo/bar/baz',1,000)|,
    q|mkpath('/foo/bar/baz',1,00)|,
    q|mkpath('/foo/bar/baz',1,0)|,
    q|mkpath('/foo/bar/baz',1,0200)|,
    q|mkpath('/foo/bar/baz',1,2000)|,
    q|mkpath $somedir, 1, 0000|,
    q|mkpath $somedir, 1, 000|,
    q|mkpath $somedir, 1, 00|,
    q|mkpath $somedir, 1, 0|,
    q|mkpath $somedir, 1, 0200|,
    q|mkpath $somedir, 1, 2000|,
    q|mkpath $somedir,1,0000|,
    q|mkpath $somedir,1,000|,
    q|mkpath $somedir,1,00|,
    q|mkpath $somedir,1,0|,
    q|mkpath $somedir,1,0200|,
    q|mkpath $somedir,1,2000|,
    q|mkpath '/foo/bar/baz', 1, 0000|,
    q|mkpath '/foo/bar/baz', 1, 000|,
    q|mkpath '/foo/bar/baz', 1, 00|,
    q|mkpath '/foo/bar/baz', 1, 0|,
    q|mkpath '/foo/bar/baz', 1, 0200|,
    q|mkpath '/foo/bar/baz', 1, 2000|,
    q|mkpath '/foo/bar/baz',1,0000|,
    q|mkpath '/foo/bar/baz',1,000|,
    q|mkpath '/foo/bar/baz',1,00|,
    q|mkpath '/foo/bar/baz',1,0|,
    q|mkpath '/foo/bar/baz',1,0200|,
    q|mkpath '/foo/bar/baz',1,2000|,
    q|mkpath([$somedir], 1, 0000)|,
    q|mkpath([$somedir, $someotherdir], 1, 0000)|,
    q|mkpath([$somedir, $someotherdir, '/foo/bar/baz'], 1, 0000)|,
    q|mkpath([$somedir],1,0000)|,
    q|mkpath([$somedir,$someotherdir],1,0000)|,
    q|mkpath([$somedir,$someotherdir,'/foo/bar/baz'],1,0000)|,
    q|mkpath([$somedir], 1, 000)|,
    q|mkpath([$somedir, $someotherdir], 1, 000)|,
    q|mkpath([$somedir, $someotherdir, '/foo/bar/baz'], 1, 000)|,
    q|mkpath([$somedir],1,000)|,
    q|mkpath([$somedir,$someotherdir],1,000)|,
    q|mkpath([$somedir,$someotherdir,'/foo/bar/baz'],1,000)|,
    q|mkpath([$somedir], 1, 00)|,
    q|mkpath([$somedir, $someotherdir], 1, 00)|,
    q|mkpath([$somedir, $someotherdir, '/foo/bar/baz'], 1, 00)|,
    q|mkpath([$somedir],1,00)|,
    q|mkpath([$somedir,$someotherdir],1,00)|,
    q|mkpath([$somedir,$someotherdir,'/foo/bar/baz'],1,00)|,
    q|mkpath([$somedir], 1, 0)|,
    q|mkpath([$somedir, $someotherdir], 1, 0)|,
    q|mkpath([$somedir, $someotherdir, '/foo/bar/baz'], 1, 0)|,
    q|mkpath([$somedir],1,0)|,
    q|mkpath([$somedir,$someotherdir],1,0)|,
    q|mkpath([$somedir,$someotherdir,'/foo/bar/baz'],1,0)|,
    q|mkpath([$somedir], 1, 0200)|,
    q|mkpath([$somedir, $someotherdir], 1, 0200)|,
    q|mkpath([$somedir, $someotherdir, '/foo/bar/baz'], 1, 0200)|,
    q|mkpath([$somedir],1,0200)|,
    q|mkpath([$somedir,$someotherdir],1,0200)|,
    q|mkpath([$somedir,$someotherdir,'/foo/bar/baz'],1,0200)|,
    q|mkpath([$somedir], 1, 200)|,
    q|mkpath([$somedir, $someotherdir], 1, 200)|,
    q|mkpath([$somedir, $someotherdir, '/foo/bar/baz'], 1, 200)|,
    q|mkpath([$somedir],1,200)|,
    q|mkpath([$somedir,$someotherdir],1,200)|,
    q|mkpath([$somedir,$someotherdir,'/foo/bar/baz'],1,200)|,

    q|make_path($somedir, { verbose => 1, mode => 0000 })|,
    q|make_path($somedir, { verbose => 1, mode => 000 })|,
    q|make_path($somedir, { verbose => 1, mode => 00 })|,
    q|make_path($somedir, { verbose => 1, mode => 0 })|,
    q|make_path($somedir, { verbose => 1, mode => 0200 })|,
    q|make_path($somedir, { verbose => 1, mode => 200 })|,
    q|make_path($somedir, $someotherdir, { verbose => 1, mode => 0000 })|,
    q|make_path($somedir, $someotherdir, { verbose => 1, mode => 000 })|,
    q|make_path($somedir, $someotherdir, { verbose => 1, mode => 00 })|,
    q|make_path($somedir, $someotherdir, { verbose => 1, mode => 0 })|,
    q|make_path($somedir, $someotherdir, { verbose => 1, mode => 0200 })|,
    q|make_path($somedir, $someotherdir, { verbose => 1, mode => 200 })|,
    q|make_path($somedir, $someotherdir, '/foo/bar/baz', { verbose => 1, mode => 0000 })|,
    q|make_path($somedir, $someotherdir, '/foo/bar/baz', { verbose => 1, mode => 000 })|,
    q|make_path($somedir, $someotherdir, '/foo/bar/baz', { verbose => 1, mode => 00 })|,
    q|make_path($somedir, $someotherdir, '/foo/bar/baz', { verbose => 1, mode => 0 })|,
    q|make_path($somedir, $someotherdir, '/foo/bar/baz', { verbose => 1, mode => 0200 })|,
    q|make_path($somedir, $someotherdir, '/foo/bar/baz', { verbose => 1, mode => 200 })|,
    q|make_path($somedir,{verbose => 1,mode => 0000})|,
    q|make_path($somedir,{verbose => 1,mode => 000})|,
    q|make_path($somedir,{verbose => 1,mode => 00})|,
    q|make_path($somedir,{verbose => 1,mode => 0})|,
    q|make_path($somedir,{verbose => 1,mode => 0200})|,
    q|make_path($somedir,{verbose => 1,mode => 200})|,
    q|make_path($somedir,$someotherdir,{verbose => 1,mode => 0000})|,
    q|make_path($somedir,$someotherdir,{verbose => 1,mode => 000})|,
    q|make_path($somedir,$someotherdir,{verbose => 1,mode => 00})|,
    q|make_path($somedir,$someotherdir,{verbose => 1,mode => 0})|,
    q|make_path($somedir,$someotherdir,{verbose => 1,mode => 0200})|,
    q|make_path($somedir,$someotherdir,{verbose => 1,mode => 200})|,
    q|make_path($somedir,$someotherdir,'/foo/bar/baz',{verbose => 1,mode => 0000})|,
    q|make_path($somedir,$someotherdir,'/foo/bar/baz',{verbose => 1,mode => 000})|,
    q|make_path($somedir,$someotherdir,'/foo/bar/baz',{verbose => 1,mode => 00})|,
    q|make_path($somedir,$someotherdir,'/foo/bar/baz',{verbose => 1,mode => 0})|,
    q|make_path($somedir,$someotherdir,'/foo/bar/baz',{verbose => 1,mode => 0200})|,
    q|make_path($somedir,$someotherdir,'/foo/bar/baz',{verbose => 1,mode => 200})|,
);

my @subset = (
    q|chmod 0, \$config_file|,              # DAGOLDEN/CPAN-Reporter-1.2018.tar.gz t/03_config_file.t
    q|chmod 0, \$no_read_file|,             # DAGOLDEN/File-RandomLine-0.20.tar.gz t/01-fast-algorithm.t
    q|chmod( 0200,   \$d . '/5' )|,         # JKEENAN/File-Path-2.15.tar.gz File-Path-2.15.tar.gz
);

my @more_strings = (
    q|mkdir "$dir/3", ; chmod 0, "$dir/3"|, # PERLANCAR/Module-Path-More-0.33/t/01-basics.t
    q|chmod 0, "$dir/3"|,   # PERLANCAR/Module-Path-More-0.33/t/01-basics.t
    q|chmod 0, "$dir/sub"|, # MANWAR/Filesys-DiskUsage-0.10/t/02.warnings.t
    q|chmod 0000, 'foo'|,   # PETDANCE/ack-2.18/t/ack-s.t
    q|unless ( mkdir $f{baddir}, 0000 ) {|, # ADAMK/File-Flat-1.04/t/03_main.t
    q|chmod 0, "$baddir/BAD\nNL3" or die|,  # ANDK/Perl-Repository-APC-2.002001/t/trimtrees.t
    q|test !eval { chmod 0, $TAINT }, 'chmod'|, # AUDREYT/Perl6-Pugs-6.2.13/misc/pX/Common/Regexp-Test-Perl5Tests/t/op/taint.t
    q|my $count = chmod 0200, 'writeable', 'not_readable',|, # BDFOY/Test-File-1.443/t/setup_common
    @subset,
);

for my $s (@strings, @more_strings) {
    like($s, $qr_chmod_et_al, "'$s' matched");
    my @captures = ();
    @captures = $s =~ $qr_chmod_et_al;
    is(@captures, 1, "Captured only the match of entire string: '$s'");
}

