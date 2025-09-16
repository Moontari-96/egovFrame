<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<header class="header" id="siteHeader">
  <!-- 상단 바 -->
  <div class="header__bar">
    <a class="brand" href="<c:url value='/'/>">Moon Site</a>

    <nav class="topnav">
      <a href="<c:url value='/'/>" class="topnav__link">홈</a>
      <a href="<c:url value='/about.do'/>" class="topnav__link">소개</a>
      <a href="<c:url value='/contact.do'/>" class="topnav__link">문의</a>
    </nav>

    <!-- 상단 전체메뉴 토글(오버레이 없음) -->
    <button type="button"
            class="btn-menu"
            aria-haspopup="dialog"
            aria-expanded="false"
            aria-controls="megaMenu"
            id="megaToggleBtn">
      ☰ 전체메뉴
    </button>
  </div>

  <!-- 같은 헤더 영역에서 아래로 펼쳐지는 평면 리스트 -->
	<div id="megaMenu" class="mega mega--columns" role="dialog" aria-label="전체 메뉴">
	  <div class="mega__inner">
	    <ul class="mega-cols">
	      <c:forEach var="m2" items="${menuList}">
	        <c:if test="${m2.menuDepth == 2 || m2.menuDepth eq '2'}">
	          <li class="mega-col">
	            <!-- 2뎁스: 컬럼 제목 (비클릭) -->
	            <div class="col-title">${m2.menuName}</div>
	
	            <!-- 3뎁스: 해당 2뎁스의 하위 링크들 -->
	            <ul class="col-links">
	              <c:set var="has3" value="false"/>
	              <c:forEach var="m3" items="${menuList}">
	                <c:if test="${
	                  (m3.menuDepth == 3 || m3.menuDepth eq '3')
	                  and (m3.parentId == m2.menuId || m3.parentId eq m2.menuId)
	                }">
	                  <c:set var="has3" value="true"/>
	                  <li>
	                    <a href="<c:url value='${m3.menuUrl}'/>" class="mega-link">${m3.menuName}</a>
	                  </li>
	                </c:if>
	              </c:forEach>
	
	              <!-- 3뎁스가 하나도 없으면, 2뎁스를 클릭 항목으로 대체(원치 않으면 이 블록 삭제) -->
	              <c:if test="${not has3}">
	                <li>
	                  <a href="<c:url value='${m2.menuUrl}'/>" class="mega-link">${m2.menuName}</a>
	                </li>
	              </c:if>
	            </ul>
	          </li>
	        </c:if>
	      </c:forEach>
	    </ul>
	  </div>
	</div>

  </div>
</header>

<script>
(function(){
	  const header = document.getElementById('siteHeader');   // <header id="siteHeader">
	  const btn    = document.getElementById('megaToggleBtn'); // 토글 버튼
	  const panel  = document.getElementById('megaMenu');      // 메가 메뉴

	  if(!header || !btn || !panel) return;

	  // 헤더 높이에 맞춰 overlay top 위치 갱신
	  function place(){
	    const rect = header.getBoundingClientRect(); // 뷰포트 기준
	    panel.style.setProperty('--mega-top', rect.bottom + 'px');
	  }

	  function open(){
	    place();
	    header.classList.add('is-menu-open');
	    // body 스크롤을 막고 싶으면 아래 주석 해제
	    // document.body.style.overflow = 'hidden';
	  }
	  function close(){
	    header.classList.remove('is-menu-open');
	    // document.body.style.overflow = '';
	  }
	  function toggle(){ header.classList.contains('is-menu-open') ? close() : open(); }

	  btn.addEventListener('click', e => { e.preventDefault(); toggle(); });

	  // 헤더 바깥 클릭 시 닫기
	  document.addEventListener('click', e => { if(!header.contains(e.target)) close(); });

	  // ESC 닫기
	  window.addEventListener('keydown', e => { if(e.key === 'Escape') close(); });

	  // 스크롤/리사이즈 중에도 헤더 하단에 계속 붙도록
	  window.addEventListener('scroll', () => { if(header.classList.contains('is-menu-open')) place(); }, {passive:true});
	  window.addEventListener('resize', () => { if(header.classList.contains('is-menu-open')) place(); });
	})();
</script>



</body>
</html>