<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 이동</title>
</head>
<body>

<!-- 방법 1: form 사용 -->
<form action="${pageContext.request.contextPath}/admin/home.do" method="get">
    <button type="submit">관리자 홈으로 이동 (form)</button>
</form>

<!-- 방법 2: JS 사용 -->
<button onclick="location.href='${pageContext.request.contextPath}/admin/home.do'">
    관리자 홈으로 이동 (JS)
</button>
<button onclick="location.href='<c:url value='/join.do'/>'">
    회원가입
</button>
<button onclick="location.href='<c:url value='/login.do'/>'">
    로그인
</button>

</body>
</html>
