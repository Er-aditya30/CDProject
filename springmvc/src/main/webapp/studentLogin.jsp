<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Initialize login status
    String loginStatus = "";
    
    // Check if the form has been submitted
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Database connection details
        String jdbcURL = "jdbc:mysql://localhost:3306/ExtracurricularAchievementsDB"; // Replace with your database name
        String dbUser = "root"; // Replace with your database username
        String dbPassword = "Vardhan@99"; // Your database password

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
            
            // Update the SQL query to match the correct table
            String sql = "SELECT * FROM student_profiles WHERE username = ? AND password = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, username);
            statement.setString(2, password);
            ResultSet resultSet = statement.executeQuery();
            
            // If a match is found, redirect to the student's dashboard
            if (resultSet.next()) {
                response.sendRedirect("studentDashboard.jsp?username=" + username);
            } else {
                loginStatus = "Invalid username or password!";
            }

            resultSet.close();
            statement.close();
            connection.close();
        } catch (Exception e) {
            e.printStackTrace();
            loginStatus = "Database error occurred!";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Login - Extracurricular Achievements Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;600&display=swap');

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Roboto', sans-serif;
        }

        body {
            position: relative;
            background: url("https://example.com/path-to-your-best-background.jpg") no-repeat center center fixed; /* Use your desired background image URL */
            background-size: cover;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
        }

        body::before {
            content: "";
            position: absolute;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 0;
        }

        .container {
            position: relative;
            max-width: 400px;
            width: 100%;
            background: rgba(0, 0, 0, 0.75);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0px 15px 20px rgba(0, 0, 0, 0.2);
            z-index: 1;
        }

        h2 {
            color: #fff; /* Title color */
        }

        .form-label {
            font-weight: bold; /* Bold labels */
            color: #fff; /* Label color */
        }

        .btn-primary {
            background-color: #007bff; /* Blue button */
            border: none; /* No border */
        }

        .btn-primary:hover {
            background-color: #0056b3; /* Darker blue on hover */
        }

        .text-danger {
            color: #f8d7da; /* Light red for error messages */
        }

        .text-center a {
            color: #1a75ff; /* Blue link color */
            text-decoration: none; /* No underline */
        }

        .text-center a:hover {
            text-decoration: underline; /* Underline on hover */
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <h2 class="text-center">Student Login</h2>
        <form action="studentLogin.jsp" method="post">
            <div class="mb-3">
                <label for="username" class="form-label">Username</label>
                <input type="text" class="form-control" id="username" name="username" required>
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" id="password" name="password" required>
            </div>
            <div class="text-center">
                <button type="submit" class="btn btn-primary">Login</button>
            </div>
            <div class="text-danger text-center mt-2">
                <%= loginStatus %>
            </div>
        </form>
        <p class="text-center mt-3">Don't have an account? <a href="signup.jsp">Sign Up</a></p>
    </div>
</body>
</html>