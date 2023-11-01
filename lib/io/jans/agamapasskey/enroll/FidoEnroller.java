package io.jans.agamapasskey.enroll;

import com.nimbusds.oauth2.sdk.http.HTTPRequest;
import com.nimbusds.oauth2.sdk.http.HTTPResponse;

import io.jans.agamapasskey.CasaWSBase;

import java.io.IOException;
import java.net.URL;
import java.util.Map;
import java.util.StringJoiner;

import net.minidev.json.JSONObject;

import static jakarta.ws.rs.core.MediaType.APPLICATION_JSON;

public class FidoEnroller extends CasaWSBase {    

    public FidoEnroller() throws IOException {
        super();        
        setScope(SCOPE_PREFIX + "casa.enroll");
    }
    
    public String getAttestationMessage(String id) throws IOException {
     
        try {    
            HTTPRequest request = new HTTPRequest(HTTPRequest.Method.GET, 
                new URL(getApiBase() + "/enrollment/fido2/attestation"));
    
            StringJoiner joiner = new StringJoiner("&");
            Map.of("userid", id, "platformAuthn", "false").forEach((k, v) -> joiner.add(k + "=" + encode(v)));
            request.setQuery(joiner.toString());
            
            logger.debug("Generating an attestation message for {}", id);       
            HTTPResponse response = sendRequest(request, false, true);
            String responseContent = response.getContent();
            int status = response.getStatusCode();
            
            if (status != 200) {
                logger.error("Attestation response was: ({}) {}", status, responseContent);
                throw new Exception(response.getContentAsJSONObject().get("code").toString());
            } 
            return responseContent;

        } catch (Exception e) {
            throw new IOException("Failed to build an attestation message", e);
        }

    }
    
    public String verifyRegistration(String id, String tokenResponse) throws IOException {
     
        try {
            HTTPRequest request = new HTTPRequest(HTTPRequest.Method.POST, 
                new URL(getApiBase() + "/enrollment/fido2/registration/" + encode(id)));
            request.setQuery(tokenResponse);

            logger.debug("Verifying registration");       
            HTTPResponse response = sendRequest(request, false, true);
            int status = response.getStatusCode();
            Map<String, Object> map = response.getContentAsJSONObject();
            
            if (status != 201) {
                logger.error("Verification response was: ({}) {}", status, response.getContent());
                throw new Exception(map.get("code").toString());
            }
            return map.get("id").toString();
            
        } catch (Exception e) {
            throw new IOException("Failed to verify fido registration", e);
        }
        
    }
    
    public boolean nameIt(String id, String name, String key) throws IOException {

        try {
            String apiBase = getApiBase();
            String body = JSONObject.toJSONString(Map.of("key", key, "nickName", name + "'s fido device"));

            HTTPRequest request = new HTTPRequest(HTTPRequest.Method.POST, 
                new URL(apiBase + "/enrollment/fido2/creds/" + encode(id)));
            request.setContentType(APPLICATION_JSON);
            request.setQuery(body);

            logger.debug("Naming fido credential for {}", name);
            HTTPResponse response = sendRequest(request, false, true);
            int status = response.getStatusCode();

            logger.debug("Response was ({}): {}", status, response.getContent());
            return status == 200;
        } catch (Exception e) {
            throw new IOException("Failed to name fido credential", e);
        }

    }
    
}
