<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Get the username from the request (e.g., from a session variable)
    String username = request.getParameter("username");
    String email = "";
    int studentId = -1;

    // Database connection details
    String jdbcURL = "jdbc:mysql://localhost:3306/ExtracurricularAchievementsDB"; // Your database name
    String dbUser = "root"; // Your database username
    String dbPassword = "Vardhan@99"; // Your database password

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
        
        // Get student ID and email
        String sql = "SELECT id, email FROM student_profiles WHERE username = ?";
        PreparedStatement statement = connection.prepareStatement(sql);
        statement.setString(1, username);
        ResultSet resultSet = statement.executeQuery();

        if (resultSet.next()) {
            studentId = resultSet.getInt("id");
            email = resultSet.getString("email");
        }

        // Closing resources
        resultSet.close();
        statement.close();
        connection.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Student Dashboard - Extracurricular Achievements Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #121212; /* Dark background for modern look */
            color: #ffffff; /* Light text color for contrast */
            font-family: Arial, sans-serif; /* Professional font */
        }

        .container {
            max-width: 800px;
            background-color: #1e1e1e; /* Slightly lighter dark for the container */
            border-radius: 10px; /* Smooth rounded corners */
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.7); /* Stronger shadow for depth */
            padding: 30px;
            margin-top: 50px;
        }

        h2 {
            font-weight: bold;
            color: #f0f0f0; /* Light gray heading */
            text-align: center;
        }

        .mb-3 {
            text-align: center;
        }

        .btn {
            border: none; /* Remove default button border */
            border-radius: 5px; /* Rounded corners for buttons */
            transition: transform 0.2s ease, box-shadow 0.2s ease; /* Smooth transition for hover effect */
            font-weight: bold;
        }

        .btn-primary {
            background-color: #0077b5; /* LinkedIn blue */
            color: #ffffff;
        }

        .btn-secondary {
            background-color: #6c757d;
            color: #ffffff;
        }

        .btn-danger {
            background-color: #e74c3c; /* Stylish red for logout */
            color: #ffffff;
        }

        .btn:hover {
            transform: scale(1.05); /* Slightly enlarge on hover */
            box-shadow: 0 5px 15px rgba(255, 255, 255, 0.2); /* Glow effect on hover */
        }

        .btn-primary:hover {
            background-color: #005fa3; /* Darker blue on hover */
        }

        .btn-secondary:hover {
            background-color: #5a6268; /* Darker gray on hover */
        }

        .module-card {
            background-color: #2a2a2a; /* Dark card color for consistency */
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.5); /* Shadow to give depth */
            padding: 20px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            transition: all 0.2s ease-in-out;
        }

        .module-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
        }

        .module-icon {
            font-size: 3em;
            margin-right: 20px;
            color: #0077b5; /* Matching LinkedIn blue */
        }

        .text-center {
            text-align: center;
        }

    </style>
</head>

<body>
    <div class="container">
        <h2>Welcome, <%= username %>!</h2>
        <div class="mb-3">
            <strong>Email:</strong> <%= email %>
        </div>

        <!-- Profile Module -->
        <div class="module-card">
            <i class="fas fa-user module-icon"></i>
            <div>
                <a href="studentProfile.jsp?username=<%= username %>" class="btn btn-primary">View Profile</a>
            </div>
        </div>

        <!-- Submit/View Achievements Module -->
        <div class="module-card">
            <i class="fas fa-trophy module-icon"></i>
            <div>
                <a href="submitAchievement.jsp?username=<%= username %>" class="btn btn-primary">Submit Achievement</a>
                <a href="viewAchievements.jsp?username=<%= username %>" class="btn btn-secondary">View Achievements</a>
            </div>
        </div>

        <!-- Submit/View Events Module -->
        <div class="module-card">
            <i class="fas fa-calendar-alt module-icon"></i>
            <div>
                <a href="submitEvent.jsp?username=<%= username %>" class="btn btn-primary">Submit Event</a>
                <a href="viewEvents.jsp?username=<%= username %>" class="btn btn-secondary">View Events</a>
            </div>
        </div>

        <!-- Submit/View Assignments Module -->
        <div class="module-card">
            <i class="fas fa-book module-icon"></i>
            <div>
                <a href="submitAssignment.jsp?username=<%= username %>" class="btn btn-primary">Submit Assignment</a>
                <a href="viewAssignments.jsp?username=<%= username %>" class="btn btn-secondary">View Assignments</a>
            </div>
        </div>

        <!-- Submit/View Feedback Module -->
        <div class="module-card">
            <i class="fas fa-comments module-icon"></i>
            <div>
                <a href="submitFeedback.jsp?username=<%= username %>" class="btn btn-primary">Submit Feedback</a>
                <a href="viewFeedback.jsp?username=<%= username %>" class="btn btn-secondary">View Feedback</a>
            </div>
        </div>

        <!-- View All Submissions Module -->
        <div class="module-card">
            <i class="fas fa-folder-open module-icon"></i>
            <div>
                <a href="viewAllSubmissions.jsp?username=<%= username %>" class="btn btn-primary">View All Submissions</a>
            </div>
        </div>

        <!-- Submit/View Certifications Module -->
        <div class="module-card">
            <i class="fas fa-certificate module-icon"></i>
            <div>
                <a href="submitCertification.jsp?username=<%= username %>" class="btn btn-primary">Submit Certification</a>
                <a href="viewCertifications.jsp?username=<%= username %>" class="btn btn-secondary">View Certifications</a>
            </div>
        </div>

        <!-- Submit/View Articles Module -->
        <div class="module-card">
            <i class="fas fa-file-alt module-icon"></i>
            <div>
                <a href="submitArticle.jsp?username=<%= username %>" class="btn btn-primary">Submit Article</a>
                <a href="viewArticles.jsp?username=<%= username %>" class="btn btn-secondary">View Articles</a>
            </div>
        </div>

        <!-- Logout -->
        <div class="text-center">
            <a href="logout.jsp" class="btn btn-danger">Logout</a>
        </div>
    </div>

    <!-- Bootstrap and FontAwesome scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
</body>

</html>
