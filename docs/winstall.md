# Kitchen-puppet windows desktop install

Directions for setting up a fully configured [Kitchen-puppet](https://github.com/neillturner/kitchen-puppet) windows desktop.

## Prerequisites

- ### Virtualization platform
  Among the many virtualization platforms that Kitchen-puppet can leverage, for users with machines capable of running local VM's, it is recommended to use the [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/) platforms. As such, be sure that you are running a reasonably up to date version of each:

  - Vagrant installer: [Vagrant website](https://www.vagrantup.com/downloads.html)
  - VirtualBox installer: [VirtualBox website](https://www.virtualbox.org/wiki/Downloads)

  For those users leveraging the cloud, [GCP installation and configuration is here](gcp_setup.md).

- ### Software platforms
  Kitchen-puppet relies on an installation of [Puppet](https://puppet.com/), [Ruby](https://www.ruby-lang.org/en/), the [Ruby Devkit](http://rubyinstaller.org/add-ons/devkit/), and some pieces of [GitBash](https://git-scm.com/download/win).

  - Puppet installer: [Puppet installers](https://downloads.puppetlabs.com/windows/)
    - Previously the puppet .msi installer was required for proper functionality but puppet can now be installed using the gem install: `gem install puppet`

  - Ruby installer: [Ruby installers](https://rubyinstaller.org/downloads/)
    - As of this writing ruby2.2.6 is the latest stable, recommended beginner load.
    - Verify installation: open command prompt (or powershell) and enter:
        ```powershell
           ruby --version
        ```
    - you should see somthing like:
        `ruby 2.2.6p396 (2016-11-15 revision 56800) [x64-mingw32]`

  - Rubydevkit installer: [Ruby installers](https://rubyinstaller.org/downloads/)
    - Scroll down the page a bit and match it to the version of ruby you just installed
        (e.g. devkit-ming64-64-4.7.4-2013... etc.)
    - Extract the file to the directory of your choice, open a command prompt (or powershell
        window). switch to that directory, and run the command:

        ```powershell
           ruby dk.rb init
        ```
    - Open the config.yml file that is generated and add the path of the puppet ruby install:
         e.g.

         ```ruby
            - C:/Ruby23-x64/bin
         ```
    - now, run `ruby dk.rb` to bind it to the puppet application.

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
      gem install test-kitchen <kitchen-vagrant> OR <kitchen-google> librarian-puppet kitchen-puppet kitchen-inspec
  ```
  This will also install all the necessary dependencies.

  After the gem installs are completed, two versions (3.2.0, 4.0.1) of the net-ssh gem may be installed. This causes
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

  Verify kitchen install:
  ```shell
     kitchen version
  ```
  Your output should be similar to this:
  ```shell
     Test Kitchen version 1.15.0
  ```

  *** NOTE: You may run into a certificate issue when running kitchen create. It stems from how the openssl piece of GitBash was compiled. There is a CA cert that can't be found.

  REMEDIATION: With some minor variations here are the two commands that need to be run:
  - ```shell
    setx SSL_CERT_DIR C:\Users\<Kohls 'tk' ID>\AppData\Local\Programs\Git\mingw64\ssl\certs
    ```
  - ```shell
    setx SSL_CERT_FILE C:\Users\<Kohls 'tk' ID>\AppData\Local\Programs\Git\mingw64\ssl\cert.pem
    ```
    This will set these paths permanently. Close and reopen the command line to continue.

## Next step

- [Configure directory structure for module testing using kitchen-puppet](kpdirectorysetup.md) OR
- [Set up Roles/Profiles testing usign the puppet agent and the Kohls Puppet infrastructure](agentsetup.md)