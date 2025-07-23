package egovframework.example.admin.boards.controller;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.example.admin.boards.service.BoardsService;
import egovframework.example.admin.boards.service.BoardsVO;

public class BoardsController {
	@Resource(name = "boardsService")
	private BoardsService boardsService;
	
//	@RequestMapping("/home.do")
//	public String home(Model model) throws Exception {
//		List<BoardsVO> mvo = boardsService.selectAll();
//		model.addAttribute("mvo", mvo);
//		return "sample/home";
//	}
}
