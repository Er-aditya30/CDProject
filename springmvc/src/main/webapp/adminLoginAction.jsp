<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String adminUsername = request.getParameter("username");
    String adminPassword = request.getParameter("password");

    // Predefined default credentials
    String defaultAdminUsername = "admin@gmail.com";
    String defaultAdminPassword = "admin123";

    // Check if the entered credentials match the predefined ones
    if (defaultAdminUsername.equals(adminUsername) && defaultAdminPassword.equals(adminPassword)) {
        // Redirect to admin dashboard if credentials are correct
        response.sendRedirect("adminDashboard.jsp");
    } else {
        // Invalid login, redirect back with an error message
        session.setAttribute("errorMessage", "Invalid username or password");
        response.sendRedirect("adminLogin.jsp");
    }
%>
