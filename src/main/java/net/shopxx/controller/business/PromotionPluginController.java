/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: lFQ52L3L5oPNkvNaa0zsXAgUv7PAa52L
 */
package net.shopxx.controller.business;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.BooleanUtils;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import net.shopxx.Pageable;
import net.shopxx.Results;
import net.shopxx.entity.Business;
import net.shopxx.entity.Promotion;
import net.shopxx.entity.PromotionPluginSvc;
import net.shopxx.entity.Store;
import net.shopxx.entity.StorePluginStatus;
import net.shopxx.plugin.PaymentPlugin;
import net.shopxx.plugin.PromotionPlugin;
import net.shopxx.security.CurrentStore;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.PluginService;
import net.shopxx.service.PromotionService;
import net.shopxx.service.StorePluginStatusService;
import net.shopxx.service.StoreService;
import net.shopxx.service.SvcService;
import net.shopxx.util.WebUtils;

/**
 * Controller - 促销插件管理
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Controller("businessPromotionPluginController")
@RequestMapping("/business/promotion_plugin")
public class PromotionPluginController extends BaseController {

	@Inject
	private PromotionService promotionService;
	@Inject
	private StoreService storeService;
	@Inject
	private PluginService pluginService;
	@Inject
	private SvcService svcService;
	@Inject
	private StorePluginStatusService storePluginStatusService;

	/**
	 * 计算
	 */
	@GetMapping("/calculate")
	public ResponseEntity<?> calculate(String promotionPluginId, String paymentPluginId, Integer months, Boolean useBalance) {
		Map<String, Object> data = new HashMap<>();
		PromotionPlugin promotionPlugin = pluginService.getPromotionPlugin(promotionPluginId);
		if (promotionPluginId == null || promotionPlugin == null || !promotionPlugin.getIsEnabled()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (months == null || months <= 0) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		BigDecimal amount = promotionPlugin.getServiceCharge().multiply(new BigDecimal(months));
		if (BooleanUtils.isTrue(useBalance)) {
			data.put("fee", BigDecimal.ZERO);
			data.put("amount", amount);
			data.put("useBalance", true);
		} else {
			PaymentPlugin paymentPlugin = pluginService.getPaymentPlugin(paymentPluginId);
			if (paymentPlugin == null || !paymentPlugin.getIsEnabled()) {
				return Results.UNPROCESSABLE_ENTITY;
			}
			data.put("fee", paymentPlugin.calculateFee(amount));
			data.put("amount", paymentPlugin.calculateAmount(amount));
			data.put("useBalance", false);
		}
		return ResponseEntity.ok(data);
	}

	/**
	 * 到期日期
	 */
	@GetMapping("/end_date")
	public @ResponseBody Map<String, Object> endDate(String promotionPluginId, @CurrentStore Store currentStore) {
		PromotionPlugin promotionPlugin = pluginService.getPromotionPlugin(promotionPluginId);
		Map<String, Object> data = new HashMap<>();
		if (promotionPlugin != null && promotionPlugin.getIsEnabled()) {
			StorePluginStatus storePluginStatus = storePluginStatusService.find(currentStore, promotionPlugin.getId());
			data.put("endDate", storePluginStatus != null ? storePluginStatus.getEndDate() : null);
		}
		return data;
	}

	/**
	 * 购买
	 */
	@GetMapping("/buy")
	public String buy(String promotionPluginId, @CurrentStore Store currentStore, ModelMap model) {
		if (currentStore.getType().equals(Store.Type.SELF)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		PromotionPlugin promotionPlugin = pluginService.getPromotionPlugin(promotionPluginId);
		if (promotionPluginId == null || promotionPlugin == null || !promotionPlugin.getIsEnabled()) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		List<PaymentPlugin> paymentPlugins = pluginService.getActivePaymentPlugins(WebUtils.getRequest());
		if (CollectionUtils.isNotEmpty(paymentPlugins)) {
			model.addAttribute("defaultPaymentPlugin", paymentPlugins.get(0));
			model.addAttribute("paymentPlugins", paymentPlugins);
		}
		StorePluginStatus storePluginStatus = storePluginStatusService.find(currentStore, promotionPlugin.getId());
		model.addAttribute("promotionPlugin", promotionPlugin);
		model.addAttribute("pluginEndDate", storePluginStatus != null ? storePluginStatus.getEndDate() : null);
		return "business/promotion_plugin/buy";
	}

	/**
	 * 购买
	 */
	@PostMapping("/buy")
	public ResponseEntity<?> buy(String promotionPluginId, Integer months, Boolean useBalance, @CurrentStore Store currentStore, @CurrentUser Business currentUser) {
		Map<String, Object> data = new HashMap<>();
		if (currentStore.getType().equals(Store.Type.SELF)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		PromotionPlugin promotionPlugin = pluginService.getPromotionPlugin(promotionPluginId);
		if (promotionPluginId == null || promotionPlugin == null || !promotionPlugin.getIsEnabled()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (months == null || months <= 0) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		int days = months * 30;
		BigDecimal amount = promotionPlugin.getServiceCharge().multiply(new BigDecimal(months));
		if (amount.compareTo(BigDecimal.ZERO) > 0) {
			if (BooleanUtils.isTrue(useBalance)) {
				if (currentUser.getAvailableBalance().compareTo(amount) < 0) {
					return Results.unprocessableEntity("business.moneyOffPromotion.insufficientBalance");
				}
				storeService.buy(currentStore, promotionPlugin, months);
			} else {
				PromotionPluginSvc promotionPluginSvc = new PromotionPluginSvc();
				promotionPluginSvc.setAmount(amount);
				promotionPluginSvc.setDurationDays(days);
				promotionPluginSvc.setStore(currentStore);
				promotionPluginSvc.setPromotionPluginId(promotionPlugin.getId());
				svcService.save(promotionPluginSvc);
				data.put("promotionPluginSvcSn", promotionPluginSvc.getSn());
			}
		} else {
			StorePluginStatus storePluginStatus = storePluginStatusService.find(currentStore, promotionPlugin.getId());
			if (storePluginStatus != null) {
				storePluginStatusService.addPluginEndDays(storePluginStatus, days);
			} else {
				storePluginStatusService.create(currentStore, promotionPlugin.getId(), days);
			}
		}
		return ResponseEntity.ok(data);
	}

	/**
	 * 首页
	 */
	@GetMapping
	public String index(@CurrentStore Store currentStore, ModelMap model) {
		model.addAttribute("promotionPlugins", pluginService.getPromotionPlugins(true));
		model.addAttribute("currentStore", currentStore);
		return "business/promotion_plugin/index";
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(String promotionPluginId, Pageable pageable, @CurrentStore Store currentStore, ModelMap model) {
		PromotionPlugin promotionPlugin = pluginService.getPromotionPlugin(promotionPluginId);
		model.addAttribute("promotionPlugin", promotionPlugin);
		model.addAttribute("page", promotionService.findPage(promotionPlugin, currentStore, pageable));
		return "business/promotion_plugin/list";
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public ResponseEntity<?> delete(Long[] ids, @CurrentStore Store currentStore) {
		for (Long id : ids) {
			Promotion promotion = promotionService.find(id);
			if (promotion == null) {
				return Results.UNPROCESSABLE_ENTITY;
			}
			if (!currentStore.equals(promotion.getStore())) {
				return Results.UNPROCESSABLE_ENTITY;
			}
		}
		promotionService.delete(ids);
		return Results.OK;
	}

}