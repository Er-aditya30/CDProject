<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String username = request.getParameter("username");
    String message = request.getParameter("message");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Submit Certification</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>Submit Certification</h2>
        <form action="${pageContext.request.contextPath}/submitCertificationServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="username" value="<%= username %>">
            <div class="mb-3">
                <label for="certificationName" class="form-label">Certification Name</label>
                <input type="text" class="form-control" id="certificationName" name="certificationName" required>
            </div>
            <div class="mb-3">
                <label for="fileName" class="form-label">Upload Certificate (Image)</label>
                <input type="file" class="form-control" id="fileName" name="fileName" accept="image/*" required>
            </div>
            <button type="submit" class="btn btn-primary">Submit Certification</button>
        </form>
        <div class="alert alert-success" style="<%= message == null ? "display:none;" : "" %>">
            <%= message %>
        </div>
        <div class="alert alert-danger" style="<%= error == null ? "display:none;" : "" %>">
            <%= error %>
        </div>
    </div>
</body>
</html>
