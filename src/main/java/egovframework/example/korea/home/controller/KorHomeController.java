package egovframework.example.korea.home.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
@Controller
public class KorHomeController {
	@RequestMapping("/home.do")
	public String Home() {
	    return "/kor/home";
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
