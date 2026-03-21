package com.tasos.demo.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import jakarta.annotation.PostConstruct;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Initializes required logging directories on application startup.
 * Ensures that log directories are created if they don't already exist,
 * preventing logback configuration errors.
 */
@Component
public class LoggingDirectoryInitializer {

    private static final Logger logger = LoggerFactory.getLogger(LoggingDirectoryInitializer.class);

    @Value("${user.home}")
    private String userHome;

    private static final String LOG_DIRECTORY = "demoProjectLogs";
    private static final String ARCHIVED_LOG_DIRECTORY = "archived";

    /**
     * Initialize logging directories on application startup.
     * This method is called automatically after the component is constructed.
     */
    @PostConstruct
    public void initializeLoggingDirectories() {
        try {
            // Create main logging directory
            Path mainLogDir = Paths.get(userHome, LOG_DIRECTORY);
            if (!Files.exists(mainLogDir)) {
                Files.createDirectories(mainLogDir);
                logger.info("Created main logging directory at: {}", mainLogDir);
            } else {
                logger.debug("Main logging directory already exists at: {}", mainLogDir);
            }

            // Create archived logging directory
            Path archivedLogDir = Paths.get(userHome, LOG_DIRECTORY, ARCHIVED_LOG_DIRECTORY);
            if (!Files.exists(archivedLogDir)) {
                Files.createDirectories(archivedLogDir);
                logger.info("Created archived logging directory at: {}", archivedLogDir);
            } else {
                logger.debug("Archived logging directory already exists at: {}", archivedLogDir);
            }

        } catch (Exception e) {
            logger.error("Failed to initialize logging directories", e);
            // Don't throw exception - allow application to continue
            System.err.println("Warning: Failed to create logging directories - " + e.getMessage());
        }
    }
}

