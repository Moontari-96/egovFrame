package egovframework.example.admin.boards.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PostVO {
    private Long postId;	// 시퀀스
    private String boardId;	// 게시판 이름
    private String createdById;	// 작성자
    private String updateById;	// 수정자
    private String title;	// 제목
    private String content;	// 내용
    private Long  views;	// 조회수
    private String status;	// 상태
    private Boolean notice;	// 공지 여부
    private MultipartFile thumbnail;	// 썸네일
    private List<MultipartFile> attachments;	// 첨부파일
    private LocalDateTime createdAt; // 생성일 
    private LocalDateTime updatedAt; // 수정일
}
