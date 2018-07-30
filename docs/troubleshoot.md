# Troublehooting, Annoyances, etc

This is a general catchall for things that I have seen pop up while working with kitchen-puppet

- You may encounter this error when you first run a kitchen list:

  ```shell
     Kitchen: Message: Could not load the 'puppet_apply' provisioner from the load path.
  ```

  This is most likely due to a version conflict with net-ssh. The kitchen log will show you exactly,
  but a quick and dirty solution is to perform:

  ```shell
     gem uninstall net-ssh --version 4.0.1
  ```

- When running puppet you may encounter the following:

  ```shell
     "DL is deprecated, please use Fiddle"
  ```

  This is caused by using an older version of ruby. There are two ways to get this warning to go away:

  i. [Upgrade](https://rubyinstaller.org/downloads/) your ruby installation to 2.2.6 or better.  
  ii. Comment out the `warn "DL is deprecated, please use Fiddle"` line in: C:\Ruby200-x64\lib\ruby\2.0.0\dl.rb

- Fix pluginsync puppet warning:

  You may encounter a warning message about pluginsync being deprecated. This is because pluginsync is enabled by default
  in some puppet installations and there is a puppet.conf setting is what is throwing the error. This is seen primarliy
  on windows boxen. The fix is to comment out the line:

  ```ruby
     pluginsync=true
  ```

  in: C:\ProgramData\PuppetLabs\puppet\etc\puppet.conf for windows or *insert path here*/puppet.conf in Lin/OSX
