class skeleton {
  file { '/etc/skel/.bashrc':
      ensure => file,
      owner => 'root',
      group => 'root',
      source => 'puppet:///modules/skeleton/bashrc',
    }
    file { '/etc/skel':
      ensure => directory,
      owner => 'root',
      group => 'root',
    }
  }
