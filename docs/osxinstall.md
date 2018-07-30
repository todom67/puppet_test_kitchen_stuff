# Kitchen-puppet mac-OSX desktop install

Directions for setting up a fully configured [Kitchen-puppet](https://github.com/neillturner/kitchen-puppet) mac/OSX desktop.

## Prerequisites

- ### Virtualization platform
  Kitchen-puppet leverages [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/) to
  deploy code onto the chosen platforms. As such, be sure that you are running a reasonably up to date version of each:

  - Vagrant installer: [Vagrant website](https://www.vagrantup.com/downloads.html)
  - VirtualBox installer: [VirtualBox website](https://www.virtualbox.org/wiki/Downloads)

- ### Software platforms
  Kitchen-puppet relies on an installation of [Puppet](https://puppet.com/) and [Ruby](https://www.ruby-lang.org/en/).

    - Puppet: Download and install the mac packages from [Puppet downloads](https://downloads.puppetlabs.com/mac/)
      - The most recent Facter package (facter-.dmg)
      - The most recent Hiera package (hiera-.dmg)
        - **NOTE as of this writing, Hiera is not compatible with macOS 10.12 (Sierra)**
      - The most recent Puppet package (puppet-.dmg)

    - Ruby installer: [Ruby installers](https://www.ruby-lang.org/en/documentation/installation/)
      - The system default installation of Ruby ( >= 2.0) should be sufficient. For older OS versions,
        ruby may need to be installed.
      - Verify installation: open command prompt and enter:
        ```shell
           ruby --version
        ```
      - you should see something like:
        ```shell
           ruby 2.2.6p396 (2016-11-15 revision 56800) [x64-mingw32]
        ```

## Installation

- ### Rubygems

  The following rubygems must all be installed for kitchen-puppet to be functional:
  - [test-kitchen](http://kitchen.ci/)
  - [kitchen-vagrant](https://github.com/test-kitchen/kitchen-vagrant)
  - [librarian-puppet](https://github.com/rodjek/librarian-puppet)
  - [kitchen-puppet](https://github.com/neillturner/kitchen-puppet)

  These can all be installed at once:

  ```shell
     gem install test-kitchen kitchen-vagrant librarian-puppet kitchen-puppet
  ```
  This will also install all the necessary dependencies.

  After the gem installs are completed, two versions (3.2.0, 4.0.1) of the net-ssh gem will be installed. This causes
  a conflict with test-kitchen, which requires a gem version ~> 3.x.x. In order to ensure that there is no conflict
  check the net-ssh gem versions by running:

  ```shell
     gem list | grep net-ssh
  ```
  If the output lists two versions of net-ssh and one is 4.0.0 or greater (see below):

  ```shell
     net-ssh(3.2.0, 4.0.1)
  ```

  You will need to remove that version:

  ```shell
     gem uninstall net-ssh --version 4.0.1
  ```
  If you skip this step and both versions of net-ssh are installed,
  any `kitchen <command>` except `kitchen list` will fail with the following error:

  ```shell
     Kitchen: Message: Could not load the 'puppet_apply' provisioner from the load path.
  ```

  Verify kitchen:

  ```shell
     kitchen version
  ```

  Your output should be similar to this:
  ```shell
     Test Kitchen version 1.15.0
  ```

## Next step

[Configure directory structure to use kitchen-puppet](kpdirectorysetup.md)