package egovframework.example.admin.menu.service.impl;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.example.admin.menu.service.AdminMenuVO;

@Mapper("adminMenuMapper")
public interface adminMenuMapper {
	List<AdminMenuVO> selectMenuList();
	int saveMenu(AdminMenuVO dto);
	int updateMenu(AdminMenuVO dto);
	int deleteMenuCascade(Long menuId);
}
