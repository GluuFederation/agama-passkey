package org.gluu.agama.passkey;

import io.jans.service.cdi.util.CdiUtil;
import jakarta.servlet.http.HttpServletRequest;

public class NetworkUtils {

    public static String urlBeforeContextPath() {
        HttpServletRequest req = CdiUtil.bean(HttpServletRequest.class);
        return req.getScheme() + "://" + req.getServerName();
    }
}
