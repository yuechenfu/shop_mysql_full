/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: ZpWf0jr706G4FzL/yb8aJOD+YM8A3/Z4
 */
package net.shopxx.controller.admin;

import javax.inject.Inject;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import net.shopxx.Pageable;
import net.shopxx.Results;
import net.shopxx.entity.DistributionCash;
import net.shopxx.service.DistributionCashService;

/**
 * Controller - 分销提现
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Controller("adminDistributionCashController")
@RequestMapping("/admin/distribution_cash")
public class DistributionCashController extends BaseController {

	@Inject
	private DistributionCashService distributionCashService;

	/**
	 * 审核
	 */
	@PostMapping("/review")
	public ResponseEntity<?> review(Long id, Boolean isPassed) {
		DistributionCash distributionCash = distributionCashService.find(id);
		if (isPassed == null || distributionCash == null || !DistributionCash.Status.PENDING.equals(distributionCash.getStatus())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		distributionCashService.review(distributionCash, isPassed);
		return Results.OK;
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(DistributionCash.Status status, Pageable pageable, ModelMap model) {
		model.addAttribute("status", status);
		model.addAttribute("page", distributionCashService.findPage(status, null, null, null, null, pageable));
		return "admin/distribution_cash/list";
	}

}