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
}
