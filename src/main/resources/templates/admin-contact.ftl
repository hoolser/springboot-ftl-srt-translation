<!DOCTYPE html>
<html lang="en" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title!}</title>
    <!-- Use existing CSS dependencies -->
    <link href="/css/bootstrap5.3.0.min.css" rel="stylesheet" />
    <link href="/css/styles.css" rel="stylesheet" />
    <style>
        body { padding: 20px; background-color: #212529; color: #e0e0e0; }
        .admin-theme { color: #e74c3c; font-weight: 600; }
        .storage-container {
            max-width: 600px;
            margin: 0 auto;
            border: 1px solid #495057;
            background-color: #2b3035;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.4);
        }
        .form-label { font-weight: bold; color: #dee2e6; }
        .form-control { background-color: #212529; border: 1px solid #495057; color: #fff; margin-bottom: 15px; }
        .form-control:focus { background-color: #2b3035; border-color: #e74c3c; color: #fff; box-shadow: 0 0 5px rgba(231, 76, 60, 0.5); }
        .btn-admin { background-color: #c0392b; color: #fff; width: 100%; font-weight: bold; margin-top: 15px; }
        .btn-admin:hover { background-color: #a93226; color: #fff; }
        .alert-success { background-color: #173b22; color: #85e0a3; border-color: #28a745; }
        .alert-danger { background-color: #442726; color: #ff9999; border-color: #e74c3c; }
        .back-link { text-align: center; margin-top: 15px; }
        .back-link a { color: #3498db; text-decoration: none; }
        .back-link a:hover { text-decoration: underline; }
        .smtp-note { font-size: 0.85rem; color: #aaa; margin-top: 5px; }
    </style>
</head>
<body>

<div style="text-align: center; margin-bottom: 20px;">
    <a href="/" aria-label="Home Page">
      <img src="/images/logo2-shrunk.webp" alt="Logo" style="max-width:300px; height: auto;">
    </a>
</div>

<div class="storage-container mt-4">
    <h2 class="text-center admin-theme mb-4">📧 Admin Contact Us</h2>
    <p class="text-center text-muted mb-4">Send a message to the system administrator directly. This goes to the configured AUDIT_EMAIL.</p>

    <#if successMessage??>
        <div class="alert alert-success">${successMessage}</div>
    </#if>
    <#if errorMessage??>
        <div class="alert alert-danger">${errorMessage}</div>
    </#if>

    <form method="post" action="/admin-contact/send">
        <!-- CRITICAL for CSRF -->
        <input type="hidden" name="${_csrf.parameterName!}" value="${_csrf.token!}"/>

        <div class="mb-3">
            <label for="userEmail" class="form-label">Your Email (So we can reply to you):</label>
            <input type="email" class="form-control" id="userEmail" name="userEmail" placeholder="your_address@gmail.com" required>
        </div>

        <div class="mb-3">
            <label for="subject" class="form-label">Subject:</label>
            <input type="text" class="form-control" id="subject" name="subject" placeholder="Inquiry about..." required>
        </div>

        <div class="mb-3">
            <label for="message" class="form-label">Message:</label>
            <textarea class="form-control" id="message" name="message" rows="5" placeholder="Type your message here..." required></textarea>
        </div>

        <button type="submit" class="btn btn-admin">Send Message</button>
    </form>

    <div class="back-link">
        <a href="/">← Back to Dashboard</a>
    </div>
</div>

<#include "footer.ftl">
</body>
</html>

