<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error</title>
    <link rel="stylesheet" href="/css/bootstrap5.3.0.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .error-container {
            background: white;
            border-radius: 15px;
            padding: 60px 40px;
            text-align: center;
            max-width: 500px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.3);
        }
        .error-code {
            font-size: 120px;
            font-weight: bold;
            color: #ff6b6b;
            line-height: 1;
            margin-bottom: 20px;
        }
        .error-title {
            font-size: 28px;
            font-weight: 600;
            color: #333;
            margin-bottom: 15px;
        }
        .error-message {
            font-size: 16px;
            color: #666;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        .btn-home {
            display: inline-block;
            padding: 12px 30px;
            background: #ff6b6b;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background 0.3s;
            font-weight: 600;
        }
        .btn-home:hover {
            background: #ee5a52;
            color: white;
            transform: translateY(-2px);
        }
        .emoji-error {
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
                margin-bottom: 20px;
            }
            .emoji-error {
                font-size: 60px;
                margin-bottom: 15px;
            }
            .btn-home {
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
            .emoji-error {
                font-size: 50px;
                margin-bottom: 10px;
            }
            .btn-home {
                padding: 10px 20px;
                font-size: 13px;
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="error-container">
        <span class="emoji-error">⚠️</span>
        <div class="error-code">Error</div>
        <div class="error-title">
            <#if status??>
                Error ${status}
            <#else>
                An Error Occurred
            </#if>
        </div>
        <div class="error-message">
            An error occurred while processing your request. Please try again later.
        </div>
        <#if message??>
            <div style="font-size: 13px; color: #999; margin-bottom: 20px;">
                ${message}
            </div>
        </#if>
        <a href="/" class="btn-home">← Back to Home</a>
    </div>
</body>
</html>

