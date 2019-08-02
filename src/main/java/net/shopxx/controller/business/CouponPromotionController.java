/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: 8O6edkqYpOS+d7IzndnXkLUYWfnnjmfp
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
import net.shopxx.plugin.CouponPromotionPlugin;
import net.shopxx.security.CurrentStore;
import net.shopxx.service.CouponService;
import net.shopxx.service.MemberRankService;
import net.shopxx.service.PromotionDefaultAttributeService;
import net.shopxx.service.PromotionService;

/**
 * Controller - 优惠券促销
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Controller("businessCouponPromotionController")
@RequestMapping("/business/coupon_promotion")
public class CouponPromotionController extends BaseController {

	@Inject
	private PromotionService promotionService;
	@Inject
	private MemberRankService memberRankService;
	@Inject
	private CouponService couponService;
	@Inject
	private PromotionDefaultAttributeService promotionDefaultAttributeService;

	/**
	 * 添加属性
	 */
	@ModelAttribute
	public void populateModel(Long promotionId, Long couponAttributeId, @CurrentStore Store currentStore, ModelMap model) {
		Promotion promotion = promotionService.find(promotionId);
		if (promotion != null && !currentStore.equals(promotion.getStore())) {
			throw new UnauthorizedException();
		}
		CouponPromotionPlugin.CouponAttribute couponAttribute = (CouponPromotionPlugin.CouponAttribute) promotionDefaultAttributeService.find(couponAttributeId);
		if (couponAttribute != null && !couponAttribute.equals(promotion.getPromotionDefaultAttribute())) {
			throw new UnauthorizedException();
		}
		model.addAttribute("promotion", promotion);
		model.addAttribute("couponAttribute", couponAttribute);
	}

	/**
	 * 添加
	 */
	@GetMapping("/add")
	public String add(String promotionPluginId, @CurrentStore Store currentStore, ModelMap model) {
		model.addAttribute("memberRanks", memberRankService.findAll());
		model.addAttribute("promotionPluginId", promotionPluginId);
		model.addAttribute("coupons", couponService.findList(currentStore));
		return "business/coupon_promotion/add";
	}

	/**
	 * 保存
	 */
	@PostMapping("/save")
	public ResponseEntity<?> save(@ModelAttribute("promotionForm") Promotion promotionForm, @ModelAttribute("couponAttributeForm") CouponPromotionPlugin.CouponAttribute couponAttributeForm, Long[] couponIds, Long[] memberRankIds, @CurrentStore Store currentStore) {
		promotionForm.setStore(currentStore);
		promotionForm.setMemberRanks(new HashSet<>(memberRankService.findList(memberRankIds)));
		couponAttributeForm.setCoupons(new HashSet<>(couponService.findList(couponIds)));
		if (!isValid(promotionForm)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (!isValid(couponAttributeForm)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (promotionForm.getBeginDate() != null && promotionForm.getEndDate() != null && promotionForm.getBeginDate().after(promotionForm.getEndDate())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (couponAttributeForm.getMinQuantity() != null && couponAttributeForm.getMaxQuantity() != null && couponAttributeForm.getMinQuantity() > couponAttributeForm.getMaxQuantity()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (couponAttributeForm.getMinPrice() != null && couponAttributeForm.getMaxPrice() != null && couponAttributeForm.getMinPrice().compareTo(couponAttributeForm.getMaxPrice()) > 0) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		promotionForm.setProducts(null);
		promotionForm.setProductCategories(null);
		promotionForm.setPromotionDefaultAttribute(null);
		promotionService.create(promotionForm, couponAttributeForm);
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
		model.addAttribute("coupons", couponService.findList(currentStore));
		CouponPromotionPlugin.CouponAttribute couponAttribute = (CouponPromotionPlugin.CouponAttribute) promotion.getPromotionDefaultAttribute();
		if (couponAttribute == null || !promotion.getPromotionDefaultAttribute().equals(couponAttribute)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		model.addAttribute("couponAttribute", couponAttribute);
		return "business/coupon_promotion/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public ResponseEntity<?> update(@ModelAttribute("promotionForm") Promotion promotionForm, @ModelAttribute(binding = false) Promotion promotion, @ModelAttribute("couponAttributeForm") CouponPromotionPlugin.CouponAttribute couponAttributeForm,
			@ModelAttribute(binding = false) CouponPromotionPlugin.CouponAttribute couponAttribute, Long[] couponIds, Long[] memberRankIds) {
		if (promotion == null) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (!isValid(couponAttribute)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		promotionForm.setMemberRanks(new HashSet<>(memberRankService.findList(memberRankIds)));
		couponAttributeForm.setCoupons(new HashSet<>(couponService.findList(couponIds)));
		if (promotionForm.getBeginDate() != null && promotionForm.getEndDate() != null && promotionForm.getBeginDate().after(promotionForm.getEndDate())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (couponAttributeForm.getMinQuantity() != null && couponAttributeForm.getMaxQuantity() != null && couponAttributeForm.getMinQuantity() > couponAttributeForm.getMaxQuantity()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (couponAttributeForm.getMinPrice() != null && couponAttributeForm.getMaxPrice() != null && couponAttributeForm.getMinPrice().compareTo(couponAttributeForm.getMaxPrice()) > 0) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		promotionForm.setId(promotion.getId());
		couponAttributeForm.setId(couponAttribute.getId());
		if (!isValid(couponAttributeForm)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		promotionService.modify(promotionForm, couponAttributeForm);
		return Results.OK;
	}

}