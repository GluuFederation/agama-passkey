<!-- These are statistics for this repository-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![Apache License][license-shield]][license-url]

# About Agama Passkey

This repo is home to the Gluu Agama-passkey project. Use this project to add
passwordless authentication using **Passkeys** — a phishing-resistant credential
that uses your device (biometrics, PIN, or security key) to verify your identity.

The project covers the full passkey adoption lifecycle: enrollment, passwordless
login, post-login nudging, and account recovery.

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

* To recover a passkey, we use [agama-smtp](https://github.com/GluuFederation/agama-smtp), which sends email messages. Please ensure that the Jans Auth Server has the [SMTP service](https://docs.jans.io/head/janssen-server/config-guide/smtp-configuration/) configured.

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
    "org.gluu.agama.passkey.first": {
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
To invoke the `org.gluu.agama.passkey.first` flow contained in the Agama-passkey
project, specify the ACR value as `agama_<qualified-name-of-the-top-level-flow>`,
i.e `agama_org.gluu.agama.passkey.first`.

## Customize and Make It Your Own

Fork this repo to start customizing the Agama-passkey project. It is possible to
customize the user interface provided by the flow to suit your organisation's
branding guidelines. Or customize the overall flow behavior. Follow the best
practices and steps listed
[here](https://docs.jans.io/head/admin/developer/agama/agama-best-practices/#project-reuse-and-customizations)
to achieve these customizations in the best possible way.
This project can be reused in other Agama projects to create more complex
authentication journeys. To reuse, trigger the
[org.gluu.agama.passkey.first](#flows-in-the-project) flow from other Agama projects.

To make it easier to visualise and customize the Agama Project, use
[Agama Lab](https://cloud.gluu.org/agama-lab/login).


## Flows In The Project

| Qualified Name | Description |
|---|---|
| `org.gluu.agama.passkey.first` | Passkey-first / passwordless login. Presents an identifier-first screen with Conditional UI (`autocomplete="username webauthn"`) so the browser can offer a passkey automatically. Falls back to password if no passkey is available, then triggers the adoption nudge. |
| `org.gluu.agama.passkey.adopt` | Post-login passkey nudge. After a successful password login, checks if the user has no passkeys enrolled and prompts them to add one. Supports a configurable snooze period so users can defer enrollment. |
| `org.gluu.agama.passkey.add` | Registers a new passkey. The user verifies their FIDO device (security key, fingerprint, Windows Hello, Apple Face ID, etc.). |
| `org.gluu.agama.passkey.nickname` | Assigns a nickname to a newly registered passkey. Nickname is optional — defaults to the device type if left blank. Returns to `org.gluu.agama.passkey.list` on completion. |
| `org.gluu.agama.passkey.recovery` | Account recovery flow. Delegates identity verification to `org.gluu.agama.smtp.main`, then uses the verified user ID to look up the account and trigger passkey re-enrollment. Requires the `agama-smtp` project to be deployed alongside this one. |



## Demo

Check out this video to see the **agama-passkey** authentication flow in action.
Also check the
[Agama Project Of The Week](https://gluu.org/agama-project-of-the-week/) video
series for a quick demo on this flow.

*Note:*
While the video shows how the flow works overall, it may be dated. Do check the
[Test The Flow](#test-the-flow) section to understand the current
method of passing the ACR parameter when invoking the flow.


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
