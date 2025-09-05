package egovframework.example.admin.menu.service.impl;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.example.admin.menu.service.AdminMenuVO;

@Mapper("AdminMenuMapper")
public interface AdminMenuMapper {
	List<AdminMenuVO> selectMenuList();
}
