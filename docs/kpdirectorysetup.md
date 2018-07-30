# Directory configuration for kitchen-puppet

Kitchen-puppet expects certain files in certain locations in order to properly execute and while this
is neither the definitive guide nor the only way to set this up, I have found that the following structure
seems to work the best:

- Given a testing directory named my\_testing\_directory we need to create the following:

  ```shell
    C:.
    └───my_testing_directory
        ├───hieradata
        ├───manifests
        └───modules
  ```

  These directories are accessed by the .kitchen.yml when we are running our kitchen commands.

  Let's examine each directory individually...

- hieradata - contains hiera data used within our testing. At the very least, we need a file named common.yaml so that the `kitchen converge` command will successfully execute.
- manifests - contains site.pp which is used to include our classes for testing. The site.pp file acts as the main manifest for the puppet run and **this directory is not
 to be confused with the manifests directory located in our module directory.** A blank file will suffice to start.
- modules - this directory contains all modules and their dependencies that we wish to utilize during testing.

- Create common.yaml:

    Switch to your testing directory and then:

  ```shell
     touch hieradata/common.yaml
     echo '---' >> hieradata/common.yaml
  ```

- Create site.pp:

    Switch to your testing directory and then:

  ```shell
     touch manifests/site.pp
  ```

## Final structure

  ```shell
    └───my_testing_directory
        ├───hieradata
        |   └───common.yaml
        ├───manifests
        |   └───site.pp
        └───modules
  ```

## Next step

- [Configure module to use kitchen-puppet](modulesetup.md)
- _Optional:_ [Include modules from the puppet forge in your tests](librarian.md)