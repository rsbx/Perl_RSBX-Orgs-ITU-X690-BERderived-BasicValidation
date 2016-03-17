use 5.010001;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'RSBX::Orgs::ITU::X690::BERderived::BasicEncodingCheck',
    VERSION_FROM      => 'lib/RSBX/Orgs/ITU/X690/BERderived/BasicEncodingCheck.pm', # finds $VERSION, requires EU::MM from perl >= 5.5
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ABSTRACT_FROM     => 'lib/RSBX/Orgs/ITU/X690/BERderived/BasicEncodingCheck.pm', # retrieve abstract from module
    AUTHOR            => 'Raymond S Brand <rsbx@acm.org>',
);
