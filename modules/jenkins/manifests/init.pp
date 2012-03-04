# TODO: add restart after installing plugins
#       java -jar jenkins-cli.jar -s http://localhost:8080 safe-restart

class jenkins::install {
  file {
    '/etc/apt/sources.list.d':
      ensure => directory;
    '/etc/apt/sources.list.d/jenkins.list':
      source => 'puppet:///modules/jenkins/apt.list',
      ensure => present,
      notify => [
        Exec['install-key'],
        Exec['refresh-apt'],
      ],
  }

  file {
    '/root/jenkins-ci.org.key':
      source => 'puppet:///modules/jenkins/jenkins-ci.org.key',
      ensure => present
  }

  exec {
    'install-key':
      command => '/usr/bin/apt-key add /root/jenkins-ci.org.key',
      unless => '/usr/bin/apt-key list | grep \'D50582E6\'',
      notify => Exec['refresh-apt'],
      require => [
        File['/etc/apt/sources.list.d/jenkins.list'],
        File['/root/jenkins-ci.org.key'],
      ];
    'refresh-apt':
      refreshonly => true,
      require => [
        File['/etc/apt/sources.list.d/jenkins.list'],
        Exec['install-key']
      ],
      command => 'apt-get update';
  }

  package {
    'jenkins':
      ensure => latest,
      require => Exec['refresh-apt']
  }
}

class jenkins::configure {
  file {
    '/var/lib/jenkins/.gitconfig':
      source => 'puppet:///modules/jenkins/gitconfig',
      owner => 'jenkins',
      group => 'nogroup',
      require => Class['jenkins::install'];
    '/var/lib/jenkins/hudson.plugins.seleniumhq.SeleniumhqBuilder.xml':
      source => 'puppet:///modules/jenkins/config.selenium.xml',
      owner => 'jenkins',
      group => 'nogroup',
      require => Class['jenkins::install'];
  }

  exec {
    'jenkins-drupal-template':
      command => 'cd /var/lib/jenkins/jobs && git clone git://github.com/wulff/jenkins-drupal-template.git drupal-template && chown -R jenkins:nogroup drupal-template/',
      creates => '/var/lib/jenkins/jobs/drupal-template',
      require => Class['jenkins::install'];
    'jenkins-selenium-template':
      command => 'cd /var/lib/jenkins/jobs && git clone git://github.com/wulff/jenkins-selenium-template.git selenium-template && chown -R jenkins:nogroup selenium-template/',
      creates => '/var/lib/jenkins/jobs/selenium-template',
      require => Class['jenkins::install'];
  }
}

class jenkins::service {
  service {
    'jenkins':
      ensure  => running,
      enable  => true,
      require => Class['jenkins::install']
  }
}

class jenkins::update {
  exec {
    'download-jenkins-cli':
      command => 'wget -P /root http://localhost:8080/jnlpJars/jenkins-cli.jar',
      creates => '/root/jenkins-cli.jar',
      require => Class['jenkins::service']
  }

  exec {
    'jenkins-download-update':
      command => 'wget -P /root http://updates.jenkins-ci.org/update-center.json',
      creates => '/root/update-center.json';
    'jenkins-clean-json':
      command => "sed '1d;$d' update-center.json > default.json",
      creates => '/root/default.json',
      require => Exec['jenkins-download-update'];
    'jenkins-post-update':
      command => 'wget --header="Accept: application/json" --post-file=/root/default.json -q -O /root/jenkins-update http://localhost:8080/updateCenter/byId/default/postBack',
      creates => '/root/jenkins-update',
      require => [Class['jenkins::service'], Exec['jenkins-clean-json']];
  }
}

class jenkins::plugins {
  jenkins::plugin::install {
    'analysis-core':
      version => '1.38';
#    'analysis-collector':
#      version => '1.20';
    'checkstyle':
      version => '3.24';
    'dry':
      version => '2.24';
    'phing':
      version => '0.10';
    'plot':
      version => '1.5';
    'pmd':
      version => '3.25';
    'build-timeout':
      version => '1.8';
    'claim':
      version => '1.7';
    'disk-usage':
      version => '0.15';
    'email-ext':
      version => '2.18';
    'favorite':
      version => '1.6';
    'git':
      version => '1.1.16';
    'envinject':
      version => '1.31';
    'jobConfigHistory':
      version => '1.13';
    'project-stats-plugin':
      version => '0.3';
    'redmine':
      version => '0.9';
    'seleniumhq':
      version => '0.4';
    'statusmonitor':
      version => '1.3';
    'instant-messaging':
      version => '1.21';
    'jabber':
      version => '1.22';
    'tasks':
      version => '4.27';
    'warnings':
      version => '3.28';

#    'greenballs':
#      version => '1.11';
#    'persona':
#      version => '2.0';
  }

  exec {
    # the latest version of analysis-collector breaks jenkins, so we'll stick
    # with an older version for now...
    'jenkins-install-analysis-collector':
      command => 'java -jar /root/jenkins-cli.jar -s http://localhost:8080 install-plugin http://maven.jenkins-ci.org/content/repositories/releases/org/jvnet/hudson/plugins/analysis-collector/1.19/analysis-collector-1.19.hpi -name analysis-collector',
      creates => '/var/lib/jenkins/plugins/analysis-collector.jpi',
      require => Class['jenkins::update'];
  }
}

class jenkins {
  include jenkins::install, jenkins::configure, jenkins::service, jenkins::update, jenkins::plugins
}

define jenkins::plugin::install($cli = '/root/jenkins-cli.jar', $version = '') {
  exec {
    $name:
#      command => "java -jar /root/jenkins-cli.jar -s http://localhost:8080 install-plugin http://updates.jenkins-ci.org/download/plugins/$name/$version/$name.hpi",
      command => "java -jar /root/jenkins-cli.jar -s http://localhost:8080 install-plugin $name",
      creates => "/var/lib/jenkins/plugins/$name.jpi",
      require => Class['jenkins::update'];
  }
}
