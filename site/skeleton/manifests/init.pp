class skeleton {
  file { '/etc/skel/.bashrc':
      ensure => directory,
      owner => 'root',
      group => 'root',
      source => 'puppet:///modules/skeleton/bashrc',
    }
    file { '/etc/skel':
      ensure => file,
      owner => 'root',
      group => 'root',
      source => 'puppet:///modules/skeleton/bashrc',
    }
  }
