package egovframework.example.admin.boards.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import egovframework.example.admin.boards.service.BoardsService;
import egovframework.example.admin.boards.service.BoardsVO;
import egovframework.example.admin.boards.service.PostVO;
import egovframework.example.admin.files.service.AdminFilesVO;
import egovframework.example.admin.files.service.impl.adminFilesMapper;
import egovframework.example.cmmn.util.FileUtil;

@Service("boardsService")
public class BoardsServiceImpl extends EgovAbstractServiceImpl implements BoardsService {
	@Resource(name="boardsMapper")
	boardsMapper boardsDAO;
	
	@Resource(name="adminFilesMapper")
	adminFilesMapper filesMapper;
	
    // FileUtil을 주입받습니다.
    @Autowired
    private FileUtil fileUtil;
    
 
	@Override
	public List<BoardsVO> selectAll() {
		return boardsDAO.selectAll();
	}
	
	@Override
	public List<Map<String, Object>> findByBoard(String boardId, int size, int offset) {
		return  boardsDAO.findByBoard(boardId, size, offset);
	}
	
	@Override
	public int countByBoard(String boardId) {
		return  boardsDAO.countByBoard(boardId);
	}
	
	@Override
	public PostVO getPostDetail(String postId) {
		return boardsDAO.getPostDetail(postId);
	}
	
	@Override
	public Long createPost(PostVO dto) {
		boardsDAO.createPost(dto);
        Long newPostId = dto.getPostId(); // insert 후, mybatis에서 <selectKey>를 통해 게시글 ID를 받아옵니다.
        // 2. 썸네일 파일 처리
        System.out.println(fileUtil.getFileStorePath() + "값 확인좀 하자");
        if (dto.getThumbnail() != null && !dto.getThumbnail().isEmpty()) {
            try {
                String fileName = fileUtil.saveFile(dto.getThumbnail());
                
                // 여기서 AdminFilesVO 객체를 생성하여 매퍼에 전달합니다.
                AdminFilesVO thumbFileDto = new AdminFilesVO();
                thumbFileDto.setPostId(dto.getPostId());
                thumbFileDto.setFileOriname(dto.getThumbnail().getOriginalFilename());
                thumbFileDto.setFileSysname(fileName);
                thumbFileDto.setFileSize(dto.getThumbnail().getSize());
                thumbFileDto.setFilePath(fileUtil.getFileStorePath());
                thumbFileDto.setFileRole("THUMBNAIL");
                filesMapper.insertFile(thumbFileDto);
            } catch (Exception e) {
                // 예외 처리
            }
        }
        
        // 3. 첨부파일 목록 처리
        if (dto.getAttachments() != null && !dto.getAttachments().isEmpty()) {
            for (MultipartFile file : dto.getAttachments()) {
                if (!file.isEmpty()) {
                    try {
                        String fileName = fileUtil.saveFile(file);
                        
                        // 각 첨부파일에 대해 AdminFilesVO 객체를 생성하여 매퍼에 전달합니다.
                        AdminFilesVO fileDto = new AdminFilesVO();
                        fileDto.setPostId(dto.getPostId());
                        fileDto.setFileOriname((file.getOriginalFilename()));;
                        fileDto.setFileSysname(fileName);
                        fileDto.setFileSize(file.getSize());
                        fileDto.setFilePath(fileUtil.getFileStorePath());
                        filesMapper.insertFile(fileDto);
                    } catch (Exception e) {
                        // 예외 처리
                    }
                }
            }
        }
		return newPostId;
	}
	
	@Override
	public int updatePost(PostVO dto) {
		return boardsDAO.updatePost(dto);
	}
	
	@Override
	public int deletePost(Map<String,Object> param) {
		return boardsDAO.deletePost(param);
	}

}
