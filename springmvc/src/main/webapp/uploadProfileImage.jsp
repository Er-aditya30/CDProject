<%@ page import="java.io.*, javax.servlet.*, javax.servlet.http.*, java.sql.*, java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.apache.commons.fileupload.*, org.apache.commons.fileupload.disk.*, org.apache.commons.fileupload.servlet.*, org.apache.commons.fileupload.FileItem" %>

<%
    String username = request.getParameter("username");
    String message = "";

    // Database connection details
    String jdbcURL = "jdbc:mysql://localhost:3306/ExtracurricularAchievementsDB"; // Your database name
    String dbUser = "root"; // Your database username
    String dbPassword = "Vardhan@99"; // Your database password

    // Directory where the uploaded files will be saved
    String uploadPath = application.getRealPath("/") + "uploads"; // Ensure this directory exists

    try {
        // Check if the upload directory exists; if not, create it
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        // Process the uploaded file
        if (ServletFileUpload.isMultipartContent(request)) {
            DiskFileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);
            List<FileItem> items = upload.parseRequest(request);

            for (FileItem item : items) {
                if (!item.isFormField()) {
                    String fileName = new File(item.getName()).getName();
                    String filePath = uploadPath + File.separator + fileName;
                    File storeFile = new File(filePath);

                    // Save the file on disk
                    item.write(storeFile);
                    
                    // Update the profile image path in the database
                    Connection connection = null;
                    PreparedStatement statement = null;

                    try {
                        // Establish database connection
                        Class.forName("com.mysql.cj.jdbc.Driver"); // Load the MySQL JDBC driver
                        connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
                        
                        // Update SQL statement to save the relative path
                        String sql = "UPDATE student_profiles SET profile_image = ? WHERE username = ?";
                        statement = connection.prepareStatement(sql);
                        statement.setString(1, "uploads/" + fileName); // Relative path
                        statement.setString(2, username);
                        statement.executeUpdate();
                        message = "Image uploaded successfully!";
                    } catch (SQLException e) {
                        message = "Database error: " + e.getMessage();
                        e.printStackTrace();
                    } catch (ClassNotFoundException e) {
                        message = "JDBC Driver not found: " + e.getMessage();
                        e.printStackTrace();
                    } finally {
                        // Close database resources
                        if (statement != null) statement.close();
                        if (connection != null) connection.close();
                    }
                }
            }
        } else {
            message = "This request does not contain upload data.";
        }
    } catch (Exception e) {
        message = "Upload failed: " + e.getMessage();
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Upload Profile Image</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>Upload Profile Image</h2>
        <form action="uploadProfileImage.jsp?username=<%= username %>" method="post" enctype="multipart/form-data">
            <div class="mb-3">
                <label for="fileUpload" class="form-label">Choose an image to upload:</label>
                <input type="file" class="form-control" id="fileUpload" name="fileUpload" required>
            </div>
            <button type="submit" class="btn btn-primary">Upload</button>
        </form>
        <div class="mt-3">
            <p><%= message %></p>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
