

use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME         => 'Identify::Doubtful::rmtree',
    VERSION_FROM => 'lib/Identify/Doubtful/rmtree.pm', # finds \$VERSION
    AUTHOR       => 'James E Keenan (jkeenan@cpan.org)',
    ABSTRACT     => 'Identify unsafe usages of File::Path::rmtree and remove_tree',
    PREREQ_PM    => {
                     'Test::Simple' => 0.44,
                     'Carp' => 0,
                    },
);
