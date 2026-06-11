package org.gluu.agama.passkey.authn;

import io.jans.fido2.client.AssertionService;
import io.jans.fido2.client.Fido2ClientFactory;

import io.jans.fido2.model.assertion.AssertionOptions;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.ws.rs.core.Response;
import org.gluu.agama.passkey.NetworkUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import io.jans.fido2.model.assertion.AssertionResult;
import java.io.IOException;
import io.jans.agama.engine.script.LogUtils;

public class FidoValidator {

    private static final Logger logger = LoggerFactory.getLogger(FidoValidator.class);
    private static ObjectMapper mapper = new ObjectMapper();
    private final String metadataConfiguration;

    public FidoValidator() throws IOException {
        LogUtils.log("Inspecting fido2 configuration discovery URL");
        String metadataUri = NetworkUtils.urlBeforeContextPath() + "/.well-known/fido2-configuration";

        try (Response response = Fido2ClientFactory.instance().createMetaDataConfigurationService(metadataUri).getMetadataConfiguration()) {
            metadataConfiguration = response.readEntity(String.class);
            int status = response.getStatus();

            if (status != Response.Status.OK.getStatusCode()) {
                String msg = "Problem retrieving fido metadata (code: " + status + ")";
                LogUtils.log(msg + "; response was: %", metadataConfiguration);
                throw new IOException(msg);
            }
        }
    }

    public String assertionRequest(String uid) throws IOException {
        // Using assertionService as a private class field gives serialization trouble...
        AssertionService assertionService = Fido2ClientFactory.instance().createAssertionService(metadataConfiguration);
        AssertionOptions assertionRequest = new AssertionOptions();
        if (uid != null) {
            assertionRequest.setUsername(uid);
        }

        try (Response response = assertionService.authenticate(assertionRequest)) {
            String content = response.readEntity(String.class);
            int status = response.getStatus();

            if (status != Response.Status.OK.getStatusCode()) {
                String msg = "Assertion request building failed (code: " + status + ")";
                LogUtils.log(msg + "; response was: %", content);
                throw new IOException(msg);
            }
            return content;
        }
    }

    public String verify(String tokenResponse) throws IOException {
        AssertionService assertionService = Fido2ClientFactory.instance().createAssertionService(metadataConfiguration);
        AssertionResult assertionResult = mapper.readValue(tokenResponse, AssertionResult.class);
        Response response = assertionService.verify(assertionResult);
        int status = response.getStatus();
        if (status != Response.Status.OK.getStatusCode()) {
            org.json.JSONObject jsonNode = new org.json.JSONObject(response.readEntity(String.class));
            StringBuilder sb = new StringBuilder(String.format("Verification step failed, status: %s", status));
            if (jsonNode.has("error_description")) {
                sb.append(String.format(", description: %s", jsonNode.getString("error_description")));
            }
            LogUtils.log(sb.toString());
            throw new IOException(sb.toString());
        }

        String resString = response.readEntity(String.class);
        LogUtils.log("Response : %",resString);
        org.json.JSONObject jsonNode = new org.json.JSONObject(resString);
        LogUtils.log("Status: %, Response: %", status, jsonNode);
        if (jsonNode.has("username")) {
            String user = jsonNode.getString("username");
            LogUtils.log("User returned: %", user);
            return user;
        }
        return "";
    }
}