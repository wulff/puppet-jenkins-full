class puppet::install {
  package {
    'puppet':
      ensure => present
  }
}

class puppet::service {
  service {
    'puppet':
      pattern => '/usr/sbin/puppetd',
      ensure => stopped,
      enable => false,
      require => Class['puppet::install']
    }
}

class puppet {
  include puppet::install, puppet::service
}
