<!DOCTYPE html>
<html lang="en" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Folder Browser</title>
    <link rel="stylesheet" href="/css/styles.css">
    <link rel="stylesheet" href="/css/admin-theme.css">
    <link rel="icon" type="image/x-icon" href="/favicon.ico">
    <style>
        .browser-container { padding: 20px; max-width: 1000px; margin: 0 auto; background: #2b3035; border-radius: 10px; border: 1px solid #495057; box-shadow: 0 4px 6px rgba(0,0,0,0.4); }
        .breadcrumb { font-size: 18px; margin-bottom: 20px; color: #e9ecef; }
        .breadcrumb a { text-decoration: none; color: #e74c3c; font-weight: bold; }
        .breadcrumb a:hover { text-decoration: underline; color: #ff6b6b; }
        .file-grid { display: flex; flex-wrap: wrap; gap: 15px; }
        .file-item { width: 120px; text-align: center; cursor: pointer; padding: 10px; border-radius: 8px; transition: background 0.3s; word-wrap: break-word; color: #dee2e6;}
        .file-item:hover { background: #343a40; }
        .file-icon { font-size: 40px; margin-bottom: 5px; }

        /* Lightbox CSS */
        .lightbox { display: none; position: fixed; z-index: 1000; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.8); align-items: center; justify-content: center; }
        .lightbox.active { display: flex; }
        .lightbox-content { max-width: 90%; max-height: 90%; object-fit: contain; }
        .lightbox-nav { position: absolute; top: 50%; transform: translateY(-50%); font-size: 40px; color: white; background: rgba(0,0,0,0.5); border: none; cursor: pointer; padding: 15px; z-index: 1001; user-select: none; }
        .lightbox-nav.prev { left: 10px; }
        .lightbox-nav.next { right: 10px; }
        .lightbox-close { position: absolute; top: 10px; right: 20px; font-size: 50px; color: white; background: none; border: none; cursor: pointer; z-index: 1001; user-select: none; padding: 10px; }

        /* Mobile-friendly grid */
        @media (max-width: 600px) {
            .file-item { width: 45%; padding: 5px; }
            .file-grid { justify-content: space-around; }
            .browser-container { padding: 10px; }
            .lightbox-nav { font-size: 30px; padding: 10px; }
        }
    </style>
</head>
<body class="storage-page">

<div style="text-align: center; margin-bottom: 20px; margin-top: 20px;">
    <a href="/" style="display: inline-block;">
        <img src="/images/logo2-shrunk.webp" alt="Logo" style="max-width:300px;">
    </a>
</div>
<hr style="border: none; height: 2px; background-color: #e74c3c; margin: 20px 0;">

<div class="browser-container">
    <div style="margin-bottom: 20px;">
        <a href="/"><button class="home-button">&#8592; Back to Home</button></a>
    </div>

    <h2 style="color: #e74c3c;">Admin Container Browser</h2>
    <div class="breadcrumb">
        <a href="/admin/browser">Root</a>
        <#if currentPath != "">
            <span> / ${currentPath}</span>
        </#if>
    </div>

    <div class="file-grid">
        <#if currentPath != "">
            <div class="file-item" onclick="window.location.href='/admin/browser?path=${parentPath}'">
                <div class="file-icon">📁</div>
                <div>.. (Up)</div>
            </div>
        </#if>

        <#list folders as folder>
            <div class="file-item" onclick="window.location.href='/admin/browser?path=${folder.relativePath}'">
                <div class="file-icon">📁</div>
                <div>${folder.name}</div>
            </div>
        </#list>

        <#list files as file>
            <#assign lowerName = file.name?lower_case>
            <#assign isImage = lowerName?ends_with('.png') || lowerName?ends_with('.jpg') || lowerName?ends_with('.jpeg') || lowerName?ends_with('.gif') || lowerName?ends_with('.webp') || lowerName?ends_with('.bmp')>

            <div class="file-item"
                 <#if isImage>
                     onclick="openLightbox('${file.relativePath}')" title="Click to preview"
                 <#else>
                     onclick="window.open('/admin/browser/file?path=${file.relativePath}', '_blank')"
                 </#if>
            >
                <div class="file-icon">
                    <#if isImage>
                        🖼️
                    <#elseif lowerName?ends_with('.pdf')>
                        📄
                    <#elseif lowerName?ends_with('.srt')>
                        📝
                    <#else>
                        📄
                    </#if>
                </div>
                <div>${file.name}</div>
                <div style="font-size: 11px; color: #777;">${(file.size / 1024)?string("0.#")} KB</div>
            </div>
        </#list>
    </div>
</div>

<!-- Lightbox Modal -->
<div id="lightbox" class="lightbox">
    <button class="lightbox-close" onclick="closeLightbox()">&times;</button>
    <button class="lightbox-nav prev" onclick="navigateImage(-1)">&#10094;</button>
    <img id="lightbox-img" class="lightbox-content" src="" alt="Preview">
    <button class="lightbox-nav next" onclick="navigateImage(1)">&#10095;</button>
</div>

<script>
    // Array of image paths for navigation
    const imagePaths = [
        <#list imagePaths as path>'${path}',</#list>
    ];
    let currentIndex = 0;

    function openLightbox(imagePath) {
        document.getElementById('lightbox').classList.add('active');
        document.getElementById('lightbox-img').src = '/admin/browser/file?path=' + encodeURIComponent(imagePath);
        currentIndex = imagePaths.indexOf(imagePath);
    }

    function closeLightbox() {
        document.getElementById('lightbox').classList.remove('active');
        document.getElementById('lightbox-img').src = '';
    }

    function navigateImage(direction) {
        if (imagePaths.length === 0) return;
        currentIndex += direction;

        if (currentIndex >= imagePaths.length) {
            currentIndex = 0;
        } else if (currentIndex < 0) {
            currentIndex = imagePaths.length - 1;
        }

        document.getElementById('lightbox-img').src = '/admin/browser/file?path=' + encodeURIComponent(imagePaths[currentIndex]);
    }

    // Close lightbox on background click or escape
    document.getElementById('lightbox').addEventListener('click', function(e) {
        if (e.target === this) {
            closeLightbox();
        }
    });

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') closeLightbox();
        if (e.key === 'ArrowRight') navigateImage(1);
        if (e.key === 'ArrowLeft') navigateImage(-1);
    });
</script>

</body>
</html>

