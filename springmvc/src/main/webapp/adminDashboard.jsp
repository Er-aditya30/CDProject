<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - Extracurricular Achievements Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }

        .container {
            margin-top: 30px;
        }
    </style>
</head>

<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">Admin Dashboard</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="adminLogout.jsp">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <h2 class="text-center">Manage Students</h2>

        <div class="mb-3">
            <input type="text" class="form-control" id="searchStudent" placeholder="Search for students...">
        </div>

        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Student ID</th>
                    <th>Username</th>
                    <th>Email</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    // Database connection details
                    String jdbcURL = "jdbc:mysql://localhost:3306/ExtracurricularAchievementsDB";
                    String dbUser = "root";
                    String dbPassword = "Vardhan@99";

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

                        String sql = "SELECT * FROM student_profiles";
                        PreparedStatement statement = connection.prepareStatement(sql);
                        ResultSet resultSet = statement.executeQuery();

                        // Loop through the result set to display student data
                        while (resultSet.next()) {
                            String studentId = resultSet.getString("id");
                            String username = resultSet.getString("username");
                            String email = resultSet.getString("email");
                %>
                <tr>
                    <td><%= studentId %></td>
                    <td><%= username %></td>
                    <td><%= email %></td>
                    <td>
                        <a href="viewStudentDetails.jsp?studentId=<%= studentId %>" class="btn btn-info">View Details</a>
                        <a href="editStudent.jsp?studentId=<%= studentId %>" class="btn btn-warning">Edit</a>
                        <a href="deleteStudentAction.jsp?studentId=<%= studentId %>" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this student?')">Delete</a>
                    </td>
                </tr>
                <%
                        }
                        // Close resources
                        resultSet.close();
                        statement.close();
                        connection.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                %>
            </tbody>
        </table>

        <h3 class="text-center">Add New Student</h3>
        <form action="addStudentAction.jsp" method="post">
            <div class="mb-3">
                <label for="studentUsername" class="form-label">Username</label>
                <input type="text" class="form-control" id="studentUsername" name="username" required>
            </div>
            <div class="mb-3">
                <label for="studentEmail" class="form-label">Email</label>
                <input type="email" class="form-control" id="studentEmail" name="email" required>
            </div>
            <div class="mb-3">
                <label for="studentPassword" class="form-label">Password</label>
                <input type="password" class="form-control" id="studentPassword" name="password" required>
            </div>
            <button type="submit" class="btn btn-success">Add Student</button>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>
