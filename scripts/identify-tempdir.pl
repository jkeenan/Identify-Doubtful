#!/usr/bin/env perl
use 5.12.0;
use warnings;
use Getopt::Long;
use Carp;
use Data::Dumper;
use Data::Dump qw( dd pp );
use CPAN::Mini::Visit::Simple;
use File::Slurp;
use File::Temp qw( tempfile );
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

#####

my %results;

for my $f (@files) {
    my ($cpanid) = $f =~ m/^([^.]+)\./;
    #say $cpanid;
    my $first_level = substr($cpanid,0,1);
    my $second_level = substr($cpanid,0,2);
    my $expected_dir  = "$id_dir/$first_level/$second_level/$cpanid";
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

    for my $tarball (sort keys %$distro_href) {
        my $pathname = "$expected_dir/$tarball";
        unless (-f $pathname) {
            # Anomaly: B/BW/BWARFIELD/Test-AutoLoader-0.03.tar.gz
            # is actually: B/BW/BWARFIELD/NRGN/Test-AutoLoader-0.03.tar.gz
            carp "Could not locate $pathname";
            next;
        }
        say $pathname;
    }


#    my $varcontent = '%ds = ' . $content . ";\n1\n";
#    #say $varcontent;
#    my ($tfh, $tfilename) = tempfile();
#    open $tfh, '>', $tfilename or croak "Could not open $tfilename for writing";
#    say $tfh $varcontent;
#    close $tfh or croak "Could not close $tfilename after writing";
#    my $xcontent = read_file($tfilename);
#    #say $xcontent;
#    our %ds = ();
#    eval 'require $tfilename;';
#    #dd(%ds);
#    #print Dumper([ \%ds ]);
#    for my $k (keys %ds) {
#        say $k;
#    }

#    my $expected_path = "$expected_dir/$dist";
#    if (-f $expected_path) {
#        push @derived_list, $expected_path;
#        my @parts = split(/\// => $dist);
#        $dists_to_expected_paths{$parts[1]} = "$expected_dir/$parts[0]";
#    }
#    else {
#        say STDERR "Unable to locate $dist as $expected_path";
#    }
}

