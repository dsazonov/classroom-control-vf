define users::managed_user (
  $group = $title,
) {
user { $title:
  ensure => present,
  }
group { $title:
  ensure => present,
  }
file { ["/home/${title}","/home/${title}/.ssh"]:
  ensure => directory,
  owner  => $title,
  group  => $group,
  }
}
