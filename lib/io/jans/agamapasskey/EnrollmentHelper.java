package io.jans.agamapasskey;

import com.fasterxml.jackson.databind.ObjectMapper;

import com.nimbusds.oauth2.sdk.http.HTTPRequest;
import com.nimbusds.oauth2.sdk.http.HTTPResponse;

import java.io.IOException;
import java.net.URL;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.StringJoiner;
import java.util.stream.Collectors;

public class EnrollmentHelper extends CasaWSBase {
    
    private static final String SCOPE_CONFIG = SCOPE_PREFIX + "casa.config";    
    private static final String SCOPE_2FA = SCOPE_PREFIX + "casa.2fa";
    
    private MFASettings mfaSettings;

    private Set<String> availableAuthnMethods;
    
    //constructor added to prevent serialization error...
    public EnrollmentHelper() {}
    
    public EnrollmentHelper(MFASettings settings) throws IOException {
        super(true);
        setScope(SCOPE_CONFIG + " " + SCOPE_2FA);
        mfaSettings = settings;
    }
    
    public Set<String> availableAuthnMethods() throws IOException {     
        
        HTTPRequest request = new HTTPRequest(HTTPRequest.Method.GET, 
            new URL(apiBase + "/v2/config/authn-methods/available"));
        
        try {
            Set<String> supportedMethods = new HashSet<>(mfaSettings.getSupportedMethods());

            Set<String> availableMethods = sendRequest(request, true, true).getContentAsJSONArray().stream()
                    .map(Object::toString).collect(Collectors.toCollection(HashSet::new));

            availableMethods.retainAll(supportedMethods);
            return availableMethods;
        } catch (Exception e) {
            throw new IOException("Unable to determine the list of available authentication methods", e);
        }

    }
    
    public MFAUserInfo userCredsInfo(String id, Set<String> methods) throws IOException {
 
        try {
            HTTPRequest request = new HTTPRequest(HTTPRequest.Method.GET, 
                new URL(apiBase + "/v2/2fa/user-info/" + encode(id)));
    
            StringJoiner joiner = new StringJoiner("&");
            methods.forEach(m -> joiner.add("m="  + m));
            request.setQuery(joiner.toString());
            
            Map<String, Object> response = sendRequest(request, true, true).getContentAsJSONObject();            
            ObjectMapper mapper = new ObjectMapper();
            return mapper.convertValue(response, MFAUserInfo.class);
        } catch (Exception e) {
            throw new IOException("Unable to determine the amount of enrolled credentials", e);
        }
        
    }
        
    public boolean sufficientCreds(int count) {
        return count >= mfaSettings.getMinCredsRequired();
    }
    
    public boolean setPreferredMethod(String id, String preference) {

        try {
            HTTPRequest request = new HTTPRequest(HTTPRequest.Method.POST, 
                new URL(apiBase + "/v2/2fa/turn-on/" + id));
            
            StringJoiner joiner = new StringJoiner("&");
            joiner.add("preference=" + Optional.ofNullable(preference).orElse("" + System.currentTimeMillis()));
            request.setQuery(joiner.toString());
            
            sendRequest(request, true, true);
            return true;
            
        } catch (Exception e) {
            throw new IOException("Unable to set the preferred method for user " + id, e);
            return false;
        }
        
    }
    
}
