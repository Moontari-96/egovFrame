package egovframework.example.admin.boards.service;

import java.time.LocalDateTime;

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
    private String title;	// 수정자
    private String content;	// 수정자
    private Long  views;	// 수정자
    private String status;	// 수정자
    private Boolean notice;	// 수정자
    private LocalDateTime createdAt; // 생성일 
    private LocalDateTime updatedAt; // 수정일
}
