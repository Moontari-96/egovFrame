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
public class BoardsVO {
    private Long boardsSeq;	// 시퀀스 (보조 키)
    private String id;	// 게시글 UUID
    private String title;	// 제목
    private String content;	// 내용
    private String writerId;	// 사용자 UUID
    private LocalDateTime createdAt; // 생성일 
    private LocalDateTime updatedAt; // 수정일
}
