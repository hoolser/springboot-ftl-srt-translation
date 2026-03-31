<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>413 - File Too Large</title>
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
        .btn-home {
            display: inline-block;
            padding: 12px 30px;
            background: #f5576c;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background 0.3s;
            font-weight: 600;
        }
        .btn-home:hover {
            background: #f093fb;
            color: white;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <span class="emoji-413">📦</span>
        <div class="error-code">413</div>
        <div class="error-title">File Too Large</div>
        <div class="error-message">
            The file you are trying to upload exceeds the maximum allowed size. Please upload a smaller file.
        </div>
        <a href="/" class="btn-home">Back to Home</a>
    </div>
</body>
</html>
            border-radius: 8px;
            text-decoration: none;
            transition: all 0.3s ease;
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
        }
        .btn-home {
            background: #f5576c;
            color: white;
        }
        .btn-home:hover {
            background: #f093fb;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(245, 87, 108, 0.4);
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
        .emoji-413 {
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
    </style>
</head>
<body>
    <div class="error-container">
        <span class="emoji-413">📦</span>
        <div class="error-code">413</div>
        <div class="error-title">File Too Large</div>
        <div class="error-message">
            The file you are trying to upload exceeds the maximum allowed size of 7GB. Please try with a smaller file. />
        </div>
        <#if requestUri??>
            <div class="error-details">
                <strong>"Requested Page" />:</strong><br>
                ${requestUri}
            </div>
        </#if>
        <div class="button-group">
            <a href="/" class="btn-home">Back to Home</a>
        </div>
    </div>
</body>
</html>

