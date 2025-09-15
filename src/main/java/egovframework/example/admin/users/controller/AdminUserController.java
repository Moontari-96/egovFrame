package egovframework.example.admin.users.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.example.admin.users.service.AdminUserService;
import egovframework.example.admin.users.service.AdminUserVO;
import egovframework.example.admin.users.service.RolesVO;
import egovframework.example.cmmn.util.JwtUtil;
import egovframework.example.cmmn.util.sha256Util;

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
	        	System.out.println(user);
	            session.setAttribute("adminUser", user);

	            // JWT 발급
	            String token = JwtUtil.generateToken(user.getUserId());

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
	
//	@RequestMapping("/board.do")
//	public String Board(HttpSession session) {
//		return "/admin/board/boardList";
//	};
	
	// 관리자 목록조회
	@RequestMapping("/adminList.do")
	public String adminList(HttpSession session, @RequestParam(defaultValue = "1") int page, @RequestParam(defaultValue = "10") int size, Model model) {
		try {
			int totalCount = userService.countByAdmin();
			int offset = (page - 1) * size;
			List<Map<String, Object>> adminList = userService.findByAdmin(size, offset);
			// 게시판 이름 (글이 0개일 때도 대비)
			String pageTitle = "관리자 관리";
			// 페이징 계산(5개짜리 블록)
			int totalPages = (int) Math.ceil((double) totalCount / size);
			if (totalPages < 1) totalPages = 1;
			
			int blockSize = 5;
			int currentBlock = (page - 1) / blockSize;
			int startPage = currentBlock * blockSize + 1;
			int endPage = Math.min(startPage + blockSize - 1, totalPages);
			int rowNoStart = totalCount - (page - 1) * size;
			System.out.println(adminList+ "게시물 리스트 확인");
			// 모델 바인딩
			model.addAttribute("adminList", adminList);
			model.addAttribute("pageTitle", pageTitle);
			model.addAttribute("page", page);
			model.addAttribute("size", size);
			model.addAttribute("totalCount", totalCount);
			model.addAttribute("totalPages", totalPages);
			model.addAttribute("blockSize", blockSize);
			model.addAttribute("startPage", startPage);
			model.addAttribute("endPage", endPage);
			model.addAttribute("rowNoStart", rowNoStart);
			model.addAttribute("contentPage", "/WEB-INF/jsp/egovframework/example/admin/user/admin/adminList.jsp");
			return "/layout/admin/layout";
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			return "/layout/admin/layout";
		}

	};
	
	// 관리자 상세 view
	@RequestMapping("/detail.do")
	public String adminDetailView(@RequestParam("id") Long id, Model model) {
		try {
			String pageTitle = "관리자 상세";
			Map<String, Object> admin = userService.findOneAdmin(id);
			List<RolesVO> roles = userService.findRole();
			model.addAttribute("admin", admin);
			model.addAttribute("roles", roles);
			model.addAttribute("pageTitle", pageTitle);
			model.addAttribute("contentPage", "/WEB-INF/jsp/egovframework/example/admin/user/admin/adminDetail.jsp");
			return "/layout/admin/layout";
		} catch (Exception e) {
			e.printStackTrace();
			return "/layout/admin/layout";
			// TODO: handle exception
		}
		
	}
	
	// 관리자 등록 view
	@RequestMapping("/adminCreateView.do")
	public String adminCreateView(Model model) {
		try {
			String pageTitle = "관리자 상세";
			List<RolesVO> roles = userService.findRole();
			model.addAttribute("roles", roles);
			model.addAttribute("pageTitle", pageTitle);
			model.addAttribute("contentPage", "/WEB-INF/jsp/egovframework/example/admin/user/admin/adminDetail.jsp");
			return "/layout/admin/layout";
		} catch (Exception e) {
			e.printStackTrace();
			return "/layout/admin/layout";
			// TODO: handle exception
		}
		
	}
	
	// 관리자 등록
	@PostMapping(value = "/adminCreate.do",
            consumes = "application/json",
            produces = "application/json; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<Map<String,Object>> adminCreate(@RequestBody AdminUserVO dto) {
	   try {
//		   System.out.println(dto.getPassword()+ "들어오는값확인");
//		   System.out.println(dto.getUserId()+ "들어오는값확인");
//		   System.out.println(dto.getUserName()+ "들어오는값확인");
//		   System.out.println(dto.getUserStatus()+ "들어오는값확인");
//		   System.out.println(dto.getRoleId()+ "들어오는값확인");
//		   System.out.println(dto.getUserEmail()+ "들어오는값확인");
		   Long newId = userService.adminCreate(dto);  // 저장 후 PK 리턴하도록 구현
		   Long idFromDto = dto.getId();
		   if (idFromDto != null && idFromDto > 0L) {
			    // 성공 시 권한 매핑
			   System.out.println(idFromDto + "들어오는값확인");
			   userService.insertAdminRoleMap(idFromDto, dto.getRoleId());
			   return ResponseEntity.ok(Map.of(
			           "success", true,
			           "message", "success"
			       ));
			} else {
				return ResponseEntity.status(500).body(Map.of(
		           "success", false,
		           "message", "server error"
		       ));
			}
	   } catch (Exception e) {
	       e.printStackTrace();
	       return ResponseEntity.status(500).body(Map.of(
	           "success", false,
	           "message", "server error"
	       ));
	   }
	}
	// 아이디 중복체크
	@RequestMapping("/checkId.do")
	public ResponseEntity<Map<String,Object>> checkId(@RequestParam String userId) {
		try {
	        boolean exists = userService.checkId(userId) > 0;
	        Map<String, Object> body = new HashMap<>();
	        body.put("available", !exists); // 사용 가능 여부
	        body.put("exists", exists);     // 존재 여부
	        return ResponseEntity.ok(body); // 200 + JSON
	    } catch (Exception e) {
	        e.printStackTrace();
	        // 에러도 200으로 주고 사용 불가로 처리하게 할 수도 있고,
	        // 500으로 명확히 내려도 프런트가 ok=false라 가용 false로 처리합니다.
	        Map<String, Object> body = new HashMap<>();
	        body.put("available", false);
	        body.put("exists", false);
	        body.put("message", "server error");
	        return ResponseEntity.status(500).body(body);
	    }
	}
	// 관리자 등록
	@PostMapping("adminDelete.do")
	@ResponseBody
	public ResponseEntity<Map<String,Object>> adminDelete (@RequestParam("id") Long id, HttpSession session) {
		System.out.println("[DELETE] userId=" + id);
		try {
		    // (선택) 본인 삭제 방지
			System.out.println(id + "들어오는값확인");
		    AdminUserVO me = (AdminUserVO) session.getAttribute("adminUser");
		    System.out.println(me.getId() + "들어오는값확인");
		    if (me != null && me.getId() != null && me.getId().equals(id)) {
		      return ResponseEntity.ok(Map.of("success", false, "message", "본인 계정은 삭제할 수 없습니다."));
		    }
	
		    int affected = userService.deleteAdmin(id); // 트랜잭션 내부에서 roles→user 순으로 삭제
		    if (affected > 0) {
		      return ResponseEntity.ok(Map.of("success", true));
		    }
		    return ResponseEntity.ok(Map.of("success", false, "message", "대상이 없거나 이미 삭제되었습니다."));
		  } catch (Exception e) {
		    e.printStackTrace();
		    return ResponseEntity.status(500).body(Map.of("success", false, "message", "server error"));
		  }
	}
}
