/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: CNcvOQePEJrtBd5xu+GXNkPVLzEKuxrH
 */
package net.shopxx.controller.business;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.inject.Inject;

import org.apache.commons.lang.StringUtils;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import net.shopxx.Results;
import net.shopxx.entity.Business;
import net.shopxx.entity.Product;
import net.shopxx.entity.Promotion;
import net.shopxx.entity.Sku;
import net.shopxx.entity.Store;
import net.shopxx.exception.UnauthorizedException;
import net.shopxx.plugin.GiftPromotionPlugin;
import net.shopxx.security.CurrentStore;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.MemberRankService;
import net.shopxx.service.PromotionDefaultAttributeService;
import net.shopxx.service.PromotionService;
import net.shopxx.service.SkuService;

/**
 * Controller - 优惠券促销
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Controller("businessGiftPromotionController")
@RequestMapping("/business/gift_promotion")
public class GiftPromotionController extends BaseController {

	@Inject
	private PromotionService promotionService;
	@Inject
	private MemberRankService memberRankService;
	@Inject
	private SkuService skuService;
	@Inject
	private PromotionDefaultAttributeService promotionDefaultAttributeService;

	/**
	 * 添加属性
	 */
	@ModelAttribute
	public void populateModel(Long promotionId, Long giftAttributeId, @CurrentStore Store currentStore, ModelMap model) {
		Promotion promotion = promotionService.find(promotionId);
		if (promotion != null && !currentStore.equals(promotion.getStore())) {
			throw new UnauthorizedException();
		}
		GiftPromotionPlugin.GiftAttribute giftAttribute = (GiftPromotionPlugin.GiftAttribute) promotionDefaultAttributeService.find(giftAttributeId);
		if (giftAttribute != null && !giftAttribute.equals(promotion.getPromotionDefaultAttribute())) {
			throw new UnauthorizedException();
		}
		model.addAttribute("promotion", promotion);
		model.addAttribute("giftAttribute", giftAttribute);
	}

	/**
	 * 赠品选择
	 */
	@GetMapping("/gift_select")
	public @ResponseBody List<Map<String, Object>> giftSelect(String promotionPluginId, String keyword, Long[] excludeIds, @CurrentUser Business currentUser) {
		List<Map<String, Object>> data = new ArrayList<>();
		if (StringUtils.isEmpty(keyword)) {
			return data;
		}
		Set<Sku> excludes = new HashSet<>(skuService.findList(excludeIds));
		List<Sku> skus = skuService.search(currentUser.getStore(), Product.Type.GIFT, keyword, excludes, null);
		for (Sku sku : skus) {
			Map<String, Object> item = new HashMap<>();
			item.put("id", sku.getId());
			item.put("sn", sku.getSn());
			item.put("name", sku.getName());
			item.put("specifications", sku.getSpecifications());
			item.put("path", sku.getPath());
			data.add(item);
		}
		return data;
	}

	/**
	 * 添加
	 */
	@GetMapping("/add")
	public String add(String promotionPluginId, @CurrentStore Store currentStore, ModelMap model) {
		model.addAttribute("memberRanks", memberRankService.findAll());
		model.addAttribute("promotionPluginId", promotionPluginId);
		return "business/gift_promotion/add";
	}

	/**
	 * 保存
	 */
	@PostMapping("/save")
	public ResponseEntity<?> save(@ModelAttribute("promotionForm") Promotion promotionForm, @ModelAttribute("giftAttributeForm") GiftPromotionPlugin.GiftAttribute giftAttributeForm, Long[] giftIds, Long[] memberRankIds, @CurrentStore Store currentStore) {
		promotionForm.setStore(currentStore);
		promotionForm.setMemberRanks(new HashSet<>(memberRankService.findList(memberRankIds)));
		giftAttributeForm.setGifts(new HashSet<>(skuService.findList(giftIds)));
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
		GiftPromotionPlugin.GiftAttribute giftAttribute = (GiftPromotionPlugin.GiftAttribute) promotion.getPromotionDefaultAttribute();
		if (giftAttribute == null || !promotion.getPromotionDefaultAttribute().equals(giftAttribute)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		model.addAttribute("giftAttribute", giftAttribute);
		return "business/gift_promotion/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public ResponseEntity<?> update(@ModelAttribute("promotionForm") Promotion promotionForm, @ModelAttribute(binding = false) Promotion promotion, @ModelAttribute("giftAttributeForm") GiftPromotionPlugin.GiftAttribute giftAttributeForm,
			@ModelAttribute(binding = false) GiftPromotionPlugin.GiftAttribute giftAttribute, Long[] giftIds, Long[] memberRankIds) {
		if (promotion == null) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (giftAttribute == null) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		promotionForm.setMemberRanks(new HashSet<>(memberRankService.findList(memberRankIds)));
		if (promotionForm.getBeginDate() != null && promotionForm.getEndDate() != null && promotionForm.getBeginDate().after(promotionForm.getEndDate())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (giftAttributeForm.getMinQuantity() != null && giftAttributeForm.getMaxQuantity() != null && giftAttributeForm.getMinQuantity() > giftAttributeForm.getMaxQuantity()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (giftAttributeForm.getMinPrice() != null && giftAttributeForm.getMaxPrice() != null && giftAttributeForm.getMinPrice().compareTo(giftAttributeForm.getMaxPrice()) > 0) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		promotionForm.setId(promotion.getId());
		giftAttributeForm.setId(giftAttribute.getId());
		giftAttributeForm.setGifts(new HashSet<>(skuService.findList(giftIds)));
		if (!isValid(giftAttributeForm)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		promotionService.modify(promotionForm, giftAttributeForm);
		return Results.OK;
	}

}