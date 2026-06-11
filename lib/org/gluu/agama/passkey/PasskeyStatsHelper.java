package org.gluu.agama.passkey;

import io.jans.agama.engine.script.LogUtils;

import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Aggregates passkey adoption metrics for the AdminUI dashboard.
 * Falls back to -1 sentinel values when SCIM is unavailable.
 */
public class PasskeyStatsHelper {

    private final ScimFido2Helper scimHelper;

    public PasskeyStatsHelper(ScimSetting scimSetting) throws IOException {
        this.scimHelper = new ScimFido2Helper(scimSetting);
    }

    /**
     * Returns adoption metrics map with keys:
     *   totalPasskeys, usersWithPasskey, adoptionPercent, avgPasskeysPerUser
     *
     * Note: totalUsers requires a separate user-count query not available via SCIM Fido2Devices alone.
     * It is returned as -1 and should be populated by the caller from the Janssen user store.
     */
    public Map<String, Object> getAdoptionStats(List<String> userInums) {
        Map<String, Object> stats = new HashMap<>();
        try {
            int totalPasskeys = 0;
            int usersWithPasskey = 0;
            int totalUsers = userInums == null ? -1 : userInums.size();

            if (userInums != null) {
                for (String inum : userInums) {
                    try {
                        Map<String, Object> result = scimHelper.getFidoDeviceByUser(inum);
                        int count = (int) result.get("count");
                        if (count > 0) {
                            usersWithPasskey++;
                            totalPasskeys += count;
                        }
                    } catch (Exception e) {
                        LogUtils.log("PasskeyStatsHelper: error fetching devices for inum=%: %", inum, e.getMessage());
                    }
                }
            }

            stats.put("totalUsers", totalUsers);
            stats.put("usersWithPasskey", usersWithPasskey);
            stats.put("totalPasskeys", totalPasskeys);
            stats.put("adoptionPercent", totalUsers > 0
                    ? Math.round((usersWithPasskey * 100.0) / totalUsers)
                    : -1);
            stats.put("avgPasskeysPerUser", usersWithPasskey > 0
                    ? Math.round((totalPasskeys * 10.0) / usersWithPasskey) / 10.0
                    : 0.0);

        } catch (Exception e) {
            LogUtils.log("PasskeyStatsHelper: getAdoptionStats failed: %", e.getMessage());
            stats.put("totalUsers", -1);
            stats.put("usersWithPasskey", -1);
            stats.put("totalPasskeys", -1);
            stats.put("adoptionPercent", -1);
            stats.put("avgPasskeysPerUser", -1);
        }
        return stats;
    }

    /**
     * Returns the list of passkey devices for a given user inum.
     * Returns an empty list on error.
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getDevicesForUser(String userInum) {
        try {
            Map<String, Object> result = scimHelper.getFidoDeviceByUser(userInum);
            Object devices = result.get("devices");
            if (devices instanceof List) {
                return (List<Map<String, Object>>) devices;
            }
        } catch (Exception e) {
            LogUtils.log("PasskeyStatsHelper: getDevicesForUser failed for inum=%: %", userInum, e.getMessage());
        }
        return Collections.emptyList();
    }
}
