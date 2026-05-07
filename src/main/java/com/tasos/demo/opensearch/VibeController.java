package com.tasos.demo.opensearch;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.stream.Collectors;

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

    @PostMapping("/api/bulk")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<String> bulkAddVibes(@RequestParam("file") MultipartFile file) {
        logger.info("Bulk adding vibes via Admin API");
        try {
            vibeService.bulkAddVibes(file.getInputStream());
            return ResponseEntity.ok("Vibes bulk added successfully");
        } catch (Exception e) {
            logger.error("Error bulk adding vibes", e);
            return ResponseEntity.status(500).body("Error bulk adding vibes");
        }
    }

    @GetMapping("/export")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<byte[]> exportVibes() {
        logger.info("Exporting vibes via Admin API");
        try {
            String content = vibeService.getAllVibes().stream()
                    .map(Vibe::getText)
                    .collect(Collectors.joining("\n"));
            byte[] output = content.getBytes();

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.TEXT_PLAIN);
            headers.setContentDispositionFormData("attachment", "vibes-export.txt");

            return ResponseEntity.ok()
                    .headers(headers)
                    .body(output);
        } catch (Exception e) {
            logger.error("Error exporting vibes", e);
            return ResponseEntity.status(500).build();
        }
    }

    @PostMapping("/api/reindex")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<String> reindexVibes() {
        logger.info("Reindexing vibes via Admin API");
        try {
            vibeService.reindexVibes();
            return ResponseEntity.ok("Vibes reindexed successfully");
        } catch (Exception e) {
            logger.error("Error reindexing vibes", e);
            return ResponseEntity.status(500).body("Error reindexing vibes");
        }
    }

    @DeleteMapping("/api/{id}")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<String> deleteVibe(@PathVariable String id) {
        logger.info("Deleting vibe via Admin API: {}", id);
        try {
            vibeService.deleteVibe(id);
            return ResponseEntity.ok("Vibe deleted successfully");
        } catch (Exception e) {
            logger.error("Error deleting vibe", e);
            return ResponseEntity.status(500).body("Error deleting vibe");
        }
    }
}
