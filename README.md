# upspin-openshift
Deploy Upspin server on OpenShift using self-signed certificate.

## Description
This repo is part of the project [Infrastructure as Code: Building a Universal Namespace](https://github.com/BU-CLOUD-S20/Infrastructure-as-Code-Building-a-Universal-Namespace). After installation, you will get an image running [Upspin](https://upspin.io/) service on OpenShift Container Platform.

## Usage
### Prerequisites
* Make sure you have access to a project on OpenShift Container Platform.
* Make sure you have [OpenShift CLI](https://docs.openshift.com/container-platform/4.2/cli_reference/openshift_cli/getting-started-cli.html) installed.
* Make sure you have Upspin packages installed.

### Install an Upspin server
1. Login to your project by OpenShift CLI
2. Deploy a new image directly from this repo
    ```
    $ oc new-app https://github.com/ZeyuKeithFu/upspin-openshift.git
    ```
3. Expose an external route on port 443

### Setup the server
1. Install the same root CA certificate as server side on your `Upspin` client
2. Push configuration data to the server by:
    ```
    $ upspin setupserver -domain=YOUR_DOMAIN -host=YOUR_SERVER_HOSTNAME
    ```