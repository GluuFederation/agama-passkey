package org.gluu.agama.passkey;

import io.jans.as.common.model.common.User;
import io.jans.as.server.service.UserService;
import io.jans.service.cdi.util.CdiUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import io.jans.agama.engine.script.LogUtils;

import java.time.Instant;
import java.time.temporal.ChronoUnit;

/**
 * Reads and writes the passkey nudge snooze attribute on a user's profile.
 * The attribute "passkeyNudgeSnoozeUntil" stores an epoch-millisecond string.
 */
public class NudgeHelper {

    private static final Logger logger = LoggerFactory.getLogger(NudgeHelper.class);
    private static final String SNOOZE_ATTR = "passkeyNudgeSnoozeUntil";

    public NudgeHelper(){
        
    }
    /**
     * Returns true if the user has an active snooze that has not yet expired.
     */
    public static boolean checkSnoozed(String uid, int snoozeDays) {
        try {
            UserService userService = CdiUtil.bean(UserService.class);
            User user = userService.getUser(uid, SNOOZE_ATTR);
            if (user == null) return false;
            String val = (String) user.getAttribute(SNOOZE_ATTR);
            if (val == null || val.isEmpty()) return false;
            long snoozeUntil = Long.parseLong(val);
            return Instant.now().toEpochMilli() < snoozeUntil;
        } catch (Exception e) {
            LogUtils.log("Could not read snooze attribute for %: %", uid, e.getMessage());
            return false;
        }
    }

    /**
     * Sets the snooze timestamp to now + snoozeDays days.
     */
    public static void snooze(String uid, int snoozeDays) {
        try {
            UserService userService = CdiUtil.bean(UserService.class);
            User user = userService.getUser(uid, SNOOZE_ATTR);
            if (user == null) {
                LogUtils.log("User not found for snooze: %", uid);
                return;
            }
            long until = Instant.now().plus(snoozeDays, ChronoUnit.DAYS).toEpochMilli();
            user.setAttribute(SNOOZE_ATTR, String.valueOf(until));
            userService.updateUser(user);
            LogUtils.log("Snoozed passkey nudge for % until epoch %", uid, until);
        } catch (Exception e) {
            LogUtils.log("Could not write snooze attribute for %: %", uid, e.getMessage());
        }
    }
}
