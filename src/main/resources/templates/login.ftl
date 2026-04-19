<!DOCTYPE html>
<html lang="en" data-bs-theme="dark">
<head>
    <title>Login - SRT Translation App</title>
    <link rel="stylesheet" href="/css/styles.css">
    <link rel="icon" type="image/x-icon" href="/favicon.ico">
    <style>
        .login-container {
            max-width: 400px;
            margin: 100px auto;
            padding: 30px;
            background-color: #2b3035; /* Bootstrap dark slightly elevated background */
            border-radius: 8px;
            border: 1px solid #495057;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.4);
        }

        .login-container h1 {
            text-align: center;
            color: #e9ecef;
            margin-bottom: 30px;
            font-size: 24px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #dee2e6;
            font-weight: bold;
            font-size: 14px;
        }

        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #495057;
            background-color: #212529;
            color: #e9ecef;
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;
            transition: border-color 0.3s;
        }

        .form-group input:focus {
            outline: none;
            border-color: #3498db;
            background-color: #2b3035;
            color: #fff;
            box-shadow: 0 0 5px rgba(52, 152, 219, 0.5);
        }

        .login-btn {
            width: 100%;
            padding: 12px;
            background-color: #27ae60;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .login-btn:hover {
            background-color: #229954;
        }

        .error-message {
            background-color: #442726; /* Dark mode error reddish tint */
            border-left: 4px solid #e74c3c;
            color: #ff9999;
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 4px;
            font-size: 14px;
        }

        .info-message {
            background-color: #1c3242; /* Dark mode blueish tint */
            border-left: 4px solid #3498db;
            color: #99ccff;
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 4px;
            font-size: 14px;
        }

        .back-link {
            text-align: center;
            margin-top: 20px;
        }

        .back-link a {
            color: #3498db;
            text-decoration: none;
            font-size: 14px;
        }

        .back-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div style="text-align: center; margin-bottom: 30px; margin-top: 20px;">
    <a href="/" aria-label="Home Page" style="display: inline-block;">
      <img src="/images/logo2-shrunk.webp" alt="Logo" style="max-width:400px; height: auto;">
    </a>
</div>
<hr style="border: none; height: 2px; background-color: #28a745; margin: 20px 0;">

<div class="login-container">
    <h1>🔐 Login</h1>

    <#if errorMessage??>
        <div class="error-message">
            ${errorMessage}
        </div>
    </#if>

    <form method="post" action="/login">
        <div class="form-group">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required autofocus/>
        </div>

        <div class="form-group">
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required/>
        </div>

        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

        <button type="submit" class="login-btn">Login</button>
    </form>

    <div class="back-link">
        <a href="/">← Back to Home</a>
    </div>
</div>
</body>
</html>

