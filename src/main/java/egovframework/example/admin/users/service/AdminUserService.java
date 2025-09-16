package egovframework.example.admin.users.service;

import java.util.List;
import java.util.Map;

public interface AdminUserService {
	AdminUserVO selectAdminUserById(String id, String password) throws Exception;
	
	// 관리자 카운트
	int countByAdmin() throws Exception;
	
	// 관리자 목록조회
	List<Map<String, Object>> findByAdmin(int size, int offset) throws Exception;
	
	// 관리자 상세
	Map<String, Object> findOneAdmin(Long id) throws Exception;
	
	// 권한목록
	List<RolesVO> findRole() throws Exception;
	
	// 아이디 체크
	int checkId(String userId) throws Exception;
	
	// 관리자 계정생성
	Long adminCreate(AdminUserVO dto) throws Exception;
	
	// 관리자 권한매핑
	int insertAdminRoleMap(Long userId, Long roleId) throws Exception;
	
	// 관리자 삭제
	int deleteAdmin(Long id) throws Exception;
	
	// 관리자 계정 수정
	int adminUpdate(AdminUserVO dto) throws Exception;
	
	// 관리자 권한매핑
	int updateAdminRoleMap(Long userId, Long roleId) throws Exception;
	
	// 사용자 카운트
	int countByUser() throws Exception;
	
	// 사용자 목록조회
	List<Map<String, Object>> findByUser(int size, int offset) throws Exception;
	
	// 사용자 상세
	Map<String, Object> findOneUser(Long id) throws Exception;
	
	// 관리자 삭제
	int deleteUser(Long id) throws Exception;
	
	// 관리자 계정 수정
	int userUpdate(AdminUserVO dto) throws Exception;
}
