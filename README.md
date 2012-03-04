This Puppet manifest configures a Jenkins instance capable of testing all aspects of a Drupal project.

## Installing

Install Ubuntu 10.04 LTS (use VirtualBox if you just want to play around). When you get to the "Software selection" screen, mark "OpenSSH server" for installation.

Add the following to your /etc/network/interfaces file and bring up the local interface (only relevant if you're using the Peytz & Co developer image):

    auto eth1
    iface eth1 inet static
      address 33.33.33.33
      netmask 255.255.255.0

    $ ifup eth0

When the interface is up, log in as the regular user and add you public key to the `/root/.ssh/authorized_keys` file (this makes it easy to log in as root when you're setting things up. Use at your own risk!).

Next, clone the Git repository:

    git clone git@github.com:wulff/puppet-jenkins.git

Finally, update the package lists and install the packages required to download and use the manifest:

    sudo apt-get update
    sudo apt-get install git-core puppet

Now:

    puppet --verbose --modulepath=/root/puppet-jenkins/modules /root/puppet-jenkins/manifests/site.pp


## Resources

* http://centripetal.ca/blog/2011/02/07/getting-started-with-selenium-and-jenkins/
* http://www.labelmedia.co.uk/blog/posts/setting-up-selenium-server-on-a-headless-jenkins-ci-build-machine.html
* http://www.devco.net/archives/2009/09/28/simple_puppet_module_structure.php
* http://benbuckman.net/tech/11/04/set-hudsonjenkins-notify-gtalk
