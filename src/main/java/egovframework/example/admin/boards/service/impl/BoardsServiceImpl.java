package egovframework.example.admin.boards.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
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
	public List<Map<String, Object>> findByBoard(String boardId, int size, int offset, String keyword) {
		return  boardsDAO.findByBoard(boardId, size, offset, keyword);
	}
	
	@Override
	public int countByBoard(String boardId, String keyword) {
		return  boardsDAO.countByBoard(boardId, keyword);
	}
	
	@Override
	public PostVO getPostDetail(String postId) {
		return boardsDAO.getPostDetail(postId);
	}
	@Transactional // (기본: RuntimeException에서 롤백)
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
            	e.printStackTrace();
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
                    	e.printStackTrace();
                    }
                }
            }
        }
		return newPostId;
	}
	
    @Transactional(rollbackFor = Exception.class)
	@Override
	public Long updatePost(PostVO dto) {
		
    	boardsDAO.updatePost(dto);
		long postId = dto.getPostId();
		try {
			System.out.println(postId+ "postid");
			System.out.println(dto.getDeletedFileIds() + "삭제 파일");
			// 1) 삭제 요청된 기존 파일 처리 (물리 + DB)
	        if (dto.getDeletedFileIds() != null && !dto.getDeletedFileIds().isEmpty()) {
	            // 보안: 해당 게시글에 속한 파일만 가져와서 삭제
	            List<AdminFilesVO> toDelete = filesMapper.selectByIdsAndPostId(dto.getDeletedFileIds(), postId);
	            for (AdminFilesVO f : toDelete) {
	                // 물리 파일 삭제 (조용히 false 반환해도 트랜잭션엔 영향 없음)
	                fileUtil.deleteFile(f.getFilePath(), f.getFileSysname());
	            }
	            // DB 삭제
	            filesMapper.deleteByIdsAndPostId(dto.getDeletedFileIds(), postId);
	        }
	        
	        // 2) 썸네일 교체: 새 썸네일이 올라온 경우에만 처리
	        MultipartFile thumb = dto.getThumbnail();
	        System.out.println(dto.getDeletedFileIds() + "삭제 파일");
	        if (thumb != null && !thumb.isEmpty()) {
	            // (정책) 썸네일은 항상 1개만 유지 → 기존 썸네일들 물리/DB 모두 정리
	            List<AdminFilesVO> oldThumbs = filesMapper.selectThumbnailsByPostId(postId);
	            for (AdminFilesVO f : oldThumbs) {
	                fileUtil.deleteFile(f.getFilePath(), f.getFileSysname());
	            }
	            filesMapper.deleteThumbnailsByPostId(postId);

	            // 새 썸네일 저장
	            String sysname = fileUtil.saveFile(thumb);
	            AdminFilesVO vo = new AdminFilesVO();
	            vo.setPostId(postId);
	            vo.setFileOriname(thumb.getOriginalFilename());
	            vo.setFileSysname(sysname);
	            vo.setFileSize(thumb.getSize());
	            vo.setFilePath(fileUtil.getFileStorePath()); // 네가 DB에 경로 저장한다면 유지
	            vo.setFileRole("THUMBNAIL");
	            filesMapper.insertFile(vo);
	        }
	        // (참고) “썸네일을 지우기만 하고 새로 안 올린다”면,
	        // 프론트에서 기존 썸네일의 fileId를 deletedFileIds에 넣었을 것이므로 1단계에서 이미 처리됨.

	        // 3) 새 첨부 저장
	        if (dto.getAttachments() != null && !dto.getAttachments().isEmpty()) {
	            for (MultipartFile mf : dto.getAttachments()) {
	                if (mf == null || mf.isEmpty()) continue;
	                String sysname = fileUtil.saveFile(mf);
	                AdminFilesVO vo = new AdminFilesVO();
	                vo.setPostId(postId);
	                vo.setFileOriname(mf.getOriginalFilename());
	                vo.setFileSysname(sysname);
	                vo.setFileSize(mf.getSize());
	                vo.setFilePath(fileUtil.getFileStorePath());
	                vo.setFileRole("ATTACHMENT");
	                filesMapper.insertFile(vo);
	            }
	        }
		} catch (Exception e) {
			e.printStackTrace();
			// TODO: handle exception
		}
		return postId; // 필요하면 rows 대신 postId 반환
	}
	
	@Override
	public int deletePost(Map<String,Object> param) {
//		// postId
//		System.out.println("진입확인1");
//	    Long postId = (Long) param.get("postId");
//		try {
//			List<AdminFilesVO> toDelete = filesMapper.getPostfiles(postId);
//			System.out.println("진입확인2");
//            // 보안: 해당 게시글에 속한 파일만 가져와서 삭제
//            for (AdminFilesVO f : toDelete) {
//                // 물리 파일 삭제 (조용히 false 반환해도 트랜잭션엔 영향 없음)
//                fileUtil.deleteFile(f.getFilePath(), f.getFileSysname());
//            }
//            System.out.println("진입확인3");
//            // DB 삭제
//            filesMapper.deletePostId(postId);
//		} catch (Exception e) {
//			e.printStackTrace();
//			// TODO: handle exception
//		}
		return boardsDAO.deletePost(param);
	}

}
