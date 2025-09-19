package egovframework.example.admin.menu.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.example.admin.menu.service.AdminMenuService;
import egovframework.example.admin.menu.service.AdminMenuVO;

@Controller
@RequestMapping("/admin/menu")
public class AdminMenuViewController {

    @Resource(name="adminMenuService")
    private AdminMenuService menuService;

    @GetMapping("/mgmt.do")
//    public String mgmtView(Model model) {
//        // UI만 잠깐 볼 거면 아래 두 줄은 생략 가능(단, JSP에서 EL 연산하면 NPE 가능)
//        List<AdminMenuVO> menuList = menuService.getMenuList();
//        model.addAttribute("menuList", menuList);
//        model.addAttribute("rowNoStart", menuList != null ? menuList.size() : 0);
//
//        model.addAttribute("pageTitle", "메뉴 관리");
//        model.addAttribute("contentPage",
//            "/WEB-INF/jsp/egovframework/example/admin/menu/management/menuMgmt.jsp");
//
//        return "layout/admin/layout"; // 앞에 슬래시 X
//    }
    public String mgmtView(Model model) throws Exception {
        List<AdminMenuVO> list = menuService.getMenuList();
        System.out.println(list);
        // 화면용으로 기본값 보정(숫자/불리언 null 방지)
        List<Map<String,Object>> simple = list.stream().map(m -> {
            Map<String,Object> o = new HashMap<>();
            o.put("menuId", m.getMenuId());
            o.put("parentId", m.getParentId() == null ? 0 : m.getParentId());
            o.put("boardId", m.getBoardId() == null ? 0 : m.getBoardId());
            o.put("menuName", m.getMenuName());
            o.put("menuCategory", m.getMenuCategory());
            o.put("menuUrl", m.getMenuUrl());
            o.put("menuDepth", m.getMenuDepth() == null ? 1 : m.getMenuDepth());
            o.put("sortOrder", m.getSortOrder() == null ? 0 : m.getSortOrder());
            o.put("isActive", Boolean.TRUE.equals(m.getIsActive()));
            return o;
        }).collect(Collectors.toList());

        String menuJson = new ObjectMapper().writeValueAsString(simple);

        model.addAttribute("menuJson", menuJson);
        model.addAttribute("pageTitle", "메뉴 관리");
        model.addAttribute("contentPage", "/WEB-INF/jsp/egovframework/example/admin/menu/management/menuMgmt.jsp");
        return "layout/admin/layout";
    }
}
