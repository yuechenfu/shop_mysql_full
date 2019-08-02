/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: 7QiZw7qPOzVOq511Y1VGzUOpLJkbZcdc
 */
package net.shopxx.controller.member;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.commons.lang.StringUtils;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fasterxml.jackson.annotation.JsonView;

import net.shopxx.Pageable;
import net.shopxx.Results;
import net.shopxx.Setting;
import net.shopxx.entity.Aftersales;
import net.shopxx.entity.AftersalesReturns;
import net.shopxx.entity.BaseEntity;
import net.shopxx.entity.DeliveryCorp;
import net.shopxx.entity.Member;
import net.shopxx.entity.Order;
import net.shopxx.exception.UnauthorizedException;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.AftersalesService;
import net.shopxx.service.DeliveryCorpService;
import net.shopxx.service.OrderService;
import net.shopxx.service.OrderShippingService;
import net.shopxx.util.SystemUtils;

/**
 * Controller - 售后
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Controller("memberAftersalesController")
@RequestMapping("/member/aftersales")
public class AftersalesController extends BaseController {

	/**
	 * 每页记录数
	 */
	private static final int PAGE_SIZE = 10;

	@Inject
	private AftersalesService aftersalesService;
	@Inject
	private OrderService orderService;
	@Inject
	private OrderShippingService orderShippingService;
	@Inject
	private DeliveryCorpService deliveryCorpService;

	/**
	 * 添加属性
	 */
	@ModelAttribute
	public void populateModel(Long aftersalesId, Long orderId, @CurrentUser Member currentUser, ModelMap model) {
		Aftersales aftersales = aftersalesService.find(aftersalesId);
		if (aftersales != null && !currentUser.equals(aftersales.getMember())) {
			throw new UnauthorizedException();
		}
		Order order = orderService.find(orderId);
		if (order != null && !currentUser.equals(order.getMember())) {
			throw new UnauthorizedException();
		}
		model.addAttribute("aftersales", aftersales);
		model.addAttribute("order", order);
	}

	/**
	 * 物流动态
	 */
	@GetMapping("/transit_step")
	public ResponseEntity<?> transitStep(@ModelAttribute(binding = false) Aftersales aftersales) {
		Map<String, Object> data = new HashMap<>();

		Setting setting = SystemUtils.getSetting();
		if (StringUtils.isEmpty(setting.getKuaidi100Customer()) || StringUtils.isEmpty(setting.getKuaidi100Key()) || StringUtils.isEmpty(aftersales.getDeliveryCorpCode()) || StringUtils.isEmpty(aftersales.getTrackingNo())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		data.put("transitSteps", orderShippingService.getTransitSteps(aftersales.getDeliveryCorpCode(), aftersales.getTrackingNo()));
		return ResponseEntity.ok(data);
	}

	/**
	 * 填写快递单
	 */
	@PostMapping("/transit_tabs")
	public ResponseEntity<?> transitTabs(@ModelAttribute(binding = false) Aftersales aftersales, Long deliveryCorpId, String trackingNo) {
		DeliveryCorp deliveryCorp = deliveryCorpService.find(deliveryCorpId);

		aftersales.setTrackingNo(trackingNo);
		aftersales.setDeliveryCorp(deliveryCorp);
		aftersales.setDeliveryCorpCode(deliveryCorp);

		aftersalesService.update(aftersales);
		return Results.OK;
	}

	/**
	 * 申请
	 */
	@GetMapping("/apply")
	public String apply(@ModelAttribute(binding = false) Order order, ModelMap model) {
		if (order == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (!Order.Type.GENERAL.equals(order.getType()) || (!Order.Status.RECEIVED.equals(order.getStatus()) && !Order.Status.COMPLETED.equals(order.getStatus()))) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		List<Aftersales> previousAftersales = aftersalesService.findList(order.getOrderItems());
		model.addAttribute("order", order);
		model.addAttribute("methods", AftersalesReturns.Method.values());
		model.addAttribute("previousAftersales", previousAftersales);
		return "member/aftersales/apply";
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Integer pageNumber, @CurrentUser Member currentUser, ModelMap model) {
		Pageable pageable = new Pageable(pageNumber, PAGE_SIZE);
		model.addAttribute("page", aftersalesService.findPage(null, null, currentUser, null, pageable));
		return "member/aftersales/list";
	}

	/**
	 * 列表
	 */
	@GetMapping(path = "/list", produces = MediaType.APPLICATION_JSON_VALUE)
	@JsonView(BaseEntity.BaseView.class)
	public ResponseEntity<?> list(Integer pageNumber, @CurrentUser Member currentUser) {
		Pageable pageable = new Pageable(pageNumber, PAGE_SIZE);
		return ResponseEntity.ok(aftersalesService.findPage(null, null, currentUser, null, pageable).getContent());
	}

	/**
	 * 查看
	 */
	@GetMapping("/view")
	public String view(@ModelAttribute(binding = false) Aftersales aftersales, ModelMap model) {
		if (aftersales == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		Setting setting = SystemUtils.getSetting();
		model.addAttribute("isKuaidi100Enabled", StringUtils.isNotEmpty(setting.getKuaidi100Customer()) && StringUtils.isNotEmpty(setting.getKuaidi100Key()));
		model.addAttribute("deliveryCorps", deliveryCorpService.findAll());
		model.addAttribute("aftersales", aftersales);
		return "member/aftersales/view";
	}

	/**
	 * 取消
	 */
	@PostMapping("/cancel")
	public ResponseEntity<?> cancel(@ModelAttribute(binding = false) Aftersales aftersales) {
		if (aftersales == null) {
			return Results.NOT_FOUND;
		}
		if (!Aftersales.Status.PENDING.equals(aftersales.getStatus()) && !Aftersales.Status.APPROVED.equals(aftersales.getStatus())) {
			return Results.UNPROCESSABLE_ENTITY;
		}

		aftersalesService.cancle(aftersales);
		return Results.OK;
	}

}