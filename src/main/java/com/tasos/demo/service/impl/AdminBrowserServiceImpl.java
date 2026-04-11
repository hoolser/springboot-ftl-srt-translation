package com.tasos.demo.service.impl;

import com.tasos.demo.config.StorageConstants;
import com.tasos.demo.model.FileItem;
import com.tasos.demo.service.AdminBrowserService;
import jakarta.annotation.PostConstruct;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

@Service
public class AdminBrowserServiceImpl implements AdminBrowserService {

    private static final Logger logger = LoggerFactory.getLogger(AdminBrowserServiceImpl.class);

    @Value("${" + StorageConstants.STORAGE_PATH_PROPERTY_KEY + ":${user.home}/" + StorageConstants.DEFAULT_LOCAL_STORAGE_DIR + "}")
    private String storagePath;

    private Path adminShareRoot;

    @PostConstruct
    public void initialize() {
        try {
            Path storageRoot = Paths.get(storagePath).toAbsolutePath().normalize();
            adminShareRoot = storageRoot.resolve(StorageConstants.ADMIN_SHARE_CONTAINER).normalize();
            if (!Files.exists(adminShareRoot)) {
                Files.createDirectories(adminShareRoot);
                logger.info("Admin share directory created at: {}", adminShareRoot);
            }
        } catch (IOException e) {
            logger.error("Failed to initialize admin share storage", e);
            throw new RuntimeException("Failed to initialize admin share storage", e);
        }
    }

    private Path getSafePath(String relativePath) {
        if (relativePath == null || relativePath.isEmpty() || relativePath.equals("/")) {
            return adminShareRoot;
        }
        // Normalize to prevent directory traversal
        Path targetPath = adminShareRoot.resolve(relativePath).normalize();
        if (!targetPath.startsWith(adminShareRoot)) {
            throw new SecurityException("Directory traversal attempt detected: " + relativePath);
        }
        return targetPath;
    }

    @Override
    public List<FileItem> listFiles(String relativePath) {
        List<FileItem> items = new ArrayList<>();
        try {
            Path targetPath = getSafePath(relativePath);
            if (!Files.exists(targetPath) || !Files.isDirectory(targetPath)) {
                return items; // Or throw an exception
            }

            File[] files = targetPath.toFile().listFiles();
            if (files != null) {
                for (File file : files) {
                    String itemRelPath = adminShareRoot.relativize(file.toPath()).toString().replace("\\", "/");
                    items.add(new FileItem(
                            file.getName(),
                            file.isDirectory(),
                            itemRelPath,
                            file.isDirectory() ? 0 : file.length()
                    ));
                }
            }
        } catch (Exception e) {
            logger.error("Error listing files in {}", relativePath, e);
        }
        return items;
    }

    @Override
    public byte[] getFile(String relativePath) {
        try {
            Path targetPath = getSafePath(relativePath);
            if (Files.exists(targetPath) && !Files.isDirectory(targetPath)) {
                return Files.readAllBytes(targetPath);
            }
        } catch (IOException e) {
            logger.error("Error reading file {}", relativePath, e);
        }
        return null;
    }
}
