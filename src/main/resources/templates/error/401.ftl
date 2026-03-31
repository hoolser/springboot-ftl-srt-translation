<!DOCTYPE html>
<html lang="en">
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
        .btn-login {
            display: inline-block;
            padding: 12px 30px;
            background: #f5576c;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background 0.3s;
            font-weight: 600;
            margin-right: 10px;
        }
        .btn-login:hover {
            background: #f093fb;
            color: white;
        }
        .btn-home {
            display: inline-block;
            padding: 12px 30px;
            background: #6c757d;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background 0.3s;
            font-weight: 600;
        }
        .btn-home:hover {
            background: #5a6268;
            color: white;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-code">🔐</div>
        <div class="error-title">Unauthorized</div>
        <div class="error-message">
            You need to be logged in to access this resource. Please log in to continue.
        </div>
        <a href="/login" class="btn-login">Login</a>
        <a href="/" class="btn-home">Back to Home</a>
    </div>
</body>
</html>
</body>
</html>

