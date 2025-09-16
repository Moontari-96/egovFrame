<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(function(){
  const ctx = "${pageContext.request.contextPath}";
  const basePath = ctx + "/admin";
  const url = ctx + "/admin/menu/menu.do";

  const eq = (a,b) => String(a) === String(b);

  function normalizeHref(menu) {
    if (menu.menuUrl && menu.menuUrl.trim() !== "") {
      var u = menu.menuUrl.trim();
      if (u.charAt(0) !== "/") u = "/" + u;
      if (!u.endsWith(".do")) u = u + ".do";
      return basePath + u;
    }
    if (menu.boardId != null) {
      return basePath + "/board/" + menu.boardId + ".do";
    }
    return "#";
  }

  $.getJSON(url)
   .done(function(menuList){
      // 자식 유무 판단
      function hasChild(pid){
        for (var i=0;i<menuList.length;i++){
          if (eq(menuList[i].parentId, pid)) return true;
        }
        return false;
      }

      function buildChildren(parentId, parentDepth){
        var html = "<ul>";
        for (var i=0;i<menuList.length;i++){
          var menu = menuList[i];
          if ((menu.parentId == null && parentId == null) || eq(menu.parentId, parentId)) {
            var depth = menu.menuDepth ? Number(menu.menuDepth) : (parentDepth ? parentDepth + 1 : 1);
            var child = hasChild(menu.menuId);

            if (depth === 1 || depth === 2) {
              html += '<li class="depth-' + depth + (child ? ' has-sub' : '') + '">';
              html += '<span data-id="' + menu.menuId + '" data-depth="' + depth + '">' + menu.menuName + '</span>';
              if (child) html += buildChildren(menu.menuId, depth);
              html += '</li>';
            } else {
              var href = normalizeHref(menu);
              html += '<li class="depth-3">';
              html += '<a href="' + href + '" data-id="' + menu.menuId + '" data-depth="3">' + menu.menuName + '</a>';
              html += '</li>';
            }
          }
        }
        html += "</ul>";
        return html;
      }

      // 루트(1뎁스) 렌더
      var html = "<ul>";
      for (var i=0;i<menuList.length;i++){
        var m = menuList[i];
        if (m.parentId == null || String(m.parentId) === "" || String(m.parentId) === "0") {
          var depth = m.menuDepth ? Number(m.menuDepth) : 1;
          if (depth !== 1) continue;
          var child = hasChild(m.menuId);
          html += '<li class="depth-1' + (child ? ' has-sub' : '') + '">';
          html += '<span data-id="' + m.menuId + '" data-depth="1">' + m.menuName + '</span>';
          if (child) html += buildChildren(m.menuId, 1);
          html += '</li>';
        }
      }
      html += "</ul>";

      $("#menu-tree").html(html);

      // 초기 접기
      $("#menu-tree ul ul").hide();

      // 1뎁스 클릭 시 2,3뎁스 모두 열기
      $("#menu-tree").on("click", "span[data-depth='1']", function(e){
        e.stopPropagation();
        var $li = $(this).closest("li");
        var $subs = $li.find("ul"); // 현재 li 안의 모든 ul (2,3뎁스 포함)

        if ($subs.length) {
          console.log("진입");
          $subs.slideToggle(150);   // 모든 하위 ul 토글
          $li.toggleClass("open");
        }
      });
   })
   .fail(function(xhr, status, err){
      console.error("❌ 메뉴 호출 실패", status, err, xhr.status, xhr.responseText);
      alert("메뉴 API 실패: " + status + " (" + xhr.status + ")");
   });
});
</script>

</head>
<body>
<div class="sidebar">
	<h3>메뉴</h3>
	<ul id="menu-tree" class="menu-tree"></ul>
</div>

</body>


</html>