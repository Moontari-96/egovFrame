<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<footer class="footer">
  <div class="footer__inner">
    <small>&copy; <span id="year"></span> MKYSite. MoonCoperation.</small>
  </div>
  <script>
    document.getElementById("year").textContent = new Date().getFullYear();
  </script>
</footer>
</body>
</html>