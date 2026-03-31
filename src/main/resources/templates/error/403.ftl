<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>403 - Access Forbidden</title>
    <link rel="stylesheet" href="/css/bootstrap5.3.0.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #f77f00 0%, #fcbf49 100%);
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
            color: #f77f00;
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
            background: #f77f00;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background 0.3s;
            font-weight: 600;
        }
        .btn-home:hover {
            background: #fcbf49;
            color: #333;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-code">🚫</div>
        <div class="error-title">Access Forbidden</div>
        <div class="error-message">
            You do not have permission to access this resource.
        </div>
        <a href="/" class="btn-home">Back to Home</a>
    </div>
</body>
</html>

