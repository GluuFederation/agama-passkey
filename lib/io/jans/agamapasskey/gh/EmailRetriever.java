package io.jans.agamapasskey.gh;

import com.nimbusds.common.contenttype.ContentType;
import com.nimbusds.oauth2.sdk.http.HTTPRequest;
import com.nimbusds.oauth2.sdk.http.HTTPResponse;

import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.function.Predicate;

import org.json.JSONArray;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class EmailRetriever {
    
    private static final Logger logger = LoggerFactory.getLogger(EmailRetriever.class);
    
    private static final String EMAILS_ENDPOINT = "https://api.github.com/user/emails";
    private static final String API_VERSION = "2022-11-28";

    public static String get(String token) throws Exception {

        HTTPRequest request = new HTTPRequest(HTTPRequest.Method.GET, new URL(EMAILS_ENDPOINT));            
        request.setAuthorization("Bearer " + token);
        request.setHeader("X-GitHub-Api-Version", API_VERSION);
        request.setAccept("application/vnd.github+json");
        request.setConnectTimeout(2000);
        request.setReadTimeout(2000);
                
        HTTPResponse r = request.send();        
        r.ensureStatusCode(200);
        r.ensureEntityContentType(ContentType.APPLICATION_JSON);

        JSONArray arr = new JSONArray(r.getContent());
        List<JSONObject> list = new ArrayList<>();
        for (int i = 0; i < arr.length(); i++) {
            list.add(arr.getJSONObject(i));
        }
        
        if (list.isEmpty()) {
            logger.error("User has no e-mails registered!");
            return null;
        } else {
            logger.info("Revising Github e-mails associated to this user");
        }

        Predicate<JSONObject> p = jobj -> jobj.optBoolean("primary") && jobj.optBoolean("verified");
        Optional<JSONObject> opt = list.stream().filter(p).findFirst();

        if (!opt.isPresent()) {
            logger.warn("No primary verified e-mail found");
            p = jobj -> jobj.optBoolean("verified");
            opt = list.stream().filter(p).findFirst();
            
            if (!opt.isPresent()) {
                logger.warn("No verified e-mail found");
                opt = list.stream().findFirst();
            }
        }
        String email = opt.get().getString("email");
        logger.info("Picking {}", email);
        return email;
        
    }
    
}
