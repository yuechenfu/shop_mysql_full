/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: 4miVJQTnpcHftxKPUrtr6MGrEF5kVrVF
 */
package net.shopxx.controller.admin;

import java.util.HashSet;

import javax.inject.Inject;

import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import net.shopxx.Pageable;
import net.shopxx.Results;
import net.shopxx.audit.Audit;
import net.shopxx.entity.Admin;
import net.shopxx.entity.BaseEntity;
import net.shopxx.service.AdminService;
import net.shopxx.service.RoleService;
import net.shopxx.service.UserService;

/**
 * Controller - 管理员
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Controller("adminAdminController")
@RequestMapping("/admin/admin")
public class AdminController extends BaseController {

	@Inject
	private AdminService adminService;
	@Inject
	private UserService userService;
	@Inject
	private RoleService roleService;

	/**
	 * 检查用户名是否存在
	 */
	@GetMapping("/check_username")
	public @ResponseBody boolean checkUsername(String username) {
		return StringUtils.isNotEmpty(username) && !adminService.usernameExists(username);
	}

	/**
	 * 检查E-mail是否唯一
	 */
	@GetMapping("/check_email")
	public @ResponseBody boolean checkEmail(Long id, String email) {
		return StringUtils.isNotEmpty(email) && adminService.emailUnique(id, email);
	}

	/**
	 * 检查手机是否唯一
	 */
	@GetMapping("/check_mobile")
	public @ResponseBody boolean checkMobile(Long id, String mobile) {
		return StringUtils.isNotEmpty(mobile) && adminService.mobileUnique(id, mobile);
	}

	/**
	 * 添加
	 */
	@GetMapping("/add")
	public String add(ModelMap model) {
		model.addAttribute("roles", roleService.findAll());
		return "admin/admin/add";
	}

	/**
	 * 保存
	 */
	@Audit(action = "auditLog.action.admin.admin.save")
	@PostMapping("/save")
	public ResponseEntity<?> save(Admin admin, Long[] roleIds) {
		admin.setRoles(new HashSet<>(roleService.findList(roleIds)));
		if (!isValid(admin, BaseEntity.Save.class)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (adminService.usernameExists(admin.getUsername())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (adminService.emailExists(admin.getEmail())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (adminService.mobileExists(admin.getMobile())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		admin.setIsLocked(false);
		admin.setLockDate(null);
		admin.setLastLoginIp(null);
		admin.setLastLoginDate(null);
		admin.setPaymentTransactions(null);
		admin.setUser1MessageGroups(null);
		admin.setToMessages(null);
		admin.setAuditLogs(null);
		admin.setSocialUsers(null);
		admin.setUser2MessageGroups(null);
		admin.setFromMessages(null);
		adminService.save(admin);
		return Results.OK;
	}

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit(Long id, ModelMap model) {
		model.addAttribute("roles", roleService.findAll());
		model.addAttribute("admin", adminService.find(id));
		return "admin/admin/edit";
	}

	/**
	 * 更新
	 */
	@Audit(action = "auditLog.action.admin.admin.update")
	@PostMapping("/update")
	public ResponseEntity<?> update(Admin admin, Long id, Long[] roleIds, Boolean unlock) {
		admin.setRoles(new HashSet<>(roleService.findList(roleIds)));
		if (!isValid(admin)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (!adminService.emailUnique(id, admin.getEmail())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (!adminService.mobileUnique(id, admin.getMobile())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		Admin pAdmin = adminService.find(id);
		if (pAdmin == null) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (BooleanUtils.isTrue(pAdmin.getIsLocked()) && BooleanUtils.isTrue(unlock)) {
			userService.unlock(admin);
			adminService.update(admin, "username", "encodedPassword", "lastLoginIp", "lastLoginDate", "paymentTransactions");
		} else {
			adminService.update(admin, "username", "encodedPassword", "isLocked", "lockDate", "lastLoginIp", "lastLoginDate", "paymentTransactions");
		}
		return Results.OK;
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Pageable pageable, ModelMap model) {
		model.addAttribute("page", adminService.findPage(pageable));
		return "admin/admin/list";
	}

	/**
	 * 删除
	 */
	@Audit(action = "auditLog.action.admin.admin.delete")
	@PostMapping("/delete")
	public ResponseEntity<?> delete(Long[] ids) {
		if (ids.length >= adminService.count()) {
			return Results.unprocessableEntity("common.deleteAllNotAllowed");
		}
		adminService.delete(ids);
		return Results.OK;
	}

}