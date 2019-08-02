/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: RLlzz2Xu/fUc+yByw7qKX2A8nFTbo1O2
 */
package net.shopxx.controller.business;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import net.shopxx.Pageable;
import net.shopxx.Results;
import net.shopxx.Setting;
import net.shopxx.entity.Aftersales;
import net.shopxx.entity.Store;
import net.shopxx.exception.UnauthorizedException;
import net.shopxx.security.CurrentStore;
import net.shopxx.service.AftersalesService;
import net.shopxx.service.OrderShippingService;
import net.shopxx.util.SystemUtils;

/**
 * Controller - 售后
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Controller("businessAftersalesController")
@RequestMapping("business/aftersales")
public class AftersalesController extends BaseController {

	@Inject
	private AftersalesService aftersalesService;
	@Inject
	private OrderShippingService orderShippingService;

	/**
	 * 添加属性
	 */
	@ModelAttribute
	public void populateModel(Long aftersalesId, @CurrentStore Store currentStore, ModelMap model) {
		Aftersales aftersales = aftersalesService.find(aftersalesId);
		if (aftersales != null && !currentStore.equals(aftersales.getStore())) {
			throw new UnauthorizedException();
		}
		model.addAttribute("aftersales", aftersales);
	}

	/**
	 * 物流动态
	 */
	@GetMapping("/transit_step")
	public ResponseEntity<?> transitStep(@ModelAttribute(binding = false) Aftersales aftersales, @CurrentStore Store currentStore) {
		Map<String, Object> data = new HashMap<>();

		Setting setting = SystemUtils.getSetting();
		if (StringUtils.isEmpty(setting.getKuaidi100Customer()) || StringUtils.isEmpty(setting.getKuaidi100Key()) || StringUtils.isEmpty(aftersales.getDeliveryCorpCode()) || StringUtils.isEmpty(aftersales.getTrackingNo())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		data.put("transitSteps", orderShippingService.getTransitSteps(aftersales.getDeliveryCorpCode(), aftersales.getTrackingNo()));
		return ResponseEntity.ok(data);
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Aftersales.Type type, Aftersales.Status status, @CurrentStore Store currentStore, Pageable pageable, ModelMap model) {
		model.addAttribute("types", Aftersales.Type.values());
		model.addAttribute("statuses", Aftersales.Status.values());
		model.addAttribute("type", type);
		model.addAttribute("status", status);
		model.addAttribute("page", aftersalesService.findPage(type, status, null, currentStore, pageable));
		return "business/aftersales/list";
	}

	/**
	 * 查看
	 */
	@GetMapping("/view")
	public String view(@ModelAttribute(binding = false) Aftersales aftersales, ModelMap model) {
		if (aftersales == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (CollectionUtils.isEmpty(aftersales.getOrderItems())) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		Setting setting = SystemUtils.getSetting();
		model.addAttribute("isKuaidi100Enabled", StringUtils.isNotEmpty(setting.getKuaidi100Customer()) && StringUtils.isNotEmpty(setting.getKuaidi100Key()));
		model.addAttribute("aftersales", aftersales);
		return "business/aftersales/view";
	}

	/**
	 * 审核
	 */
	@PostMapping("/review")
	public ResponseEntity<?> review(@ModelAttribute(binding = false) Aftersales aftersales, boolean passed) {
		if (aftersales == null) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (!Aftersales.Status.PENDING.equals(aftersales.getStatus())) {
			return Results.UNPROCESSABLE_ENTITY;
		}

		aftersalesService.review(aftersales, passed);
		return Results.OK;
	}

	/**
	 * 完成
	 */
	@PostMapping("/complete")
	public ResponseEntity<?> complete(@ModelAttribute(binding = false) Aftersales aftersales) {
		if (aftersales == null) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (!Aftersales.Status.APPROVED.equals(aftersales.getStatus())) {
			return Results.UNPROCESSABLE_ENTITY;
		}

		aftersalesService.complete(aftersales);
		return Results.OK;
	}

}