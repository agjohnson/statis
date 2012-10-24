use 5.010;
use strict;
use warnings;

use Module::Build;

my $builder = Module::Build->new(
    module_name => 'Statis',
    license => 'mit',
    dist_author => q{Anthony Johnson <aj@ohess.org>},
    dist_version_from => 'lib/Statis/App.pm',
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'perl' => 5.010,
        'YAML' => 0,
        'Template' => 0,
        'AnyEvent' => 0,
        'Plack' => 0,
        'Twiggy' => 0,
        'Moo' => 0,
        'JSON' => 0,
        'Hash::MultiValue' => 0
    },
    add_to_cleanup => [ 'Statis-*' ],
    create_makefile_pl => 'traditional',
    #meta_merge => {
    #   resources => {
    #       homepage => 'http://ohess.org/projects/stateboard',
    #       bugtracker => 'http://github.com/agjohnson/stateboard/issues',
    #       repository => 'http://github.com/agjohnson/stateboard.git',
    #   }
    #},
);

$builder->create_build_script();
