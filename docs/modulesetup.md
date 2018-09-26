# Configure puppet module to use kitchen-puppet

## Table of Contents

- [Prerequisites](#prerequisites)
- [Module Configuration](#module-configuration)
  - [.kitchen.yml](#kitchen.yml)
- [Directory Structure](#testing-directory-structure-and-files)
- [Test run](#run-the-test)
- [Encore](#encore)

## Prerequisites

- In order for these tests to properly execute

  - kitchen-puppet must be installed and configured on the machine where
    we are running our tests. See the [README](../README.md) for installation instructions.
  - [The directory structure must be configured](kpdirectorysetup.md)

## Module configuration

- We execute kitchen-puppet commands from the ../my\_testing\_directory directory and it
  leverages [inspec](http://inspec.io/) to perform the automated module testing. As such,
  it is expecting two things:

  - a .kitchen.yml file in ../my\_testing\_directory.
  - a directory structure within our ../modules/\<our\_module\> directory containing the inspec ruby files.

- ### .kitchen.yml

  This file resides in ../my\_testing\_directory and contains the configuration that is needed
  for kitchen-puppet to work its magic.

  The first important property to note is the name: **.kitchen.yml**, that is, the file name is: (dot)kitchen(dot)yml.
  The filename **MUST START WITH A '.' **

  For the initial setup we will use the sample code in the file ../puppet_test_kitchen_stuff/.kitchen.yml:

  ```yaml
      ---
      driver:
        name: gce
        project: my_project-infraci-sbx
        region: us-central1
        network: sandbox
        subnet: sandbox-ci-cd-prv01
        disk_size: 40
        use_private_ip: true
        tags:
          - test-kitchen

      provisioner:
        name: puppet_apply
        manifests_path: manifests
        modules_path: modules
        hiera_data_path: hieradata
        require_chef_for_busser: false
        require_puppet_collections: true
        puppet_detailed_exitcodes: true
        puppet_whitelist_exit_code:
          - 0
          - 2

      verifier:
        ruby_bindir: '/opt/puppetlabs/puppet/bin'
        name: inspec

      platforms:
        - name: infraci-sbx-rhel-7
          driver:
            image_project: my_project-infraci-sbx
            image_name: my_project-rhel7-puppetci-1495490509

      transport:
        username: <username>
        ssh_key: ~/.ssh/google_compute_engine

      suites:
        - name: sfp
          verifier:
            inspec_tests:
              - path: modules/simple_file_demo/test/acceptance/default_spec.rb
        - name: te2
          verifier:
            inspec_tests:
              - path: modules/test_example_2/test/acceptance/default_spec.rb
  ```

  Here is a brief overview of each section:

  - #### driver
    this is the driver used to create platform instances.

  - #### provisioner

    this is the shell provisioner that is going to execute the puppet commands, in our case
    we are using [puppet_apply](https://github.com/neillturner/kitchen-puppet/blob/master/provisioner_options.md). We then
    include specific configurations needed for the provisioner to successfullly execute. Notice that the
    three directory paths specified coincide with the directory structure that we created in the [directory structure configuration guide](kpdirectorysetup.md).

    We set the `require_chef_for_busser:` setting to `false` as kitchen-puppet versions >1.4 no longer require chef for installation or bussing.

    The final setting that we use is `require_puppet_collections: true`. This ensures that we are using the
    latest version of puppet on our provisioned machine. Setting this to false or omitting it will install puppet 3.8
    on the GCE host.

    *** NOTE: puppet is already baked into the Kohl's sandbox images, but omitting this setting will cause test-kitchen to attempt an install of puppet 3.8 which breaks the puppet apply command ***

  - #### verifier
    This is the testing software that will be used. By default, serverspec is installed and run. Our configuration will be using [InSpec](https://www.inspec.io/).

    Since we are not using chef as our testing busser, we must supply the proper path to a ruby installation: `ruby_bindir: '/opt/puppetlabs/puppet/bin'`.

    We then specify that we are using inspec and not the default serverspec: `name: inspec`.

  - #### platforms
    This can be any operating system platform you wish. Since we are using the Google Compute Platform and our the Kohl's Packer images, we must specify the GCP project name and the image name in the `drivers:` section.

  - #### transport
    We are using the default transport of ssh and need to specify which key to use for logins. This should be a key that is in the project metadata, and its associated username.

  - #### suites
    This is where we configure individual suites of tests. In this example scenario, we are testing two modules: simple\_file\_demo and test\_example\_2. 

    For each module we need to supply test-kitchen with a name for the suite and we need to point test-kitchen to our tests. The settings are self explanatory.
    ```yaml
    suites:
      - name: sfp
        verifier:
          inspec_tests:
            - path: modules/simple_file_demo/test/acceptance/default_spec.rb
      - name: te2
        verifier:
          inspec_tests:
            - path: modules/test_example_2/test/acceptance/default_spec.rb
    ```

  Once the kitchen file is complete and still in the ../my\_testing\_directory directory,
  run the command:

  ```shell
     kitchen converge
  ```

  You will see a lot of output as test-kitchen calls GCP to build and spin up machines and then run the puppet manifests. The last several lines should be similar to this:

   ```shell
          Transferring files to <default-centos-71>
          Going to invoke puppet apply with:

                sudo -E /opt/puppetlabs/bin/puppet apply /tmp/kitchen/manifests/site.pp --modulepath=/tmp/kitchen/modules -
   -fileserverconfig=/tmp/kitchen/fileserver.conf

          Notice: Compiled catalog for default-centos-71.vagrantup.com in environment production in 0.09 seconds
          Notice: Greetings from default-centos-71!
          Notice: /Stage[main]/Simple_file_demo/Notify[Greetings from default-centos-71!]/message: defined 'message' as 'Gr
   eetings from default-centos-71!'
          Notice: Applied catalog in 0.07 seconds
          Finished converging <default-centos-71> (0m5.47s).
   -----> Kitchen is finished. (0m5.71s)
   ```

  For more info on settings within the .kitchen.yml file see: [Kitchen yaml](https://docs.chef.io/config_yml_kitchen.html)

## Testing directory structure and files

Now that we have a working .kitchen.yml file, our next step is to give kitchen-puppet some tests to run.
Kitchen-puppet looks for _serverspec_ test cases in the ../modules/\<our\_module\>/test/integration/default/serverspec directory, and _inspec_ tests in the ../modules/\<our\_module\>/test/acceptance/ directory, so let's configure one or the other or both of them!

### serverspec

- switch to the ../modules/\<our\_module\> directory and run:
  - windows (powershell):

    ```powershell
       new-item -type directory -path ./test/integration/default/serverspec -Force
    ```

  - linux/OSX

    ```shell
       mkdir -p /test/integration/default/serverspec
    ```

  Next we create a spec_helper.rb file. This file will save us some typing as our test classes grow in number and complexity.
  We will then include it in our individual test cases.

  ```shell
    touch /test/integration/default/serverspec/spec_helper.rb
    echo "require 'serverspec'" >> test/integration/default/serverspec/spec_helper.rb
    echo "set :backend, :exec" >> test/integration/default/serverspec/spec_helper.rb
  ```

  Our spec_helper.rb should look like this:

  ```ruby
    require 'serverspec'

    set :backend, :exec
  ```

  Next up is to create ../modules/\<our\_module\>/test/integration/default/serverspec/default_spec.rb.
  We need this file to test our module class as coded in ../modules/\<our\_module\>/manifest/init.pp file

  As a basic test, add this content:

  ```ruby
    require 'spec_helper'

    if os[:family] == 'redhat'
      describe '/etc/redhat-release' do
        it "exists" do
          expect(file('/etc/redhat-release')).to be_file
        end
      end
    end
  ```

  Once we have this file completed we are ready to test!

### inspec

- switch to the ../modules/\<our\_module\> directory and run:
  - windows (powershell):

    ```powershell
       new-item -type directory -path ./test/acceptance -Force
    ```

  - linux/OSX

    ```shell
       mkdir -p /test/acceptance
    ```

  Next up is to create ../modules/\<our\_module\>/test/accepatance/default_spec.rb.
  We need this file to test our module class as coded in ../modules/\<our\_module\>/manifest/init.pp file

  As a basic test, add this content:

  ```ruby
    describe file('/etc/redhat-release') do
      it { should exist }
      its('type') { should eq :file }
    end
  ```

  Once we have this file completed we are ready to test!

## Run the test

- run:

  ```shell
     kitchen verify
  ```

  There will be some program execution output and the you should see something like this:

  ```shell
     PS C:\my_testing_directory\modules\test_demo> kitchen verify
    -----> Starting Kitchen (v1.15.0)
    -----> Verifying <default-centos-71>...
           Preparing files for transfer
    -----> Busser installation detected (busser)
           Installing Busser plugins: busser-serverspec
           Plugin serverspec already installed
           Removing /tmp/verifier/suites/serverspec
           Transferring files to <default-centos-71>
    -----> Running serverspec test suite
           /opt/chef/embedded/bin/ruby -I/tmp/verifier/suites/serverspec -I/tmp/verifier/gems/gems/rspec-support-3.5.0/lib:/
    tmp/verifier/gems/gems/rspec-core-3.5.4/lib /opt/chef/embedded/bin/rspec --pattern /tmp/verifier/suites/serverspec/\*\*/
    \*_spec.rb --color --format documentation --default-path /tmp/verifier/suites/serverspec

           /etc/redhat-release
             exists

           Finished in 0.01243 seconds (files took 0.37115 seconds to load)
           1 example, 0 failures

           Finished verifying <default-centos-71> (0m7.08s).
    -----> Kitchen is finished. (0m7.32s)
  ```

  We see that our test ran and that it passed! You are now on your way to integrating TDD into your puppet
  development process!

## Encore

- To test other subclasses with your module, create a \<subclass_name\>_spec.rb file, and include the new subclass in your site.pp
- [Include modules from the puppet forge in your tests](librarian.md)