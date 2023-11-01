package io.jans.agamapasskey.zoho;

import com.nimbusds.oauth2.sdk.http.HTTPRequest;
import com.nimbusds.oauth2.sdk.http.HTTPResponse;
import com.nimbusds.oauth2.sdk.ParseException;

import io.jans.inbound.Attrs;
import io.jans.util.StringHelper;

import jakarta.ws.rs.core.Response;

import java.io.IOException;
import java.net.URL;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Stream;
import java.util.StringJoiner;

import net.minidev.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static jakarta.ws.rs.core.MediaType.APPLICATION_JSON;

public class ZohoLeadsManager {

    private static final Logger logger = LoggerFactory.getLogger(ZohoLeadsManager.class);
    private static final String LeadSource = "Agama Lab";
    private static final String LeadsEndpoint = "/crm/v2/Leads";
    private static final String TokenEndpoint = "/oauth/v2/token";
    private static final String AuthHeaderFormat = "Zoho-oauthtoken %s";
    
    private static ZohoLeadsManager instance;
    
    private String apiDomain;  
    private String accessToken;
    private AuthSettings authSettings;

    private ZohoLeadsManager() { }

    private static ZohoLeadsManager getInstance() {
        if (instance == null) {
            instance = new ZohoLeadsManager();
        }
        return instance;
    }

    public static void insert(AuthSettings settings, Map<String, String> profile) {

        try {
            if (settings.isEnabled()) {
                getInstance().addLead(settings, profile);
            } else {
                logger.info("CRM lead insertion is disabled");
            }
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }

    }
    
    private void addLead(AuthSettings settings, Map<String, String> profile) throws Exception {

        ensureValidSettings(settings);
        
        //Request a token only if needed                
        if (accessToken == null || !this.authSettings.equals(settings)) {
            this.authSettings = settings;
            renewAccessToken();
        }

        String email = profile.get(Attrs.MAIL);
        //See form fields in template profile.ftlh
        Map<String, Object> thelead = new HashMap<>(
                Map.of("Lead_Source", LeadSource, "Last_Name", profile.get(Attrs.SN),
                        "Email", email, "First_Name", profile.get(Attrs.GIVEN_NAME)));        
        
        String attr = profile.get("o");     //Company is supposed to be unique in a lead, see
        // https://crmplus.zoho.com/gluuorg/index.do/cxapp/crm/org719403462/settings/api/modules/Leads?step=FieldsList
        // so a timestamp is appended        
        if (StringHelper.isNotEmpty(attr)) {
            attr += " " + (int) (System.currentTimeMillis() / 1000);
            thelead.put("Company", attr);
        }
        
        attr = profile.get("c");
        if (StringHelper.isNotEmpty(attr)) {
            thelead.put("Country", attr);
        }
        
        attr = profile.get("jansRole");
        if (StringHelper.isNotEmpty(attr)) {
            thelead.put("Designation", attr);
        }

        attr = profile.get("jansProfileURL");
        if (StringHelper.isNotEmpty(attr)) {
            thelead.put("LinkedIn", attr);
        }
        
        //Using backslash to skip Groovy's string interpolation, see https://groovy-lang.org/syntax.html        
        thelead.put("\$approved", false);           //create record in approval mode        

        logger.info("Attempting lead insertion of {}", email);        
        HTTPRequest request = new HTTPRequest(HTTPRequest.Method.POST, new URL(apiDomain + LeadsEndpoint));
        setTimeouts(request);
        request.setContentType(APPLICATION_JSON);
        request.setQuery(JSONObject.toJSONString(
                Collections.singletonMap("data", Collections.singletonList(thelead))));        
        request.setAuthorization(String.format(AuthHeaderFormat, accessToken));
        
        HTTPResponse response = request.send();
        int status = response.getStatusCode();
        
        if (status == Response.Status.UNAUTHORIZED.getStatusCode()) {
            //access token may have expired
            logger.warn("Request unauthorized, retrying...");
            renewAccessToken();
            request.setAuthorization(String.format(AuthHeaderFormat, accessToken));

            response = request.send();
            status = response.getStatusCode();
        }

        if (status != Response.Status.OK.getStatusCode()) {
            logger.error("Insertion response was {}: {}", status, response.getContent());
        } else {
            logger.info("Successful insertion");
        }
            
    }

    //See https://www.zoho.com/crm/developer/docs/api/v2/token-validity.html
    private void renewAccessToken() throws IOException, ParseException {

        logger.debug("Requesting a Zoho CRM access token");
        
        StringJoiner joiner = new StringJoiner("&");
        Map.of("grant_type", "refresh_token", "client_secret", authSettings.getClientSecret(),
                "client_id", authSettings.getClientId(), "refresh_token", authSettings.getRefreshToken())
            .forEach((k, v) -> joiner.add( k + "=" + v));
        
        HTTPRequest request = new HTTPRequest(HTTPRequest.Method.POST, new URL(authSettings.getAccountsUrl() + TokenEndpoint));
        setTimeouts(request);
        request.setQuery(joiner.toString());
        
        HTTPResponse response = request.send();
        logger.debug("Response status was {}", response.getStatusCode());

        Map<String, Object> jobj = response.getContentAsJSONObject();
        accessToken = jobj.getAsString("access_token");
        apiDomain = jobj.getAsString("api_domain");
        
        if (Stream.of(accessToken, apiDomain).anyMatch(Objects::isNull)) 
            throw new IOException("An error occurred obtaining an access token: " + response.getContent());
        
        logger.debug("Access token was obtained");
        
    }

    private void setTimeouts(HTTPRequest request) {
        request.setConnectTimeout(3000);
        request.setReadTimeout(3000);
    }
    
    private void ensureValidSettings(AuthSettings settings) throws IOException {
        
        if (Stream.of(settings.getRefreshToken(), settings.getAccountsUrl(), 
                    settings.getClientId(), settings.getClientSecret()).anyMatch(Objects::isNull))
            throw new IOException("One or more of the ZOHO settings are missing. Check the registration flow configs");

    }
    
}
