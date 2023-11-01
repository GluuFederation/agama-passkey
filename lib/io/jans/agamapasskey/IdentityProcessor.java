package io.jans.agamapasskey;

import io.jans.as.common.model.common.User;
import io.jans.as.common.service.common.EncryptionService;
import io.jans.as.common.service.common.UserService;
import io.jans.orm.exception.operation.EntryNotFoundException;
import io.jans.service.cdi.util.CdiUtil;
import io.jans.util.StringHelper;

import java.io.IOException;
import java.util.HashMap;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static io.jans.inbound.Attrs.*;

public class IdentityProcessor {

    private static final Logger logger = LoggerFactory.getLogger(IdentityProcessor.class);

    private static final String INUM_ATTR = "inum";
    private static final String EXT_ATTR = "jansExtUid";
        
    public static Map<String, String> accountFromUid(String uid) {

        User user = getUser(UID, uid);
        boolean local = user != null;
        logger.debug("There is {} local account for {}", local ? "a" : "no", uid);

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
        return Collections.emptyMap();

    }

    public static Map<String, String> remoteAccountDetails(String extUid) {
        
        User user = getUser(EXT_ATTR, extUid);
        boolean remote = user != null;
        
        Map<String, String> details = null;
        logger.debug("There is {} local account mapping to the remote account {}", remote ? "a" : "no", extUid);
        
        if (remote) {
            details = new HashMap<>();            

            for (String attr : Arrays.asList(INUM_ATTR, UID, GIVEN_NAME)) {
                String val = getSingleValuedAttr(user, attr);
                if (val != null) {
                    details.put(attr.equals(GIVEN_NAME) ? "name" : attr, val);
                }
            }
        }
        return details;

    }
    
    public static String externalIdOf(String provider, String id) {
        return provider + ":" + id;
    }
    
    public static String onboard(Map<String, String> profile, Set<String> attributes, String extUid)
        throws Exception {
        
        User user = new User();
        if (StringHelper.isEmpty(profile.get(GIVEN_NAME))) throw new Exception("First name not provided");

        if (extUid != null) {
            user.setAttribute(EXT_ATTR, extUid, true);
        }
        
        attributes.forEach(attr -> {
                String val = profile.get(attr);
                if (StringHelper.isNotEmpty(val)) {
                    user.setAttribute(attr, val);
                }
        });
        UserService userService = CdiUtil.bean(UserService.class);
        
        user = userService.addUser(user, true);
        if (user == null) throw new EntryNotFoundException("Added user not found");
        
        return getSingleValuedAttr(user, INUM_ATTR);
        
    }

    public static String link(String encInum, String extId) throws Exception {
        
        EncryptionService ense = CdiUtil.bean(EncryptionService.class);
        String inum = ense.decrypt(encInum);
        logger.debug("Linking external user {} to local user {}", extId, inum);
        
        User user = getUser(INUM_ATTR, inum);
        if (user == null) {
            logger.error("User identified with {} not found!", inum);
            throw new IOException("Target user for account linking does not exist");
        }
        
        List<String> extUids = user.getAttributeValues(EXT_ATTR);
        if (extUids == null) {
            extUids = new ArrayList<>();
        }
        extUids.add(extId);
        user.setAttribute(EXT_ATTR, extUids.toArray(new String[0]), true);
        //The setAttribute(String, List<String>, boolean) version does weird stuff when used from Groovy
        
        UserService userService = CdiUtil.bean(UserService.class);
        userService.updateUser(user);        
        return getSingleValuedAttr(user, UID);
        
    }

    private static User getUser(String attributeName, String value) {
        UserService userService = CdiUtil.bean(UserService.class);
        return userService.getUserByAttribute(attributeName, value, true);
    }

    private static String getSingleValuedAttr(User user, String attribute) {

        Object value = null;
        if (attribute.equals(UID)) {
            //user.getAttribute("uid", true, false) always returns null :(
            value = user.getUserId();
        } else {
            value = user.getAttribute(attribute, true, false); 
        }
        return value == null ? null : value.toString();

    }
    
}
