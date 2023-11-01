package io.jans.agamapasskey;

import io.jans.as.common.service.common.UserService;
import io.jans.service.cdi.util.CdiUtil;
import io.jans.service.MailService;

import java.security.SecureRandom;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class EmailOTPUtil {
    
    private static final int OTP_LENGTH = 6;
    private static final String SUBJECT = "Here's your passcode";
    private static final String BODY_TEMPLATE = "%s is the code to complete your verification";
    private static final SecureRandom RAND = new SecureRandom();

    private static final Logger logger = LoggerFactory.getLogger(EmailOTPUtil.class);

    public static String send(String to) {

        IntStream digits = RAND.ints(OTP_LENGTH, 0, 10);
        String otp = digits.mapToObj(i -> "" + i).collect(Collectors.joining());
        
        String body = String.format(BODY_TEMPLATE, otp);
        MailService mailService = CdiUtil.bean(MailService.class);

        if (mailService.sendMail(to, SUBJECT, body)) {
            logger.debug("E-mail has been delivered to {} with code {}", to, otp);
            return otp;
        }
        logger.debug("E-mail delivery failed, check jans-auth logs");
        return null;

    }

}