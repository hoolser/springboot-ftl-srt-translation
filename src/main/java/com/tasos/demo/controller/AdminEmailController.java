package com.tasos.demo.controller;

import com.tasos.demo.service.EmailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class AdminEmailController {

    @Autowired
    private EmailService emailService;

    @GetMapping("/admin-email")
    public String showEmailPage(Model model) {
        model.addAttribute("title", "Admin Email Tester");
        return "admin-email";
    }

    @PostMapping("/admin-email/send")
    public String sendEmail(@RequestParam("toEmail") String toEmail,
                            @RequestParam("fromEmail") String fromEmail,
                            @RequestParam("subject") String subject,
                            @RequestParam("message") String message,
                            RedirectAttributes redirectAttributes) {
        try {
            // Note: fromEmail MUST be something like "contact@leaflogic.xyz" configured in your SMTP!
            emailService.sendAdminTestEmail(toEmail, subject, message, fromEmail);
            redirectAttributes.addFlashAttribute("successMessage", "Email successfully sent to " + toEmail + " from " + fromEmail + "!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to send email: " + e.getMessage());
        }
        return "redirect:/admin-email";
    }

    @GetMapping("/admin-contact")
    public String showContactPage(Model model) {
        model.addAttribute("title", "Admin Contact");
        return "admin-contact";
    }

    @PostMapping("/admin-contact/send")
    public String sendContact(@RequestParam("userEmail") String userEmail,
                              @RequestParam("subject") String subject,
                              @RequestParam("message") String message,
                              RedirectAttributes redirectAttributes) {
        try {
            // Hardcode the verified SMTP sender for internal notifications
            String systemSender = "noreply@leaflogic.xyz";
            emailService.sendContactEmail(userEmail, subject, message, systemSender);
            redirectAttributes.addFlashAttribute("successMessage", "Contact form successfully sent to system auditor.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to send contact message: " + e.getMessage());
        }
        return "redirect:/admin-contact";
    }
}

