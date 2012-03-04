class xvfb::install {
  package {
    ['xvfb', 'x11-apps', 'xfonts-100dpi', 'xfonts-75dpi', 'xfonts-scalable', 'xfonts-cyrillic']:
      ensure => latest
  }

  file {
    '/etc/init.d/xvfb':
      source => 'puppet:///modules/xvfb/xvfb',
      mode => 0755
  }
}

class xvfb::service {
  service {
    'xvfb':
      pattern => 'Xvfb',
      ensure  => running,
      enable  => true,
      require => Class['xvfb::install']
  }
}

class xvfb {
  include xvfb::install, xvfb::service
}
