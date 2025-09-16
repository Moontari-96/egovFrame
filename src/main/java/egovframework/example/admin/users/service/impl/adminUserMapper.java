package egovframework.example.admin.users.service.impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.example.admin.users.service.AdminUserVO;
import egovframework.example.admin.users.service.RolesVO;

@Mapper("adminUserMapper")
public interface AdminUserMapper {
	// ID로 관리자 정보 조회
	AdminUserVO loginAdminCheck(Map<String, String> params);
	
	// 관리자 카운트
	int countByAdmin();
	
	// 관리자 목록 조회
	List<Map<String, Object>> findByAdmin(@Param("size") int size, @Param("offset") int offset);
	
	// 관리자 상세
	Map<String, Object> findOneAdmin(Long id);
	
	// 권한목록
	List<RolesVO> findRole();
	
	// 관리자 아이디 중복체크
	int checkId(String userId);
	
	// 관리자 계정 생성
	Long adminCreate(AdminUserVO dto);
	
	// 관리자 권한 매핑
	int insertAdminRoleMap(@Param("userId") Long userId, @Param("roleId") Long roleId);
	
	// 관리자 계정 삭제
	int deleteAdmin(Long id);
	
	// 관리자 수정
	int adminUpdate(AdminUserVO dto);
	
	// 관리자 권한 매핑 수정
	int updateAdminRoleMap(@Param("userId") Long userId, @Param("roleId") Long roleId);

	// 사용자 카운트
	int countByUser();
	
	// 사용자 목록 조회
	List<Map<String, Object>> findByUser(@Param("size") int size, @Param("offset") int offset);
	
	// 사용자 상세
	Map<String, Object> findOneUser(Long id);
	
	// 사용자 계정 삭제
	int deleteUser(Long id);
	
	// 사용자 수정
	int userUpdate(AdminUserVO dto);
}
