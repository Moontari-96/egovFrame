package egovframework.example.admin.files.service.impl;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.example.admin.files.service.AdminFilesVO;

@Mapper("adminFilesMapper")
public interface adminFilesMapper {
	int fileUpload(AdminFilesVO dto);
    int insertFile(AdminFilesVO dto);
    List<AdminFilesVO> getPostfiles(Long postId);
}
