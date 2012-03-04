class postfix::install {
  package {
    'postfix':
      ensure => latest;
  }
}

class postfix::config {
  file {
    '/etc/postfix/main.cf':
      source => 'puppet:///modules/postfix/main.cf',
      notify => Exec['/etc/init.d/postfix reload'],
      require => Class['postfix::install'];
  }

  exec {
    '/etc/init.d/postfix reload':
      refreshonly => true,
      require => Class['postfix::install'];
  }
}

class postfix::service {
  service {
    'postfix':
      ensure => running,
      require => Class['postfix::install'];
  }
}

class postfix {
  include postfix::install, postfix::config, postfix::service
}
