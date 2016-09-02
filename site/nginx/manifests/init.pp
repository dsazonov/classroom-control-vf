class nginx (
  $root = undef,
) {
  case $::osfamily {
    'redhat','debian' : {
      $package = 'nginx'
      $owner   = 'root'
      $group   = 'root'
      $default_docroot = '/var/www'
      $confdir = '/etc/nginx'
      $logdir  = '/var/log/nginx'
    }
    'windows' : {
      $package = 'nginx-service'
      $owner   = 'Administrator'
      $group   = 'Administrators'
      $default_docroot = 'C:/ProgramData/nginx/html'
      $confdir = 'C:/ProgramData/nginx'
      $logdir  = 'C:/ProgramData/nginx/logs'
    }
    default   : {
      fail("Module ${module_name} is not supported on ${::osfamily}")
    }
  }

  # user the service will run as. Used in the nginx.conf.erb template
  $user = $::osfamily ? {
    'redhat'  => 'nginx',
    'debian'  => 'www-data',
    'windows' => 'nobody',
  }
$docroot = $root? {    
  undef   => $default_docroot,
  default => $root,
  }
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
    require Package['nginx'],
  }

  file { "${docroot}/index.html":
    ensure => file,
    source => 'puppet:///modules/nginx/index.html',
    require Package['nginx'],
  }
  file { "${confdir}/nginx.conf":
    ensure  => file,
    content => template('nginx/nginx.conf.erb'),
    notify  => Service['nginx'],
    require Package['nginx'],
  }
  file { "${confdir}/conf.d/default.conf":
    ensure  => file,
    content => template('nginx/default.conf.erb'),
    notify  => Service['nginx'],
    require Package['nginx'],
  }

  service { 'nginx':
    ensure    => running,
    enable    => true,
  }
}
