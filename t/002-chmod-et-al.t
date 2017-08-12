# t/002-chmod-et-al.t
use 5.12.0;
use warnings;
use Identify::Doubtful::Regexp::chmod_et_al qw( $qr_chmod_et_al );
use Test::More ( qw| no_plan | );

my @strings = (
    q|chmod $somedir, 0000|,
    q|chmod $somedir, 000|,
    q|chmod $somedir, 00|,
    q|chmod $somedir, 0|,
    q|chmod $somedir, 0200|,
    q|chmod $somedir, 200|,
    q|chmod	$somedir, 0000|,
    q|chmod	$somedir, 000|,
    q|chmod	$somedir, 00|,
    q|chmod	$somedir, 0|,
    q|chmod	$somedir, 0200|,
    q|chmod	$somedir, 200|,
    q|chmod $somedir,0000|,
    q|chmod $somedir,000|,
    q|chmod $somedir,00|,
    q|chmod $somedir,0|,
    q|chmod $somedir,0200|,
    q|chmod $somedir,200|,
    q|chmod '/foo/bar/baz', 0000|,
    q|chmod '/foo/bar/baz', 000|,
    q|chmod '/foo/bar/baz', 00|,
    q|chmod '/foo/bar/baz', 0|,
    q|chmod '/foo/bar/baz', 0200|,
    q|chmod '/foo/bar/baz', 200|,
    q|chmod	'/foo/bar/baz', 0000|,
    q|chmod	'/foo/bar/baz', 000|,
    q|chmod	'/foo/bar/baz', 00|,
    q|chmod	'/foo/bar/baz', 0|,
    q|chmod	'/foo/bar/baz', 0200|,
    q|chmod	'/foo/bar/baz', 200|,
    q|chmod '/foo/bar/baz',0000|,
    q|chmod '/foo/bar/baz',000|,
    q|chmod '/foo/bar/baz',00|,
    q|chmod '/foo/bar/baz',0|,
    q|chmod '/foo/bar/baz',0200|,
    q|chmod '/foo/bar/baz',200|,
    q|chmod($somedir, 0000)|,
    q|chmod($somedir, 000)|,
    q|chmod($somedir, 00)|,
    q|chmod($somedir, 0)|,
    q|chmod($somedir, 0200)|,
    q|chmod($somedir, 200)|,
    q|chmod($somedir,0000)|,
    q|chmod($somedir,000)|,
    q|chmod($somedir,00)|,
    q|chmod($somedir,0)|,
    q|chmod($somedir,0200)|,
    q|chmod($somedir,200)|,
    q|chmod('/foo/bar/baz', 0000)|,
    q|chmod('/foo/bar/baz', 000)|,
    q|chmod('/foo/bar/baz', 00)|,
    q|chmod('/foo/bar/baz', 0)|,
    q|chmod('/foo/bar/baz', 0200)|,
    q|chmod('/foo/bar/baz', 200)|,
    q|chmod('/foo/bar/baz',0000)|,
    q|chmod('/foo/bar/baz',000)|,
    q|chmod('/foo/bar/baz',00)|,
    q|chmod('/foo/bar/baz',0)|,
    q|chmod('/foo/bar/baz',0200)|,
    q|chmod('/foo/bar/baz',200)|,
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

@strings = (
    q|make_path($somedir,$someotherdir,'/foo/bar/baz',{verbose => 1,mode => 200})|,
);
for my $s (@strings) {
    like($s, m/$qr_chmod_et_al/, "'$s' matched");
}
