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
   <!--  <div class="searchBox">
		<div class="searchbar">
			  <span class="searchbar__icon" aria-hidden="true">
			    돋보기 아이콘 (SVG)
			    <svg viewBox="0 0 24 24" width="18" height="18">
			      <path d="M15.5 14h-.79l-.28-.27a6.471 6.471 0 001.57-4.23A6.5 6.5 0 109.5 16.5a6.471 6.471 0 004.23-1.57l.27.28v.79L20 21.49 21.49 20 15.5 14zM9.5 14A4.5 4.5 0 119.5 5a4.5 4.5 0 010 9z"/>
			    </svg>
			  </span>
			  <input
			    type="text"
			    name="search"
			    class="searchbar__input"
			    placeholder="검색어를 입력하세요"
			    autocomplete="off"
			  />
			  <button class="searchbar__btn" type="submit">검색</button>
		</div>
    </div> -->
    <div class="searchBox">
	    <c:url var="listAction" value="/admin/board/${boardIdResolved}.do"/>
		<form class="searchbar" action="${listAction}" method="get" role="search">
		  <span class="searchbar__icon" aria-hidden="true">
	  		  <svg viewBox="0 0 24 24" width="18" height="18">
		     	<path d="M15.5 14h-.79l-.28-.27a6.471 6.471 0 001.57-4.23A6.5 6.5 0 109.5 16.5a6.471 6.471 0 004.23-1.57l.27.28v.79L20 21.49 21.49 20 15.5 14zM9.5 14A4.5 4.5 0 119.5 5a4.5 4.5 0 010 9z"/>
		      </svg>
		  </span>
		  <input
		    type="text"
		    name="q"
		    class="searchbar__input"
		    placeholder="검색어를 입력하세요"
		    value="${fn:escapeXml(param.q)}" />
		  <button class="searchbar__btn" type="submit">검색</button>
		  <c:if test="${not empty param.q}">
		    <a class="reset" href="${listAction}">초기화</a>
		  </c:if>
		</form>
	</div>
    <%-- 페이징 네비게이션 --%>
    <div class="pagination">
        <%-- 맨앞 --%>
        <c:choose>
            <c:when test="${page > 1}">
                <a href="<c:url value='/admin/board/${boardIdResolved}.do'>
                           <c:param name='page' value='1'/>
                           <c:param name='size' value='${size}'/>
                           <c:if test="${not empty param.q}">
						    <c:param name="q" value="${param.q}"/>
						  </c:if>
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
                           <c:if test="${not empty param.q}">
						    <c:param name="q" value="${param.q}"/>
						  </c:if>
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
                               <c:if test="${not empty param.q}">
						    <c:param name="q" value="${param.q}"/>
						  </c:if>
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
                           <c:if test="${not empty param.q}">
						    <c:param name="q" value="${param.q}"/>
						  </c:if>
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
                           <c:if test="${not empty param.q}">
						    <c:param name="q" value="${param.q}"/>
						  </c:if>
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
