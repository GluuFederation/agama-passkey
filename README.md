<!-- These are statistics for this repository-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![Apache License][license-shield]][license-url]

# About Agama Passkey

This repo is home to the Gluu Agama-passkey project. Use this project to add 
user authentication with **Passkey**(passwordless authentication that uses 
a device to verify a user's identity before allowing them to access an account)
2-factor authentication.

## Where To Deploy

The project can be deployed to any IAM server that runs an implementation of
the [Agama Framework](https://docs.jans.io/head/agama/introduction/) like
[Janssen Server](https://jans.io) and [Gluu Flex](https://gluu.org/flex/).


## How To Deploy

Different IAM servers may provide different methods and
user interfaces from where an Agama project can be deployed on that server.
The steps below show how the Agama-passkey project can be deployed on the
[Janssen Server](https://jans.io).

Deployment of an Agama project involves three steps.

- [Downloading the `.gama` package from the project repository](#download-the-project)
- [Adding the `.gama` package to the IAM server](#add-the-project-to-the-server)
- [Configure the project](#configure-the-project)


#### Pre-Requisites

* Register a client to integrate with SCIM (used to list passkeys and edit), minimum scopes:
- https://jans.io/scim/fido2.read
- https://jans.io/scim/fido2.write


### Download The Project

> [!TIP]
> Skip this step if you use the Janssen Server TUI tool to
> configure this project. The TUI tool enables the download and adding of this
> project directly from the tool, as part of the `community projects` listing.

The project is bundled as 
[.gama package](https://docs.jans.io/head/agama/gama-format/). 
Visit the `Assets` section of the 
[Releases](https://github.com/GluuFederation/agama-passkey/releases) to download 
the `.gama` package.


### Add The Project To The Server

The Janssen Server provides multiple ways an Agama project can be 
deployed and configured. Either use the command-line tool, REST API, or a 
TUI (text-based UI). Refer to the [Agama project configuration page](https://docs.jans.io/head/admin/config-guide/auth-server-config/agama-project-configuration/) in the Janssen Server documentation for more details.

### Configure The Project

The Agama project accepts configuration parameters in the JSON format. Every Agama 
project comes with a basic sample configuration file for reference. 

Below is a typical configuration of the Agama-passkey project. As shown, it contains 
configuration parameters for the [flows contained in it](#flows-in-the-project):

Sample JSON:

``` json
{
    "org.gluu.agama.passkey.main": {
        "scimClientId": "PUT_YOUR_SCIM_CLIENT_ID_HERE",
        "scimClientSecret": "PUT_YOUR_SCIM_CLIENT_SECRET"
    }
}
```



### Test The Flow

Use any relying party implementation (like [jans-tarp](https://github.com/JanssenProject/jans/tree/main/demos/jans-tarp)) 
to send an authentication request that triggers the flow.

From the incoming authentication request, the Janssen Server reads the `ACR` 
parameter value to identify which authentication method should be used.
To invoke the `org.gluu.agama.passkey.main` flow contained in the Agama-passkey 
project, specify the ACR value as `agama_<qualified-name-of-the-top-level-flow>`, 
i.e `agama_org.gluu.agama.passkey.main`.

## Customize and Make It Your Own

Fork this repo to start customizing the Agama-passkey project. It is possible to
customize the user interface provided by the flow to suit your organisation's
branding
guidelines. Or customize the overall flow behavior. Follow the best
practices and steps listed
[here](https://docs.jans.io/head/admin/developer/agama/agama-best-practices/#project-reuse-and-customizations)
to achieve these customizations in the best possible way.
This project can be reused in other Agama projects to create more complex
authentication journeys.  To reuse, trigger the
[org.gluu.agama.passkey.main](#flows-in-the-project) flow from other Agama projects.

To make it easier to visualise and customize the Agama Project, use
[Agama Lab](https://cloud.gluu.org/agama-lab/login).


## Flows In The Project

| Qualified Name | Description |
|-----------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `org.gluu.agama.passkey.main` | This is the main flow, which you can directly launch from the browser. If you have not configured a passkey, you must first log in with your credentials and register your passkey(s) at `org.gluu.agama.passkey.list`. If you have at least 1 passkey configured, then you can click the "Login with passkey" button. |
| `org.gluu.agama.passkey.list` | This flow is used to list the passkeys that the logged-in user has registered. If you do not have a passkey, an option to add a new passkey, `org.gluu.agama.passkey.add` is enabled. If you already have at least one passkey, you can click `Login with passkey`. |
| `org.gluu.agama.passkey.add` | This flow is used to register a new passkey. The user has to validate his FIDO device, which can be a (Yubico key, device fingerprint, Windows Hello, Apple Face ID, etc.). |
| `org.gluu.agama.passkey.nickname` | This flow is used to add a nickname to the newly registered passkey. Once completed, this stream returns to the `org.gluu.agama.passkey.list`



## Demo

Check out this video to see the **agama-passkey** authentication flow in action.
Also check the
[Agama Project Of The Week](https://gluu.org/agama-project-of-the-week/) video
series for a quick demo on this flow.

*Note:*
While the video shows how the flow works overall, it may be dated. Do check the
[Test The Flow](#test-the-flow) section to understand the current
method of passing the ACR parameter when invoking the flow.


* Login with credentials and configure your first passkey device, and as a last step, complete the login with your new configured key.
![TEST_USE_CASE_1](https://github.com/GluuFederation/agama-passkey/assets/86965029/0e5cc346-a576-499a-a9e3-6069d6932a4b)

* Log in without credentials; use the `Login with passkey` button.
![TEST_USE_CASE_2](https://github.com/GluuFederation/agama-passkey/assets/86965029/200328ec-888a-4767-8242-1c50a126a979)


<!-- This is the stats url reference for this repository -->

[contributors-shield]: https://img.shields.io/github/contributors/GluuFederation/agama-passkey.svg?style=for-the-badge

[contributors-url]: https://github.com/GluuFederation/agama-passkey/graphs/contributors

[forks-shield]: https://img.shields.io/github/forks/GluuFederation/agama-passkey.svg?style=for-the-badge

[forks-url]: https://github.com/GluuFederation/agama-passkey/network/members

[stars-shield]: https://img.shields.io/github/stars/GluuFederation/agama-passkey?style=for-the-badge

[stars-url]: https://github.com/GluuFederation/agama-passkey/stargazers

[issues-shield]: https://img.shields.io/github/issues/GluuFederation/agama-passkey.svg?style=for-the-badge

[issues-url]: https://github.com/GluuFederation/agama-passkey/issues

[license-shield]: https://img.shields.io/github/license/GluuFederation/agama-passkey.svg?style=for-the-badge

[license-url]: https://github.com/GluuFederation/agama-passkey/blob/main/LICENSE
