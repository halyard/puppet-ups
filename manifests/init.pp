# @summary Configure UPS monitoring
#
class ups {
  package { 'nut': }

  -> file { '/etc/nut/ups.conf':
    ensure => file,
    source => 'puppet:///modules/ups/ups.conf',
  }

  ~> service { 'nut-driver@ups':
    ensure => running,
    enable => true,
  }

  ~> service { 'nut-server':
    ensure => running,
    enable => true,
  }
}
