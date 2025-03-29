<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sign Up - Extracurricular Achievements Portal</title>
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
            background: url("https://example.com/path-to-your-best-background.jpg") no-repeat center center fixed; /* Use a better background image URL */
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

        .btn-success {
            background-color: #007bff; /* Blue button */
            border: none; /* No border */
        }

        .btn-success:hover {
            background-color: #0056b3; /* Darker blue on hover */
        }

        .text-center a {
            color: #1a75ff; /* Blue link color */
            text-decoration: none; /* No underline */
        }

        .text-center a:hover {
            text-decoration: underline; /* Underline on hover */
        }
    </style>
    <script>
        function showAlert() {
            alert("Account created successfully! You can now log in.");
        }
    </script>
</head>
<body>
    <div class="container">
        <h2 class="text-center">Sign Up</h2>
        <form action="" method="post">
            <div class="mb-3">
                <label for="username" class="form-label">Username</label>
                <input type="text" class="form-control" id="username" name="username" required>
            </div>
            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" class="form-control" id="email" name="email" required>
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" id="password" name="password" required>
            </div>
            <div class="text-center">
                <button type="submit" class="btn btn-success">Sign Up</button>
            </div>
        </form>
        
        <%
            if (request.getMethod().equalsIgnoreCase("POST")) {
                String username = request.getParameter("username");
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                
                Connection conn = null;
                PreparedStatement pstmt = null;
                
                try {
                    // Load MySQL JDBC Driver
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    
                    // Establish connection to the database
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ExtracurricularAchievementsDB", "root", "Vardhan@99");
                    
                    // Insert user data into the database
                    String sql = "INSERT INTO student_profiles (username, email, password) VALUES (?, ?, ?)"; // Use 'student_profiles' as the new table name
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, username);
                    pstmt.setString(2, email);
                    pstmt.setString(3, password);
                    
                    int rowsAffected = pstmt.executeUpdate();
                    if (rowsAffected > 0) {
                        // Show alert and redirect to login page
                        out.println("<script>showAlert(); window.location.href='studentLogin.jsp';</script>");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                    try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            }
        %>
        
        <p class="text-center mt-3">Already have an account? <a href="studentLogin.jsp">Login</a></p>
    </div>
</body>
</html>
