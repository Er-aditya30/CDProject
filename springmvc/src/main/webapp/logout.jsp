<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Invalidate the current session
    session.invalidate();
    response.sendRedirect("studentLogin.jsp"); // Redirect to login page
%>
