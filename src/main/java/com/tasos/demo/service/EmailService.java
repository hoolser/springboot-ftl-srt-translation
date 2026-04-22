package com.tasos.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Service
public class EmailService {

    private static final Logger log = LoggerFactory.getLogger(EmailService.class);

    @Autowired
    private JavaMailSender emailSender;

    @Value("${app.email.audit.email:}")
    private String auditEmail;

    public void sendAdminTestEmail(String to, String subject, String text, String fromEmail) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            // In a real environment the 'from' must match the verified domain
            message.setFrom(fromEmail);
            message.setTo(to);
            message.setSubject(subject);
            message.setText(text);

            if (StringUtils.hasText(auditEmail)) {
                message.setBcc(auditEmail);
            }

            emailSender.send(message);
            log.info("Test email successfully sent to: {}", to);
        } catch (Exception e) {
            log.error("Failed to send test email to {}: {}", to, e.getMessage(), e);
            throw new RuntimeException("Failed to send email: " + e.getMessage());
        }
    }

    public void sendContactEmail(String userEmail, String subject, String text, String fromEmail) {
        try {
            if (!StringUtils.hasText(auditEmail)) {
                throw new RuntimeException("Contact monitoring email (AUDIT_EMAIL) is not configured.");
            }

            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail); // Hardcoded system sender (e.g. noreply@leaflogic.xyz)
            message.setReplyTo(userEmail); // If you click "reply" in your email client, it goes to the user who filled the form!
            message.setTo(auditEmail);
            message.setSubject("Contact Form: " + subject);

            // We also inject their email literally in the text body so you can read it clearly
            String fullText = "Message from: " + userEmail + "\n\n" + text;
            message.setText(fullText);

            emailSender.send(message);
            log.info("Contact email successfully sent from: {} to: {}", userEmail, auditEmail);
        } catch (Exception e) {
            log.error("Failed to send contact email from {}: {}", userEmail, e.getMessage(), e);
            throw new RuntimeException("Failed to send contact email: " + e.getMessage());
        }
    }
}

