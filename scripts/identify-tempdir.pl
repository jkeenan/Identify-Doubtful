#!/usr/bin/env perl
use 5.12.0;
use warnings;
use Getopt::Long;
use Carp;
use Data::Dumper;
use Data::Dump qw( dd pp );
use CPAN::Mini::Visit::Simple;
use File::Slurp;
use File::Temp qw( tempfile tempdir );
use File::Copy;
use File::Basename;
use File::Find;
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
my @suffixlist = ( '.tgz', '.tar.gz' );

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

    DISTRO: for my $tarball (sort keys %$distro_href) {
        my $d = basename($tarball, @suffixlist);
        my $pathname = "$expected_dir/$tarball";
        say join('|' => $d, $pathname);
        # GlbDNS-0.30|/home/jkeenan/minicpan/authors/id/A/AB/ABERGMAN/GlbDNS-0.30.tar.gz
        unless (-f $pathname) {
            # Anomaly: B/BW/BWARFIELD/Test-AutoLoader-0.03.tar.gz
            # is actually: B/BW/BWARFIELD/NRGN/Test-AutoLoader-0.03.tar.gz
            carp "Could not locate $pathname";
            next DISTRO;
        }
        my $tdir = tempdir( CLEANUP => 1 );
        copy $pathname => $tdir or carp "Could not copy $pathname" and next DISTRO;
        # We probably want to use Archive Extract here.
        chdir $tdir or carp "Could not change directory " and next DISTRO;
        if (system(qq{tar xzf $pathname})) {
            carp "Could not untar";
            next DISTRO;
        }
        # At this point you're in a tdir one level above the top-level dir of
        # an unwrapped tarball.  The name of that top-level dir cannot be
        # precisely predicted in a non-trivial percentage of cases.  So, to
        # locate the files we need to grep for tempdir|newdir, we need to do a
        # 'find' searching for files whose names match each element in:

        #dd( [ keys %{$distro_href->{$tarball}} ] );
        #["t/zone.t", "t/zone_dir.t"]

        my @files_for_grep = ();
        my %targets = map { $_ => 1 } keys %{$distro_href->{$tarball}};
        #dd(\%targets);
        say "->  $_" for sort keys %targets;
        #sub wanted { $targets{$_} and push @files_for_grep, $File::Find::name; }
        #sub wanted { if ($targets{$_}) { say "<$_>"; } }
        #sub wanted { if (-f $_) { say "    <$File::Find::name>"; } }
#    <./GlbDNS-0.30.tar.gz>
#    <./GlbDNS-0.30/META.yml>
#    <./GlbDNS-0.30/Changes>
#    <./GlbDNS-0.30/MANIFEST> 
#    <./GlbDNS-0.30/Makefile.PL>
#    <./GlbDNS-0.30/README>
#    <./GlbDNS-0.30/t/daemon.t>
#    <./GlbDNS-0.30/t/show-calling-server.t>
#    <./GlbDNS-0.30/t/geo.t>
#    <./GlbDNS-0.30/t/zone.t>
#    <./GlbDNS-0.30/t/zone_dir.t>

        sub wanted {
            if (-f $_) {
                #say "    <$File::Find::name>";
                my $n = $File::Find::name;
                my $o;
                if (($o) = $n =~ m{^\./[^/]+?/(.*)}) {
                    #say "    |$n|";
                    say "    |$o|";
                    #if ($targets{$o}) {
                    #    say "BINGO: $o";
                        push @files_for_grep, $o;
                        #}
                }
                else {
                    #say "    No!";
                }
            }
        }
        find(\&wanted, '.');
        %targets = ();
        dd(\@files_for_grep);


#        for my $f (keys %{$distro_href->{$tarball}}) {
#            (-f $f) and say "    $f";
#        }
    }
}

