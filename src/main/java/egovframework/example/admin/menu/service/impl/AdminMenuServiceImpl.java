package egovframework.example.admin.menu.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.example.admin.menu.service.AdminMenuService;
import egovframework.example.admin.menu.service.AdminMenuVO;

@Service("menuService")
public class AdminMenuServiceImpl extends EgovAbstractServiceImpl implements AdminMenuService {
	@Resource(name="adminMenuMapper")
	adminMenuMapper menuMapper;
	
	@Override
    public List<AdminMenuVO> getMenuList() {
        return menuMapper.selectMenuList();
    }
}
