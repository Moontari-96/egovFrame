package egovframework.example.admin.menu.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
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
    
    @PostMapping(value = "/saveMenu.do", produces = "application/json")
    public ResponseEntity<Map<String, Object>> saveMenu(
            @RequestBody Map<String, List<Map<String, Object>>> payload) {

        try {
            List<Map<String, Object>> rows = payload.get("rows");
            List<Map<String, Object>> updated = new ArrayList<>();

            for (Map<String, Object> row : rows) {
                // clientTempId도 받아둬야 프론트에서 음수ID 매핑 가능
                Long clientTempId = toLong(row.get("clientTempId"));

                AdminMenuVO vo = new AdminMenuVO();
                vo.setMenuId(   toLong(row.get("menuId")));
                vo.setParentId( toLong(row.get("parentId")));
                vo.setBoardId(  toLong(row.get("boardId"))); // null 허용/검증 필요 시 toNullableFk 사용
                vo.setMenuName( (String) row.get("menuName"));
                vo.setMenuUrl(  (String) row.get("menuUrl"));
                vo.setMenuDepth(toLong(row.get("menuDepth")));   // VO 타입에 맞게 Long/Integer
                vo.setSortOrder(toLong(row.get("sortOrder")));
                vo.setIsActive( row.get("isActive") != null && Boolean.parseBoolean(row.get("isActive").toString()));

                if (vo.getMenuId() != null && vo.getMenuId() > 0) {
                	// INSERT: PK 생성 후 반환 (MyBatis면 useGeneratedKeys=true, keyProperty="menuId")
                	if (vo.getParentId() != null && vo.getParentId() == 0L) {
                	    vo.setParentId(null);
                	}
                    menuService.updateMenu(vo);
                    // 업데이트는 updated 없어도 프론트가 동작함
                } else {
                    // INSERT: PK 생성 후 반환 (MyBatis면 useGeneratedKeys=true, keyProperty="menuId")
                	if (vo.getParentId() != null && vo.getParentId() == 0L) {
                	    vo.setParentId(null);
                	}
                	System.out.println(vo.getParentId() + "형태확인");
                    menuService.saveMenu(vo);
                    Long newId = vo.getMenuId(); // 또는 service가 리턴해주면 그 값
                    Map<String, Object> u = new HashMap<>();
                    if (clientTempId != null) u.put("clientTempId", clientTempId);
                    u.put("menuId", newId);
                    updated.add(u);
                }
            }

            Map<String, Object> res = new HashMap<>();
            res.put("success", true);
            if (!updated.isEmpty()) res.put("updated", updated);
            return ResponseEntity.ok(res);

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.ok(Map.of(
                "success", false,
                "message", e.getMessage()
            ));
        }
    }  
    
	// DELETE /admin/menu/deleteMenu/16
    @PostMapping(value = "/deleteMenu.do", produces = "text/plain; charset=UTF-8")
    public ResponseEntity<String> deleteMenu(@RequestParam("menuId") Long menuId) {
        System.out.println("[DELETE-POST] menuId=" + menuId);
        int count = menuService.deleteMenuCascade(menuId); // ON DELETE CASCADE or 재귀 삭제
        return ResponseEntity.ok(count > 0 ? "OK" : "Delete_FAILED");
    }
    
    //타입변경 
    private Long toLong(Object v) {
        if (v == null) return null;
        if (v instanceof Number) return ((Number) v).longValue();
        String s = v.toString().trim();
        if (s.isEmpty()) return null;           // 빈 문자열은 null 취급
        return Long.parseLong(s);
    }
}
