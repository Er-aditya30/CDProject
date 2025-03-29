<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String username = request.getParameter("username");
    int studentId = -1;

    if (request.getMethod().equalsIgnoreCase("POST")) {
        String eventTitle = request.getParameter("event_title");
        String eventDescription = request.getParameter("event_description");
        String eventDate = request.getParameter("event_date");

        String jdbcURL = "jdbc:mysql://localhost:3306/ExtracurricularAchievementsDB"; // Your database name
        String dbUser = "root"; // Your database username
        String dbPassword = "Vardhan@99"; // Your database password

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

            // Insert event into database
            String insertSQL = "INSERT INTO student_events (student_id, event_title, event_description, event_date) VALUES (?, ?, ?, ?)";
            PreparedStatement insertStmt = connection.prepareStatement(insertSQL);
            insertStmt.setInt(1, studentId);
            insertStmt.setString(2, eventTitle);
            insertStmt.setString(3, eventDescription);
            insertStmt.setDate(4, Date.valueOf(eventDate)); // Assuming event_date is in 'YYYY-MM-DD' format

            int rowsAffected = insertStmt.executeUpdate();
            if (rowsAffected > 0) {
                out.println("<script>alert('Event submitted successfully!');</script>");
            } else {
                out.println("<script>alert('Failed to submit event.');</script>");
            }

            // Closing resources
            insertStmt.close();
            resultSet.close();
            statement.close();
            connection.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Submit Event</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <h2>Submit Event</h2>
        <form method="post">
            <div class="mb-3">
                <label for="event_title" class="form-label">Event Title</label>
                <input type="text" class="form-control" name="event_title" required>
            </div>
            <div class="mb-3">
                <label for="event_description" class="form-label">Event Description</label>
                <textarea class="form-control" name="event_description" required></textarea>
            </div>
            <div class="mb-3">
                <label for="event_date" class="form-label">Event Date</label>
                <input type="date" class="form-control" name="event_date" required>
            </div>
            <button type="submit" class="btn btn-primary">Submit Event</button>
        </form>
        <a href="studentDashboard.jsp?username=<%= username %>" class="btn btn-secondary mt-3">Back to Dashboard</a>
    </div>
</body>
</html>
