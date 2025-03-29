<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String username = request.getParameter("username");
    int studentId = -1;

    if (request.getMethod().equalsIgnoreCase("POST")) {
        String feedbackContent = request.getParameter("feedback_content");

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

            // Insert feedback into database
            String insertSQL = "INSERT INTO student_feedback (student_id, feedback_content) VALUES (?, ?)";
            PreparedStatement insertStmt = connection.prepareStatement(insertSQL);
            insertStmt.setInt(1, studentId);
            insertStmt.setString(2, feedbackContent);

            int rowsAffected = insertStmt.executeUpdate();
            if (rowsAffected > 0) {
                out.println("<script>alert('Feedback submitted successfully!');</script>");
            } else {
                out.println("<script>alert('Failed to submit feedback.');</script>");
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
    <title>Submit Feedback</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <h2>Submit Feedback</h2>
        <form method="post">
            <div class="mb-3">
                <label for="feedback_content" class="form-label">Feedback Content</label>
                <textarea class="form-control" name="feedback_content" required></textarea>
            </div>
            <button type="submit" class="btn btn-primary">Submit Feedback</button>
        </form>
        <a href="studentDashboard.jsp?username=<%= username %>" class="btn btn-secondary mt-3">Back to Dashboard</a>
    </div>
</body>
</html>
