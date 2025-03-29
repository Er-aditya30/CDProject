<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String username = request.getParameter("username");
    int studentId = -1;
    String jdbcURL = "jdbc:mysql://localhost:3306/ExtracurricularAchievementsDB";
    String dbUser = "root";
    String dbPassword = "Vardhan@99";

    StringBuilder feedbackList = new StringBuilder();

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

        // Fetch feedback
        String feedbackSQL = "SELECT feedback_text, feedback_date FROM student_feedback WHERE student_id = ?";
        PreparedStatement feedbackStmt = connection.prepareStatement(feedbackSQL);
        feedbackStmt.setInt(1, studentId);
        ResultSet feedbackSet = feedbackStmt.executeQuery();
        
        while (feedbackSet.next()) {
            feedbackList.append("<li>")
                .append(feedbackSet.getString("feedback_text")).append("<br>")
                .append("Date: ").append(feedbackSet.getDate("feedback_date")).append("</li><br>");
        }

        // Closing resources
        feedbackSet.close();
        feedbackStmt.close();
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
    <title>View Feedback</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <h2>Your Feedback</h2>
        <ul>
            <%= feedbackList.length() == 0 ? "<li>No feedback listed.</li>" : feedbackList.toString() %>
        </ul>
        <a href="studentDashboard.jsp?username=<%= username %>" class="btn btn-secondary">Back to Dashboard</a>
    </div>
</body>
</html>
