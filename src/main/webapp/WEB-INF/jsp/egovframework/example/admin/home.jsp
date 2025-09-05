<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
   
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 대시보드</title>
</head>
<body>

    <div class="card">
	    <h2>
	        <c:choose>
	            <c:when test="${not empty sessionScope.adminUser}">
	                환영합니다, <c:out value="${sessionScope.adminUser.user_name}" />님!
	            </c:when>
	            <c:otherwise>
	                로그인 정보가 없습니다.
	            </c:otherwise>
	        </c:choose>
	    </h2>
	    <p>
	        <c:if test="${not empty sessionScope.adminUser}">
	            이메일: <c:out value="${sessionScope.adminUser.user_email}" />
	        </c:if>
	    </p>
	</div>
	
	<div class="card">
	    <h3>빠른 메뉴</h3>
	    <ul>
	        <li><a href="#">회원 관리</a></li>
	        <li><a href="<c:url value='/admin/user/board.do' />">게시판 관리</a></li>
	        <li><a href="#">통계 확인</a></li>
	    </ul>
	</div>

</body>
</html>
