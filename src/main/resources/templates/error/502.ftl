<!DOCTYPE html>
<html lang="${.lang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>"Bad Gateway"</title>
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
        .error-details {
            background: #f8f9fa;
            border-left: 4px solid #667eea;
            padding: 15px;
            border-radius: 5px;
            text-align: left;
            margin-bottom: 30px;
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
            .error-details {
                padding: 12px;
                margin-bottom: 20px;
                font-size: 11px;
                max-height: 120px;
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
        <div class="error-code">502</div>
        <div class="error-title">Bad Gateway</div>
        <div class="error-message">
            The server received an invalid response from an upstream server. Please try again in a few moments.
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

