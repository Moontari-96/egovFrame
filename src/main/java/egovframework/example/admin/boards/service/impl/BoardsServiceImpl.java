package egovframework.example.admin.boards.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.example.admin.boards.service.BoardsService;
import egovframework.example.admin.boards.service.BoardsVO;

@Service("boardsService")
public class BoardsServiceImpl extends EgovAbstractServiceImpl implements BoardsService {
	@Resource(name="boardsMapper")
	boardsMapper boardsDAO;
	@Override
	public List<BoardsVO> selectAll() {
		return boardsDAO.selectAll();
	}
}
