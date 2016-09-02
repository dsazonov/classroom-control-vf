class nginx (
      $package = $nginx::params::package,
      $owner   = $nginx::params::owner,
      $group   = $nginx::params::group,
      $docroot = $nginx::params::docroot,
      $confdir = $nginx::params::confdir,
      $user = $nginx::params::user,
      $logdir = $nginx::params::logdir,
) inherits nginx::params {

  File {
    owner => $owner,
    group => $group,
    mode  => '0664',
  }

  package { $package:
    ensure => present,
  }

  file { [ $docroot, "${confdir}/conf.d" ]:
    ensure => directory,
    require => Package['nginx'],
  }

  file { "${docroot}/index.html":
    ensure => file,
    source => 'puppet:///modules/nginx/index.html',
    require => Package['nginx'],
  }
  file { "${confdir}/nginx.conf":
    ensure  => file,
    content => template('nginx/nginx.conf.erb'),
    notify  => Service['nginx'],
    require => Package['nginx'],
  }
  file { "${confdir}/conf.d/default.conf":
    ensure  => file,
    content => template('nginx/default.conf.erb'),
    notify  => Service['nginx'],
    require => Package['nginx'],
  }

  service { 'nginx':
    ensure    => running,
    enable    => true,
  }
}
