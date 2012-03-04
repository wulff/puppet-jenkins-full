class ssh::install {
  package {
    ['openssh-server', 'openssh-client']:
      ensure => latest
  }
}

class ssh::config {
  File {
    require => Class['ssh::install']
  }

  file {
    '/etc/ssh/sshd_config':
      source => 'puppet:///modules/ssh/sshd_config';
    '/root/.ssh':
      ensure => directory;
    '/root/.ssh/known_hosts':
      source => 'puppet:///modules/ssh/known_hosts',
      require => File['/root/.ssh'];
  }

  Ssh_authorized_key {
    ensure => present,
    user => 'root'
  }

  ssh_authorized_key {
    'wulff':
      type => 'ssh-rsa',
      key => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAxGUvbW5XBxFu0fyhiVWmlRRxyGn/VZi1650G4KMAj/9Rta36dyzxzGFDmy/hISUMl5xAuFOdVXhC64eg2xTUkwf5d6N97U4xjSzRRRFgBRVCnA/Jh1V6Y3DJbFvBKteLudFKYfbjt/AOmsdEUdMQS0t4m23wAjxvPE0xcLbAJjhB2hxcj+Ni/sO9e/mEz7KUb3EZN1Chw5nr28RnJWSGaJOBWYUmp21KYlRtj1CtE0pVlktNf61EhHJahbTvLG8QHVj2nKY9hkKaFuMm/yy5qclaSzc1ES4zvNSyd11YORCZN6pLO2S0kmTKOKK9GI1wJHCmCuj4JAD17X3eVyurVQ==',
  }
}

class ssh::service {
  service {
    'ssh':
      ensure  => running,
      enable  => true,
      require => Class['ssh::config']
  }
}

class ssh {
  include ssh::install, ssh::config, ssh::service
}
