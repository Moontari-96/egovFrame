package egovframework.example.admin.boards.service;

import java.util.List;
import java.util.Map;

public interface BoardsService {
	List<BoardsVO> selectAll() throws Exception;
	List<Map<String, Object>> getPostsByBoardId(String boardId) throws Exception;
}
