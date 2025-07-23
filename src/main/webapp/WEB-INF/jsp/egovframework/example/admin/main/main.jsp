<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 대시보드</title>
    <style>
        body {
            font-family: '맑은 고딕', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f6f8;
        }

        .header {
            background-color: #2c3e50;
            color: white;
            padding: 20px;
            font-size: 20px;
            font-weight: bold;
        }

        .content {
            padding: 30px;
        }

        .card {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .logout {
            float: right;
            font-size: 14px;
            color: #ecf0f1;
        }

        .logout a {
            color: #ecf0f1;
            text-decoration: none;
        }

        .logout a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <div class="header">
        관리자 대시보드
        <div class="logout">
            <a href="<c:url value='/admin/user/logout.do' />">로그아웃</a>
        </div>
    </div>

    <div class="content">
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
                <li><a href="#">게시판 관리</a></li>
                <li><a href="#">통계 확인</a></li>
            </ul>
        </div>
    </div>

</body>
</html>
