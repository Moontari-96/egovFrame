package egovframework.example.admin.files.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.example.admin.boards.service.BoardsVO;
import egovframework.example.admin.files.service.AdminFilesService;
import egovframework.example.admin.files.service.AdminFilesVO;

@Service("adminFilesService")
public class AdminFilesSerivceImpl extends EgovAbstractServiceImpl implements AdminFilesService {
	@Resource(name="adminFilesMapper")
	adminFilesMapper mapper;
	
	@Override
	public int fileUpload(AdminFilesVO dto) throws Exception{
		return mapper.fileUpload(dto);
	}
	
	@Override
	public List<AdminFilesVO> getPostfiles(Long postId) throws Exception{
		return mapper.getPostfiles(postId);
	}
}
