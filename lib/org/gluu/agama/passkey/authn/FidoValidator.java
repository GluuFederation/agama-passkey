package org.gluu.agama.passkey.authn;

import io.jans.fido2.client.AssertionService;
import io.jans.fido2.client.Fido2ClientFactory;

import io.jans.fido2.model.assertion.AssertionOptions;

import jakarta.ws.rs.core.Response;
import net.minidev.json.JSONObject;
import org.gluu.agama.passkey.NetworkUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.Map;

public class FidoValidator {

    private static final Logger logger = LoggerFactory.getLogger(FidoValidator.class);

    private final String metadataConfiguration;

    public FidoValidator() throws IOException {
        logger.info("Inspecting fido2 configuration discovery URL");
        String metadataUri = NetworkUtils.urlBeforeContextPath() + "/.well-known/fido2-configuration";

        try (Response response = Fido2ClientFactory.instance().createMetaDataConfigurationService(metadataUri).getMetadataConfiguration()) {
            metadataConfiguration = response.readEntity(String.class);
            int status = response.getStatus();

            if (status != Response.Status.OK.getStatusCode()) {
                String msg = "Problem retrieving fido metadata (code: " + status + ")";
                logger.error(msg + "; response was: " + metadataConfiguration);
                throw new IOException(msg);
            }
        }
    }

    public String assertionRequest(String uid) throws IOException {
        logger.info("Building an assertion request for {}", uid);
        // Using assertionService as a private class field gives serialization trouble...
        AssertionService assertionService = Fido2ClientFactory.instance().createAssertionService(metadataConfiguration);
        String content;
        AssertionOptions assertionRequest = new AssertionOptions()
        if (uid == null) {
            content = JSONObject.toJSONString(Map.of("timeout", 90000));
        } else {
            content = JSONObject.toJSONString(Map.of("timeout", 90000, "username", uid));
            assertionRequest.setUsername(uid);
        }
        
        
        try (Response response = ( assertionService.authenticate(assertionRequest))) {
            content = response.readEntity(String.class);
            int status = response.getStatus();

            if (status != Response.Status.OK.getStatusCode()) {
                String msg = "Assertion request building failed (code: " + status + ")";
                logger.error(msg + "; response was: " + content);
                throw new IOException(msg);
            }
            return content;
        }
    }

    public String verify(String tokenResponse) throws IOException {
        logger.debug("Verifying fido token response");
        AssertionService assertionService = Fido2ClientFactory.instance().createAssertionService(metadataConfiguration);

        Response response = assertionService.verify(tokenResponse);
        int status = response.getStatus();
        if (status != Response.Status.OK.getStatusCode()) {
            org.json.JSONObject jsonNode = new org.json.JSONObject(response.readEntity(String.class));
            StringBuilder sb = new StringBuilder(String.format("Verification step failed, status: %s", status));
            if (jsonNode.has("error_description")) {
                sb.append(String.format(", description: %s", jsonNode.getString("error_description")));
            }
            logger.error(sb.toString());
            throw new IOException(sb.toString());
        }

        String resString = response.readEntity(String.class);
        org.json.JSONObject jsonNode = new org.json.JSONObject(resString);
        logger.error("Status: {}, Response: {}", status, jsonNode);
        if (jsonNode.has("username")) {
            String user = jsonNode.getString("username");
            logger.debug("User returned: {}", user);
            return user;
        }
        return "";
    }
}
