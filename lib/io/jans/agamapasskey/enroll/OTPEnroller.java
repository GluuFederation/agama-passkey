package io.jans.agamapasskey.enroll;

import com.nimbusds.oauth2.sdk.http.HTTPRequest;
import com.nimbusds.oauth2.sdk.http.HTTPResponse;

import io.jans.agamapasskey.CasaWSBase;
import io.jans.util.Pair;

import java.io.IOException;
import java.net.URL;
import java.util.Map;
import java.util.StringJoiner;

import net.minidev.json.JSONObject;

import static jakarta.ws.rs.core.MediaType.APPLICATION_JSON;

public class OTPEnroller extends CasaWSBase {
    
    private static final String MODE = "totp";

    public OTPEnroller() throws IOException {
        super();        
        setScope(SCOPE_PREFIX + "casa.enroll");
    }

    public Pair<String, String> QRRequest(String name) throws IOException {
     
        try {    
            HTTPRequest request = new HTTPRequest(HTTPRequest.Method.GET, 
                new URL(getApiBase() + "/enrollment/otp/qr-request"));
    
            String displayName = String.format("%s at %s", name, new URL(apiBase).getHost()); 
            StringJoiner joiner = new StringJoiner("&");
            
            Map.of("displayName", displayName, "mode", MODE).forEach((k, v) -> joiner.add(k + "=" + encode(v)));
            request.setQuery(joiner.toString());
            
            logger.debug("Generating a QR request for {}", name);
       
            Map<String, Object> response = sendRequest(request, true, true).getContentAsJSONObject();
            return new Pair<>(response.get("request").toString(), response.get("key").toString());

        } catch (Exception e) {
            throw new IOException("Failed to issue a QR code request", e);
        }

    }
    
    public boolean validateCode(String code, String key) throws IOException {
     
        try {    
            HTTPRequest request = new HTTPRequest(HTTPRequest.Method.POST, 
                new URL(getApiBase() + "/enrollment/otp/validate-code"));
    
            StringJoiner joiner = new StringJoiner("&");
            Map.of("code", code, "key", key, "mode", MODE).forEach((k, v) -> joiner.add(k + "=" + encode(v)));
            request.setQuery(joiner.toString());

            logger.debug("Validating code {} for key {}", code, key);

            HTTPResponse response = sendRequest(request, false, true);
            if (response.getStatusCode() != 200) throw new Exception(response.getContent());
            
            return response.getContentAsJSONObject().get("code").toString().equals("MATCH");

        } catch (Exception e) {
            throw new IOException("Failed to determine if the passcode is valid", e);
        }

    }
    
    public boolean save(String id, String name, String key) throws IOException {
     
        try {
            String apiBase = getApiBase();
            String body = JSONObject.toJSONString(Map.of("key", key, "nickName", name + "'s OTP authenticator"));

            HTTPRequest request = new HTTPRequest(HTTPRequest.Method.POST, 
                new URL(apiBase + "/enrollment/otp/creds/" + encode(id)));
            request.setContentType(APPLICATION_JSON);
            request.setQuery(body);

            logger.debug("Saving credential for {}", name);
            HTTPResponse response = sendRequest(request, false, true);
            int status = response.getStatusCode();

            logger.debug("Response was ({}): {}", status, response.getContent());
            return status == 201;
        } catch (Exception e) {
            throw new IOException("Failed to save OTP credential", e);
        }

    }
    
    public int timeLeft(long requestGeneratedAt, int timeoutSeconds) {
        return timeoutSeconds - (int)(System.currentTimeMillis() - requestGeneratedAt) / 1000;
    }
    
}
