# Jans Deploy

First install Janssen [Deployment instructions](https://docs.jans.io/head/admin/install/)

## SCIM Configuration

Agama passkey uses SCIM to list and edit the logged-in user's passwords.

Then let's create the SCIM client with the following command.

```shell
curl --location 'https://YOUR_SERVER_HOST/jans-auth/restv1/register' \
--header 'Content-Type: application/json' \
--data '{
  "client_name": "SCIM for agama passkey",
  "token_endpoint_auth_method": "client_secret_basic",
  "scope": [
    "https://jans.io/scim/fido2.read",
    "https://jans.io/scim/fido2.write"
  ],
  "grant_types": [
    "client_credentials"
  ]
}'
```

Response:

```json
{
  "application_type": "web",
  "rpt_as_jwt": false,
  "registration_client_uri": "https://YOUR_SERVER_HOST/jans-auth/restv1/register?client_id=454496c0-c1da-43d2-929e-53539e403db6",
  "client_name": "SCIM for agama passkey",
  "client_id": "YOUR_CLIENT_ID",
  "client_secret": "YOUR_CLIENT_SECRET",
  "registration_access_token": "YOUR_REGISTRATION_ACCESS_TOKEN",
  "token_endpoint_auth_method": "client_secret_basic",
  "scope": "https://jans.io/scim/fido2.read https://jans.io/scim/fido2.write",
  "client_secret_expires_at": 0,
  ...
}
```

From this response you will get the fields you need to configure agama passkey:

- **YOUR_CLIENT_ID**
- **YOUR_CLIENT_SECRET**

## Jans Fido2 Configuration

Agama passkey uses a specific `Jans Fido2` endpoint, so it is necessary to enable this configuration to activate the
endpoint.

In the `Jans Fido2` dynamic configuration, set the `assertionOptionsGenerateEndpointEnabled` field to `true`

```json
{
  "issuer": "https://YOUR_SERVER_HOST",
  "baseEndpoint": "https://YOUR_SERVER_HOST/jans-fido2/restv1",
  ...,
  "fido2Configuration": {
    ...,
    "skipDownloadMdsEnabled": false,
    "skipValidateMdsInAttestationEnabled": false,
    "assertionOptionsGenerateEndpointEnabled": true
  }
}
```

Restart `Jans Fido2` server
