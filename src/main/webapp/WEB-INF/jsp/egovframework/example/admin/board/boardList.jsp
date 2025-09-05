<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 목록</title>
<style>
    /* 카드 */
	.card {
	    background-color: #fff;
	    padding: 25px;
	    border-radius: 12px;
	    box-shadow: 0 4px 12px rgba(0,0,0,0.08);
	    margin-bottom: 20px;
	}
	
	/* 게시판 테이블 */
	table.board-table {
	    width: 100%;
	    border-collapse: collapse;
	}
	
	table.board-table thead {
	    background: #f0f4f9;
	}
	
	table.board-table th,
	table.board-table td {
	    padding: 12px 14px;
	    text-align: center;
	    font-size: 14px;
	    border-bottom: 1px solid #e5e8eb;
	}
	
	table.board-table th {
	    font-weight: 600;
	    color: #333;
	}
	
	table.board-table tr:hover td {
	    background: #f9fcff;
	}
	
	/* 버튼 */
	.board-actions {
	    margin-top: 20px;
	    text-align: right;
	}
	
	.board-actions a {
	    display: inline-block;
	    padding: 10px 16px;
	    background: #4dabf7;
	    color: #fff;
	    text-decoration: none;
	    border-radius: 6px;
	    font-size: 14px;
	    font-weight: bold;
	    transition: background 0.2s ease;
	}
	
	.board-actions a:hover {
	    background: #339af0;
	}
	
	td a {
	    color: #000;
    	text-decoration: none;
  	    cursor: pointer;
	}

</style>
</head>
<body>
<div class="card">
    <h2>${postList[0].board_nm} 게시판</h2>
    <table class="board-table">
        <thead>
            <tr>
                <th>No</th>
                <th>제목</th>
                <th>작성자</th>
                <th>등록일</th>
                <th>조회수</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="post" items="${postList}" varStatus="status">
                <tr>
                    <td>${status.count}</td>
                    <td style="text-align:left;">
                        <a href="<c:url value='/admin/board/view.do?postId=${post.post_id}'/>">
                            ${post.title}
                        </a>
                    </td>
                    <td>${post.created_by_id}</td>
                    <td>${post.created_at}</td>
                    <td>${post.views}</td>
                </tr>
            </c:forEach>

            <c:if test="${empty postList}">
                <tr>
                    <td colspan="5">등록된 게시글이 없습니다.</td>
                </tr>
            </c:if>
        </tbody>
    </table>

    <div class="board-actions">
        <a href="<c:url value='/admin/board/write.do'/>">글쓰기</a>
    </div>
</div>
</body>
</html>
