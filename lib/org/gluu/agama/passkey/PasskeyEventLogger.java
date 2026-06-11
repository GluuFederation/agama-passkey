package org.gluu.agama.passkey;

import io.jans.agama.engine.script.LogUtils;

import java.time.Instant;
import java.util.Map;

/**
 * Emits structured JSON audit events for passkey actions.
 * Supported event types:
 *   PASSKEY_ENROLLED, PASSKEY_AUTH_SUCCESS, PASSKEY_AUTH_FAILURE,
 *   PASSKEY_NUDGE_SHOWN, PASSKEY_NUDGE_ACCEPTED, PASSKEY_NUDGE_DISMISSED
 *
 * Never throws — all exceptions are silently swallowed.
 */
public class PasskeyEventLogger {

    private PasskeyEventLogger() {}


    public static void log(String eventType, String uid, Map<String, String> extra) {
        try {
            StringBuilder sb = new StringBuilder();
            sb.append("{");
            sb.append("\"eventType\":\"").append(escape(eventType)).append("\",");
            sb.append("\"uid\":\"").append(escape(uid)).append("\",");
            sb.append("\"timestamp\":\"").append(Instant.now().toString()).append("\"");
            if (extra != null && !extra.isEmpty()) {
                sb.append(",\"extra\":{");
                boolean first = true;
                for (Map.Entry<String, String> entry : extra.entrySet()) {
                    if (!first) sb.append(",");
                    sb.append("\"").append(escape(entry.getKey())).append("\":");
                    sb.append("\"").append(escape(entry.getValue())).append("\"");
                    first = false;
                }
                sb.append("}");
            }
            sb.append("}");
            LogUtils.log("PASSKEY_EVENT %", sb.toString());
        } catch (Exception e) {
            // Silently swallow — event logging must never break the auth flow
        }
    }

    private static String escape(String value) {
        if (value == null) return "";
        return value.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
