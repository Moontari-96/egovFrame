package egovframework.example.admin.files.service.impl;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.example.admin.files.service.AdminFilesVO;

@Mapper("adminFilesMapper")
public interface adminFilesMapper {
	int fileUpload(AdminFilesVO dto);
    int insertFile(AdminFilesVO dto);
    List<AdminFilesVO> getPostfiles(Long postId);
    List<AdminFilesVO> selectByIdsAndPostId(@Param("ids") List<Long> ids, @Param("postId") long postId);
	int deleteByIdsAndPostId(@Param("ids") List<Long> ids, @Param("postId") long postId);
	List<AdminFilesVO> selectThumbnailsByPostId(@Param("postId") long postId);
	int deleteThumbnailsByPostId(@Param("postId") long postId);
	int deletePostId(Long postId);
}
