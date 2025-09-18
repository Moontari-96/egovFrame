package egovframework.example.admin.files.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class AdminFilesVO {
	private Long fileId;
	private Long postId;
	private String filePath;
	private String fileOriname;
	private String fileSysname;
	private String fileRole;
	private Long fileSize;
    private MultipartFile thumbnail;	// 썸네일
    private List<MultipartFile> attachments;	// 첨부파일
    private List<Long> deletedFileIds;
    private LocalDateTime createdAt; // 수정일
}
