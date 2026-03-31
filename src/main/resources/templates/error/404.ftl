<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Page Not Found</title>
    <link rel="stylesheet" href="/css/bootstrap5.3.0.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            overflow: auto;
            padding: 20px;
        }
        .error-container {
            background: white;
            border-radius: 20px;
            padding: 80px 50px;
            text-align: center;
            max-width: 600px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            animation: slideUp 0.5s ease-out;
            width: 100%;
        }
        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        .error-code {
            font-size: 150px;
            font-weight: 900;
            color: #667eea;
            line-height: 1;
            margin-bottom: 20px;
            text-shadow: 2px 2px 4px rgba(102, 126, 234, 0.1);
        }
        .error-title {
            font-size: 32px;
            font-weight: 700;
            color: #333;
            margin-bottom: 15px;
        }
        .error-message {
            font-size: 18px;
            color: #666;
            margin-bottom: 40px;
            line-height: 1.6;
        }
        .error-details {
            background: #f8f9fa;
            border-left: 5px solid #667eea;
            padding: 20px;
            border-radius: 8px;
            text-align: left;
            margin-bottom: 40px;
            font-family: 'Courier New', monospace;
            font-size: 13px;
            color: #555;
            word-break: break-all;
            max-height: 150px;
            overflow-y: auto;
        }
        .button-group {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }
        .btn-home, .btn-back {
            display: inline-block;
            padding: 14px 35px;
            border: none;
            border-radius: 8px;
            text-decoration: none;
            transition: all 0.3s ease;
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
        }
        .btn-home {
            background: #667eea;
            color: white;
        }
        .btn-home:hover {
            background: #764ba2;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
        }
        .btn-back {
            background: #e9ecef;
            color: #333;
        }
        .btn-back:hover {
            background: #dee2e6;
            color: #333;
            transform: translateY(-2px);
        }
        .emoji-404 {
            font-size: 80px;
            margin-bottom: 20px;
            display: block;
            animation: bounce 2s infinite;
        }
        @keyframes bounce {
            0%, 100% {
                transform: translateY(0);
            }
            50% {
                transform: translateY(-20px);
            }
        }
        @media (max-width: 768px) {
            body {
                padding: 15px;
            }
            .error-container {
                padding: 40px 25px;
            }
            .error-code {
                font-size: 80px;
                margin-bottom: 15px;
            }
            .error-title {
                font-size: 24px;
                margin-bottom: 12px;
            }
            .error-message {
                font-size: 16px;
                margin-bottom: 25px;
            }
            .error-details {
                padding: 15px;
                margin-bottom: 25px;
                font-size: 12px;
            }
            .emoji-404 {
                font-size: 60px;
                margin-bottom: 15px;
            }
            .btn-home, .btn-back {
                padding: 12px 28px;
                font-size: 14px;
            }
        }
        @media (max-width: 480px) {
            body {
                padding: 10px;
            }
            .error-container {
                padding: 30px 15px;
                border-radius: 15px;
            }
            .error-code {
                font-size: 60px;
                margin-bottom: 10px;
            }
            .error-title {
                font-size: 20px;
                margin-bottom: 10px;
            }
            .error-message {
                font-size: 14px;
                margin-bottom: 20px;
            }
            .error-details {
                padding: 12px;
                margin-bottom: 20px;
                font-size: 11px;
                max-height: 120px;
            }
            .emoji-404 {
                font-size: 50px;
                margin-bottom: 10px;
            }
            .button-group {
                gap: 10px;
            }
            .btn-home, .btn-back {
                padding: 10px 20px;
                font-size: 13px;
                flex: 1;
                min-width: 120px;
            }
        }
    </style>
</head>
<body>
    <div class="error-container">
        <span class="emoji-404">🔍</span>
        <div class="error-code">404</div>
        <div class="error-title">Page Not Found</div>
        <div class="error-message">
            Sorry, the page you are looking for does not exist or has been moved.
        </div>
        <#if requestUri??>
            <div class="error-details">
                <strong>Requested Page:</strong><br>
                ${requestUri?html}
            </div>
        </#if>
        <div class="button-group">
            <a href="/" class="btn-home">Back to Home</a>
        </div>
    </div>
</body>
</html>

