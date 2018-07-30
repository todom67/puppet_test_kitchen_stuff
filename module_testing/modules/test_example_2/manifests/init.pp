# Class: test_example_2
#
#
class test_example_2 {
    notify{"This is the other class! '${module_name}'": }

    file { '/tmp/from_example_2':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => "Example class number 2\n\nKernel: ${facts['kernel']}";
    }

}