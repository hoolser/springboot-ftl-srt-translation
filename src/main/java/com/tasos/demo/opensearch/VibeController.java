package com.tasos.demo.opensearch;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
@Controller
@RequestMapping("/vibes")
@ConditionalOnProperty(name = "opensearch.enabled", havingValue = "true")
public class VibeController {
    private static final Logger logger = LoggerFactory.getLogger(VibeController.class);
    @Autowired
    private VibeService vibeService;

    @GetMapping("/admin")
    @PreAuthorize("hasRole('ADMIN')")
    public String adminVibePage(Model model) {
        model.addAttribute("vibes", vibeService.getAllVibes());
        return "admin-vibe";
    }

    @GetMapping("/random")
    @ResponseBody
    public ResponseEntity<?> getRandomVibe() {
        try {
            Vibe vibe = vibeService.getRandomVibe();
            if (vibe != null) {
                return ResponseEntity.ok(vibe);
            }
            return ResponseEntity.status(404).body("{\"error\":\"No vibes found\"}");
        } catch (Exception e) {
            return ResponseEntity.status(500).body("{\"error\":\"Error fetching vibe\"}");
        }
    }

    @PostMapping("/api")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<String> addVibe(@RequestBody Vibe vibe) {
        logger.info("Adding new vibe via Admin API: {}", vibe.getText());
        try {
            vibeService.createVibe(vibe);
            return ResponseEntity.ok("Vibe created successfully");
        } catch (Exception e) {
            logger.error("Error creating vibe", e);
            return ResponseEntity.status(500).body("Error creating vibe");
        }
    }
}
