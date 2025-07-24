package egovframework.example.korea.auth.controller;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.http.ResponseEntity;

import egovframework.example.cmmn.util.JwtUtil;
import egovframework.example.korea.auth.service.KorAuthService;
import egovframework.example.korea.auth.service.KorAuthVO;

@Controller
@RequestMapping("/auth")
public class KorAuthController {
	
	@Resource(name = "authService")
	private KorAuthService authService;
	
	@PostMapping("/joinProc.do")
	@ResponseBody
	public ResponseEntity<String> join(KorAuthVO authVO) {
		try {
	        authService.joinAuth(authVO);
	        return ResponseEntity.ok("OK"); // HTTP 200 + 본문 OK
	    } catch (Exception e) {
	        e.printStackTrace();
	        return ResponseEntity.status(500).body("회원가입 처리 중 오류 발생");
	    }
	}
	
	// 로그인 유효성 체크
	@PostMapping(value = "/loginProc.do", produces = "application/json; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<Map<String, String>> login(@RequestParam("user_id") String userId,
	                                                 @RequestParam("user_pw") String userpw,
	                                                 HttpSession session) {
	    Map<String, String> result = new HashMap<>();
	    try {
	        System.out.println(">> 로그인 시도: " + userId);
	        KorAuthVO user = authService.loginValid(userId, userpw);
	        
	        if (user == null) {
	            result.put("message", "존재하지 않는 계정입니다.");
	            return ResponseEntity.status(403).body(result);
	        }

	        if (!"active".equalsIgnoreCase(user.getUser_status())) {
	            result.put("message", "비활성화된 계정입니다.");
	            return ResponseEntity.status(403).body(result);
	        }

	        String jwtToken = JwtUtil.generateToken(user.getUser_id());
	        result.put("token", jwtToken);
	        result.put("message", "로그인 성공");
	        System.out.println("응답 내용: " + result);
	        return ResponseEntity.ok(result);
	    } catch (Exception e) {
	        e.printStackTrace();
	        result.put("message", "로그인 처리 중 오류 발생");
	        return ResponseEntity.status(500).body(result);
	    }
	}
	
}
