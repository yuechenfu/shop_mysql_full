/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: ZQ5B2JgJzeuqp1QFLewmCAOQ3GCtrHJx
 */
package net.shopxx.controller.business;

import java.util.Date;
import java.util.List;

import javax.inject.Inject;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateFormatUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import net.shopxx.ExcelView;
import net.shopxx.Pageable;
import net.shopxx.Results;
import net.shopxx.entity.Coupon;
import net.shopxx.entity.CouponCode;
import net.shopxx.entity.Store;
import net.shopxx.exception.UnauthorizedException;
import net.shopxx.security.CurrentStore;
import net.shopxx.service.CouponCodeService;
import net.shopxx.service.CouponService;

/**
 * Controller - 优惠券
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Controller("businessCouponController")
@RequestMapping("/business/coupon")
public class CouponController extends BaseController {

	@Inject
	private CouponService couponService;
	@Inject
	private CouponCodeService couponCodeService;

	/**
	 * 添加属性
	 */
	@ModelAttribute
	public void populateModel(Long couponId, @CurrentStore Store currentStore, ModelMap model) {
		Coupon coupon = couponService.find(couponId);
		if (coupon != null && !currentStore.equals(coupon.getStore())) {
			throw new UnauthorizedException();
		}
		model.addAttribute("coupon", coupon);
	}

	/**
	 * 检查价格运算表达式是否正确
	 */
	@GetMapping("/check_price_expression")
	public @ResponseBody boolean checkPriceExpression(String priceExpression) {
		return StringUtils.isNotEmpty(priceExpression) && couponService.isValidPriceExpression(priceExpression);
	}

	/**
	 * 添加
	 */
	@GetMapping("/add")
	public String add(ModelMap model) {
		return "business/coupon/add";
	}

	/**
	 * 保存
	 */
	@PostMapping("/save")
	public ResponseEntity<?> save(@ModelAttribute("couponForm") Coupon couponForm, @CurrentStore Store currentStore) {
		if (!isValid(couponForm)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (couponForm.getBeginDate() != null && couponForm.getEndDate() != null && couponForm.getBeginDate().after(couponForm.getEndDate())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (couponForm.getMinimumQuantity() != null && couponForm.getMaximumQuantity() != null && couponForm.getMinimumQuantity() > couponForm.getMaximumQuantity()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (couponForm.getMinimumPrice() != null && couponForm.getMaximumPrice() != null && couponForm.getMinimumPrice().compareTo(couponForm.getMaximumPrice()) > 0) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (StringUtils.isNotEmpty(couponForm.getPriceExpression()) && !couponService.isValidPriceExpression(couponForm.getPriceExpression())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (couponForm.getIsExchange() && couponForm.getPoint() == null) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (!couponForm.getIsExchange()) {
			couponForm.setPoint(null);
		}
		couponForm.setStore(currentStore);
		couponForm.setCouponCodes(null);
		couponForm.setOrders(null);
		couponService.save(couponForm);

		return Results.OK;
	}

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit(@ModelAttribute(binding = false) Coupon coupon, ModelMap model) {
		if (coupon == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		model.addAttribute("coupon", coupon);
		return "business/coupon/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public ResponseEntity<?> update(@ModelAttribute("couponForm") Coupon couponForm, @ModelAttribute(binding = false) Coupon coupon) {
		if (coupon == null) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (!isValid(couponForm)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (couponForm.getBeginDate() != null && couponForm.getEndDate() != null && couponForm.getBeginDate().after(couponForm.getEndDate())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (couponForm.getMinimumQuantity() != null && couponForm.getMaximumQuantity() != null && couponForm.getMinimumQuantity() > couponForm.getMaximumQuantity()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (couponForm.getMinimumPrice() != null && couponForm.getMaximumPrice() != null && couponForm.getMinimumPrice().compareTo(couponForm.getMaximumPrice()) > 0) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (StringUtils.isNotEmpty(couponForm.getPriceExpression()) && !couponService.isValidPriceExpression(couponForm.getPriceExpression())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (couponForm.getIsExchange() && couponForm.getPoint() == null) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (!couponForm.getIsExchange()) {
			couponForm.setPoint(null);
		}

		BeanUtils.copyProperties(couponForm, coupon, "id", "couponCodes", "promotions", "orders", "store");
		couponService.update(coupon);

		return Results.OK;
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Pageable pageable, @CurrentStore Store currentStore, ModelMap model) {
		model.addAttribute("page", couponService.findPage(currentStore, pageable));
		return "business/coupon/list";
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public ResponseEntity<?> delete(Long[] ids, @CurrentStore Store currentStore) {
		for (Long id : ids) {
			Coupon coupon = couponService.find(id);
			if (coupon != null && currentStore.equals(coupon.getStore())) {
				couponService.delete(coupon);
			}
		}
		return Results.OK;
	}

	/**
	 * 生成优惠码
	 */
	@GetMapping("/generate")
	public String generate(@ModelAttribute(binding = false) Coupon coupon, ModelMap model) {
		if (coupon == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		model.addAttribute("coupon", coupon);
		model.addAttribute("totalCount", couponCodeService.count(coupon, null, null, null, null));
		model.addAttribute("usedCount", couponCodeService.count(coupon, null, null, null, true));
		return "business/coupon/generate";
	}

	/**
	 * 下载优惠码
	 */
	@PostMapping("/download")
	public ModelAndView download(@ModelAttribute(binding = false) Coupon coupon, Integer count, ModelMap model) {
		if (coupon == null) {
			return new ModelAndView(UNPROCESSABLE_ENTITY_VIEW);
		}
		if (count == null || count <= 0) {
			count = 100;
		}

		List<CouponCode> couponCodes = couponCodeService.generate(coupon, null, count);
		String filename = "coupon_code_" + DateFormatUtils.format(new Date(), "yyyyMM") + ".xls";
		model.addAttribute("coupon", coupon);
		model.addAttribute("couponCodes", couponCodes);
		model.addAttribute("date", new Date());
		return new ModelAndView(new ExcelView("/business/coupon/download.xls", filename), model);
	}

}