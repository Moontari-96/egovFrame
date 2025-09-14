package egovframework.example.admin.menu.service;

import java.util.List;

public interface AdminMenuService {
	List<AdminMenuVO> getMenuList();
	int saveMenu(AdminMenuVO dto);
	int updateMenu(AdminMenuVO dto);
	int deleteMenuCascade(Long menuId);
}
