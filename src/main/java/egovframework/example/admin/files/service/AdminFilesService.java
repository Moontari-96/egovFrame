package egovframework.example.admin.files.service;

import java.util.List;

public interface AdminFilesService {
	int fileUpload(AdminFilesVO dto) throws Exception;
	List<AdminFilesVO> getPostfiles(Long postId) throws Exception;
}
