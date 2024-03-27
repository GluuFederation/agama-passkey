<!-- These are statistics for this repository-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![Apache License][license-shield]][license-url]

# Agama Passkey

Welcome to the https://github.com/GluuFederation/agama-passkey project. This project is governed by Gluu and published under an Apache 2.0 license.

Use this project to add user authentication with **Passkey**(passwordless authentication that uses a device to verify a user's identity before allowing them to access an account) 2-factor authentication.

For more information you can also see
* [Passkey](https://passkey.io)
* [FIDO Specs](https://www.w3.org/TR/webauthn-1)

## Requirements

* Register a client to integrate with SCIM, minimum scopes:
  - https://jans.io/scim/fido2.read
  - https://jans.io/scim/fido2.write
* The following step is necessary because it adds a dependency to Jans in order for the project to work

### Add Java dependencies

1. cd /opt/jans/jetty/jans-auth/custom/libs
2. wget https://github.com/GluuFederation/agama-passkey/releases/latest/download/agama-passkey-custom.jar
3. If you are not using *.jar, update extractClasspath in /opt/jans/jetty/jans-auth/webapps/jans-auth.xml
4. Restart server

## Supported IDPs

| IDP              | Description                                                                                 |
|:-----------------|:--------------------------------------------------------------------------------------------| 
| Jans Auth Server | [Deployment instructions](https://gluu.org/agama/deploying-an-agama-project-to-jans-server) | 
| Gluu Flex        | [Deployment instructions](https://gluu.org/agama/deploying-an-agama-project-to-jans-server) | 

## Flows

| Qualified Name                    | Description                                                                                                                                                                                                                                                                                                        |
|-----------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------| 
| `org.gluu.agama.passkey.main`     | This is the main flow which you can directly launch from the browser. If you have not configured a passkey, you must first log in with your credentials and register your passkey(s) `org.gluu.agama.passkey.list`. If you have at least 1 passkey configured, then you can click the "Login with passkey" button. | 
| `org.gluu.agama.passkey.list`     | This flow is used to list the passkeys that the logged-in user has registered. If you do not have a passkey, an option to add a new passkey `org.gluu.agama.passkey.add` is enabled. If you already have at least one passkey, you can click `Login with passkey`.                                                 | 
| `org.gluu.agama.passkey.add`      | This flow is used to register a new passkey. The user has to validate his FIDO device, which can be a (Yubico key, Device fingerprint, Windows Hello, Apple Face ID, etc.).                                                                                                                                        | 
| `org.gluu.agama.passkey.nickname` | This flow is used to add a nickname to the newly registered passkey. Once completed this stream returns to the `org.gluu.agama.passkey.list`                                                                                                                                                                       |                                                                                                                                                                                                                                                                                                                    |

## Configuration

| Flow                          | Property         | Value Description  |
|-------------------------------|:-----------------|:-------------------|
| `org.gluu.agama.passkey.main` | scimClientId     | SCIM Client id     |
| `org.gluu.agama.passkey.main` | scimClientSecret | SCIM Client secret |

Sample JSON:

``` json
{
    "org.gluu.agama.passkey.main": {
        "scimClientId": "PUT_YOUR_SCIM_CLIENT_ID_HERE",
        "scimClientSecret": "PUT_YOUR_SCIM_CLIENT_SECRET"
    }
}
```

## Demo

### Use case 1:

Login with credentials and configure your first passkey device and as a last step complete the login with your new configured key.

![TEST_USE_CASE_1](https://github.com/GluuFederation/agama-passkey/assets/86965029/0e5cc346-a576-499a-a9e3-6069d6932a4b)

### Use case 2:

Log in without credentials, use the `Login with passkey` button.


![TEST_USE_CASE_2](https://github.com/GluuFederation/agama-passkey/assets/86965029/200328ec-888a-4767-8242-1c50a126a979)

# Contributors

<table>
<tr>
    <td align="center" style="word-wrap: break-word; width: 150.0; height: 150.0">
        <a href=https://github.com/Milton-Ch>
            <img src=https://avatars.githubusercontent.com/u/86965029?v=4 width="100;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=Milton Ch/>
            <br />
            <sub style="font-size:14px"><b>Milton Ch.</b></sub>
        </a>
    </td>
</tr>
</table>

# License

This project is licensed under the [Apache 2.0](https://github.com/GluuFederation/agama-security-key/blob/main/LICENSE)

<!-- This are stats url reference for this repository -->

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
