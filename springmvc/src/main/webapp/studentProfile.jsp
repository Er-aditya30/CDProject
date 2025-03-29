<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String username = request.getParameter("username");
    String email = "";
    String imagePath = "";

    // Database connection details
    String jdbcURL = "jdbc:mysql://localhost:3306/ExtracurricularAchievementsDB"; // Your database name
    String dbUser = "root"; // Your database username
    String dbPassword = "Vardhan@99"; // Your database password

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
        
        // Get student details including profile image
        String sql = "SELECT email, profile_image FROM student_profiles WHERE username = ?";
        PreparedStatement statement = connection.prepareStatement(sql);
        statement.setString(1, username);
        ResultSet resultSet = statement.executeQuery();

        if (resultSet.next()) {
            email = resultSet.getString("email");
            imagePath = resultSet.getString("profile_image");
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
    <title>Student Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: black; /* Set black background for the page */
            color: white; /* Set text color to white for better contrast */
        }

        .profile-card {
            background-color: #333; /* Darker background for the profile card */
            border-radius: 10px; /* Rounded corners */
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.5); /* Subtle shadow */
            margin: 20px auto; /* Center the card */
            max-width: 500px; /* Max width for the card */
            padding: 20px;
            text-align: center; /* Center text in the card */
        }

        .profile-image {
            width: 150px;
            height: 150px;
            border-radius: 50%; /* Circular image */
            object-fit: cover; /* Maintain aspect ratio */
            border: 2px solid #0077b5; /* Optional border */
        }

        .btn-primary {
            margin-top: 10px; /* Spacing above button */
        }
    </style>
</head>

<body>
    <div class="container">
        <div class="profile-card">
            <h2>Profile of <%= username %></h2>
            <% if (imagePath != null && !imagePath.isEmpty()) { %>
                <img src="<%= imagePath %>" alt="Profile Image" class="profile-image">
            <% } else { %>
                <img src="default-profile.png" alt="Default Profile Image" class="profile-image"> <!-- Default image if none uploaded -->
            <% } %>
            <div class="mb-3">
                <strong>Email:</strong> <%= email %>
            </div>
            <a href="uploadProfileImage.jsp?username=<%= username %>" class="btn btn-primary">Upload New Image</a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>
