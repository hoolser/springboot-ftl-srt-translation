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
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

import java.io.IOException;
import java.util.List;

@Controller
@RequestMapping("/courses")
@ConditionalOnProperty(name = "opensearch.enabled", havingValue = "true")
public class CourseController {

    private static final Logger logger = LoggerFactory.getLogger(CourseController.class);

    @Autowired
    private CourseService courseService;

    @GetMapping
    public String coursesPage(Model model) {
        model.addAttribute("title", "Courses List");

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        boolean isAdmin = auth != null && auth.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
        model.addAttribute("isAdmin", isAdmin);

        return "courses";
    }

    @GetMapping("/api")
    @ResponseBody
    public ResponseEntity<List<Course>> getCourses() {
        logger.info("Fetching all courses");
        try {
            return ResponseEntity.ok(courseService.getAllCourses());
        } catch (IOException e) {
            logger.error("Error fetching courses", e);
            return ResponseEntity.status(500).build();
        }
    }

    @GetMapping("/api/search")
    @ResponseBody
    public ResponseEntity<List<Course>> searchCourses(
            @RequestParam(value = "title", required = false) String title,
            @RequestParam(value = "description", required = false) String description) {
        logger.info("Searching courses with title: {}, description: {}", title, description);
        try {
            return ResponseEntity.ok(courseService.searchCourses(title, description));
        } catch (IOException e) {
            logger.error("Error searching courses", e);
            return ResponseEntity.status(500).build();
        }
    }

    @PostMapping("/api")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<String> addCourse(@RequestBody Course course) {
        logger.info("Adding new course via Admin API: {}", course.getTitle());
        try {
            courseService.createCourse(course);
            return ResponseEntity.ok("Course created successfully");
        } catch (IOException e) {
            logger.error("Error creating course", e);
            return ResponseEntity.status(500).body("Error creating course");
        }
    }

    @DeleteMapping("/api/{id}")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<String> deleteCourse(@PathVariable String id) {
        logger.info("Deleting course via Admin API: {}", id);
        try {
            courseService.deleteCourse(id);
            return ResponseEntity.ok("Course deleted successfully");
        } catch (IOException e) {
            logger.error("Error deleting course", e);
            return ResponseEntity.status(500).body("Error deleting course");
        }
    }
}
