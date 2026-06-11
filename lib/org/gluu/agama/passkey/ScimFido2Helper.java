package org.gluu.agama.passkey;

import com.nimbusds.oauth2.sdk.http.HTTPRequest;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.net.URL;
import java.util.*;
import io.jans.agama.engine.script.LogUtils;

import static jakarta.ws.rs.core.MediaType.APPLICATION_JSON;

public class ScimFido2Helper extends ScimWSBase {

    private static final String SCOPE_FIDO2_READ = SCOPE_PREFIX + "/fido2.read";
    private static final String SCOPE_FIDO2_WRITE = SCOPE_PREFIX + "/fido2.write";

    public ScimFido2Helper() throws IOException {
        super(false, null);
    }

    public ScimFido2Helper(ScimSetting scimSetting) throws IOException {
        super(true, scimSetting);
        setScope(SCOPE_FIDO2_READ + " " + SCOPE_FIDO2_WRITE);
    }

    public Map<String, Object> getFidoDeviceByUser(String userInum) throws IOException {
        try {
            URL url = new URL(apiBase + "/v2/Fido2Devices");
            HTTPRequest request = new HTTPRequest(HTTPRequest.Method.GET, url);
            request.setAccept("application/json");

            StringJoiner joiner = new StringJoiner("&");
            Map.of("userId", userInum).forEach((k, v) -> joiner.add(k + "=" + v));
            request.setQuery(joiner.toString());
            
            String response = sendRequest(request, true, true).getContentAsJSONObject().toJSONString();
            LogUtils.log("Response scim fido2 devices: %", response);
            JSONObject resObject = new JSONObject(response);
            int count = resObject.getInt("totalResults");
            List<Map<String, String>> mapList = new ArrayList<>();
            if (count > 0) {
                JSONArray jsonArray = resObject.getJSONArray("Resources");
                LogUtils.log("Response jsonarray: %", jsonArray);
                int i = 0;
                while (i < jsonArray.length()) {
                    JSONObject item = jsonArray.getJSONObject(i);
                    Map<String, String> result = new HashMap<>();
                    result.put("id", item.getString("id")); 
                    result.put("displayName", item.has("displayName") ? item.getString("displayName") : "Registered without name");
                    result.put("creationDate", item.getString("creationDate"));
                    if (item.has("lastAccessTime")) result.put("lastAccessTime", item.getString("lastAccessTime"));
                    if (item.has("deviceData")) {
                        JSONObject deviceData = item.getJSONObject("deviceData");
                        if (deviceData.has("type")) result.put("deviceType", deviceData.getString("type"));
                        if (deviceData.has("name")) result.put("deviceName", deviceData.getString("name"));
                    }
                    mapList.add(result);
                    i++;
                }
            }else{
                return Map.of("count", count);
            }
            return Map.of("count", count, "devices", mapList);

        } catch (Exception e) {
            throw new IOException("Could not obtain the user's list of fido devices: " + userInum, e);
        }
    }

    public String deleteDevice(String userId, String deviceId) throws IOException {
        try {
            URL url = new URL(apiBase + "/v2/Fido2Devices/" + encode(deviceId));
            HTTPRequest request = new HTTPRequest(HTTPRequest.Method.DELETE, url);
            request.setAccept(APPLICATION_JSON);
            log.debug("Deleting device {} for user {}", deviceId, userId);
            int status = sendRequest(request, true, true).getStatusCode();
            if (status == 204 || status == 200) {
                return "DELETED";
            }
            throw new IOException("Delete returned unexpected status: " + status);
        } catch (IOException e) {
            throw e;
        } catch (Exception e) {
            throw new IOException("Could not delete device: " + e.getMessage(), e);
        }
    }

    public String updateDevice(String userId, String deviceId, String displayName) throws Exception {
        try {
            URL url = new URL(apiBase + "/v2/Fido2Devices/" + encode(deviceId));
            HTTPRequest request = new HTTPRequest(HTTPRequest.Method.PUT, url);
            request.setAccept(APPLICATION_JSON);
            request.setContentType(APPLICATION_JSON);
            String body = net.minidev.json.JSONObject.toJSONString(Map.of("userId", userId, "displayName", displayName));
            log.debug("Request updateDevice body: {}", body);
            request.setQuery(body);

            String response = sendRequest(request, true, true).getContentAsJSONObject().toJSONString();
            log.debug("Response update device: {}", response);
            return "UPDATED";

        } catch (Exception e) {
            throw new IOException("Could not update device: " + e.getMessage(), e);
        }
    }
}
