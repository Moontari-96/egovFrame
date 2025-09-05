<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><c:out value="${pageTitle != null ? pageTitle : '관리자 대시보드'}" /></title>
    <link rel="stylesheet" href="<c:url value='/css/layout.css'/>">
    <style>
       /* 기본 리셋 */
       * {
           box-sizing: border-box;
           margin: 0;
           padding: 0;
       }

       body {
           font-family: 'Segoe UI', '맑은 고딕', sans-serif;
           background-color: #f0f2f5;
           color: #333;
       }

       /* 레이아웃 */
       .container {
           display: flex;
           min-height: 100vh;
       }

       /* 콘텐츠 */
       .content {
           flex: 1;
           padding: 30px;
           background-color: #f0f2f5;
       }

       /* 카드 */
       .card {
           background-color: #fff;
           padding: 25px;
           border-radius: 12px;
           box-shadow: 0 4px 12px rgba(0,0,0,0.08);
           margin-bottom: 20px;
       }

       /* 헤더 */
       .header {
           width: 100%;
           background-color: #1f2a38;
           color: #fff;
           padding: 20px 30px;
           font-size: 20px;
           font-weight: bold;
           display: flex;
           justify-content: space-between;
           align-items: center;
       }

       .logout a {
           color: #cfd8dc;
           text-decoration: none;
           font-size: 14px;
       }

       .logout a:hover {
           color: #fff;
       }
    </style>
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
