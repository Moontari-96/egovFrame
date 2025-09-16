package egovframework.example.korea.menu.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.example.korea.menu.service.MenuService;
import egovframework.example.korea.menu.service.MenuVO;
@Service("menuService")
public class MenuServiceImpl extends EgovAbstractServiceImpl implements MenuService{
	@Resource(name="menuMapper") menuMapper mapper;
    
	@Override
    public List<MenuVO> getActiveMenuFlat() {
        return mapper.selectActiveAll(); // 매요청 DB조회(즉시 반영)
    }
}
