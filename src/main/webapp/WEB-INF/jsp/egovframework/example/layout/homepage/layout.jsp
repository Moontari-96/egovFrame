<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
	<title><c:out value="${pageTitle != null ? pageTitle : '홈페이지'}"/></title>
  <link rel="stylesheet" href="<c:url value='/css/egovframework/common.css'/>">
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
</head>
<body class="layout">

  <jsp:include page="/home/menu/header.do" flush="true"/>
  <div class="container">
    <main class="content">
      	<c:choose>
		  <c:when test="${not empty contentPage}">
		    <jsp:include page="${contentPage}"/>
		  </c:when>
		  <c:otherwise>
		    <p class="muted">콘텐츠가 없습니다.</p>
		  </c:otherwise>
		</c:choose>
    </main>
  </div>

  <jsp:include page="/WEB-INF/jsp/egovframework/example/layout/homepage/footer.jsp"/>

  <script>
    // 상단 드롭다운 메뉴 열기/닫기
    (function(){
      const openBtn  = document.querySelector('[data-open-topmenu]');
      const panel    = document.getElementById('megaMenu');
      const scrim    = document.getElementById('megaMenuScrim'); // 배경 클릭 닫힘
      const body     = document.body;

      function open(){
        panel.classList.add('is-open');
        scrim.classList.add('is-on');
      }
      function close(){
        panel.classList.remove('is-open');
        scrim.classList.remove('is-on');
        body.style.overflow='';
      }

      if (openBtn) openBtn.addEventListener('click', function(e){
        e.preventDefault();
        const isOpen = panel.classList.contains('is-open');
        if (isOpen) close(); else open();
      });
      if (scrim) scrim.addEventListener('click', close);
      window.addEventListener('keydown', (e)=> { if(e.key==='Escape') close(); });
      window.addEventListener('scroll', close); // 스크롤 시 닫힘(원치 않으면 제거)
    })();
  </script>
</body>

</html>
