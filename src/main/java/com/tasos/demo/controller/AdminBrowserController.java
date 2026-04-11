package com.tasos.demo.controller;

import com.tasos.demo.model.FileItem;
import com.tasos.demo.service.AdminBrowserService;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.IOException;
import java.net.URLConnection;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin/browser")
@PreAuthorize("hasRole('ADMIN')")
public class AdminBrowserController {

    private final AdminBrowserService adminBrowserService;

    public AdminBrowserController(AdminBrowserService adminBrowserService) {
        this.adminBrowserService = adminBrowserService;
    }

    @GetMapping
    public String browse(@RequestParam(required = false, defaultValue = "") String path, Model model) {
        List<FileItem> allItems = adminBrowserService.listFiles(path);

        // Split lists for nice UI
        List<FileItem> folders = allItems.stream()
                .filter(FileItem::isDirectory)
                .collect(Collectors.toList());
        List<FileItem> files = allItems.stream()
                .filter(f -> !f.isDirectory())
                .collect(Collectors.toList());

        // Extract images and order them for the lightbox
        List<String> imagePaths = files.stream()
                .filter(f -> isImage(f.getName()))
                .map(FileItem::getRelativePath)
                .collect(Collectors.toList());

        model.addAttribute("folders", folders);
        model.addAttribute("files", files);
        model.addAttribute("currentPath", path);
        model.addAttribute("parentPath", getParentPath(path));
        model.addAttribute("imagePaths", imagePaths);

        return "admin-browser";
    }

    @GetMapping("/file")
    @ResponseBody
    public ResponseEntity<Resource> getFile(@RequestParam String path) {
        byte[] data = adminBrowserService.getFile(path);
        if (data == null) {
            return ResponseEntity.notFound().build();
        }

        String mimeType = URLConnection.guessContentTypeFromName(path);
        if (mimeType == null) {
            mimeType = MediaType.APPLICATION_OCTET_STREAM_VALUE;
        }

        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(mimeType))
                .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + getFileName(path) + "\"")
                .body(new ByteArrayResource(data));
    }

    private boolean isImage(String name) {
        String lowerName = name.toLowerCase();
        return lowerName.endsWith(".png") || lowerName.endsWith(".jpg") ||
               lowerName.endsWith(".jpeg") || lowerName.endsWith(".gif") ||
               lowerName.endsWith(".webp") || lowerName.endsWith(".bmp");
    }

    private String getFileName(String path) {
        int index = path.lastIndexOf('/');
        return index >= 0 ? path.substring(index + 1) : path;
    }

    private String getParentPath(String path) {
        if (path == null || path.isEmpty()) return "";
        path = path.replace("\\", "/");
        int lastSlashInfo = path.lastIndexOf('/');
        if (lastSlashInfo == -1) {
             return "";
        }
        return path.substring(0, lastSlashInfo);
    }
}
