/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: CpxZQ9KCRiBZyzPoerxaiF5eDePCYqaF
 */
package net.shopxx.controller.member;

import javax.inject.Inject;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import net.shopxx.Pageable;
import net.shopxx.Results;
import net.shopxx.entity.Member;
import net.shopxx.entity.SocialUser;
import net.shopxx.exception.UnauthorizedException;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.SocialUserService;

/**
 * Controller - 社会化用户
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Controller("memberSocialUserController")
@RequestMapping("/member/social_user")
public class SocialUserController extends BaseController {

	/**
	 * 每页记录数
	 */
	private static final int PAGE_SIZE = 10;

	@Inject
	private SocialUserService socialUserService;

	/**
	 * 添加属性
	 */
	@ModelAttribute
	public void populateModel(Long socialUserId, @CurrentUser Member currentUser, ModelMap model) {
		SocialUser socialUser = socialUserService.find(socialUserId);
		if (socialUser != null && !currentUser.equals(socialUser.getUser())) {
			throw new UnauthorizedException();
		}
		model.addAttribute("socialUser", socialUser);
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Integer pageNumber, @CurrentUser Member currentUser, ModelMap model) {
		Pageable pageable = new Pageable(pageNumber, PAGE_SIZE);
		model.addAttribute("page", socialUserService.findPage(currentUser, pageable));
		return "member/social_user/list";
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public ResponseEntity<?> delete(@ModelAttribute(binding = false) SocialUser socialUser) {
		if (socialUser == null) {
			return Results.NOT_FOUND;
		}

		socialUserService.delete(socialUser);
		return Results.OK;
	}

}