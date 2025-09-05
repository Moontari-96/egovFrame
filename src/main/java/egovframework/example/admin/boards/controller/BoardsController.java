package egovframework.example.admin.boards.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import egovframework.example.admin.boards.service.BoardsService;
import egovframework.example.admin.boards.service.BoardsVO;
import egovframework.example.admin.boards.service.PostVO;
@Controller
@RequestMapping("/admin/board")
public class BoardsController {
	@Resource(name = "boardsService")
	private BoardsService boardsService;
	
//	@RequestMapping("/home.do")
//	public String home(Model model) throws Exception {
//		List<BoardsVO> mvo = boardsService.selectAll();
//		model.addAttribute("mvo", mvo);
//		return "sample/home";
//	}
	@GetMapping("/{boardId}.do")
	public String boardListRedirect(@PathVariable String boardId, Model model) {
	    // boardList 페이지로 포워딩하면서 boardId 전달
		System.out.println(boardId + "진입확인");
	    model.addAttribute("boardId", boardId);

	    try {
	    	// 게시글 가져오기
	    	List<Map<String, Object>> postList = boardsService.getPostsByBoardId(boardId);
	    	model.addAttribute("postList", postList);
    	   String boardName = "";
    	    if (postList != null && !postList.isEmpty()) {
    	        boardName = (String) postList.get(0).get("board_nm");
    	    }

	    	// 레이아웃 유지
	    	model.addAttribute("contentPage", "/WEB-INF/jsp/egovframework/example/admin/board/boardList.jsp");
	    	model.addAttribute("pageTitle", boardName + " 게시판");
	    	System.out.println(model);
	    	return "/layout/admin/layout"; 
		} catch (Exception e) {
			// TODO: handle exception
			return "/layout/admin/layout";
		}
	}
	@GetMapping("/view.do")
	public String boardDetailRedirect(@RequestParam("postId") String postId, Model model) {
	    // boardDetail postId 전달
	    try {
	    	// 게시글 상세 가져오기
	    	List<Map<String, Object>> postList = boardsService.getPostsByBoardId(postId);
	    	model.addAttribute("postList", postList);
	    	String boardName = "";
    	    if (postList != null && !postList.isEmpty()) {
    	        boardName = (String) postList.get(0).get("board_nm");
    	    }

	    	// 레이아웃 유지
	    	model.addAttribute("contentPage", "/WEB-INF/jsp/egovframework/example/admin/board/boardDetail.jsp");
	    	model.addAttribute("pageTitle", boardName + " 게시판");
	    	System.out.println(model);
	    	return "/layout/admin/layout"; 
		} catch (Exception e) {
			// TODO: handle exception
			return "/layout/admin/layout";
		}
	}
}
