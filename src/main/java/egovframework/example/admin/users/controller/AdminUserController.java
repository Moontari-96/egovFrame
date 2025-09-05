package egovframework.example.admin.users.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.example.admin.users.service.AdminUserService;
import egovframework.example.admin.users.service.AdminUserVO;
import egovframework.example.cmmn.util.JwtUtil;

@Controller
@RequestMapping("/admin/user")
public class AdminUserController {
	@Resource(name = "UserService")
	private AdminUserService userService;
	
//	@PostMapping("/login.do")
//	public String login(@RequestParam("username") String id,
//	                    @RequestParam("password") String pw,
//	                    HttpSession session, Model model) {
//	    try {
//	        AdminUserVO user = userService.selectAdminUserById(id, pw);
//	        if(user != null) {
//	            session.setAttribute("adminUser", user);
//	            return "redirect:/admin/home.do"; // ✅ 리다이렉트
//	        } else {
//	            model.addAttribute("errorMsg", "아이디 또는 비밀번호가 올바르지 않습니다.");
//	            return "/admin/login";
//	        }
//	    } catch (Exception e) {
//	        model.addAttribute("errorMsg", "로그인 중 오류가 발생했습니다.");
//	        return "/admin/login";
//	    }
//	}
	@PostMapping("/login.do")
	@ResponseBody
	public Map<String, Object> login(@RequestParam String username,
	                                 @RequestParam String password,
	                                 HttpSession session) {
	    Map<String, Object> res = new HashMap<>();
	    try {
	        AdminUserVO user = userService.selectAdminUserById(username, password);
	        if(user != null){
	            // 세션 저장
	            session.setAttribute("adminUser", user);

	            // JWT 발급
	            String token = JwtUtil.generateToken(user.getUser_id());

	            res.put("success", true);
	            res.put("token", token);
	        } else {
	            res.put("success", false);
	            res.put("msg", "아이디 또는 비밀번호가 올바르지 않습니다.");
	        }
	    } catch(Exception e) {
	        res.put("success", false);
	        res.put("msg", "로그인 중 오류가 발생했습니다.");
	    }
	    return res;
	}
	
	@RequestMapping("/logout.do")
	public String logout(HttpSession session) {
		session.invalidate(); // 세션 초기화
		return "/admin/login";
	};
	
	@RequestMapping("/join.do")
	public String Join(HttpSession session) {
		return "/admin/auth/join";
	};
	@RequestMapping("/board.do")
	public String Board(HttpSession session) {
		return "/admin/board/boardList";
	};
}
