package egovframework.example.korea.menu.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.example.korea.menu.service.MenuService;

@Controller
@RequestMapping("/home/menu")
public class MenuController {
	@Resource(name="menuService") private MenuService menuService;
	@RequestMapping("/header.do")
    public String header(Model model) {
		model.addAttribute("menuList", menuService.getActiveMenuFlat());
		return "/layout/homepage/header"; // viewResolver 사용
	}
}
