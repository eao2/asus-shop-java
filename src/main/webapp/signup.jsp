<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ASUS Shop Signup</title>
    <style>
        /* ASUS x Cyberpunk Signup Page */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Orbitron', sans-serif;
        }

        body {
            background: linear-gradient(120deg, #000000, #050505, #0a0a0a);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden;
            color: #ffffff;
            padding: 10px; /* Added for better spacing on smaller screens */
        }

        .signup-container {
            position: relative;
            width: 100%;
            max-width: 400px;
            padding: 30px;
            background: #121212;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.7);
            overflow: hidden;
        }

        /* Flowing Neon Borders */
        .signup-container::before {
            content: '';
            position: absolute;
            top: -3px;
            left: -3px;
            right: -3px;
            bottom: -3px;
            z-index: -1;
            border-radius: 20px;
            background: linear-gradient(90deg,
            #ff0000,
            #ff8800,
            #ffff00,
            #00ff00,
            #00ffff,
            #0000ff,
            #ff00ff);
            background-size: 300% 300%;
            animation: flowingColors 6s infinite linear;
        }

        @keyframes flowingColors {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .logo {
            text-align: center;
            margin-bottom: 30px;
        }

        .logo img {
            width: 180px;
            max-width: 100%; /* Responsive logo */
            filter: drop-shadow(0 0 20px #00ffff);
        }

        h2 {
            font-size: 26px;
            text-align: center;
            color: #ff00ff;
            text-shadow: 0 0 10px #ff00ff, 0 0 20px #800080;
            margin-bottom: 20px;
            text-transform: uppercase;
        }

        .input-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            font-size: 13px;
            color: #ffffff;
            margin-bottom: 8px;
            text-transform: uppercase;
        }

        input {
            width: 100%;
            padding: 12px;
            background: #1e1e1e;
            color: #ffffff;
            border: 1px solid #333;
            border-radius: 8px;
            font-size: 14px;
            transition: border 0.3s, box-shadow 0.3s;
        }

        input:focus {
            outline: none;
            border-color: #ff00ff;
            box-shadow: 0 0 10px #ff00ff, 0 0 20px #ff00ff;
        }

        .signup-btn {
            width: 100%;
            padding: 12px;
            background: linear-gradient(90deg, #ff0080, #00ffff);
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: bold;
            color: #ffffff;
            text-transform: uppercase;
            cursor: pointer;
            transition: box-shadow 0.3s ease, transform 0.2s ease;
            box-shadow: 0 0 15px #ff0080, 0 0 20px #00ffff;
        }

        .signup-btn:hover {
            transform: scale(1.05);
            box-shadow: 0 0 20px #00ffff, 0 0 40px #ff0080;
        }

        .additional-text {
            text-align: center;
            font-size: 14px;
            margin-top: 20px;
        }

        .additional-text a {
            color: #00ffff;
            text-decoration: none;
            font-weight: bold;
        }

        .additional-text a:hover {
            text-shadow: 0 0 10px #00ffff, 0 0 20px #ff0080;
        }

        /* Background Accent Lines */
        .accent-line {
            position: absolute;
            width: 2px;
            height: 100%;
            background: linear-gradient(to bottom, #ff00ff, transparent);
            animation: neonFlicker 2s infinite;
        }

        .accent-line:nth-child(1) {
            left: 20%;
            animation-delay: 0.2s;
        }

        .accent-line:nth-child(2) {
            left: 50%;
            animation-delay: 1s;
        }

        .accent-line:nth-child(3) {
            left: 80%;
            animation-delay: 1.5s;
        }

        @keyframes neonFlicker {
            0%, 100% { opacity: 0.8; }
            50% { opacity: 0.4; }
        }
    </style>
</head>
<body>
<div class="accent-line"></div>
<div class="accent-line"></div>
<div class="accent-line"></div>
<div class="signup-container">
    <div class="logo">
        <img src="images/asus-logo.png" alt="ASUS Logo">
    </div>
    <h2>ASUS Shop Signup</h2>
    <form action="SignupServlet" method="post">
        <div class="input-group">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" placeholder="Enter your username" required>
        </div>
        <div class="input-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" placeholder="Enter your password" required>
        </div>
        <div class="input-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" placeholder="Enter your email" required>
        </div>
        <div class="input-group">
            <label for="phone_number">Phone Number</label>
            <input type="number" id="phone_number" name="phone_number" placeholder="Enter your phone number">
        </div>
        <button type="submit" class="signup-btn">Signup</button>
    </form>
    <p class="additional-text">Already have an account? <a href="login.jsp">Login</a></p>
</div>
</body>
</html>
