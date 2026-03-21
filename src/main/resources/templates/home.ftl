<!DOCTYPE html>
<html>
<head>
    <title>Spring Boot FreeMarker Landing Page</title>
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <link rel="stylesheet" href="/css/styles.css">
    <link rel="icon" type="image/x-icon" href="/favicon.ico">
    <style>
        .logout-container {
            position: absolute;
            top: 20px;
            right: 20px;
        }
        .logout-btn {
            background-color: #e74c3c;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
            transition: background-color 0.3s;
        }
        .logout-btn:hover {
            background-color: #c0392b;
        }
    </style>
</head>
<body>
<div class="centered-message">
    <#if isAdmin?? && isAdmin>
        <div class="logout-container">
            <form action="/logout" method="post" style="display:inline;">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <button type="submit" class="logout-btn">Logout</button>
            </form>
        </div>
    </#if>
    <h1>Welcome to the Spring Boot Demo of Tasos!</h1>
    <p>${message}</p>
    <div class="home-buttons">
        <a href="/storage-blob-page">
            <button class="home-button" style="margin-top: 30px;">Go to Storage Blob Management</button>
        </a>
        <a href="/share-blob-page">
            <button class="home-button" style="margin-top: 30px;">Go to Share Blob Page</button>
        </a>
        <a href="/srt-translation-page">
            <button class="home-button" style="margin-top: 30px;">Go to SRT Translation</button>
        </a>
    </div>
</div>
</body>
</html>