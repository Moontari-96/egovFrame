package egovframework.example.korea.menu.service;

import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;

@Data
public class MenuVO {
	private Long menuId; // 메뉴 고유 ID
    private Long parentId; // 부모 메뉴 ID
    private Long boardId; // 게시판 ID
    private String menuName;
    private String menuUrl;
    private Long menuDepth; 
    private Long sortOrder; 
    private Boolean isActive; 
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createdAt;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updatedAt;
}
