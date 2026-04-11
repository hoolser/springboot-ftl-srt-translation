package com.tasos.demo.controller;

import com.tasos.demo.config.StorageConstants;
import com.tasos.demo.service.StorageBlobsService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/api/admin/storage/blobs")
@PreAuthorize("hasRole('ADMIN')")
public class AdminStorageBlobsController {

    private static final Logger logger = LoggerFactory.getLogger(AdminStorageBlobsController.class);

    private final StorageBlobsService storageBlobsService;

    public AdminStorageBlobsController(StorageBlobsService storageBlobsService) {
        this.storageBlobsService = storageBlobsService;
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<String> handleIllegalArgument(IllegalArgumentException ex) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ex.getMessage());
    }

    @GetMapping("/listFilesOfShared")
    public String listFilesOfShared() {
        List<String> fileNames = storageBlobsService.listFilesInContainer(StorageConstants.ADMIN_SHARE_CONTAINER);
        return (fileNames != null ? ("Files in container: " + fileNames) : ("Container " + StorageConstants.ADMIN_SHARE_CONTAINER + " does not exist."));
    }

    @PostMapping("/share/upload")
    public String uploadFileToShareContainer(@RequestPart("file") MultipartFile file) {
        if (file.isEmpty()) {
            return "No file selected.";
        }
        logger.info("Admin file upload for: {}", file.getOriginalFilename());
        // Using isAdmin = true to bypass standard limits
        return storageBlobsService.uploadFileToContainer(StorageConstants.ADMIN_SHARE_CONTAINER, file, true);
    }

    @GetMapping("/share/download")
    public ResponseEntity<byte[]> downloadFileFromShareContainer(@RequestParam String fileName) {
        byte[] data = storageBlobsService.downloadFileFromContainer(StorageConstants.ADMIN_SHARE_CONTAINER, fileName);
        if (data == null) {
            return ResponseEntity.notFound().build();
        }
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
        headers.setContentDispositionFormData("attachment", fileName);
        return ResponseEntity.ok().headers(headers).body(data);
    }

    @PostMapping("/share/clear")
    public String clearShareContainer() {
        return storageBlobsService.clearContainer(StorageConstants.ADMIN_SHARE_CONTAINER);
    }
    
    @PostMapping("/share/extract")
    public String extractArchive(@RequestParam String fileName) {
        logger.info("Admin extracting archive: {}", fileName);
        return storageBlobsService.extractArchive(StorageConstants.ADMIN_SHARE_CONTAINER, fileName);
    }
}
