/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: u8o+j6QnNiY+pFnayBItUx9edsr0N18T
 */
package net.shopxx.controller.member;

import javax.inject.Inject;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import net.shopxx.Results;
import net.shopxx.entity.Aftersales;
import net.shopxx.entity.AftersalesRepair;
import net.shopxx.entity.Area;
import net.shopxx.entity.Member;
import net.shopxx.entity.Order;
import net.shopxx.exception.UnauthorizedException;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.AftersalesRepairService;
import net.shopxx.service.AftersalesService;
import net.shopxx.service.AreaService;
import net.shopxx.service.OrderService;

/**
 * Controller - 维修
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Controller("memberAftersalesRepairController")
@RequestMapping("/member/aftersales_repair")
public class AftersalesRepairController extends BaseController {

	@Inject
	private AftersalesRepairService aftersalesRepairService;
	@Inject
	private OrderService orderService;
	@Inject
	private AftersalesService aftersalesService;
	@Inject
	private AreaService areaService;

	/**
	 * 添加属性
	 */
	@ModelAttribute
	public void populateModel(Long aftersalesRepairId, Long orderId, @CurrentUser Member currentUser, ModelMap model) {
		AftersalesRepair aftersalesRepair = aftersalesRepairService.find(aftersalesRepairId);
		if (aftersalesRepair != null && !currentUser.equals(aftersalesRepair.getMember())) {
			throw new UnauthorizedException();
		}
		Order order = orderService.find(orderId);
		if (order != null && !currentUser.equals(order.getMember())) {
			throw new UnauthorizedException();
		}
		model.addAttribute("aftersalesRepair", aftersalesRepair);
		model.addAttribute("order", order);
	}

	/**
	 * 维修
	 */
	@PostMapping("/repair")
	public ResponseEntity<?> repair(@ModelAttribute("aftersalesRepairForm") AftersalesRepair aftersalesRepairForm, @ModelAttribute(binding = false) Order order, Long areaId) {
		if (order == null) {
			return Results.UNPROCESSABLE_ENTITY;
		}

		aftersalesService.filterNotActiveAftersalesItem(aftersalesRepairForm);
		if (aftersalesService.existsIllegalAftersalesItems(aftersalesRepairForm.getAftersalesItems())) {
			return Results.UNPROCESSABLE_ENTITY;
		}

		Area area = areaService.find(areaId);
		aftersalesRepairForm.setStatus(Aftersales.Status.PENDING);
		aftersalesRepairForm.setArea(area);
		aftersalesRepairForm.setMember(order.getMember());
		aftersalesRepairForm.setStore(order.getStore());

		if (!isValid(aftersalesRepairForm)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		aftersalesRepairService.save(aftersalesRepairForm);
		return Results.OK;
	}

}