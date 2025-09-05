package egovframework.example.admin.menu.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import egovframework.example.admin.menu.service.AdminMenuService;
import egovframework.example.admin.menu.service.AdminMenuVO;

@RestController
@RequestMapping("/admin/menu")
public class AdminMenuController {
    @Resource(name="MenuService") // name 주의: 소문자 시작
    private AdminMenuService menuService;
    
//    @GetMapping("/menu.do")
//    public List<AdminMenuVO> getMenuList() {
//        System.out.println(menuService.getMenuList() + "메뉴확인");
//        return menuService.getMenuList();
//    }
    @GetMapping("/menu.do")
    public List<Map<String, Object>> getMenuList() {
        List<AdminMenuVO> menuList = menuService.getMenuList();

        // VO → Map 변환 (LocalDateTime 등 안전하게 문자열 처리)
        List<Map<String, Object>> result = menuList.stream().map(menu -> {
            Map<String, Object> map = new HashMap<>();
            map.put("menuId", menu.getMenuId());
            map.put("parentId", menu.getParentId());
            map.put("boardId", menu.getBoardId());
            map.put("menuName", menu.getMenuName());
            map.put("menuUrl", menu.getMenuUrl());
            map.put("menuDepth", menu.getMenuDepth());
            map.put("sortOrder", menu.getSortOrder());
            map.put("isActive", menu.getIsActive());
            map.put("createdAt", menu.getCreatedAt() != null ? menu.getCreatedAt().toString() : null);
            map.put("updatedAt", menu.getUpdatedAt() != null ? menu.getUpdatedAt().toString() : null);
            return map;
        }).collect(Collectors.toList());

        return result;
    }
}
