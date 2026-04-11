package com.tasos.demo.service;

import com.tasos.demo.model.FileItem;
import java.util.List;

public interface AdminBrowserService {
    List<FileItem> listFiles(String relativePath);
    byte[] getFile(String relativePath);
}
