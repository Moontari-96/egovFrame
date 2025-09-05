<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
	/* 사이드바 */
	.menu-tree {
	    list-style: none;
	    padding-left: 0;
	}
	
	.menu-tree li {
	    margin: 5px 0;
	}
	
	.menu-tree li span {
	    font-weight: bold;
	    display: block;
	    padding: 6px 10px;
	    cursor: pointer;
	    border-radius: 5px;
	}
	
	.menu-tree li span:hover {
	    background-color: #2e3b4e;
	    color: #fff;
	}
	
	.menu-tree li a {
	    display: block;
	    padding: 6px 10px;
	    margin-left: 15px;
	    color: #cfd8dc;
	    text-decoration: none;
	    border-radius: 5px;
	    font-size: 14px;
	}
	
	.menu-tree li a:hover {
	    background-color: #2e3b4e;
	    color: #fff;
	}
	
	.menu-tree li.has-sub > span::after {
	    content: "▶";
	    float: right;
	    transition: transform 0.3s ease;
	}
	
	.menu-tree li.open > span::after {
	    transform: rotate(90deg);
	}

</style>
<script>
$(document).ready(function(){
    console.log("document ready"); // 문서 준비 확인

    $.getJSON("${pageContext.request.contextPath}/admin/menu/menu.do")
    .done(function(menuList){
        console.log("서버 응답 받음:", menuList);
     	// JSP에서 context path 받아오기
        let basePath = "${pageContext.request.contextPath}/admin";

        // 메뉴를 트리 구조로 변환 (최대 3단계)
        function buildMenu(parentId, depth = 1) {
            console.log("buildMenu 호출, parentId:", parentId, "depth:", depth);

            let html = "<ul>";
            menuList.forEach(function(menu){
                console.log("menu 반복:", menu);
                if((menu.parentId === null && parentId === null) || menu.parentId === parentId){
                    let hasChild = menuList.some(m => m.parentId === menu.menuId);
                    console.log("hasChild 체크:", menu.menuName, hasChild);

                    if(hasChild){
                        html += "<li class='has-sub'><span>"+menu.menuName+"</span>";
                        html += buildMenu(menu.menuId, depth + 1); // 재귀 호출
                        html += "</li>";
                    } else {
                    	html += "<li><a href='"+basePath+(menu.menuUrl || "#")+".do'>"+menu.menuName+"</a></li>";
                        /* html += "<li><a href='"+basePath+(menu.menuUrl || "#")+"'>"+menu.menuName+"</a></li>"; */
                    }
                }
            });
            html += "</ul>";
            console.log("buildMenu 리턴 HTML:", html);
            return html;
        }

        // 최상위 메뉴만 root로
        let rootMenu = "";
        menuList.forEach(function(menu){
            if(menu.parentId == null){
                console.log("루트 메뉴 발견:", menu.menuName);
                rootMenu += "<li class='has-sub'><span>"+menu.menuName+"</span>";
                rootMenu += buildMenu(menu.menuId);
                rootMenu += "</li>";
            }
        });

        console.log("최종 rootMenu HTML:", rootMenu);
        $("#menu-tree").html(rootMenu);

        // 초기 상태: 서브메뉴 접기
        $("#menu-tree ul ul").hide();

        // 클릭 이벤트로 토글
        $("#menu-tree").on("click", "span", function(e){
            e.stopPropagation();
            let subMenu = $(this).siblings("ul");
            if(subMenu.length > 0){
                console.log("메뉴 클릭:", $(this).text());
                subMenu.slideToggle(300);
                $(this).parent().toggleClass("open");
            }
        });
    })
    .fail(function(jqXHR, textStatus, errorThrown){
        console.error("서버 요청 실패:", textStatus, errorThrown);
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