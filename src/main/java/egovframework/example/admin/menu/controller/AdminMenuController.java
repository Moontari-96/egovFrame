package egovframework.example.admin.menu.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.example.admin.menu.service.AdminMenuService;
import egovframework.example.admin.menu.service.AdminMenuVO;

@RestController
@RequestMapping("/admin/menu")
public class AdminMenuController {
    @Resource(name="menuService") // name 주의: 소문자 시작
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
    
//    @GetMapping("/mgmt.do")
//    public void mgmtView(HttpServletRequest req, HttpServletResponse res) throws Exception {
//        // 화면에 뿌릴 데이터(JSON으로 만들어서 JSP로 주입)
//        List<AdminMenuVO> list = menuService.getMenuList();
//
//        List<Map<String, Object>> simple = list.stream().map(m -> {
//            Map<String, Object> o = new HashMap<>();
//            o.put("menuId", m.getMenuId());
//            o.put("parentId", m.getParentId() == null ? 0 : m.getParentId());
//            o.put("menuName", m.getMenuName());
//            o.put("menuUrl", m.getMenuUrl());
//            o.put("menuDepth", m.getMenuDepth() == null ? 1 : m.getMenuDepth());
//            o.put("sortOrder", m.getSortOrder() == null ? 0 : m.getSortOrder());
//            o.put("isActive", Boolean.TRUE.equals(m.getIsActive()));
//            return o;
//        }).collect(Collectors.toList());
//
//        String menuJson = new ObjectMapper().writeValueAsString(simple);
//
//        // 레이아웃에서 include할 경로와 모델값을 request attribute로 세팅
//        req.setAttribute("pageTitle", "메뉴 관리");
//        req.setAttribute("menuJson", menuJson);
//        req.setAttribute("contentPage",
//            "/WEB-INF/jsp/egovframework/example/admin/menu/management/menuMgmt.jsp");
//
//        // ViewResolver를 거치지 않고 레이아웃 JSP로 직접 forward
//        req.getRequestDispatcher("/WEB-INF/jsp/layout/admin/layout.jsp").forward(req, res);
//    }
}
