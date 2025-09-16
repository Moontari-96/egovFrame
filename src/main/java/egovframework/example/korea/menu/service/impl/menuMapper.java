package egovframework.example.korea.menu.service.impl;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.example.korea.menu.service.MenuVO;

@Mapper("menuMapper")
public interface menuMapper {
	List<MenuVO> selectActiveAll();
}
