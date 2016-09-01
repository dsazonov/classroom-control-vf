class memcached {
  package { 'memcached':
    ensure => latest,
  }
  file { '/etc/sysconfig/memcached':
    ensure => file,
    owner => 'root',
    group => 'root',
    mode => '0644',
    require => Package['memcached'],
    notify => Service['memcached'],
    source => 'puppet:///modules/memcached/memcached',
  }
  service { 'memcached':
    enable => true,
    ensure  => running,
  }

}
