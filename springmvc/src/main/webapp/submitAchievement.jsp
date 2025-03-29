<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String username = request.getParameter("username");
    int studentId = -1;

    if (request.getMethod().equalsIgnoreCase("POST")) {
        String achievementTitle = request.getParameter("achievement_title");
        String achievementDescription = request.getParameter("achievement_description");
        String dateAchieved = request.getParameter("date_achieved");

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

            // Insert achievement into database
            String insertSQL = "INSERT INTO student_achievements (student_id, achievement_title, achievement_description, date_achieved) VALUES (?, ?, ?, ?)";
            PreparedStatement insertStmt = connection.prepareStatement(insertSQL);
            insertStmt.setInt(1, studentId);
            insertStmt.setString(2, achievementTitle);
            insertStmt.setString(3, achievementDescription);
            insertStmt.setDate(4, Date.valueOf(dateAchieved)); // Assuming date_achieved is in 'YYYY-MM-DD' format

            int rowsAffected = insertStmt.executeUpdate();
            if (rowsAffected > 0) {
                out.println("<script>alert('Achievement submitted successfully!');</script>");
            } else {
                out.println("<script>alert('Failed to submit achievement.');</script>");
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
    <title>Submit Achievement</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <h2>Submit Achievement</h2>
        <form method="post">
            <div class="mb-3">
                <label for="achievement_title" class="form-label">Achievement Title</label>
                <input type="text" class="form-control" name="achievement_title" required>
            </div>
            <div class="mb-3">
                <label for="achievement_description" class="form-label">Achievement Description</label>
                <textarea class="form-control" name="achievement_description" required></textarea>
            </div>
            <div class="mb-3">
                <label for="date_achieved" class="form-label">Date Achieved</label>
                <input type="date" class="form-control" name="date_achieved" required>
            </div>
            <button type="submit" class="btn btn-primary">Submit Achievement</button>
        </form>
        <a href="studentDashboard.jsp?username=<%= username %>" class="btn btn-secondary mt-3">Back to Dashboard</a>
    </div>
</body>
</html>
