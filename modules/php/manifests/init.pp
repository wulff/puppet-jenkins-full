class php::install {
  package {
    ['php5-cli', 'php5-dev', 'php5-curl', 'php-pear', 'php5-gd', 'php5-sqlite']:
      ensure => present
  }
}

class php::update {
  exec {
    'php-update-pear':
      command => 'pear upgrade pear',
      unless => 'pear version | grep -q 1.9.4'
  }
}

class php::pear::discover {
  php::pear::discover::channel {
    [
      'pear.phing.info',
      'pear.pdepend.org',
      'pear.phpmd.org',
      'pear.phpunit.de',
      'components.ez.no',
      'pear.symfony-project.com'
    ]:
      require => Class['php::update'];
  }
}

class php::pear::install {
  php::pear::install::package {
    [
      'phing/phing',
      'phpmd/PHP_PMD',
      'phpunit/phpcpd',
      'phpunit/phploc',
      'PHPDocumentor',
      'PHP_CodeSniffer',
      'HTTP_Request2',
      'phpunit/PHP_CodeBrowser'
    ]:
      require => Class['php::pear::discover'];
  }
}

class php {
  include php::install, php::update, php::pear::discover, php::pear::install
}

define php::pear::discover::channel() {
  exec {
    "pear-discover-channel-$name":
      command => "pear channel-discover $name",
      unless => "pear list-channels | grep -q $name"
  }
}

define php::pear::install::package() {
  exec {
    "pear-install-package-$name":
      command => "pear install -a $name",
      onlyif  => "pear list-files $name | grep -q 'not installed'"
  }
}
