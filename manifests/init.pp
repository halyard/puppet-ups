# @summary Configure UPS monitoring
#
# @param vendorid sets the USB Vendor ID for the UPS
# @param productid sets the USB Product ID for the UPS
class ups (
  String $vendorid,
  String $productid,
) {
  package { 'nut': }

  -> file { '/etc/udev/rules.d/50-ups.rules':
    ensure  => file,
    content => template('ups/udev.rules.erb'),
  }

  ~> exec { 'reload udev':
    command => '/usr/bin/udevadm control --reload-rules',
    path    => '/usr/bin',
    refreshonly => true,
  }

  ~> exec { 'retrigger udev':
    command     => '/usr/bin/udevadm trigger',
    path        => '/usr/bin',
    refreshonly => true,
  }

  -> file { '/etc/nut/ups.conf':
    ensure  => file,
    content => template('ups/ups.conf.erb'),
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
