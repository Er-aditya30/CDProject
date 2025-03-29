<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String username = request.getParameter("username");
    int studentId = -1;
    String jdbcURL = "jdbc:mysql://localhost:3306/ExtracurricularAchievementsDB";
    String dbUser = "root";
    String dbPassword = "Vardhan@99";

    StringBuilder eventsList = new StringBuilder();

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

        // Fetch events
        String eventsSQL = "SELECT event_title, event_description, event_date FROM student_events WHERE student_id = ?";
        PreparedStatement eventStmt = connection.prepareStatement(eventsSQL);
        eventStmt.setInt(1, studentId);
        ResultSet eventsSet = eventStmt.executeQuery();
        
        while (eventsSet.next()) {
            eventsList.append("<li>")
                .append("<strong>").append(eventsSet.getString("event_title")).append("</strong><br>")
                .append(eventsSet.getString("event_description")).append("<br>")
                .append("Event Date: ").append(eventsSet.getDate("event_date")).append("</li><br>");
        }

        // Closing resources
        eventsSet.close();
        eventStmt.close();
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
    <title>View Events</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <h2>Your Events</h2>
        <ul>
            <%= eventsList.length() == 0 ? "<li>No events listed.</li>" : eventsList.toString() %>
        </ul>
        <a href="studentDashboard.jsp?username=<%= username %>" class="btn btn-secondary">Back to Dashboard</a>
    </div>
</body>
</html>
