package egovframework.example.admin.boards.service.impl;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.example.admin.boards.service.BoardsVO;

@Mapper("boardsMapper")
public interface boardsMapper {
	List<BoardsVO> selectAll();
}