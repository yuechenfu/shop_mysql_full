/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: /XSp9JRudHEoiri5TNW6aRPtirY75b4j
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
import net.shopxx.entity.AftersalesReturns;
import net.shopxx.entity.Member;
import net.shopxx.entity.Order;
import net.shopxx.exception.UnauthorizedException;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.AftersalesReturnsService;
import net.shopxx.service.AftersalesService;
import net.shopxx.service.OrderService;

/**
 * Controller - 退货
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Controller("memberAftersalesReturnsController")
@RequestMapping("/member/aftersales_returns")
public class AftersalesReturnsController extends BaseController {

	@Inject
	private AftersalesReturnsService aftersalesReturnsService;
	@Inject
	private OrderService orderService;
	@Inject
	private AftersalesService aftersalesService;

	/**
	 * 添加属性
	 */
	@ModelAttribute
	public void populateModel(Long aftersalesReturnsId, Long orderId, @CurrentUser Member currentUser, ModelMap model) {
		AftersalesReturns aftersalesReturns = aftersalesReturnsService.find(aftersalesReturnsId);
		if (aftersalesReturns != null && !currentUser.equals(aftersalesReturns.getMember())) {
			throw new UnauthorizedException();
		}
		Order order = orderService.find(orderId);
		if (order != null && !currentUser.equals(order.getMember())) {
			throw new UnauthorizedException();
		}
		model.addAttribute("aftersalesReturns", aftersalesReturns);
		model.addAttribute("order", order);
	}

	/**
	 * 退货
	 */
	@PostMapping("/returns")
	public ResponseEntity<?> returns(@ModelAttribute("aftersalesReturnsForm") AftersalesReturns aftersalesReturnsForm, @ModelAttribute(binding = false) Order order) {
		if (order == null) {
			return Results.UNPROCESSABLE_ENTITY;
		}

		aftersalesService.filterNotActiveAftersalesItem(aftersalesReturnsForm);
		if (aftersalesService.existsIllegalAftersalesItems(aftersalesReturnsForm.getAftersalesItems())) {
			return Results.UNPROCESSABLE_ENTITY;
		}

		aftersalesReturnsForm.setStatus(Aftersales.Status.PENDING);
		aftersalesReturnsForm.setMember(order.getMember());
		aftersalesReturnsForm.setStore(order.getStore());

		if (!isValid(aftersalesReturnsForm)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		aftersalesReturnsService.save(aftersalesReturnsForm);
		return Results.OK;
	}

}