package org.gluu.agama.passkey;

import io.jans.as.common.model.common.User;
import io.jans.as.common.service.common.UserService;
import io.jans.as.model.exception.InvalidClaimException;
import io.jans.service.cdi.util.CdiUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Map;

public class IdentityProcessor {

    private static final Logger log = LoggerFactory.getLogger(IdentityProcessor.class);

    private static final String INUM_ATTR = "inum";
    private static final String UID = "uid";
    private static final String GIVEN_NAME = "givenName";
    private static final String DISPLAY_NAME = "displayName";
    private static final String MAIL = "mail";

    public static Map<String, String> accountFromUid(String uid) throws InvalidClaimException {
        User user = getUser(UID, uid);
        boolean local = user != null;
        log.debug("There is {} local account for {}", local ? "a" : "no", uid);

        if (local) {
            String inum = getSingleValuedAttr(user, INUM_ATTR);
            String name = getSingleValuedAttr(user, GIVEN_NAME);
            String email = getSingleValuedAttr(user, MAIL);

            if (name == null) {
                name = getSingleValuedAttr(user, DISPLAY_NAME);

                if (name == null) {
                    name = email.substring(0, email.indexOf("@"));
                }
            }
            return Map.of(UID, uid, INUM_ATTR, inum, "name", name, "email", email);
        }
        return null;
    }

    private static User getUser(String attributeName, String value) {
        UserService userService = CdiUtil.bean(UserService.class);
        return userService.getUserByAttribute(attributeName, value, true);
    }

    private static String getSingleValuedAttr(User user, String attribute) throws InvalidClaimException {
        Object value;
        if (attribute.equals(UID)) {
            value = user.getUserId();
        } else {
            value = user.getAttribute(attribute, true, false);
        }
        return value == null ? null : value.toString();
    }
}
