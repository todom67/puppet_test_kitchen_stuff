# class simple_file_demo
class simple_file_demo(
    $our_parameter = 'default value'
){
    notify { "Greetings from ${facts['networking']['hostname']}!": }
    $message = hiera('message')
    notify { "Hiera message: '${message}'": }

    if $facts['kernel'] == 'Linux'{
      $file_path = '/tmp'
    }else{
      $file_path = 'C:\temp'
    }

    user{'demo_user':
        ensure => present,
    }

    file{"${file_path}/my_dir":
        ensure => directory,
        mode   => '0755',
    }

    file{"${file_path}/my_dir/my_file_template.txt":
        ensure  => present,
        mode    => '0755',
        content => epp('simple_file_demo/template.epp'),
    }

    file{"${file_path}/my_dir/my_file_static.txt":
        ensure => present,
        mode   => '0644',
        source => 'puppet:///modules/simple_file_demo/staticcontent',
    }

    file{"${file_path}/my_dir/my_file_content.txt":
        ensure  => present,
        mode    => '0644',
        owner   => 'demo_user',
        content => "This file contains our parameter: '${our_parameter}'!\n",
        require => User['demo_user'],
    }

}
