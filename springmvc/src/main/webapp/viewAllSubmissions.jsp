<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Create a map to hold usernames and their corresponding achievements
    Map<String, List<String>> achievementsMap = new HashMap<>();
    String jdbcURL = "jdbc:mysql://localhost:3306/ExtracurricularAchievementsDB"; // Your database name
    String dbUser = "root"; // Your database username
    String dbPassword = "Vardhan@99"; // Your database password

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

        // Fetch all achievements including certification images and titles
        String sql = "SELECT a.achievement_title, a.achievement_description, a.date_achieved, s.username, " +
                     "c.certification_title, c.certification_image " +
                     "FROM student_achievements a " +
                     "JOIN student_profiles s ON a.student_id = s.id " +
                     "LEFT JOIN student_certifications c ON a.student_id = c.student_id " +
                     "ORDER BY s.username, a.date_achieved DESC"; // Order by username and achievement date

        PreparedStatement statement = connection.prepareStatement(sql);
        ResultSet resultSet = statement.executeQuery();

        // Populate the achievementsMap
        while (resultSet.next()) {
            String title = resultSet.getString("achievement_title");
            String description = resultSet.getString("achievement_description");
            java.sql.Date dateAchieved = resultSet.getDate("date_achieved");
            String studentUsername = resultSet.getString("username");
            String certificationTitle = resultSet.getString("certification_title");
            Blob certificationImageBlob = resultSet.getBlob("certification_image");

            // Format date if needed
            String formattedDate = new SimpleDateFormat("yyyy-MM-dd").format(dateAchieved);

            // Prepare the achievement string
            String achievement = "<strong class='achievement-title'>" + title + "</strong>" + 
                                 (description != null && !description.isEmpty() ? " - <span class='achievement-description'>" + description + "</span>" : "") + 
                                 " <span class='text-muted'>(Achieved on: " + formattedDate + ")</span>";

            // Add the achievement to the map
            if (!achievementsMap.containsKey(studentUsername)) {
                achievementsMap.put(studentUsername, new ArrayList<String>());
            }
            achievementsMap.get(studentUsername).add(achievement);

            // If a certification was uploaded, add its title and image
            if (certificationTitle != null && certificationImageBlob != null) {
                // Convert Blob to byte array for image rendering
                byte[] imageBytes = certificationImageBlob.getBytes(1, (int) certificationImageBlob.length());
                String imageBase64 = Base64.getEncoder().encodeToString(imageBytes);
                String imageTag = "<img src='data:image/png;base64," + imageBase64 + "' class='certification-image' />"; // Adjusted for larger size
                
                // Add certification title and image to achievements
                String certificationInfo = "<strong class='certification-title'>Certification:</strong> " + certificationTitle + " " + imageTag;
                achievementsMap.get(studentUsername).add(certificationInfo);
            }
        }

        // Close resources
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
    <title>All Achievements</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(to right, #e0f7fa, #b2ebf2); /* Light aqua gradient background */
            color: #333; /* Darker text for better contrast */
            font-family: Arial, sans-serif; /* Set a clean font */
        }
        .container {
            max-width: 800px; /* Max width for better layout */
            margin: 0 auto; /* Center the container */
            padding: 20px; /* Padding for spacing */
            border-radius: 10px; /* Rounded corners for the container */
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* Soft shadow */
        }
        .list-group-item {
            background-color: #ffffff; /* White for list items */
            color: #333; /* Dark text */
            border: 1px solid #ddd; /* Light border */
            border-radius: 5px; /* Rounded corners */
            margin-bottom: 10px; /* Space between items */
            padding: 15px; /* Padding for a more spacious look */
            transition: transform 0.3s, box-shadow 0.3s; /* Smooth transition for hover effect */
        }
        .list-group-item:hover {
            transform: translateY(-5px); /* Lift effect */
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2); /* Shadow on hover */
        }
        h2 {
            color: #ffcc00; /* Gold color for headings */
            text-align: center; /* Center align heading */
            margin-bottom: 20px; /* Space below heading */
        }
        a.btn {
            color: #fff; /* White text color for buttons */
            background-color: #007bff; /* Bootstrap primary color */
            border-radius: 5px; /* Rounded corners for buttons */
            margin-top: 20px; /* Space above button */
            display: block; /* Make button take full width */
            text-align: center; /* Center button text */
            text-decoration: none; /* Remove underline */
        }
        /* Custom styles for achievement and certification fields */
        .achievement-title {
            font-weight: bold; /* Bold titles */
            color: #ffcc00; /* Gold color for titles */
            font-size: 1.3rem; /* Larger font size for titles */
        }
        .achievement-description {
            color: #666; /* Darker gray for descriptions */
            font-style: italic; /* Italicize descriptions */
        }
        .certification-image {
            max-width: 300px; /* Increased max width for certification images */
            height: auto; /* Maintain aspect ratio */
            margin-left: 10px; /* Space between text and image */
            border-radius: 5px; /* Rounded corners for images */
            border: 2px solid #007bff; /* Add a border to images */
            transition: transform 0.3s; /* Smooth transform effect */
        }
        .certification-image:hover {
            transform: scale(1.1); /* Zoom effect on hover */
        }
        .certification-title {
            font-weight: bold; /* Bold certification title */
            color: #66ff66; /* Light green for certification title */
        }
        .text-muted {
            color: #999; /* Muted color for the date */
        }
        @media (max-width: 600px) {
            .certification-image {
                max-width: 100%; /* Full width for smaller screens */
            }
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <h2>All Achievements</h2>
        <div class="list-group">
            <%
                // Iterate over the map to display achievements grouped by username
                for (Map.Entry<String, List<String>> entry : achievementsMap.entrySet()) {
                    String username = entry.getKey();
                    List<String> userAchievements = entry.getValue();

                    // Display the username as a heading
            %>
                <h5 class="list-group-item list-group-item-action active"><%= username %></h5>
            <%
                    // Display each achievement for the user
                    for (String achievement : userAchievements) {
            %>
                <li class="list-group-item"><%= achievement %></li>
            <%
                    }
                }
            %>
        </div>
        <a href="studentDashboard.jsp?username=<%= request.getParameter("username") %>" class="btn btn-secondary">Back to Dashboard</a>
    </div>
</body>
</html>
