package egovframework.example.admin.users.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import egovframework.example.admin.users.service.AdminUserService;
import egovframework.example.admin.users.service.AdminUserVO;

@Controller
@RequestMapping("/admin/user")
public class AdminUserController {
	@Resource(name = "UserService")
	private AdminUserService userService;
	
	@PostMapping("/login.do")
	public String login(@RequestParam("username") String id, @RequestParam("password") String pw, HttpSession session, Model model) {
		try {
			System.out.println(id + pw + "파라미터 확인");
			AdminUserVO user = userService.selectAdminUserById(id, pw);
			System.out.println(user + "값 확인");
			if(user != null) {
				session.setAttribute("adminUser", user);
				System.out.println("로그인성공");
				return "/admin/main/main";
			} else {
                model.addAttribute("errorMsg", "아이디 또는 비밀번호가 올바르지 않습니다.");
                return "/admin/login"; // 다시 로그인 페이지로
			}
		} catch (Exception e) {
			model.addAttribute("errorMsg", "로그인 중 오류가 발생했습니다.");
            return "/admin/login";
		}
	};
	
	@RequestMapping("/logout.do")
	public String logout(HttpSession session) {
		session.invalidate(); // 세션 초기화
		System.out.println("로그아웃 성공");
		return "/admin/login";
	};
}
