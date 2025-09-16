package egovframework.example.admin.users.service.impl;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.example.admin.users.service.AdminUserService;
import egovframework.example.admin.users.service.AdminUserVO;
import egovframework.example.admin.users.service.RolesVO;
import egovframework.example.cmmn.util.sha256Util;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("UserService")
public class AdminUserServiceImpl extends EgovAbstractServiceImpl implements AdminUserService {

	@Resource(name="adminUserMapper")
	AdminUserMapper userMapper;
	
	@Override
    public AdminUserVO selectAdminUserById(String id, String password) throws Exception {
        // 비밀번호 SHA-256 암호화
        String encryptedPassword = sha256Util.encrypt(password);

        Map<String, String> param = new HashMap<>();
        param.put("id", id);
        param.put("password", encryptedPassword);
        System.out.println(param + "확인용");
        return userMapper.loginAdminCheck(param); // MyBatis에서 검증
    }
	
	// 관리자 카운트
	@Override
	public int countByAdmin() throws Exception {
		return userMapper.countByAdmin();
	}
	
	// 관리자 목록조회
	@Override
	public List<Map<String, Object>> findByAdmin(int size, int offset) throws Exception {
		return userMapper.findByAdmin(size, offset); 
	}
	
	// 관리자 상세
	@Override
	public Map<String, Object> findOneAdmin(Long id) throws Exception {
		return userMapper.findOneAdmin(id); 
	}
	
	// 권한 목록	
	@Override
	public List<RolesVO> findRole() throws Exception {
		return userMapper.findRole(); 
	}
	
	// 관리자 아이디 중복체크 	
	@Override
	public int checkId(String userId) throws Exception {
		return userMapper.checkId(userId); 
	}
	
	// 관리자 계정 생성	
	@Override
	public Long adminCreate(AdminUserVO dto) throws Exception {
		// 비밀번호 SHA-256 암호화
		String password = dto.getUserPw();
        String encryptedPassword = sha256Util.encrypt(password);
        dto.setUserPw(encryptedPassword);
		return userMapper.adminCreate(dto); 
	}
	
	// 관리자 권한 매핑 	
	@Override
	public int insertAdminRoleMap(Long userId, Long roleId) throws Exception {
		return userMapper.insertAdminRoleMap(userId, roleId); 
	}
	
	// 관리자 계정 삭제
	@Override
	public int deleteAdmin(Long userId) throws Exception {
		return userMapper.deleteAdmin(userId); 
	}
	
	// 관리자 계정 수정
	@Override
	public int adminUpdate(AdminUserVO dto) throws Exception {
		String raw = dto.getUserPw();
	    if (raw != null && !raw.isBlank()) {          // 비번 입력됨 → 해시 후 세팅
	        dto.setUserPw(sha256Util.encrypt(raw));
	    } else {                                      // 비번 미입력 → null 로 보내기
	        dto.setUserPw(null);
	    }
		return userMapper.adminUpdate(dto); 
	}
	
	// 관리자 권한 매핑 수정 	
	@Override
	public int updateAdminRoleMap(Long userId, Long roleId) throws Exception {
		return userMapper.updateAdminRoleMap(userId, roleId); 
	}
	
	// 사용자 카운트
	@Override
	public int countByUser() throws Exception {
		return userMapper.countByUser();
	}
	
	// 사용자 목록조회
	@Override
	public List<Map<String, Object>> findByUser(int size, int offset) throws Exception {
		return userMapper.findByUser(size, offset); 
	}
	
	// 사용자 상세
	@Override
	public Map<String, Object> findOneUser(Long id) throws Exception {
		return userMapper.findOneUser(id); 
	}
	
	// 사용자 계정 삭제
	@Override
	public int deleteUser(Long userId) throws Exception {
		return userMapper.deleteUser(userId); 
	}
	
	// 사용자 계정 수정
	@Override
	public int userUpdate(AdminUserVO dto) throws Exception {
		String raw = dto.getUserPw();
	    if (raw != null && !raw.isBlank()) {          // 비번 입력됨 → 해시 후 세팅
	        dto.setUserPw(sha256Util.encrypt(raw));
	    } else {                                      // 비번 미입력 → null 로 보내기
	        dto.setUserPw(null);
	    }
		return userMapper.userUpdate(dto); 
	}
	
}
