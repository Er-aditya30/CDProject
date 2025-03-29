package Servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/submitCertificationServlet")
@MultipartConfig
public class SubmitCertificationServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String certificationName = request.getParameter("certificationName");
        Part filePart = request.getPart("fileName"); // Retrieve the file part
        String fileName = filePart.getSubmittedFileName(); // Get the file name

        // Database connection details
        String jdbcURL = "jdbc:mysql://localhost:3306/ExtracurricularAchievementsDB";
        String dbUser = "root";
        String dbPassword = "Vardhan@99";

        // Set a valid upload directory path
        String uploadPath = "C:/uploads/"; // Change this to your valid path
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs(); // Create the directory if it doesn't exist
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

            // Fetch student_id based on the username
            int studentId = fetchStudentIdByUsername(connection, username);

            // Check if studentId is valid
            if (studentId == -1) {
                throw new Exception("Student ID not found for username: " + username);
            }

            String sql = "INSERT INTO student_certifications (student_id, certification_title, certification_image) VALUES (?, ?, ?)";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, studentId);
            statement.setString(2, certificationName);
            statement.setBlob(3, filePart.getInputStream()); // Save the file as a BLOB in the database
            statement.executeUpdate();

            // Save the uploaded file to the server
            String fullPath = uploadPath + fileName; // Full path for the uploaded file
            filePart.write(fullPath); // Write the file to the specified directory

            statement.close();
            connection.close();
            
            // Redirect to viewCertification.jsp after successful submission
            response.sendRedirect("viewCertification.jsp?username=" + username + "&message=Certification submitted successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("submitCertification.jsp?username=" + username + "&error=" + e.getMessage());
        }
    }

    private int fetchStudentIdByUsername(Connection connection, String username) {
        int studentId = -1; // Default value if not found
        String query = "SELECT id FROM student_profiles WHERE username = ?";
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, username);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                studentId = resultSet.getInt("id"); // Get student_id
            }
            preparedStatement.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return studentId;
    }
}
