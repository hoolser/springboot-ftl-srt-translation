package com.tasos.demo.model;

public class FileItem {
    private String name;
    private boolean isDirectory;
    private String relativePath;
    private long size;

    public FileItem(String name, boolean isDirectory, String relativePath, long size) {
        this.name = name;
        this.isDirectory = isDirectory;
        this.relativePath = relativePath;
        this.size = size;
    }

    public String getName() { return name; }
    public boolean isDirectory() { return isDirectory; }
    public String getRelativePath() { return relativePath; }
    public long getSize() { return size; }
}
