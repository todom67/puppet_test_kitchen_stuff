# Kitchen-puppet agent_provisioner setup

## Table of Contents

- [Prerequisites](#prerequisites)
- [Agent Configuration](#agent-configuration)
  - [.kitchen.yml](#kitchen.yml)
- [Directory Structure](#testing-directory-structure-and-files)
- [Test run](#run-the-test)
- [Encore](#encore)

## Prerequisites

- In order for these tests to properly execute

  - kitchen-puppet must be installed and configured on the machine where
    we are running our tests. See the [README](../README.md) for installation instructions.

## Agent configuration

- We execute kitchen-puppet commands from the ../my\_testing\_directory directory and it
  leverages [inspec](http://inspec.io/) to perform the automated testing. As such,
  it is expecting two things:

  - a .kitchen.yml file in ../my\_testing\_directory.
  - a directory structure within our ../my\_testing\_directory directory containing the inspec ruby testing files.

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
        project: kohls-infraci-sbx
        region: us-central1
        network: sandbox
        subnet: sandbox-ci-cd-prv01
        disk_size: 40
        use_private_ip: true
        tags:
          - test-kitchen

     provisioner:
        name: puppet_agent
        require_chef_for_busser: false

     verifier:
        ruby_bindir: '/opt/puppetlabs/puppet/bin'
        sudo: false
        output: results/%{platform}_%{suite}_inspec.yaml
        format: documentation
        name: inspec

     platforms:
     - name: rhel7
         driver:
         image_project: kohls-infraci-sbx
         image_name: kohls-rhel7-puppetci-1495490509
     - name: rhel6
         driver:
         image_project: kohls-infraci-sbx
         image_name: kohls-rhel6-puppetci-1495489777

    transport:
      username: TKMAITG
      ssh_key: ~/.ssh/google_compute_engine

    suites:
    - name: pab7
        provisioner:
          puppet_agent_command: sudo /usr/local/bin/activate_pos.sh --pup-env nonprod --server puppet.kohls.com --ca-server puppetmom.kohls.com --location gcp_central_us --flavor base --role base_rhel7 --fact-env nonprod
        verifier:
          inspec_tests:
            - path: agent_tests/acceptance/
        excludes: ['rhel6']
    - name: pab6
        provisioner:
          puppet_agent_command: sudo /usr/local/bin/activate_pos.sh --pup-env nonprod --server puppet.kohls.com --ca-server puppetmom.kohls.com --location gcp_central_us --flavor base --role base_rhel6 --fact-env nonprod
        verifier:
          inspec_tests:
            - path: agent_tests/acceptance/
        excludes: ['rhel7','rhel6']
  ```

  Here is a brief overview of each section:

  - #### driver
    this is the driver used to create platform instances.

  - #### provisioner

    this is the shell provisioner that is going to execute the puppet commands, in our case
    we are using [puppet_agent](https://github.com/neillturner/kitchen-puppet/blob/master/provisioner_options.md). We then
    include specific configurations needed for the provisioner to successfullly execute.

    We set the `require_chef_for_busser:` setting to `false` as kitchen-puppet versions >1.4 no longer require chef for installation or bussing.

    *** NOTE: There are going to be test suite sepcific provisioner settings. Settings at this level are global. ***

  - #### verifier
    This is the testing software that will be used. By default, serverspec is installed and run. Our configuration will be using [InSpec](https://www.inspec.io/). Remember, these are the global settings, we will also be providing suite specific settings below.

    Since we are not using chef as our testing busser, we must supply the proper path to a ruby installation: `ruby_bindir: '/opt/puppetlabs/puppet/bin'`.

    We must then tell the verifier not to prepend it's commands with sudo as the puppet run will remove that access:`sudo: false`

    We can redirect the testing output from stdout to a file as follows:

    ```yaml
        output: results/%{platform}\_%{suite}\_inspec.yaml
        format: documentation
    ```

    We then specify that we are using inspec and not the default serverspec: `name: inspec`.

  - #### platforms
    This can be any operating system platform you wish. Since we are using the Google Compute Platform and our the Kohl's Packer images, we must specify the GCP project name and the image name in the `drivers:` section.

  - #### transport
    We are using the default transport of ssh and need to specify which key to use for logins. This should be a key that is in the project metadata, and its associated username.

  - #### suites
    This is where we configure individual suites of tests. In this example scenario, we are testing the base_rhel7 role.

    For each profile, we need to specify the proper conditions to allow the provisioner to exectute the activate_pos.sh script. Note that this provisioner setting is specific to this test suite.

    We also need to point our verifier to the location of our testing files.

    Finally, since we have two operating system platforms configured in the global section, we will need to exclude the Redhat 6 platform.

    ```yaml
    suites:
      - name: pab7
          provisioner:
            puppet_agent_command: sudo /usr/local/bin/activate_pos.sh --pup-env nonprod --server puppet.kohls.com --ca-server puppetmom.kohls.com --location gcp_central_us --flavor base --role base_rhel7 --fact-env nonprod
          verifier:
            inspec_tests:
              - path: agent_tests/acceptance/
            excludes: ['rhel6']
    ```

  Once the kitchen file is complete and still in the ../my\_testing\_directory directory,
  run the command:

  ```shell
     kitchen converge
  ```

  You will see a lot of output as test-kitchen calls GCP to build and spin up machines and then run the puppet manifests. The last several lines should be similar to this:

   ```shell
             Notice: /Stage[main]/Ei_unix_service_account::Nzintgr/Ssh_authorized_key[nzintgr-jenkins-mobility@kohls.com]/ensure: created
             Notice: /Stage[main]/Ei_unix_service_account::Nzintgr/Ssh_authorized_key[nzintgr-jenkins-cfmc@kohls.com]/ensure: created
             Notice: /Stage[main]/Ei_unix_service_account::Nzintgr/Ssh_authorized_key[nzintgr-QCoE-Automation@kohls.com]  /ensure: created
             Notice: /Stage[main]/Ei_unix_service_account::Nzintgr/Ssh_authorized_key[nzintgr-Jenkins-CI@kohls.com ]/ensure:  created
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

  For more info on settings within the .kitchen.yml file see: [Kitchen yaml](https://docs.chef.io/config_yml_kitchen.html)

## Testing directory structure and files

Now that we have a working .kitchen.yml file, our next step is to give kitchen-puppet some tests to run.
Our kitchen-puppet looks for _inspec_ test cases in the ../agent_tests/acceptance/ directory, so let's configure a few tests!
