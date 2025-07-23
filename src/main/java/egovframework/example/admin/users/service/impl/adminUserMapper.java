package egovframework.example.admin.users.service.impl;

import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.example.admin.users.service.AdminUserVO;

@Mapper("adminUserMapper")
public interface adminUserMapper {
	// ID로 관리자 정보 조회
	AdminUserVO loginAdminCheck(Map<String, String> params);
}
