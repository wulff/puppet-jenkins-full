class selenium::install {
  file {
    ['/opt/selenium-server', '/usr/local/lib/selenium']:
      ensure => directory;
  }

  exec {
    'download-selenium':
      command => 'wget -P /opt/selenium-server http://selenium.googlecode.com/files/selenium-server-standalone-2.20.0.jar',
      creates => '/opt/selenium-server/selenium-server-standalone-2.20.0.jar',
      require => File['/opt/selenium-server'];
    'symlink-selenium':
      command => 'cd /usr/local/lib/selenium && ln -s /opt/selenium-server/selenium-server-standalone-2.20.0.jar selenium-server.jar',
      creates => '/usr/local/lib/selenium/selenium-server.jar',
      require => [File['/usr/local/lib/selenium'], Exec['download-selenium']];
  }
}

class selenium {
  include selenium::install
}
