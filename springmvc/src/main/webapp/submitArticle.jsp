<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String username = request.getParameter("username");
    int studentId = -1;

    if (request.getMethod().equalsIgnoreCase("POST")) {
        String articleTitle = request.getParameter("article_title");
        String articleContent = request.getParameter("article_content");
        String datePublished = request.getParameter("date_published");

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

            // Insert article into database
            String insertSQL = "INSERT INTO student_articles (student_id, article_title, article_content, date_published) VALUES (?, ?, ?, ?)";
            PreparedStatement insertStmt = connection.prepareStatement(insertSQL);
            insertStmt.setInt(1, studentId);
            insertStmt.setString(2, articleTitle);
            insertStmt.setString(3, articleContent);
            insertStmt.setDate(4, Date.valueOf(datePublished)); // Assuming date_published is in 'YYYY-MM-DD' format

            int rowsAffected = insertStmt.executeUpdate();
            if (rowsAffected > 0) {
                out.println("<script>alert('Article submitted successfully!');</script>");
            } else {
                out.println("<script>alert('Failed to submit article.');</script>");
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
    <title>Submit Article</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <h2>Submit Article</h2>
        <form method="post">
            <div class="mb-3">
                <label for="article_title" class="form-label">Article Title</label>
                <input type="text" class="form-control" name="article_title" required>
            </div>
            <div class="mb-3">
                <label for="article_content" class="form-label">Article Content</label>
                <textarea class="form-control" name="article_content" required></textarea>
            </div>
            <div class="mb-3">
                <label for="date_published" class="form-label">Date Published</label>
                <input type="date" class="form-control" name="date_published" required>
            </div>
            <button type="submit" class="btn btn-primary">Submit Article</button>
        </form>
        <a href="studentDashboard.jsp?username=<%= username %>" class="btn btn-secondary mt-3">Back to Dashboard</a>
    </div>
</body>
</html>
