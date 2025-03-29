<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String username = request.getParameter("username");
    int studentId = -1;

    if (request.getMethod().equalsIgnoreCase("POST")) {
        String assignmentTitle = request.getParameter("assignment_title");
        String assignmentDescription = request.getParameter("assignment_description");
        String dueDate = request.getParameter("due_date");

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

            // Insert assignment into database
            String insertSQL = "INSERT INTO student_assignments (student_id, assignment_title, assignment_description, due_date) VALUES (?, ?, ?, ?)";
            PreparedStatement insertStmt = connection.prepareStatement(insertSQL);
            insertStmt.setInt(1, studentId);
            insertStmt.setString(2, assignmentTitle);
            insertStmt.setString(3, assignmentDescription);
            insertStmt.setDate(4, Date.valueOf(dueDate)); // Assuming due_date is in 'YYYY-MM-DD' format

            int rowsAffected = insertStmt.executeUpdate();
            if (rowsAffected > 0) {
                out.println("<script>alert('Assignment submitted successfully!');</script>");
            } else {
                out.println("<script>alert('Failed to submit assignment.');</script>");
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
    <title>Submit Assignment</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <h2>Submit Assignment</h2>
        <form method="post">
            <div class="mb-3">
                <label for="assignment_title" class="form-label">Assignment Title</label>
                <input type="text" class="form-control" name="assignment_title" required>
            </div>
            <div class="mb-3">
                <label for="assignment_description" class="form-label">Assignment Description</label>
                <textarea class="form-control" name="assignment_description" required></textarea>
            </div>
            <div class="mb-3">
                <label for="due_date" class="form-label">Due Date</label>
                <input type="date" class="form-control" name="due_date" required>
            </div>
            <button type="submit" class="btn btn-primary">Submit Assignment</button>
        </form>
        <a href="studentDashboard.jsp?username=<%= username %>" class="btn btn-secondary mt-3">Back to Dashboard</a>
    </div>
</body>
</html>
