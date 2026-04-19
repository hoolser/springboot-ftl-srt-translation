package com.tasos.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Service
public class EmailService {

    private static final Logger log = LoggerFactory.getLogger(EmailService.class);

    @Autowired
    private JavaMailSender emailSender;

    public void sendAdminTestEmail(String to, String subject, String text, String fromEmail) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            // In a real environment the 'from' must match the verified domain
            message.setFrom(fromEmail);
            message.setTo(to);
            message.setSubject(subject);
            message.setText(text);

            emailSender.send(message);
            log.info("Test email successfully sent to: {}", to);
        } catch (Exception e) {
            log.error("Failed to send test email to {}: {}", to, e.getMessage(), e);
            throw new RuntimeException("Failed to send email: " + e.getMessage());
        }
    }
}

