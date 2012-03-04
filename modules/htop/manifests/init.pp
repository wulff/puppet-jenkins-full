class htop::install {
  package {
    'htop':
      ensure => present
  }
}

class htop {
  include htop::install
}
