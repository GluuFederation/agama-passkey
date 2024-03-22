# Agama Passkey Project

<!-- These are statistics for this repository-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![Apache License][license-shield]][license-url]

Use this project to authenticate using security devices (Android Touch, iOS Face Id, Yubico Key, Windows Hello, Touch ID on Mac, etc.)

## How it works at a glance

When a main flow of this project is launched (namely `org.gluu.agama.passkey.main`) the user's browser is
redirected to a view where he/she must first enter your username and password, then show a list of passkeys that you have
registered, in case you do not have one you must register one, once you have registered your passkey you can complete
the authentication step with passkey.
But you can also log in from the initial screen without entering a credential.

## Project Deployment

To deploy this project we need to meet the requirements.

### Requirements

1. Running instance of
   - `Jans Auth Server`
   - `Jans Fido2`
   - `Jans Casa`
   - `Jans Scim`

### Add Java dependencies

1. cd /opt/jans/jetty/jans-auth/custom/libs
2. wget https://github.com/GluuFederation/agama-passkey/releases/latest/download/agama-passkey-custom.jar
3. If you are not using *.jar, update extractClasspath in /opt/jans/jetty/jans-auth/webapps/jans-auth.xml
4. Restart server

### Deployment

Run these instructions on the server where you have `Janssen` or `Gluu` installed:

- Download the
  latest [agama-passkey.gama](https://github.com/GluuFederation/agama-passkey/releases/latest/download/agama-passkey.gama), you can use `wget`
```shell
wget https://github.com/GluuFederation/agama-passkey/releases/latest/download/agama-passkey.gama
```

![TUI_AGAMA_DEPLOY](https://github.com/GluuFederation/agama-passkey/assets/86965029/1d6b8cab-ddad-451c-b620-d19be1b7f9e3)

### Configure Jans Scim

- Once we have deployed the `agama project`, we need to configure the `jans scim` parameters, then we proceed to create
  a new client `jans scim` with scope `https://jans.io/scim/fido2.read` and `https://jans.io/scim/fido2.write`.

You can create the client using the registration web service.

**Request**

```
curl --location 'https://<YOUR_DOMAIN>/jans-auth/restv1/register' \
--header 'Content-Type: application/json' \
--data '{
  "client_name": "SCIM Agama Client",
  "scope": [
    "https://jans.io/scim/fido2.read",
    "https://jans.io/scim/fido2.write"
  ],
  "grant_types": [
    "client_credentials"
  ],
  "token_endpoint_auth_method": "client_secret_basic"
}'
```

**Response**

```
{
  "allow_spontaneous_scopes": false,
  "application_type": "web",
  "rpt_as_jwt": false,
  "registration_client_uri": "https://<YOUR_DOMAIN>/jans-auth/restv1/register?client_id=27975f1c-eee6-4bf8-b393-5fb47d44c566",
  "tls_client_auth_subject_dn": "",
  "run_introspection_script_before_jwt_creation": false,
  "registration_access_token": "<YOUR_REGISTRATION_ACCESS_TOKEN>",
  "client_id": "<YOUR_CLIENT_ID>",
  "client_secret": "<YOUR_SECRET_KEY>",
  "token_endpoint_auth_method": "client_secret_basic",
  "scope": "https://jans.io/scim/fido2.read https://jans.io/scim/fido2.write",
  "client_id_issued_at": 1710469308,
  "backchannel_logout_session_required": false,
  "client_name": "Scim custom client",
  "par_lifetime": 600,
  "spontaneous_scopes": [],
  "id_token_signed_response_alg": "RS256",
  ...,
  ...,
  ...
}
```

- Now that we have the jans scim client, we proceed to configure this client using `TUI`.
- We open `TUI` and we are located in agama, we select in the table where our application is deployed and press `c`, this
  will open a configuration panel, where we must first hit `Export Sample Config` and save the file in some path.
- Now we go to the exported file and edit it and enter the credentials


```
{
  "org.gluu.agama.passkey.add": {},
  "org.gluu.agama.passkey.nickname": {},
  "org.gluu.agama.passkey.list": {},
  "org.gluu.agama.passkey.main": {
    "scimClientId": "YOUR_SCIM_CLIENT_ID",
    "scimClientSecret": "YOUR_SCIM_CLIENT_SECRET"
  }
}
```

- We go back to the TUI and click on `Import Configuration` and select the modified configuration file with our parameters.
- With this, our `agama project` is now configured and we can start testing.

![TUI_SCIM_CONFIGURATION](https://github.com/GluuFederation/agama-passkey/assets/86965029/404b066e-a6f3-4c1e-9bf8-afe3f63121e7)

## Testing

You'll need an OpenID Connect test RP. You can try [oidcdebugger](https://oidcdebugger.com/),
[jans-tarp](https://github.com/JanssenProject/jans/tree/main/demos/jans-tarp)
or [jans-tent](https://github.com/JanssenProject/jans/tree/main/demos/jans-tent). Check out this video to see an example
of **agama-passkey** in action:v

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
