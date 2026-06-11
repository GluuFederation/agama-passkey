package org.gluu.agama.passkey;

import io.jans.as.common.model.common.User;
import io.jans.as.server.service.UserService;
import io.jans.agama.engine.script.LogUtils;
import io.jans.service.cdi.util.CdiUtil;

import java.util.HashMap;
import java.util.Map;

/**
 * Reads and writes the passkey rollout configuration stored as a JSON string
 * in the custom attribute "passkeyRolloutConfig" on the admin config user entry.
 *
 * Defaults: nudgeEnabled=true, nudgeFrequencyLogins=1, adoptionTargetPercent=10
 */
public class PasskeyRolloutConfig {

    private static final String CONFIG_ATTR = "passkeyRolloutConfig";
    // Well-known uid used as the config holder entry
    private static final String CONFIG_UID = "passkey-rollout-config";

    private static final boolean DEFAULT_NUDGE_ENABLED = true;
    private static final int DEFAULT_NUDGE_FREQUENCY = 1;
    private static final int DEFAULT_ADOPTION_TARGET = 10;

    /**
     * Returns the current rollout configuration.
     * Falls back to defaults if the attribute is missing or unreadable.
     */
    public Map<String, Object> getConfig() {
        try {
            UserService userService = CdiUtil.bean(UserService.class);
            User configUser = userService.getUser(CONFIG_UID, CONFIG_ATTR);
            if (configUser != null) {
                String json = (String) configUser.getAttribute(CONFIG_ATTR);
                if (json != null && !json.isEmpty()) {
                    return parseConfig(json);
                }
            }
        } catch (Exception e) {
            LogUtils.log("PasskeyRolloutConfig: could not read config, using defaults. Error: %", e.getMessage());
        }
        return defaults();
    }

    /**
     * Persists the given configuration map.
     * Falls back silently on error.
     */
    public void setConfig(Map<String, Object> config) {
        try {
            UserService userService = CdiUtil.bean(UserService.class);
            User configUser = userService.getUser(CONFIG_UID, CONFIG_ATTR);
            if (configUser == null) {
                LogUtils.log("PasskeyRolloutConfig: config entry not found for uid=%", CONFIG_UID);
                return;
            }
            String json = toJson(config);
            configUser.setAttribute(CONFIG_ATTR, json);
            userService.updateUser(configUser);
            LogUtils.log("PasskeyRolloutConfig: saved config %", json);
        } catch (Exception e) {
            LogUtils.log("PasskeyRolloutConfig: could not write config. Error: %", e.getMessage());
        }
    }

    // --- helpers ---

    private Map<String, Object> defaults() {
        Map<String, Object> m = new HashMap<>();
        m.put("nudgeEnabled", DEFAULT_NUDGE_ENABLED);
        m.put("nudgeFrequencyLogins", DEFAULT_NUDGE_FREQUENCY);
        m.put("adoptionTargetPercent", DEFAULT_ADOPTION_TARGET);
        return m;
    }

    /** Minimal JSON parser — avoids pulling in a full JSON library dependency. */
    private Map<String, Object> parseConfig(String json) {
        Map<String, Object> result = defaults();
        try {
            // nudgeEnabled
            if (json.contains("\"nudgeEnabled\":false")) result.put("nudgeEnabled", false);
            else if (json.contains("\"nudgeEnabled\":true")) result.put("nudgeEnabled", true);
            // nudgeFrequencyLogins
            int freq = extractInt(json, "nudgeFrequencyLogins");
            if (freq >= 0) result.put("nudgeFrequencyLogins", freq);
            // adoptionTargetPercent
            int target = extractInt(json, "adoptionTargetPercent");
            if (target >= 0) result.put("adoptionTargetPercent", target);
        } catch (Exception e) {
            LogUtils.log("PasskeyRolloutConfig: parse error, using defaults. Error: %", e.getMessage());
        }
        return result;
    }

    private int extractInt(String json, String key) {
        String marker = "\"" + key + "\":";
        int idx = json.indexOf(marker);
        if (idx < 0) return -1;
        int start = idx + marker.length();
        int end = start;
        while (end < json.length() && Character.isDigit(json.charAt(end))) end++;
        if (end == start) return -1;
        return Integer.parseInt(json.substring(start, end));
    }

    private String toJson(Map<String, Object> config) {
        StringBuilder sb = new StringBuilder("{");
        boolean first = true;
        for (Map.Entry<String, Object> e : config.entrySet()) {
            if (!first) sb.append(",");
            sb.append("\"").append(e.getKey()).append("\":");
            Object v = e.getValue();
            if (v instanceof Boolean || v instanceof Number) sb.append(v);
            else sb.append("\"").append(v).append("\"");
            first = false;
        }
        sb.append("}");
        return sb.toString();
    }
}
