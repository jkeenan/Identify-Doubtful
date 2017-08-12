#!/usr/bin/env perl
use 5.12.0;
use warnings;
use Getopt::Long;
use Carp;
##use Data::Dumper;$Data::Dumper::Indent=1;
use Data::Dump qw( dd pp );
#use List::Util qw( first );
use CPAN::Mini::Visit::Simple;
use File::Slurp;
use lib (
    '/home/jkeenan/gitwork/Identify-Doubtful/blib/lib',
    '/home/jkeenan/gitwork/Identify-Doubtful/lib'
);
use Identify::Doubtful qw( match_file_against_regex );
#use Identify::Doubtful::chmod_et_al ();

my $outputdir = "$ENV{HOMEDIR}/tmp";
my ($contrib, $verbose, $quiet, $list) = ("") x 4;
GetOptions(
	"contrib"		=> \$contrib,
	"verbose"		=> \$verbose,
    "outputdir=s"   => \$outputdir,
    "quiet"         => \$quiet,
    "list"          => \$list, 
) or croak "Error in command-line arguments";
croak "Could not locate $outputdir" unless (-d $outputdir);

=pod

    ./scripts/chmod-visit.pl 'A/AB/ABELTJE' 'J/JK/JKEENAN'

or

    get-minicpan-authors.pl | xargs ./scripts/chmod-visit.pl

=cut

my %bad_contributors = map { $_ => 1 } ( qw|
    D/DA/DAOTOAD
    W/WI/WILL
    P/PE/PERLANCAR
|);

my @contributors = grep { ! $bad_contributors{$_} } @ARGV;
if ($contrib) {
	say "@contributors";
    exit 0;
}

my $focus = 'chmod_et_al';

# Given a list of CPAN authors in A/AB/ABELTJE format and a stub for a
# filename, create one file for each contributor of suspect chmod_et_al.

for my $con (@contributors) {
    say "Processing $con ..." unless $quiet;
    my $base = (split(/\//, $con))[2];
    my $output = "$outputdir/$base.$focus.txt";
    #sub list_contributor_distros {
    my $dd;
    if ($list ) {
        $dd = list_contributor_distros($con, $quiet);
    }
    else {
        $dd = visit_contributor_distros($con, $quiet);
    }
    if (keys %{$dd}) {
        open my $OUT, '>', $output or croak "Unable to open $output for writing";
        my $oldfh = select($OUT);
        dd($dd);
        select($oldfh);
        close $OUT or croak "Unable to close $output after writing";
    }
}

say "\nFinished" unless $quiet;

# Conduct one visit for a given A/AB/ABELTJE directory in minicpan
sub fh_detect_chmod_et_al { return []; }

sub visit_contributor_distros {
    my ($con, $quiet) = @_;
    my $self = CPAN::Mini::Visit::Simple->new();
    my $minicpan_id_dir = $self->get_id_dir();
    $self->identify_distros( {
        start_dir   => "$minicpan_id_dir/$con",
    } );
    
    my %distros;
    my $rv = $self->visit( {
        action  => sub {
            my $distro = shift @_;
            say "    $distro" unless $quiet;
            if (-f 'MANIFEST') {
                my @files = grep { m/\.(?:pl|PL|pm|t)$/ } read_file('MANIFEST');
                chomp(@files);
                #say "@files";
                for my $f (@files) {
                    if (-f $f) {
                        #                        say "$distro: $f";
                        my $aref = [];
                        $aref = match_file_against_regex(
                            $f,
                            #                            \&fh_detect_chmod_et_al,
                            \&Identify::Doubtful::chmod_et_al::fh_detect_chmod_et_al,
                        );
                        if (defined $aref and @{$aref}) {
                            $distros{$distro}{$f} = $aref;
                        }
                    }
                    else {
                        say STDERR "Unable to locate $f";
                    }
                }
            }
        },
    } );
    return \%distros;
}

sub list_contributor_distros {
    my ($con, $quiet) = @_;
    my $self = CPAN::Mini::Visit::Simple->new();
    my $minicpan_id_dir = $self->get_id_dir();
    $self->identify_distros( {
        start_dir   => "$minicpan_id_dir/$con",
    } );
    
    my %distros;
    my $rv = $self->visit( {
        action  => sub {
            my $distro = shift @_;
            say "    $distro" unless $quiet;
            $distros{$con}{$distro}++;
        },
    } );
    return \%distros;
}

