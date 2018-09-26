# Table of Contents

- [Introduction](#introduction)
- [Quickstarts](#quickstarts)
  - [Preparation](#preparation)
  - [Quickstart Module Testing #1](#quickstart-module-testing-1)
  - [Quickstart Module Testing #2](#quickstart-module-testing-2)
  - [Quickstart Profile Testing #1](#quickstart-profile-testing-1)
  - [Quickstart Profile Testing #2](#quickstart-profile-testing-2)
- [Installation and configuration](#installation-and-configuration)
- [Module confugration for TDD](#module-confugration-for-tdd)
- [Including forge modules in your tests](#including-forge-modules-in-your-tests)
- [Troubleshooting](#troubleshooting)

## Introduction

Welcome to the puppet_test_kitchen_stuff repository!
This repo is your one stop shop for everything you need to get a
[test-driven developement (TDD)](https://en.wikipedia.org/wiki/Test-driven_development)  environment for puppet
up and running.

## Quickstarts

### Preparation

- Follow the [installation and configuration instructions for your particular platform](#installation-and-configuration). **You do not need to
  configure the directory structure.**

- Clone this repository to your workstation:

  ```shell
     git clone git@github.com:todom67/puppet_test_kitchen_stuff.git
     cd puppet_test_kitchen_stuff
  ```

- Remove this repository as the origin remote:

  ```shell
     git remote remove origin
  ```
- Add your internal repository as the origin remote:

  ```shell
     git remote add origin <url of YOUR repository>
  ```

Your local test environment is now under version control and you are ready to proceed.

### Quickstart Module Testing #1

If you already have experience with test-kitchen and serverspec or inspec and wish to start using this framework immediately, perform the following steps:

- Be sure you have [prepared your workstation](#preparation)
- switch to the puppet\_test\_kitchen\_stuff/module\_testing directory:

  ```shell
     cd /PATH/TO/puppet_test_kitchen_stuff/module_testing
  ```

- remove the puppet\_test\_kitchen_stuff/module_testing/modules/simple\_file\_demo directory and the puppet\_test\_kitchen_stuff/module_testing/modules/test\_example\_2 directory as well as all their contents:
  - windows (powershell)
  ```powershell
     Remove-Item ./modules/* -recurse
  ```
  - Linux
  ```shell
     rm -rf modules/simple_file_demo
     rm -rf modules/test_example_2
  ```

- create your module and tests in the modules directory and marvel at the wonders of TDD!
- (optional) [Add puppet forge modules to your tests](docs/librarian.md)

### Quickstart Module Testing #2

To see a test run using the sample code, do the following:

- Be sure you have [completed the preparation](#preparation)
- switch to the puppet\_test\_kitchen\_stuff/module\_testing directory:

  ```shell
     cd /PATH/TO/puppet_test_kitchen_stuff/module_testing
  ```

- Run the following commands:

  i. List test kitchen machines:

    ```shell
       kitchen list
    ```

    You should see output similar to this:

    ```shell
       PS C:\puppet_test_kitchen_stuff> kitchen list
       Instance                 Driver                Provisioner  Verifier  Transport  Last Action  Last Error
       sfp-puppet-apply-rhel-7  Google Compute (GCE)  PuppetApply  Inspec    Ssh        <Not Created>  <None>
       sfp-puppet-apply-rhel6   Google Compute (GCE)  PuppetApply  Inspec    Ssh        <Not Created>  <None>
       te2-puppet-apply-rhel-7  Google Compute (GCE)  PuppetApply  Inspec    Ssh        <Not Created>  <None>
       te2-puppet-apply-rhel6   Google Compute (GCE)  PuppetApply  Inspec    Ssh        <Not Created>  <None>
    ```

     This indicates that the .kitchen.yml file is valid and that we are ready to converge.

  ii. Next, let's converge the machines:

     ```shell
        kitchen converge
     ```

     You will see quite a bit of output as GCP builds and spins up the machines, installs and then runs the puppet manifests. It should end similar to this:

     ```shell
            Notice: /Stage[main]/Simple_file_demo/File[/tmp/my_dir/my_file_content.txt]/ensure: defined content as
            '{md5}458420979837bffd4d24cb1d0bf5c1ef'
            Notice: This is the other class! 'test_example_2'
            Notice: /Stage[main]/Test_example_2/Notify[This is the other class! 'test_example_2']/message: defined
            'message' as 'This is the other class! 'test_example_2''
            Notice: /Stage[main]/Test_example_2/File[/tmp/from_example_2]/ensure: defined content as '{md5}3351a99e
            2935f5f544a98dca0e7dcf44'
            Notice: Applied catalog in 0.32 seconds
            Finished converging <te2-puppet-apply-rhel6> (0m9.74s).
    -----> Kitchen is finished. (6m9.01s)
     ```

     If you received error messages at any point after running either of the above commands, review the installation instructions
    and/or check the [Troubleshooting, errors, etc](docs/troubleshoot.md) doc.

  iii. And finally let's run the test:

    ```shell
       kitchen verify
    ```

    There will again be quite a bit of output as two test suites are run against two operating system platforms. The last few lines should be similar to the following:

     ```shell
        Profile: tests from {:path=>"C:/source/aheadsource/puppet_test_kitchen_stuff/module_testing/modules/test_examp
        le_2/test/acceptance/default_spec.rb"}
        Version: (not specified)
        Target:  ssh://TKMAITG@10.207.141.14:22

          [PASS]  te2-ctl-01: testing /tmp/from_example_2
            [PASS]  File /tmp/from_example_2 should exist
            [PASS]  File /tmp/from_example_2 type should eq :file
            [PASS]  File /tmp/from_example_2 mode should cmp == "0644"
            [PASS]  File /tmp/from_example_2 owner should eq "root"
            [PASS]  File /tmp/from_example_2 content should match /Linux/

        Profile Summary: 1 successful, 0 failures, 0 skipped
        Test Summary: 5 successful, 0 failures, 0 skipped
              Finished verifying <te2-puppet-apply-rhel6> (0m1.39s).
        -----> Kitchen is finished. (0m18.90s)
     ```

    Congratulations! You have successfully run inspec tests against a puppet module!

### Quickstart Profile Testing #1

If you already have experience with test-kitchen and serverspec or inspec and wish to start using this framework immediately, perform the following steps:

- Be sure you have [prepared your workstation](#preparation)
- switch to the puppet\_test\_kitchen\_stuff/agent\_testing directory:

  ```shell
     cd /PATH/TO/puppet_test_kitchen_stuff/agent_testing
  ```

- remove the contents of the agent_tests/acceptance directory:
  - windows (powershell)
  ```powershell
     Remove-Item ./agent_tests/acceptance -recurse
  ```
  - Linux
  ```shell
     rm -rf agent_tests/acceptance
  ```

- create your tests and configure the .kitchen.yml file and marvel at the wonders of TDD!

### Quickstart Profile Testing #2

To see a test run using the sample code a profile from the control repo, do the following:

- Be sure you have [completed the preparation](#preparation)
- switch to the puppet\_test\_kitchen\_stuff/agent\_testing directory:

  ```shell
     cd /PATH/TO/puppet_test_kitchen_stuff/agent_testing
  ```

- Run the following commands:

  i. List test kitchen machines:

    ```shell
       kitchen list
    ```

    You should see output similar to this:

    ```shell
       Instance    Driver                Provisioner  Verifier  Transport  Last Action   Last Error
       pab7-rhel7  Google Compute (GCE)  PuppetAgent  Inspec    Ssh        <Not Created> <None>
    ```

     This indicates that the .kitchen.yml file is valid and that we are ready to converge.

  ii. Next, let's converge the machines:

     ```shell
        kitchen converge
     ```

     You will see quite a bit of output as GCP builds and spins up the machines, installs and then runs the puppet manifests. It should end similar to this:

     ```shell
             Notice: /Stage[main]/Ei_unix_service_account::Nzintgr/Ssh_authorized_key[nzintgr-jenkins-mobility@my_project.com]/ensure: created
             Notice: /Stage[main]/Ei_unix_service_account::Nzintgr/Ssh_authorized_key[nzintgr-jenkins-cfmc@my_project.com]/ensure: created
             Notice: /Stage[main]/Ei_unix_service_account::Nzintgr/Ssh_authorized_key[nzintgr-QCoE-Automation@my_project.com]  /ensure: created
             Notice: /Stage[main]/Ei_unix_service_account::Nzintgr/Ssh_authorized_key[nzintgr-Jenkins-CI@my_project.com ]/ensure:  created
             Info: Stage[main]: Unscheduling all events on Stage[main]
             Notice: Applied catalog in 561.48 seconds
             Notice: /Service[puppet]/ensure: ensure changed 'stopped' to 'running'
             service { 'puppet':
               ensure => 'running',
               enable => 'true',
             }
             Finished converging <pab7-rhel7> (10m35.40s).
      -----> Kitchen is finished. (11m42.39s)
     ```

     If you received error messages at any point after running either of the above commands, review the installation instructions
    and/or check the [Troubleshooting, errors, etc](docs/troubleshoot.md) doc.

  iii. And finally let's run the test:

    ```shell
       kitchen verify
    ```

    There will again be quite a bit of output as two test suites are run against two operating system platforms. The last few lines should be similar to the following:

     ```shell
        iamawesome@timtest-tkitchen ~/puppet_test_kitchen_stuff/agent_testing > kitchen verify
        -----> Starting Kitchen (v1.16.0)
        -----> Setting up <pab7-rhel7>...
              Finished setting up <pab7-rhel7> (0m0.00s).
        -----> Verifying <pab7-rhel7>...
              Loaded tests from {:path=>"/root/puppet_test_kitchen_stuff/agent_testing/agent_tests/acceptance/"}
              Finished verifying <pab7-rhel7> (0m15.81s).
        -----> Kitchen is finished. (0m16.96s)
        iamawesome@timtest-tkitchen ~/puppet_test_kitchen_stuff/agent_testing >
     ```

    Congratulations! You have successfully run inspec tests against a puppet profile!
    Note: In this case we have the output configured to dump to file. If you examine the .kitchen.yml file you will see that the output has been redirected to results/rhel7_pab7_inspec.cli

    If you cat that file, you will see results similar to terminal out put.

## Installation and configuration

- [Windows desktop](docs/winstall.md)
- [Mac-OSX desktop](docs/osxinstall.md)
- [Linux desktop](docs/linstall.md)
- [Configure directory structure to use kitchen-puppet agent provisioner (all operating systems)](docs/kpdirectorysetup.md)

## Module confugration for TDD

- [Configure a puppet module to use kitchen-puppet](docs/modulesetup.md)

## Including forge modules in your tests

- [Add modules from the puppet forge to your tests](docs/librarian.md)

## Troubleshooting

- [Troubleshooting, errors, etc](docs/troubleshoot.md)