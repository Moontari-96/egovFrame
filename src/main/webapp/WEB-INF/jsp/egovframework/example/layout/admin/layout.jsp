<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><c:out value="${pageTitle != null ? pageTitle : '관리자 대시보드'}" /></title>
    <link rel="stylesheet" href="<c:url value='/css/egovframework/layout.css'/>">
</head>
<body>

    <!-- 상단 헤더 -->
    <div class="header">
        관리자 대시보드
        <div class="logout">
            <a href="<c:url value='/admin/user/logout.do' />">로그아웃</a>
        </div>
    </div>

    <!-- 좌측 메뉴 + 본문 -->
    <div class="container">
        <!-- 사이드 메뉴 -->
        <jsp:include page="/WEB-INF/jsp/egovframework/example/admin/menu.jsp" />

        <!-- 메인 컨텐츠 -->
        <div class="content">
            <jsp:include page="${contentPage}" />
        </div>
    </div>

</body>
</html>
