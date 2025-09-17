package egovframework.example.admin.boards.service.impl;

import java.util.List;
import java.util.Map;

import javax.ws.rs.POST;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.example.admin.boards.service.BoardsVO;
import egovframework.example.admin.boards.service.PostVO;

@Mapper("boardsMapper")
public interface boardsMapper {
	List<BoardsVO> selectAll();
	List<Map<String, Object>> findByBoard(
	        @Param("boardId") String boardId,
	        @Param("size") int size,
	        @Param("offset") int offset
	    );
	int countByBoard(String boardId);
	PostVO getPostDetail(String postId);
	Long createPost(PostVO dto);
	int updatePost(PostVO dto);
	int deletePost(Map<String,Object> param);
}