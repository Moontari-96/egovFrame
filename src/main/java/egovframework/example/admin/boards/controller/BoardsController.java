package egovframework.example.admin.boards.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import egovframework.example.admin.boards.service.BoardsService;
import egovframework.example.admin.boards.service.BoardsVO;
import egovframework.example.admin.boards.service.PostVO;
import egovframework.example.admin.files.service.AdminFilesService;
import egovframework.example.admin.files.service.AdminFilesVO;
import egovframework.example.admin.users.service.AdminUserVO;
import lombok.Data;
import lombok.NoArgsConstructor;
@Controller
@RequestMapping("/admin/board")
public class BoardsController {
	@Resource(name = "boardsService")
	private BoardsService boardsService;
	@Resource(name = "adminFilesService")
	private AdminFilesService filesService;
//	@RequestMapping("/home.do")
//	public String home(Model model) throws Exception {
//		List<BoardsVO> mvo = boardsService.selectAll();
//		model.addAttribute("mvo", mvo);
//		return "sample/home";
//	}
	@GetMapping("/{boardId}.do")
	public String boardListRedirect(@PathVariable String boardId, @RequestParam(defaultValue = "1") int page, @RequestParam(defaultValue = "10") int size, Model model) {
			System.out.println(boardId + "게시물 리스트 진입확인");
			model.addAttribute("boardId", boardId);
			
			try {
				// 총 개수 + 목록 조회
				int totalCount = boardsService.countByBoard(boardId);
				int offset = (page - 1) * size;
				List<Map<String, Object>> postList = boardsService.findByBoard(boardId, size, offset);
				
				// 게시판 이름 (글이 0개일 때도 대비)
				String boardName = "";
				// 페이징 계산(5개짜리 블록)
				int totalPages = (int) Math.ceil((double) totalCount / size);
				if (totalPages < 1) totalPages = 1;
				
				int blockSize = 5;
				int currentBlock = (page - 1) / blockSize;
				int startPage = currentBlock * blockSize + 1;
				int endPage = Math.min(startPage + blockSize - 1, totalPages);
				int rowNoStart = totalCount - (page - 1) * size;
				System.out.println(postList+ "게시물 리스트 확인");
				// 모델 바인딩
				model.addAttribute("postList", postList);
				model.addAttribute("page", page);
				model.addAttribute("size", size);
				model.addAttribute("totalCount", totalCount);
				model.addAttribute("totalPages", totalPages);
				model.addAttribute("blockSize", blockSize);
				model.addAttribute("startPage", startPage);
				model.addAttribute("endPage", endPage);
				model.addAttribute("rowNoStart", rowNoStart);
				
				model.addAttribute("contentPage", "/WEB-INF/jsp/egovframework/example/admin/board/boardList.jsp");
				return "/layout/admin/layout";
			} catch (Exception e) {
				// 로그 정도 남기고 동일 레이아웃 반환
				model.addAttribute("postList", List.of());
				model.addAttribute("page", page);
				model.addAttribute("size", size);
				model.addAttribute("totalCount", 0);
				model.addAttribute("totalPages", 1);
				model.addAttribute("blockSize", 5);
				model.addAttribute("startPage", 1);
				model.addAttribute("endPage", 1);
				model.addAttribute("rowNoStart", 0);
				model.addAttribute("contentPage", "/WEB-INF/jsp/egovframework/example/admin/board/boardList.jsp");
				model.addAttribute("pageTitle", "게시판");
				
				return "/layout/admin/layout";
			}
	}

	@GetMapping("/view.do")
	public String boardDetailRedirect(@RequestParam("postId") String postId, Model model) {
	    // boardDetail postId 전달
	    try {
	    	// 게시글 상세 가져오기
	    	PostVO postDetail = boardsService.getPostDetail(postId);
	    	Long id = Long.parseLong(postId);
	    	List<AdminFilesVO> files = filesService.getPostfiles(id);
	    	System.out.println(files);
	    	// 레이아웃 유지
	    	model.addAttribute("post", postDetail);
	    	model.addAttribute("files", files);
	    	model.addAttribute("contentPage", "/WEB-INF/jsp/egovframework/example/admin/board/boardDetail.jsp");
	    	return "/layout/admin/layout"; 
		} catch (Exception e) {
			// TODO: handle exception
			return "/layout/admin/layout";
		}
	}
	
	@GetMapping("/write.do")
	public String boardDetailWrite(@RequestParam("boardId") String boardId, Model model) {
		try {
			model.addAttribute("boardId", boardId);
			model.addAttribute("contentPage", "/WEB-INF/jsp/egovframework/example/admin/board/boardDetail.jsp");
			return "/layout/admin/layout"; 
		} catch (Exception e) {
			// TODO: handle exception
			return "/layout/admin/layout";
		}
	}
	
	@PostMapping("/updatePost.do")
	public ResponseEntity<String> postUpdate(@RequestBody PostVO dto, HttpServletRequest request, HttpSession session){
		AdminUserVO loginUser = (AdminUserVO) session.getAttribute("adminUser");
		if (loginUser != null) {
		    String userId = loginUser.getUserId();
		} else {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("LOGIN_REQUIRED");
		}
		// 3) 업데이트 메타 정보 세팅
	    dto.setUpdateById(loginUser.getUserId());
		try {
			int update = boardsService.updatePost(dto);
			if (update == 0) {
	            // 대상 게시글이 없거나 이미 삭제된 경우
	            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("POST_NOT_FOUND");
	        }

	        return ResponseEntity.ok("OK-POST"); // 200
		} catch (Exception e) {
			// TODO Auto-generated catch block
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("UPDATE_FAILED");
		}
	}
	
	@PostMapping("/deletePost.do")
	public ResponseEntity<String> postDelete(@RequestParam int postId, HttpSession session) {
		// 로그인 여부 확인
		Map<String,Object> param = new HashMap();
		AdminUserVO loginUser = (AdminUserVO) session.getAttribute("adminUser");
		System.out.println("삭제요청 진입확인");
		System.out.println(postId);
		if (loginUser != null) {
		    String userId = loginUser.getUserId();
		    param.put("userId", userId);
		    param.put("postId", postId);
		} else {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("LOGIN_REQUIRED");
		}
		try {
			int delete = boardsService.deletePost(param);
			if (delete == 0) {
				return ResponseEntity.status(HttpStatus.NOT_FOUND).body("POST_NOT_FOUND");
			}
			return ResponseEntity.ok("OK-Delete"); // 200
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Delete_FAILED");
		}
	}
	
	@PostMapping("/createPost.do")
	public ResponseEntity<String> postCreate(PostVO dto, HttpServletRequest request, HttpSession session){
		AdminUserVO loginUser = (AdminUserVO) session.getAttribute("adminUser");

		if (loginUser != null) {
		    String userId = loginUser.getUserId();
		} else {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("LOGIN_REQUIRED");
		}
		// 3) 업데이트 메타 정보 세팅
	    dto.setCreatedById(loginUser.getUserId());
		try {
			Long create = boardsService.createPost(dto);
			if (create == null) {
	            // 대상 게시글이 없거나 이미 삭제된 경우
	            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("POST_NOT_FOUND");
	        }

	        return ResponseEntity.ok("OK-POST"); // 200
		} catch (Exception e) {
			// TODO Auto-generated catch block
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("UPDATE_FAILED");
		}
	}
}
