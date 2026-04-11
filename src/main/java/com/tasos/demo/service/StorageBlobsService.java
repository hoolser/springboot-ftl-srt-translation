package com.tasos.demo.service;

import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface StorageBlobsService {

    boolean test();

    List<String> listContainers();

    String createUniqueContainer(String containerName);

    String uploadTestFileToContainer(String containerName);

    List<String> listFilesInContainer(String containerName);

    List<byte[]> downloadBlobsFromContainer(String containerName);

    String deleteContainer(String containerName);

    String uploadFileToContainer(String container, MultipartFile file);

    /**
     * Upload a file to a container with admin size limit support
     * @param container the container name
     * @param file the file to upload
     * @param isAdmin if true, uses 15GB limit; otherwise uses 100MB limit
     * @return upload status message
     */
    String uploadFileToContainer(String container, MultipartFile file, boolean isAdmin);

    byte[] downloadFileFromContainer(String container, String fileName);

    String clearContainer(String container);

    String readContainerProperties(String containerName);

    String addContainerMetadata(String containerName);

    String extractArchive(String container, String fileName);

}
