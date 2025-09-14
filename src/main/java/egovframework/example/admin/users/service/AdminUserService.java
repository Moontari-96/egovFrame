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
}
