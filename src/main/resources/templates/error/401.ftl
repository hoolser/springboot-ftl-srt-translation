<!DOCTYPE html>
<html lang="en" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>401 - Unauthorized</title>
    <link rel="stylesheet" href="/css/bootstrap5.3.0.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
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
            border-radius: 15px;
            padding: 60px 40px;
            text-align: center;
            max-width: 500px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.3);
            width: 100%;
        }
        .error-code {
            font-size: 120px;
            font-weight: bold;
            color: #f5576c;
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
        .button-group {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }
        .btn-login, .btn-home {
            display: inline-block;
            padding: 12px 30px;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: all 0.3s;
            font-weight: 600;
        }
        .btn-login {
            background: #f5576c;
        }
        .btn-login:hover {
            background: #f093fb;
            color: white;
            transform: translateY(-2px);
        }
        .btn-home {
            background: #6c757d;
        }
        .btn-home:hover {
            background: #5a6268;
            color: white;
            transform: translateY(-2px);
        }
        .emoji-401 {
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
            .emoji-401 {
                font-size: 60px;
                margin-bottom: 15px;
            }
            .btn-login, .btn-home {
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
            .emoji-401 {
                font-size: 50px;
                margin-bottom: 10px;
            }
            .button-group {
                gap: 10px;
            }
            .btn-login, .btn-home {
                padding: 10px 20px;
                font-size: 13px;
                flex: 1;
                min-width: 100px;
            }
        }
    </style>
</head>
<body>
    <div class="error-container">
        <span class="emoji-401">🔐</span>
        <div class="error-code">401</div>
        <div class="error-title">Unauthorized</div>
        <div class="error-message">
            You need to be logged in to access this resource. Please log in to continue.
        </div>
        <div class="button-group">
            <a href="/login" class="btn-login">Login</a>
            <a href="/" class="btn-home">Back to Home</a>
        </div>
    </div>
</body>
</html>


