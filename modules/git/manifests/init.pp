class git::install {
  package {
    'git-core':
      ensure => latest
  }
}

class git {
  include git::install
}
