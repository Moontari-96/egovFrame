package egovframework.example.korea.home.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
@Controller
public class KorHomeController {
	@RequestMapping("/home.do")
	public String Home(Model model) {
		model.addAttribute("pageTitle", "홈페이지");
		model.addAttribute("contentPage", "/WEB-INF/jsp/egovframework/example/kor/home.jsp");
		return "/layout/homepage/layout";
	}
	
	@RequestMapping("/join.do") 
	public String join() {
		return "/kor/auth/join";
	}
	@RequestMapping("/login.do") 
	public String login() {
		return "/kor/auth/login";
	}
}
