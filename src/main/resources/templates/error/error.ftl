<!DOCTYPE html>
<html lang="en" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${status!'Error'} - An Error Occurred</title>
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
        .error-status {
            display: inline-block;
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            padding: 8px 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            font-family: 'Courier New', monospace;
            font-size: 14px;
            color: #555;
        }
        .error-details {
            background: #f8f9fa;
            border-left: 4px solid #ff6b6b;
            padding: 15px;
            border-radius: 5px;
            text-align: left;
            margin-bottom: 30px;
            font-size: 13px;
            color: #555;
            max-height: 150px;
            overflow-y: auto;
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
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-code">⚠️</div>
        <div class="error-title">An Error Occurred</div>

        <#if status??>
            <div class="error-status">
                Status Code: ${status?html}
            </div>
        </#if>

        <div class="error-message">
            <#if message??>${message?html}<#else>An error occurred while processing your request. Please try again later.</#if>
        </div>

        <a href="/" class="btn-home">Back to Home</a>
    </div>
</body>
</html>


