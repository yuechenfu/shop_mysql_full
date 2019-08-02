/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: j4GO0GxX9biPTqTM0yjANeKGeuTzfxNw
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
import net.shopxx.plugin.FreeShippingPromotionPlugin;
import net.shopxx.security.CurrentStore;
import net.shopxx.service.MemberRankService;
import net.shopxx.service.PromotionDefaultAttributeService;
import net.shopxx.service.PromotionService;

/**
 * Controller - 免运费促销
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Controller("businessFreeShippingPromotionController")
@RequestMapping("/business/free_shipping_promotion")
public class FreeShippingPromotionController extends BaseController {

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
	public void populateModel(Long promotionId, Long freeShippingAttributeId, @CurrentStore Store currentStore, ModelMap model) {
		Promotion promotion = promotionService.find(promotionId);
		if (promotion != null && !currentStore.equals(promotion.getStore())) {
			throw new UnauthorizedException();
		}
		FreeShippingPromotionPlugin.FreeShippingAttribute freeShippingAttribute = (FreeShippingPromotionPlugin.FreeShippingAttribute) promotionDefaultAttributeService.find(freeShippingAttributeId);
		if (freeShippingAttribute != null && !freeShippingAttribute.equals(promotion.getPromotionDefaultAttribute())) {
			throw new UnauthorizedException();
		}
		model.addAttribute("promotion", promotion);
		model.addAttribute("freeShippingAttribute", freeShippingAttribute);
	}

	/**
	 * 添加
	 */
	@GetMapping("/add")
	public String add(String promotionPluginId, @CurrentStore Store currentStore, ModelMap model) {
		model.addAttribute("memberRanks", memberRankService.findAll());
		model.addAttribute("promotionPluginId", promotionPluginId);
		return "business/free_shipping_promotion/add";
	}

	/**
	 * 保存
	 */
	@PostMapping("/save")
	public ResponseEntity<?> save(@ModelAttribute("promotionForm") Promotion promotionForm, @ModelAttribute("giftAttributeForm") FreeShippingPromotionPlugin.FreeShippingAttribute giftAttributeForm, Long[] memberRankIds, @CurrentStore Store currentStore) {
		promotionForm.setStore(currentStore);
		promotionForm.setMemberRanks(new HashSet<>(memberRankService.findList(memberRankIds)));
		if (!isValid(promotionForm)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (!isValid(giftAttributeForm)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (promotionForm.getBeginDate() != null && promotionForm.getEndDate() != null && promotionForm.getBeginDate().after(promotionForm.getEndDate())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (giftAttributeForm.getMinQuantity() != null && giftAttributeForm.getMaxQuantity() != null && giftAttributeForm.getMinQuantity() > giftAttributeForm.getMaxQuantity()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (giftAttributeForm.getMinPrice() != null && giftAttributeForm.getMaxPrice() != null && giftAttributeForm.getMinPrice().compareTo(giftAttributeForm.getMaxPrice()) > 0) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		promotionForm.setProducts(null);
		promotionForm.setProductCategories(null);
		promotionForm.setPromotionDefaultAttribute(null);
		promotionService.create(promotionForm, giftAttributeForm);
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
		FreeShippingPromotionPlugin.FreeShippingAttribute freeShippingAttribute = (FreeShippingPromotionPlugin.FreeShippingAttribute) promotion.getPromotionDefaultAttribute();
		if (freeShippingAttribute == null || !promotion.getPromotionDefaultAttribute().equals(freeShippingAttribute)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		model.addAttribute("freeShippingAttribute", freeShippingAttribute);
		return "business/free_shipping_promotion/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public ResponseEntity<?> update(@ModelAttribute("promotionForm") Promotion promotionForm, @ModelAttribute(binding = false) Promotion promotion, @ModelAttribute("freeShippingAttributeForm") FreeShippingPromotionPlugin.FreeShippingAttribute freeShippingAttributeForm,
			@ModelAttribute(binding = false) FreeShippingPromotionPlugin.FreeShippingAttribute freeShippingAttribute, Long[] memberRankIds) {
		if (promotion == null) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (freeShippingAttribute == null) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		promotionForm.setMemberRanks(new HashSet<>(memberRankService.findList(memberRankIds)));
		if (promotionForm.getBeginDate() != null && promotionForm.getEndDate() != null && promotionForm.getBeginDate().after(promotionForm.getEndDate())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (freeShippingAttributeForm.getMinQuantity() != null && freeShippingAttributeForm.getMaxQuantity() != null && freeShippingAttributeForm.getMinQuantity() > freeShippingAttributeForm.getMaxQuantity()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (freeShippingAttributeForm.getMinPrice() != null && freeShippingAttributeForm.getMaxPrice() != null && freeShippingAttributeForm.getMinPrice().compareTo(freeShippingAttributeForm.getMaxPrice()) > 0) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		promotionForm.setId(promotion.getId());
		freeShippingAttributeForm.setId(freeShippingAttribute.getId());
		if (!isValid(freeShippingAttributeForm)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		promotionService.modify(promotionForm, freeShippingAttributeForm);
		return Results.OK;
	}

}