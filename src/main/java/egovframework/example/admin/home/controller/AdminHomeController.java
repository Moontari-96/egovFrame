package egovframework.example.admin.home.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminHomeController {
	@RequestMapping("/home.do")
	public String adminHome(Model model, HttpSession session) {
	    Object adminUser = session.getAttribute("adminUser");
	    
	    if (adminUser == null) {
	        // 로그인 안된 경우 → 로그인 화면으로
	        return "/admin/login";
	    }

	    // 레이아웃에 포함될 컨텐츠 JSP 경로 전달
	    model.addAttribute("contentPage", "/WEB-INF/jsp/egovframework/example/admin/home.jsp");
	    model.addAttribute("pageTitle", "관리자 홈");

	    // 공통 레이아웃 JSP로 이동
	    return "/layout/admin/layout";  
	}
}
