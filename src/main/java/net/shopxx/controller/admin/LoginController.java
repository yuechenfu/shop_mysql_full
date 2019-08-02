/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: DH38FNKW+t7Q/8rHvnuZJPQZLqTsXpIH
 */
package net.shopxx.controller.admin;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import net.shopxx.entity.Admin;
import net.shopxx.security.CurrentUser;

/**
 * Controller - 管理员登录
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Controller("adminLoginController")
@RequestMapping("/admin")
public class LoginController extends BaseController {

	@Value("${security.admin_login_success_url}")
	private String adminLoginSuccessUrl;

	/**
	 * 登录跳转
	 */
	@GetMapping({ "", "/" })
	public String index() {
		return "redirect:/admin/login";
	}

	/**
	 * 登录页面
	 */
	@GetMapping("/login")
	public String login(@CurrentUser Admin currentUser, ModelMap model) {
		if (currentUser != null) {
			return "redirect:" + adminLoginSuccessUrl;
		}
		model.addAttribute("adminLoginSuccessUrl", adminLoginSuccessUrl);
		return "admin/login/index";
	}

}