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
  const isActive = v => !(v === false || v === 0 || v === '0' || v === 'false' || v === 'N' || v == null);

  function normalizeHref(menu) {
    if (menu.menuUrl && menu.menuUrl.trim() !== "") {
      var u = menu.menuUrl.trim();
      if (u.charAt(0) !== "/") u = "/" + u;
      if (!u.endsWith(".do")) u = u + ".do";
      return basePath + u;
    }
    if (menu.boardId != null) return basePath + "/board/" + menu.boardId + ".do";
    return "#";
  }

  function samePath(href){
    var a = document.createElement('a');
    a.href = href;
    var linkPath = (a.pathname || '').replace(/\/+$/,'');
    var curPath  = (location.pathname || '').replace(/\/+$/,'');
    return linkPath === curPath; // 필요하면 쿼리도 비교 가능
  }

  $.getJSON(url).done(function(menuList){

    function hasActiveChild(pid){
      for (var i=0;i<menuList.length;i++){
        var m = menuList[i];
        if (!isActive(m.isActive)) continue;
        if (eq(m.parentId, pid)) return true;
      }
      return false;
    }

    function buildChildren(parentId, parentDepth){
      var items = [];
      for (var i=0;i<menuList.length;i++){
        var menu = menuList[i];
        if (!isActive(menu.isActive)) continue;
        if (!eq(menu.parentId, parentId)) continue;

        var depth = menu.menuDepth ? Number(menu.menuDepth) : (parentDepth ? parentDepth + 1 : 1);
        var child = hasActiveChild(menu.menuId);

        if (depth === 1 || depth === 2){
          var li = '<li class="depth-' + depth + (child ? ' has-sub' : '') + '">';
          li += '<span data-id="' + menu.menuId + '" data-depth="' + depth + '">' + menu.menuName + '</span>';
          if (child) li += buildChildren(menu.menuId, depth);
          li += '</li>';
          items.push(li);
        } else {
          var href = normalizeHref(menu);
          items.push(
            '<li class="depth-3">' +
              '<a href="' + href + '" data-id="' + menu.menuId + '" data-depth="3">' + menu.menuName + '</a>' +
            '</li>'
          );
        }
      }
      return items.length ? ('<ul>' + items.join('') + '</ul>') : '';
    }

    // 루트 렌더
    var out = ['<ul>'];
    for (var i=0;i<menuList.length;i++){
      var m = menuList[i];
      if (!isActive(m.isActive)) continue;
      if (m.parentId == null || String(m.parentId)==="" || String(m.parentId)==="0"){
        var depth = m.menuDepth ? Number(m.menuDepth) : 1;
        if (depth !== 1) continue;
        var child = hasActiveChild(m.menuId);
        out.push('<li class="depth-1' + (child ? ' has-sub' : '') + '">');
        out.push('<span data-id="' + m.menuId + '" data-depth="1">' + m.menuName + '</span>');
        if (child) out.push(buildChildren(m.menuId, 1));
        out.push('</li>');
      }
    }
    out.push('</ul>');

    $('#menu-tree').html(out.join(''));

    // 초기 접기
    $('#menu-tree ul ul').hide();

    // 1뎁스 토글 + 상태 저장 (단일 핸들러만!)
    /* $('#menu-tree').on('click', "span[data-depth='1']", function(e){
      e.stopPropagation(); 
      var $li = $(this).closest("li"); 
      var $subs = $li.find("ul"); // 현재 li 안의 모든 ul (2,3뎁스 포함)
      var opened = $li.hasClass('open');
      if ($subs.length) { 
    	  console.log("진입"); 
    	  $subs.slideToggle(150); // 모든 하위 ul 토글 
      	  $li.toggleClass("open"); 
   	  }
      // localStorage 저장
      var id = String($(this).data('id'));
      var list = new Set(JSON.parse(localStorage.getItem('menu:openRoots') || '[]'));
      if (opened) list.delete(id); else list.add(id);
      localStorage.setItem('menu:openRoots', JSON.stringify(Array.from(list)));
    }); */
	 // 1) 1뎁스 토글: 하위(2·3뎁스) 전부 토글 + 열림 상태 저장
    $('#menu-tree').on('click', "span[data-depth='1']", function (e) {
      e.preventDefault();
      e.stopPropagation();

      var $root = $(this).closest('li.depth-1');
      var opening = !$root.hasClass('open');

      var $allSubs = $root.find('ul');           // 모든 하위 ul
      var $allBranches = $root.find('li.has-sub'); // 모든 하위 가지

      if (opening) {
        $root.addClass('open');
        $allBranches.addClass('open');
        $allSubs.stop(true, true).slideDown(150);
      } else {
        $root.removeClass('open');
        $allBranches.removeClass('open');
        $allSubs.stop(true, true).slideUp(150);
      }

      // openRoots 저장(1뎁스 루트만)
      var id = String($(this).data('id'));
      var openedSet = new Set(JSON.parse(localStorage.getItem('menu:openRoots') || '[]'));
      if (opening) openedSet.add(id); else openedSet.delete(id);
      localStorage.setItem('menu:openRoots', JSON.stringify(Array.from(openedSet)));
    });
 	// 2) 3뎁스 클릭: 이 항목만 active, 조상(2·1뎁스) 모두 펼침
    $('#menu-tree').on('click', "a[data-depth='3']", function () {
	  var $link = $(this);
	
	  // active 단일화
	  $('#menu-tree .is-active').removeClass('is-active');
	  $link.addClass('is-active');
	
	  // 현재 루트(1뎁스)
	  var $root = $link.closest('li.depth-1');
	  var rootId = String($root.find('> span').data('id'));
	
	  // 루트의 모든 하위(2·3뎁스)까지 '전부' 펼치기
	  $root.addClass('open');
	  $root.find('li.has-sub').addClass('open');
	  $root.find('ul').show();
	
	  // 다른 루트(1뎁스)는 모두 닫기
	  $('#menu-tree > ul > li.depth-1').not($root)
	    .removeClass('open')
	    .find('li.has-sub').removeClass('open').end()
	    .find('ul').hide();
	
	  // 상태 저장: 열린 루트는 현재 것만, 마지막 active 저장
	  localStorage.setItem('menu:openRoots', JSON.stringify([rootId]));
	  localStorage.setItem('menu:lastActiveId', String($link.data('id')));
	  // 기본 네비게이션 진행 (preventDefault X)
	});
 	// 3) 복원(렌더 직후 호출): 열린 루트 + active 복원
    (function restoreMenuState(){
	  function samePath(href){
	    var a = document.createElement('a'); a.href = href;
	    var lp = (a.pathname||'').replace(/\/+$/,'');
	    var cp = (location.pathname||'').replace(/\/+$/,'');
	    return lp === cp;
	  }
	
	  var $a = $('#menu-tree a').filter(function(){ return samePath(this.href); }).first();
	  if (!$a.length){
	    var lastId = localStorage.getItem('menu:lastActiveId');
	    if (lastId) $a = $('#menu-tree a[data-id="'+ lastId +'"]').first();
	  }
	
	  var $rootToOpen = $();
	
	  if ($a.length){
	    $('#menu-tree .is-active').removeClass('is-active');
	    $a.addClass('is-active');
	
	    // active의 루트 선택
	    $rootToOpen = $a.closest('li.depth-1');
	  } else {
	    var openRoots = JSON.parse(localStorage.getItem('menu:openRoots') || '[]');
	    if (openRoots.length){
	      $rootToOpen = $('#menu-tree [data-id="'+ openRoots[0] +'"]').closest('li.depth-1');
	    }
	  }
	
	  if ($rootToOpen.length){
	    // ✅ 루트의 모든 하위(2·3뎁스)까지 '전부' 펼치기
	    $rootToOpen.addClass('open');
	    $rootToOpen.find('li.has-sub').addClass('open');
	    $rootToOpen.find('ul').show();
	
	    // 다른 루트는 모두 닫기
	    $('#menu-tree > ul > li.depth-1').not($rootToOpen)
	      .removeClass('open')
	      .find('li.has-sub').removeClass('open').end()
	      .find('ul').hide();
	
	    // 저장도 단일 루트로 정규화
	    var rid = String($rootToOpen.find('> span').data('id'));
	    localStorage.setItem('menu:openRoots', JSON.stringify([rid]));
	  }
	})();

  }).fail(function(xhr, status, err){
    console.error("메뉴 호출 실패", status, err, xhr.status, xhr.responseText);
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