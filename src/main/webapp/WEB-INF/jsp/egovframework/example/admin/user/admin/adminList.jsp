<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${pageTitle}</title>
<link rel="stylesheet" href="<c:url value='/css/egovframework/layout.css'/>">
</head>
<body>


<div class="card">
    <h2>${pageTitle}</h2>

    <table class="board-table">
        <thead>
            <tr>
                <th>No</th>
                <th>관리자ID</th>
                <th>이름</th>
                <th>상태</th>
                <th>가입일</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${not empty adminList}">
                    <c:forEach var="admin" items="${adminList}" varStatus="s">
                        <tr>
                            <td>${rowNoStart - s.index}</td>
                            <td style="text-align:left;">
                                <a href="<c:url value='/admin/user/detail.do'>
                                            <c:param name='id' value='${admin.id}'/>
                                         </c:url>">
                                    ${admin.user_id}
                                </a>
                            </td>
                            <td>${admin.user_name}</td>
                            <td>
                            	<c:set var="status" value="${admin.user_status}" />
									<c:choose>
									  <c:when test="${status == 'active'}">활성</c:when>
									  <c:when test="${status == 'dormant'}">휴면</c:when>
									  <c:when test="${status == 'black'}">블랙</c:when>
									  <c:otherwise>미정</c:otherwise>
									</c:choose>
                            </td>
                            <td class="date-cell" data-date="${admin.create_at}"></td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="5">등록된 관리자가 없습니다.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <%-- 페이징 네비게이션 --%>
    <div class="pagination">
        <c:choose>
            <c:when test="${page > 1}">
                <a href="<c:url value='/admin/user/adminList.do'>
                           <c:param name='page' value='1'/>
                           <c:param name='size' value='${size}'/>
                         </c:url>">« </a>
            </c:when>
            <c:otherwise><span class="disabled">« </span></c:otherwise>
        </c:choose>

        <c:set var="prevBlockPage" value="${startPage - 1}" />
        <c:choose>
            <c:when test="${prevBlockPage >= 1}">
                <a href="<c:url value='/admin/user/adminList.do'>
                           <c:param name='page' value='${prevBlockPage}'/>
                           <c:param name='size' value='${size}'/>
                         </c:url>">‹ </a>
            </c:when>
            <c:otherwise><span class="disabled">‹ </span></c:otherwise>
        </c:choose>

        <c:forEach var="p" begin="${startPage}" end="${endPage}">
            <c:choose>
                <c:when test="${p == page}">
                    <span class="active">${p}</span>
                </c:when>
                <c:otherwise>
                    <a href="<c:url value='/admin/user/adminList.do'>
                               <c:param name='page' value='${p}'/>
                               <c:param name='size' value='${size}'/>
                             </c:url>">${p}</a>
                </c:otherwise>
            </c:choose>
        </c:forEach>

        <c:set var="nextBlockPage" value="${endPage + 1}" />
        <c:choose>
            <c:when test="${nextBlockPage <= totalPages}">
                <a href="<c:url value='/admin/user/adminList.do'>
                           <c:param name='page' value='${nextBlockPage}'/>
                           <c:param name='size' value='${size}'/>
                         </c:url>"> ›</a>
            </c:when>
            <c:otherwise><span class="disabled"> ›</span></c:otherwise>
        </c:choose>

        <c:choose>
            <c:when test="${page < totalPages}">
                <a href="<c:url value='/admin/user/adminList.do'>
                           <c:param name='page' value='${totalPages}'/>
                           <c:param name='size' value='${size}'/>
                         </c:url>"> »</a>
            </c:when>
            <c:otherwise><span class="disabled"> »</span></c:otherwise>
        </c:choose>
    </div>

    <div class="board-actions">
        <a href="<c:url value='/admin/user/adminCreateView.do'>
                   <%-- <c:param name='boardId' value='${boardIdResolved}'/> --%>
              	</c:url>">관리자 등록</a>
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
