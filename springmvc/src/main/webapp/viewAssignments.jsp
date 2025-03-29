<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String username = request.getParameter("username");
    int studentId = -1;
    String jdbcURL = "jdbc:mysql://localhost:3306/ExtracurricularAchievementsDB";
    String dbUser = "root";
    String dbPassword = "Vardhan@99";

    StringBuilder assignmentsList = new StringBuilder();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

        // Get student ID
        String sql = "SELECT id FROM student_profiles WHERE username = ?";
        PreparedStatement statement = connection.prepareStatement(sql);
        statement.setString(1, username);
        ResultSet resultSet = statement.executeQuery();

        if (resultSet.next()) {
            studentId = resultSet.getInt("id");
        }

        // Fetch assignments
        String assignmentsSQL = "SELECT assignment_title, assignment_description, due_date FROM student_assignments WHERE student_id = ?";
        PreparedStatement assignmentStmt = connection.prepareStatement(assignmentsSQL);
        assignmentStmt.setInt(1, studentId);
        ResultSet assignmentsSet = assignmentStmt.executeQuery();
        
        while (assignmentsSet.next()) {
            assignmentsList.append("<li>")
                .append("<strong>").append(assignmentsSet.getString("assignment_title")).append("</strong><br>")
                .append(assignmentsSet.getString("assignment_description")).append("<br>")
                .append("Due Date: ").append(assignmentsSet.getDate("due_date")).append("</li><br>");
        }

        // Closing resources
        assignmentsSet.close();
        assignmentStmt.close();
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
    <title>View Assignments</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <h2>Your Assignments</h2>
        <ul>
            <%= assignmentsList.length() == 0 ? "<li>No assignments listed.</li>" : assignmentsList.toString() %>
        </ul>
        <a href="studentDashboard.jsp?username=<%= username %>" class="btn btn-secondary">Back to Dashboard</a>
    </div>
</body>
</html>
