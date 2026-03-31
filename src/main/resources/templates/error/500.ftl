<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Server Error</title>
    <link rel="stylesheet" href="/css/bootstrap5.3.0.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #eb3349 0%, #f45c43 100%);
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
            animation: slideUp 0.5s ease-out;
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
            font-size: 120px;
            font-weight: bold;
            color: #eb3349;
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
        .error-details {
            background: #f8f9fa;
            border-left: 4px solid #eb3349;
            padding: 15px;
            border-radius: 5px;
            text-align: left;
            margin-bottom: 30px;
            font-size: 13px;
            color: #555;
            max-height: 150px;
            overflow-y: auto;
            word-break: break-all;
        }
        .button-group {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }
        .btn-home, .btn-back {
            display: inline-block;
            padding: 12px 30px;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: all 0.3s;
            font-weight: 600;
            border: none;
            cursor: pointer;
        }
        .btn-home {
            background: #eb3349;
        }
        .btn-home:hover {
            background: #f45c43;
            color: white;
            transform: translateY(-2px);
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
        .emoji-500 {
            font-size: 80px;
            margin-bottom: 20px;
            display: block;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <span class="emoji-500">⚠️</span>
        <div class="error-code">500</div>
        <div class="error-title">Server Error</div>
        <div class="error-message">
            An unexpected error occurred on the server. Please try again later or contact the administrator if the problem persists.
        </div>
        <#if message??>
            <div class="error-details">
                <strong>Details:</strong><br>
                ${message?html}
            </div>
        </#if>
        <div class="button-group">
            <a href="/" class="btn-home">Back to Home</a>
        </div>
    </div>
</body>
</html>

