class firefox::install {
  package {
    'firefox':
      ensure => installed,
      require => Class['xvfb'];
  }
}

class firefox {
  include firefox::install
}
