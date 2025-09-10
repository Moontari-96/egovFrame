package egovframework.example.admin.boards.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.example.admin.boards.service.BoardsService;
import egovframework.example.admin.boards.service.BoardsVO;
import egovframework.example.admin.boards.service.PostVO;

@Service("boardsService")
public class BoardsServiceImpl extends EgovAbstractServiceImpl implements BoardsService {
	@Resource(name="boardsMapper")
	boardsMapper boardsDAO;
	

	@Override
	public List<BoardsVO> selectAll() {
		return boardsDAO.selectAll();
	}
	
	@Override
	public List<Map<String, Object>> findByBoard(String boardId, int size, int offset) {
		return  boardsDAO.findByBoard(boardId, size, offset);
	}
	
	@Override
	public int countByBoard(String boardId) {
		return  boardsDAO.countByBoard(boardId);
	}
	
	@Override
	public PostVO getPostDetail(String postId) {
		return boardsDAO.getPostDetail(postId);
	}
	
	@Override
	public int createPost(PostVO dto) {
		return boardsDAO.createPost(dto);
	}
	
	@Override
	public int updatePost(PostVO dto) {
		return boardsDAO.updatePost(dto);
	}
	
	@Override
	public int deletePost(Map<String,Object> param) {
		return boardsDAO.deletePost(param);
	}

}
