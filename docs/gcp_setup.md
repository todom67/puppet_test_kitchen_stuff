# Configure Google Cloud Platform

Directions for installing and configuring the Google Cloud SDK to enable spinning up and connecting to GCP machines with test kitchen.

The `kitchen-google` gem, which allows us to provision GCP machines using test-kitchen,
leverages the [Google Ruby API Client](https://github.com/google/google-api-ruby-client) which in turn, relies on the [Google Auth Library](https://github.com/google/google-auth-library-ruby) to handle Authentication and Authorization.

## Install Google Cloud SDK

The easiest way to get all of the above configured is to download and install the [Google Cloud SDK](https://cloud.google.com/sdk/).

- After browsing to the [Google Cloud SDK Quickstarts](https://cloud.google.com/sdk/docs/quickstarts) page,  choose the proper install method:
  - For a Windows install, choose [Quickstart for Windows](https://cloud.google.com/sdk/docs/quickstart-windows) and download the [installer](https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKInstaller.exe).
    - Launch the installer after it downloads.
    - Choose the current user option to avoid needing local admin credentials to complete the install.
    - After the installer completes,
      - uncheck the "Run 'gcloud init'" box and click finish.
  - For a Linux install, choose  [Quickstart for Linux](https://cloud.google.com/sdk/docs/quickstart-linux) and download the proper tarball.
    - Extract the tarball to a safe and sane location.
    - Execute: `./google-cloud-sdk/install.sh`

## Initialize Google Cloud SDK

### Windows
  (continued from previous section)
- This will launch the GC SDK Shell,
  - at the command line type `gcloud init --console-only`
- At the `You must log in to continue. Would you like to log in (Y/n)?` prompt, enter Y.

### Linux
  (continued from previous section)
- From the command line, enter `gcloud init --console-only`
- You may see a few options, depending on what type of machine you have provisioned, choose the option for
  `Log in with a new account`

### All platforms

- An authorization link will be generated.
  - Copy and paste the link from the command window into a browser, preferrably Google Chrome, as it behaves better.
- On the page in your browser,
  - copy the verification code and paste it back into your command window.
- You will now see a message stating that you are logged in as: [username].
- A list of available projects will scroll through, along with a warning message.
  - Enter `my_project-infraci-sbx` after the project prompt.
- You will then be prompted to configure a default zone,
  - choose one of the us-central-xx zones.
- The configuration will finish and you will now have successfully initialized the GC SDK.

## Create Authorization Token

As stated in the introduction, the underlying [API](https://github.com/google/google-api-ruby-client) used by the [kitchen-google plugin](https://github.com/test-kitchen/kitchen-google) relies on the [Google Auth Library](https://github.com/google/google-auth-library-ruby) to handle authentication. The auth library expects to find a JSON credentials file at: `~/.config/gcloud/application_default_credentials.json`

To generate the file:

- From the GC SDK Shell,
  - run the command: `gcloud auth application-default login`
- On a Windows machine, this will open your default browser and authenticate to the GCP. *** _Note: In the event that your default browser is not Google Chrome, you can copy the link from the shell window and paste it into Chrome. IE does not always properly authenticate._ ***
- In the Linux console, you will be provided with a link to copy and paste to a browser as previously performed.
- There will be a success message in the browser and in the GC SDK Shell the line:

```shell
   Windows:
   Credentials saved to file: [C:\Users\<tk-id>\AppData\Roaming\gcloud\application_default_credentials.json]
   Linux:
   Credentials saved to file: [/<USERNAME>/.config/gcloud/application_default_credentials.json]
```

will appear.

- This is the credential file that we need, and will be used by any library requesting default application credentials.

## SSH Keys

In order to bootstrap Linux nodes, you need to have SSH keys setup correctly. Here at Kohl's it will need to be added to the _my_project-infraci-sbx_ project metadata.

## Next Steps

Once these steps have been completed, head back to [Windows desktop](winstall.md) or to [Linux Workstation](linstall.md) and continue on in the 'Software platforms' section.
