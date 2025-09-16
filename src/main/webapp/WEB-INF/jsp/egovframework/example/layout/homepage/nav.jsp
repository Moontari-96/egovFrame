<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="<c:url value='/js/jquery.min.js'/>"></script>
</head>
<body>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div id="navOverlay" class="nav-ov">
  <div id="navOverlayScrim" class="nav-ov__scrim" aria-hidden="true"></div>

  <aside class="nav-ov__panel" role="dialog" aria-modal="true" aria-label="전체 메뉴">
    <div class="nav-ov__head">
      <strong>전체 메뉴</strong>
      <button class="btn-close" type="button" aria-label="닫기" data-close-overlay>✕</button>
    </div>

    <div class="nav-ov__body">
      <c:choose>
        <c:when test="${not empty menuList}">
          <ul class="tree">
            <c:forEach var="m1" items="${menuList}">
              <c:if test="${m1.menuDepth == 1}">
                <li class="tree__li depth1">
                  <a class="tree__a" href="<c:url value='${m1.menuUrl}'/>">${m1.menuName}</a>

                  <!-- 2뎁스 -->
                  <c:set var="hasL2" value="false"/>
                  <ul class="tree__ul">
                    <c:forEach var="m2" items="${menuList}">
                      <c:if test="${m2.parentId == m1.menuId}">
                        <c:set var="hasL2" value="true"/>
                        <li class="tree__li depth2">
                          <!-- 필요시 버튼으로 토글 가능 -->
                          <a class="tree__a" href="<c:url value='${m2.menuUrl}'/>" data-toggle>${m2.menuName}</a>

                          <!-- 3뎁스 -->
                          <c:set var="hasL3" value="false"/>
                          <ul class="tree__ul">
                            <c:forEach var="m3" items="${menuList}">
                              <c:if test="${m3.parentId == m2.menuId}">
                                <c:set var="hasL3" value="true"/>
                                <li class="tree__li depth3">
                                  <a class="tree__a" href="<c:url value='${m3.menuUrl}'/>">${m3.menuName}</a>
                                </li>
                              </c:if>
                            </c:forEach>
                          </ul>
                        </li>
                      </c:if>
                    </c:forEach>
                  </ul>
                </li>
              </c:if>
            </c:forEach>
          </ul>
        </c:when>

        <c:otherwise>
          <!-- 샘플 데이터 -->
          <ul class="tree">
            <li class="tree__li depth1">
              <a class="tree__a" href="<c:url value='/'/>">대시보드</a>
            </li>
            <li class="tree__li depth1">
              <a class="tree__a" href="#" data-toggle>게시판</a>
              <ul class="tree__ul">
                <li class="tree__li depth2">
                  <a class="tree__a" href="<c:url value='/board/notice.do'/>">공지사항</a>
                </li>
                <li class="tree__li depth2">
                  <a class="tree__a" href="#" data-toggle>자료실</a>
                  <ul class="tree__ul">
                    <li class="tree__li depth3">
                      <a class="tree__a" href="<c:url value='/board/data/forms.do'/>">양식</a>
                    </li>
                    <li class="tree__li depth3">
                      <a class="tree__a" href="<c:url value='/board/data/manuals.do'/>">매뉴얼</a>
                    </li>
                  </ul>
                </li>
              </ul>
            </li>
          </ul>
        </c:otherwise>
      </c:choose>
    </div>
  </aside>
</div>
</body>
</html>