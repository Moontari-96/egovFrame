package egovframework.example.admin.boards.service;

import java.util.List;
import java.util.Map;

public interface BoardsService {
	List<BoardsVO> selectAll() throws Exception;
	int countByBoard(String boardId, String keyword) throws Exception;
	List<Map<String, Object>> findByBoard(String boardId, int size, int offset, String keyword) throws Exception;
	PostVO getPostDetail(String postId) throws Exception;
	Long createPost(PostVO dto) throws Exception;
	Long updatePost(PostVO dto) throws Exception;
	int deletePost(Map<String,Object> param) throws Exception;
}
