# Kitchen-puppet linux workstation install

Directions for setting up a fully configured [Kitchen-puppet](https://github.com/neillturner/kitchen-puppet) linux workstation.

## Prerequisites

- ### Virtualization platform
  Among the many virtualization platforms that Kitchen-puppet can leverage, for users with machines capable of running local VM's, it is recommended to use the [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/) platforms. As such, be sure that you are running a reasonably up to date version of each:

  - Vagrant installer: [Vagrant website](https://www.vagrantup.com/downloads.html)
  - VirtualBox installer: [VirtualBox website](https://www.virtualbox.org/wiki/Downloads)

  For those users leveraging the cloud, [GCP installation and configuration is here](gcp_setup.md).

- ### Software platforms
  A linux Kitchen-puppet setup relies on an installation of [Puppet](https://puppet.com/) (including Facter and Hiera), and [Ruby](https://www.ruby-lang.org/en/). Additionally, we will need to have git installed for our dev work.

  - Most my_project machines have puppet baked in and as such, we can leverage the puppet ruby installation.
    - Verify ruby installation: from the terminal enter:
            ```bash
            ruby --version; gem --version
            gem
            ```
    - you should see somthing like:
        ```shell
        ruby 2.1.9p490 (2016-03-30 revision 54437) [x86_64-linux]
        2.2.5
        ```
    - In the event that you see this:
        ```shell
        -bash: -ruby: command not found
        ```
      then we need to create symlinks for both ruby and gem:
      ```bash
         ln -s /opt/puppetlabs/puppet/bin/ruby /usr/local/bin/
         ln -s /opt/puppetlabs/puppet/bin/gem /usr/local/bin/
      ```

  - Verify Puppet installation:
      ```shell
        ~ > puppet --version
        4.8.1
       ```
  - Install git: `yum -y install git`

## Installation

- ### Rubygems

  The following rubygems must all be installed for kitchen-puppet to be functional:
  - [test-kitchen](http://kitchen.ci/)
  - Virtualization platform:
    - Vagrant: [kitchen-vagrant](https://github.com/test-kitchen/kitchen-vagrant)
    - GCP: [kitchen-google](https://github.com/test-kitchen/kitchen-google)
  - [librarian-puppet](https://github.com/rodjek/librarian-puppet)
  - [kitchen-puppet](https://github.com/neillturner/kitchen-puppet)
  - [kitchen-inspec](https://github.com/chef/kitchen-inspec)

  These can all be installed at once:
  ```shell
      gem install  -p https://proxy.my_project.com:3128 test-kitchen <kitchen-vagrant> OR <kitchen-google> librarian-puppet kitchen-puppet kitchen-inspec
  ```
  This will also install all the necessary dependencies.

  We will then need to add the kitchen command to our path:
  ```shell
    ln -s /opt/puppetlabs/puppet/bin/kitchen /usr/local/bin/
  ```

  Verify kitchen install:
  ```shell
     kitchen version
  ```
  Your output should be similar to this:
  ```shell
     Test Kitchen version 1.15.0
  ```

## Next step

- [Configure directory structure for module testing using kitchen-puppet](kpdirectorysetup.md) OR
- [Set up Roles/Profiles testing using the puppet agent and the my_project Puppet infrastructure](agentsetup.md)