package egovframework.example.admin.home.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminHomeController {
    @RequestMapping("/home.do")
    public String adminHome(HttpSession session) {
        Object adminUser = session.getAttribute("adminUser");

        if (adminUser == null) {
            return "/admin/login"; // 로그인 페이지로 리디렉트
        }

        return "/admin/home"; // 관리자 홈 화면
    }
}
