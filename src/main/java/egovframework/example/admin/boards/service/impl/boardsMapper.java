package egovframework.example.admin.boards.service.impl;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.example.admin.boards.service.BoardsVO;
import egovframework.example.admin.boards.service.PostVO;

@Mapper("boardsMapper")
public interface boardsMapper {
	List<BoardsVO> selectAll();
	List<Map<String, Object>> getPostsByBoardId(String boardId);
}