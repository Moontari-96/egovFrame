<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 대시보드</title>
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
		
		/* 사이드바 */
		.sidebar {
		    width: 240px;
		    background-color: #1f2a38;
		    color: #fff;
		    padding: 20px;
		    flex-shrink: 0;
		}
		
		.sidebar h3 {
		    font-size: 18px;
		    margin-bottom: 20px;
		    border-bottom: 1px solid #2e3b4e;
		    padding-bottom: 10px;
		}
		
		.menu-tree {
		    list-style: none;
		}
		
		.menu-tree > li {
		    margin-bottom: 10px;
		}
		
		.menu-tree li span {
		    font-weight: bold;
		    display: block;
		    padding: 8px;
		    border-radius: 5px;
		    cursor: default;
		}
		
		.menu-tree li a {
		    display: block;
		    padding: 6px 12px;
		    margin-top: 2px;
		    color: #cfd8dc;
		    text-decoration: none;
		    border-radius: 5px;
		    font-size: 14px;
		}
		
		.menu-tree li a:hover {
		    background-color: #2e3b4e;
		    color: #fff;
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

    <div class="header">
        관리자 대시보드
        <div class="logout">
            <a href="<c:url value='/admin/user/logout.do' />">로그아웃</a>
        </div>
    </div>
    <div class="container">
 <div class="sidebar">
        <h3>메뉴</h3>
        <ul class="menu-tree">
            <c:forEach var="m1" items="${menuList}">
                <c:if test="${m1.parentId == null}">
                    <li>
                        <span>${m1.menuName}</span>
                        <ul>
                            <c:forEach var="m2" items="${menuList}">
                                <c:if test="${m2.parentId == m1.menuId}">
                                    <li>
                                        <a href="${m2.menuUrl}">${m2.menuName}</a>
                                    </li>
                                </c:if>
                            </c:forEach>
                        </ul>
                    </li>
                </c:if>
            </c:forEach>
        </ul>
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
                <li><a href="<c:url value='/admin/user/board.do' />">게시판 관리</a></li>
                <li><a href="#">통계 확인</a></li>
            </ul>
        </div>
    </div>
</div>
</body>
</html>
