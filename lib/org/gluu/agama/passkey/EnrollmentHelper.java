package org.gluu.agama.passkey;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.nimbusds.oauth2.sdk.http.HTTPRequest;

import java.io.IOException;
import java.net.URL;
import java.util.Collections;
import java.util.Map;
import java.util.Set;
import java.util.StringJoiner;

public class EnrollmentHelper extends CasaWSBase {

    private static final String SCOPE_CONFIG = SCOPE_PREFIX + "casa.config";
    private static final String SCOPE_2FA = SCOPE_PREFIX + "casa.2fa";

    public EnrollmentHelper() throws IOException {
        super(true);
        setScope(SCOPE_CONFIG + " " + SCOPE_2FA);
    }

    public MFAUserInfo getMFAUserInfo(String personUid, Set<String> methods) throws IOException {
        try {
            HTTPRequest request = new HTTPRequest(HTTPRequest.Method.GET, new URL(apiBase + "/v2/2fa/user-info/" + encode(personUid)));
            StringJoiner joiner = new StringJoiner("&");
            methods.forEach(m -> joiner.add("m=" + m));
            request.setQuery(joiner.toString());
            Map<String, Object> response = sendRequest(request, true, true).getContentAsJSONObject();
            ObjectMapper mapper = new ObjectMapper();
            return mapper.convertValue(response, MFAUserInfo.class);

        } catch (Exception e) {
            throw new IOException("Unable to determine the amount of enrolled credentials", e);
        }
    }

    public MFAUserInfo getMFAUserInfoByFido2(String personUid) throws IOException {
        return getMFAUserInfo(personUid, Collections.singleton("fido2"));
    }
}
