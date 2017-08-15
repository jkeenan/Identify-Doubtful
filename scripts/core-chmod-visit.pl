#!/usr/bin/env perl
use 5.12.0;
use warnings;
use Getopt::Long;
use Carp;
use Data::Dump qw( dd pp );
use File::Slurp;
use Identify::Doubtful qw( match_file_against_regex );
use Identify::Doubtful::chmod_et_al qw( fh_detect_chmod_et_al );

my $repo = "$ENV{HOMEDIR}/gitwork/perl";
chdir $repo or croak "Unable to chdir";
my @files = `find . -type f`;
chomp @files;
my @xfiles = sort grep { ! m/^\./ } map { s<^\./(.*)><$1>; $_ } @files;

my $focus = 'chmod_et_al';

my %results;
for my $f (@xfiles) {
    if (-f $f) {
        my $aref = [];
        $aref = match_file_against_regex(
            $f,
            \&Identify::Doubtful::chmod_et_al::fh_detect_chmod_et_al,
        );
        if (defined $aref and @{$aref}) {
            $results{$f}{chmod_et_al} = $aref;
        }
    }
    else {
        say STDERR "Unable to locate $f";
    }
}

# At this point we have identified the files in core which meet the
# chmod_et_al criterion.  Sample output:

=pod

  "t/lib/warnings/doio"              => [
                                          { line => 236, matches => ["mkdir \$dir0, 0"] },
                                          { line => 405, matches => ["chmod(0, \"foo\\0bar\");"] },
                                          { line => 407, matches => ["chmod(0, \"foo\\0bar\");"] },
                                        ],

=cut

# We now have to inspect those files for the tempdir criterion.

for my $f (sort keys %results) {
    #say $f;
    my @greps = `grep -n -E 'tempdir|newdir' $f`;
    $results{$f}{tempdir} = \@greps;
}
my %qualifying_results = ();
while (my($k,$v) = each %results) {
    if (scalar @{ $results{$k}{tempdir} }) {
        $qualifying_results{$k} = $v;
    }
}
dd(\%qualifying_results);

say "\nFinished";

