Exec { path => "/usr/sbin/:/sbin:/usr/bin:/bin" }
File { owner => 'root', group => 'root' }

node 'default' {
  include ssh
  include git
  include puppet
  include php
  include postfix

  include drush
  include jenkins
  include selenium
  include xvfb
  include firefox

  include htop

#  import 'settings'

#  include htop
#  include jenkins
#  include php
#  include puppet

# todo: postfix, ntp

#  include puppet
#  include sudo
#  include iptables
#  include cron
#  include ppa
#  include system
#  include git
#  include mysql
#  include nginx
#  include ntp
#  include php
#  include memcache
#  include drush
#  include mysqltuner
#  include tuningprimer
#  include mtop
#  include munin
#  include unzip
}
