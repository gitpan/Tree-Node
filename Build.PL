require 5.006;

use Module::Build;

my $build = Module::Build->new
    (
     module_name => 'Tree::Node',
     license => 'perl',
     requires => {
       'base'                       => 0,
       'perl'                       => '5.6.0',
     },
     recommends => {
       'Devel::Leak'                => 0,
       'Test::Portability::Files'   => 0,
       'Test::Pod'                  => '1.00',
       'Test::Pod::Coverage'        => 0,
     },
     build_requires => {
       'Test::More'                 => 0,
     },
     xs_files => {
       'Node.xs' => 'lib/Tree/Node.xs',
     },
     c_source     =>   "./", 
     include_dirs => [ "./" ],
     dist_author        => 'Robert Rothenberg <rrwo at cpan.org>',
     sign               => 1,
     create_readme      => ($Module::Build::VERSION >= 0.2702),
);

$build->create_build_script;
