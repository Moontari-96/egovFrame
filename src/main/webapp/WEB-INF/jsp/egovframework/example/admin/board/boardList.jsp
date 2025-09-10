<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${pageTitle}</title>
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
    table.board-table { width: 100%; border-collapse: collapse; }
    table.board-table thead { background: #f0f4f9; }
    table.board-table th, table.board-table td {
        padding: 12px 14px; text-align: center; font-size: 14px; border-bottom: 1px solid #e5e8eb;
    }
    table.board-table th { font-weight: 600; color: #333; }
    table.board-table tr:hover td { background: #f9fcff; }

    /* 버튼 */
    .board-actions { margin-top: 20px; text-align: right; }
    .board-actions a {
        display: inline-block; padding: 10px 16px; background: #4dabf7; color: #fff;
        text-decoration: none; border-radius: 6px; font-size: 14px; font-weight: bold; transition: background 0.2s ease;
    }
    .board-actions a:hover { background: #339af0; }
    td a { color: #000; text-decoration: none; cursor: pointer; }

    /* 페이징 */
    .pagination { margin-top: 20px; display: flex; justify-content: center; gap: 6px; flex-wrap: wrap; }
    .pagination a, .pagination span {
        display: inline-block; min-width: 36px; padding: 8px 10px; text-align: center;
        border: 1px solid #e5e8eb; border-radius: 6px; color: #333; text-decoration: none; font-size: 14px;
    }
    .pagination a:hover { background: #f5f8ff; }
    .pagination .active { background: #4dabf7; color: #fff; border-color: #4dabf7; }
    .pagination .disabled { color: #bbb; border-color: #eee; pointer-events: none; background: #fafafa; }
</style>
</head>
<body>

<%-- 모델(boardId) 우선, 없으면 param, 리스트 순으로 해석 --%>
<c:set var="boardIdResolved"
       value="${not empty boardId ? boardId
                : (not empty param.boardId ? param.boardId
                   : (empty postList ? '' : postList[0].board_id))}" />

<div class="card">
    <h2>${pageTitle}</h2>

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
            <c:choose>
                <c:when test="${not empty postList}">
                    <c:forEach var="post" items="${postList}" varStatus="s">
                        <tr>
                            <td>${rowNoStart - s.index}</td>
                            <td style="text-align:left;">
                                <a href="<c:url value='/admin/board/view.do'>
                                            <c:param name='postId' value='${post.post_id}'/>
                                         </c:url>">
                                    ${post.title}
                                </a>
                            </td>
                            <td>${post.created_by_id}</td>
                            <td class="date-cell" data-date="${post.created_at}"></td>
                            <td>${post.views}</td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="5">등록된 게시글이 없습니다.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <%-- 페이징 네비게이션 --%>
    <div class="pagination">
        <%-- 맨앞 --%>
        <c:choose>
            <c:when test="${page > 1}">
                <a href="<c:url value='/admin/board/${boardIdResolved}.do'>
                           <c:param name='page' value='1'/>
                           <c:param name='size' value='${size}'/>
                         </c:url>">« </a>
            </c:when>
            <c:otherwise><span class="disabled">« </span></c:otherwise>
        </c:choose>

        <%-- 이전 블록 --%>
        <c:set var="prevBlockPage" value="${startPage - 1}" />
        <c:choose>
            <c:when test="${prevBlockPage >= 1}">
                <a href="<c:url value='/admin/board/${boardIdResolved}.do'>
                           <c:param name='page' value='${prevBlockPage}'/>
                           <c:param name='size' value='${size}'/>
                         </c:url>">‹ </a>
            </c:when>
            <c:otherwise><span class="disabled">‹ </span></c:otherwise>
        </c:choose>

        <%-- 페이지 번호 (startPage ~ endPage) --%>
        <c:forEach var="p" begin="${startPage}" end="${endPage}">
            <c:choose>
                <c:when test="${p == page}">
                    <span class="active">${p}</span>
                </c:when>
                <c:otherwise>
                    <a href="<c:url value='/admin/board/${boardIdResolved}.do'>
                               <c:param name='page' value='${p}'/>
                               <c:param name='size' value='${size}'/>
                             </c:url>">${p}</a>
                </c:otherwise>
            </c:choose>
        </c:forEach>

        <%-- 다음 블록 --%>
        <c:set var="nextBlockPage" value="${endPage + 1}" />
        <c:choose>
            <c:when test="${nextBlockPage <= totalPages}">
                <a href="<c:url value='/admin/board/${boardIdResolved}.do'>
                           <c:param name='page' value='${nextBlockPage}'/>
                           <c:param name='size' value='${size}'/>
                         </c:url>"> ›</a>
            </c:when>
            <c:otherwise><span class="disabled"> ›</span></c:otherwise>
        </c:choose>

        <%-- 맨끝 --%>
        <c:choose>
            <c:when test="${page < totalPages}">
                <a href="<c:url value='/admin/board/${boardIdResolved}.do'>
                           <c:param name='page' value='${totalPages}'/>
                           <c:param name='size' value='${size}'/>
                         </c:url>"> »</a>
            </c:when>
            <c:otherwise><span class="disabled"> »</span></c:otherwise>
        </c:choose>
    </div>

    <div class="board-actions">
        <a href="<c:url value='/admin/board/write.do'>
                   <c:param name='boardId' value='${boardIdResolved}'/>
                 </c:url>">글쓰기</a>
    </div>
</div>

<script>
    // 날짜 표시
    function formatDateTime(isoString) {
        if (!isoString) return '';
        return isoString.replace('T', ' ').slice(0, -3);
    }
    document.addEventListener('DOMContentLoaded', function() {
        document.querySelectorAll('.date-cell').forEach(cell => {
            const isoString = cell.getAttribute('data-date');
            cell.textContent = formatDateTime(isoString);
        });
    });
</script>
</body>
</html>
