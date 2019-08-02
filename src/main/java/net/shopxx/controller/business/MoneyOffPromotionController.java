/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: PVohW1mxgBXO30dp2SDd2MXqZxqlRsSF
 */
package net.shopxx.controller.business;

import java.util.HashSet;

import javax.inject.Inject;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import net.shopxx.Results;
import net.shopxx.entity.Promotion;
import net.shopxx.entity.Store;
import net.shopxx.exception.UnauthorizedException;
import net.shopxx.plugin.MoneyOffPromotionPlugin;
import net.shopxx.security.CurrentStore;
import net.shopxx.service.MemberRankService;
import net.shopxx.service.PromotionDefaultAttributeService;
import net.shopxx.service.PromotionService;

/**
 * Controller - 满减折扣促销
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Controller("businessMoneyOffPromotionController")
@RequestMapping("/business/money_off_promotion")
public class MoneyOffPromotionController extends BaseController {

	@Inject
	private PromotionService promotionService;
	@Inject
	private MemberRankService memberRankService;
	@Inject
	private PromotionDefaultAttributeService promotionDefaultAttributeService;

	/**
	 * 添加属性
	 */
	@ModelAttribute
	public void populateModel(Long promotionId, Long moneyOffAttributeId, @CurrentStore Store currentStore, ModelMap model) {
		Promotion promotion = promotionService.find(promotionId);
		if (promotion != null && !currentStore.equals(promotion.getStore())) {
			throw new UnauthorizedException();
		}
		MoneyOffPromotionPlugin.MoneyOffAttribute moneyOffAttribute = (MoneyOffPromotionPlugin.MoneyOffAttribute) promotionDefaultAttributeService.find(moneyOffAttributeId);
		if (moneyOffAttribute != null && !moneyOffAttribute.equals(promotion.getPromotionDefaultAttribute())) {
			throw new UnauthorizedException();
		}
		model.addAttribute("promotion", promotion);
		model.addAttribute("moneyOffAttribute", moneyOffAttribute);
	}

	/**
	 * 添加
	 */
	@GetMapping("/add")
	public String add(String promotionPluginId, @CurrentStore Store currentStore, ModelMap model) {
		model.addAttribute("memberRanks", memberRankService.findAll());
		model.addAttribute("promotionPluginId", promotionPluginId);
		model.addAttribute("discountTypes", MoneyOffPromotionPlugin.MoneyOffAttribute.DiscountType.values());
		return "business/money_off_promotion/add";
	}

	/**
	 * 保存
	 */
	@PostMapping("/save")
	public ResponseEntity<?> save(@ModelAttribute("promotionForm") Promotion promotionForm, @ModelAttribute("moneyOffAttributeForm") MoneyOffPromotionPlugin.MoneyOffAttribute moneyOffAttributeForm, Long[] memberRankIds, @CurrentStore Store currentStore) {
		promotionForm.setStore(currentStore);
		promotionForm.setMemberRanks(new HashSet<>(memberRankService.findList(memberRankIds)));
		if (!isValid(promotionForm)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (!isValid(moneyOffAttributeForm)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (promotionForm.getBeginDate() != null && promotionForm.getEndDate() != null && promotionForm.getBeginDate().after(promotionForm.getEndDate())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (moneyOffAttributeForm.getMinQuantity() != null && moneyOffAttributeForm.getMaxQuantity() != null && moneyOffAttributeForm.getMinQuantity() > moneyOffAttributeForm.getMaxQuantity()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (moneyOffAttributeForm.getMinPrice() != null && moneyOffAttributeForm.getMaxPrice() != null && moneyOffAttributeForm.getMinPrice().compareTo(moneyOffAttributeForm.getMaxPrice()) > 0) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		promotionForm.setProducts(null);
		promotionForm.setProductCategories(null);
		promotionForm.setPromotionDefaultAttribute(null);
		promotionService.create(promotionForm, moneyOffAttributeForm);
		return Results.OK;
	}

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit(@ModelAttribute(binding = false) Promotion promotion, @CurrentStore Store currentStore, ModelMap model) {
		if (promotion == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		model.addAttribute("promotion", promotion);
		model.addAttribute("memberRanks", memberRankService.findAll());
		model.addAttribute("discountTypes", MoneyOffPromotionPlugin.MoneyOffAttribute.DiscountType.values());
		MoneyOffPromotionPlugin.MoneyOffAttribute moneyOffAttribute = (MoneyOffPromotionPlugin.MoneyOffAttribute) promotion.getPromotionDefaultAttribute();
		if (moneyOffAttribute == null || !promotion.getPromotionDefaultAttribute().equals(moneyOffAttribute)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		model.addAttribute("moneyOffAttribute", moneyOffAttribute);
		return "business/money_off_promotion/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public ResponseEntity<?> update(@ModelAttribute("promotionForm") Promotion promotionForm, @ModelAttribute(binding = false) Promotion promotion, @ModelAttribute("moneyOffAttributeForm") MoneyOffPromotionPlugin.MoneyOffAttribute moneyOffAttributeForm,
			@ModelAttribute(binding = false) MoneyOffPromotionPlugin.MoneyOffAttribute moneyOffAttribute, Long[] memberRankIds) {
		if (promotion == null) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		promotionForm.setMemberRanks(new HashSet<>(memberRankService.findList(memberRankIds)));
		if (promotionForm.getBeginDate() != null && promotionForm.getEndDate() != null && promotionForm.getBeginDate().after(promotionForm.getEndDate())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (moneyOffAttributeForm.getMinQuantity() != null && moneyOffAttributeForm.getMaxQuantity() != null && moneyOffAttributeForm.getMinQuantity() > moneyOffAttributeForm.getMaxQuantity()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (moneyOffAttributeForm.getMinPrice() != null && moneyOffAttributeForm.getMaxPrice() != null && moneyOffAttributeForm.getMinPrice().compareTo(moneyOffAttributeForm.getMaxPrice()) > 0) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		promotionForm.setId(promotion.getId());
		moneyOffAttributeForm.setId(moneyOffAttribute.getId());
		if (!isValid(moneyOffAttributeForm)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		promotionService.modify(promotionForm, moneyOffAttributeForm);
		return Results.OK;
	}

}