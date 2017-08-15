#!/usr/bin/env perl
use 5.12.0;
use warnings;
use Getopt::Long;
use Carp;
use Data::Dumper;
use Data::Dump qw( dd );
use CPAN::Mini::Visit::Simple;
use File::Slurp;
use File::Temp qw( tempdir );
use File::Basename;
use Archive::Extract;
use JSON;

my $sourcedir = "$ENV{HOMEDIR}/tmp/chmod_et_al";
croak "$sourcedir not found" unless (-d $sourcedir);

my $minicpan = "$ENV{HOMEDIR}/minicpan";
my $id_dir = "$minicpan/authors/id";
croak "$id_dir not found" unless (-d $id_dir);

opendir my $DIRH, $sourcedir or croak "Cannot opendir";
my @files = sort grep { /chmod_et_al\.json$/ } readdir $DIRH;
closedir $DIRH or croak "Cannot closedir";
#dd(\@files);


my %results;
my @suffixlist = ( '.tgz', '.tar.gz' );
my $out = "/home/jkeenan/learn/perl/file-path/tempdir-bad-perms-files.txt";
open my $OUT, '>', $out or croak "Unable to open $out for writing";

for my $f (@files) {
    my ($cpanid) = $f =~ m/^([^.]+)\./;
    #say $cpanid;
    my $first_level = substr($cpanid,0,1);
    my $second_level = substr($cpanid,0,2);
    my $all_levels = "$first_level/$second_level/$cpanid";
    my $expected_dir  = "$id_dir/$all_levels";
    #say $expected_dir;
    my $content = read_file("$sourcedir/$f");
    my $json = JSON->new->allow_nonref;
    my $distro_href = $json->decode( $content );
    #dd($distro_href);
    # For each key like "GlbDNS-0.30.tar.gz", we need to get the full path
    # to that tarball, decompress it and grep each file like "t/zone.t" 
    # for 'tempdir', 'newdir', etc. as appropriate.
    # If we find that, then we need to populate a new structure with that
    # information and print it out (probably as .json).

    DISTRO: for my $tarball (sort keys %$distro_href) {
        my $d = basename($tarball, @suffixlist);
        my $pathname = "$expected_dir/$tarball";
        #say join('|' => $d, $pathname);
        # GlbDNS-0.30|/home/jkeenan/minicpan/authors/id/A/AB/ABERGMAN/GlbDNS-0.30.tar.gz
        my %targets = map { $_ => 1 } keys %{$distro_href->{$tarball}};
        #dd(\%targets);
        unless (-f $pathname) {
            # Anomaly: B/BW/BWARFIELD/Test-AutoLoader-0.03.tar.gz
            # is actually: B/BW/BWARFIELD/NRGN/Test-AutoLoader-0.03.tar.gz
            carp "Could not locate $pathname";
            next DISTRO;
        }
        my $tdir = tempdir( CLEANUP => 1 );
        my $ae = Archive::Extract->new( archive => $pathname )
            or carp "Could not run AE constructor for $pathname";
        my $ok = $ae->extract( to => $tdir )
            or carp "Could not extract $pathname";
        my $outdir  = $ae->extract_path;
		my $outdirname = dirname($outdir);
        my $files = $ae->files;
        #dd([ $outdirname, $files ]);
        my $truefiles = [ grep { -f $_ } map { "$outdirname/$_" } @$files ];
        #dd([ $outdirname, $truefiles ]);

        #index STR,SUBSTR
        for my $key (sort keys %targets) {
            for my $path (@{$truefiles}) {
                my $rv = index $path, $key;
                if ($rv != -1) {
                    say $OUT join('|' => $all_levels, $tarball, $key);
                    my @greps = `grep -n -E 'tempdir|newdir' $path`;
                    chomp(@greps);
                    if (@greps) {
                        for my $s (@greps) {
                            say $OUT "    $s";
                        }
                    }
                }
            }
        }
    }
}

close $OUT or croak "Unable to close $out after writing";
say "\nFinished!";

