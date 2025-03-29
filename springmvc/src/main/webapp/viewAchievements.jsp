<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String username = request.getParameter("username");
    int studentId = -1;
    String jdbcURL = "jdbc:mysql://localhost:3306/ExtracurricularAchievementsDB";
    String dbUser = "root";
    String dbPassword = "Vardhan@99";

    StringBuilder achievementsList = new StringBuilder();

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

        // Fetch achievements
        String achievementsSQL = "SELECT achievement_title, achievement_description, date_achieved FROM student_achievements WHERE student_id = ?";
        PreparedStatement achievementStmt = connection.prepareStatement(achievementsSQL);
        achievementStmt.setInt(1, studentId);
        ResultSet achievementsSet = achievementStmt.executeQuery();
        
        while (achievementsSet.next()) {
            achievementsList.append("<li>")
                .append("<strong>").append(achievementsSet.getString("achievement_title")).append("</strong><br>")
                .append(achievementsSet.getString("achievement_description")).append("<br>")
                .append("Date Achieved: ").append(achievementsSet.getDate("date_achieved")).append("</li><br>");
        }

        // Closing resources
        achievementsSet.close();
        achievementStmt.close();
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
    <title>View Achievements</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <h2>Your Achievements</h2>
        <ul>
            <%= achievementsList.length() == 0 ? "<li>No achievements listed.</li>" : achievementsList.toString() %>
        </ul>
        <a href="studentDashboard.jsp?username=<%= username %>" class="btn btn-secondary">Back to Dashboard</a>
    </div>
</body>
</html>
