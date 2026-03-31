<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>400 - Bad Request</title>
    <link rel="stylesheet" href="/css/bootstrap5.3.0.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
            color: #667eea;
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
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background 0.3s;
            font-weight: 600;
        }
        .btn-home:hover {
            background: #764ba2;
            color: white;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-code">⚠️</div>
        <div class="error-title">Bad Request</div>
        <div class="error-message">
            The request could not be understood by the server. Please check your input and try again.
        </div>
        <a href="/" class="btn-home">Back to Home</a>
    </div>
</body>
</html>
            font-size: 14px;
            color: #555;
        }
        .btn-home {
            display: inline-block;
            padding: 12px 30px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background 0.3s;
            font-weight: 600;
        }
        .btn-home:hover {
            background: #764ba2;
            color: white;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-code">400</div>
        <div class="error-title">Bad Request</div>
        <div class="error-message">
            The request could not be understood by the server. Please check your input and try again.
        </div>
        <#if request.getAttribute('jakarta.servlet.error.message')??>
            <div class="error-details">
                <strong>Details:</strong><br>
                ${request.getAttribute('jakarta.servlet.error.message')}
            </div>
        </#if>
        <a href="/" class="btn-home">Back to Home</a>
    </div>
</body>
</html>

