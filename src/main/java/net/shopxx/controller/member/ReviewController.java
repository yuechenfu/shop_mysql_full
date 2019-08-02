/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: UEZZe/l4ZPU7FAPbDxVp6dt2xj6BpC2D
 */
package net.shopxx.controller.member;

import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.CollectionUtils;
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
import net.shopxx.entity.BaseEntity;
import net.shopxx.entity.Member;
import net.shopxx.entity.Order;
import net.shopxx.entity.OrderItem;
import net.shopxx.entity.Review;
import net.shopxx.entity.Review.Entry;
import net.shopxx.entity.Sku;
import net.shopxx.exception.UnauthorizedException;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.OrderItemService;
import net.shopxx.service.OrderService;
import net.shopxx.service.ReviewService;
import net.shopxx.util.SystemUtils;

/**
 * Controller - 评论
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Controller("memberReviewController")
@RequestMapping("/member/review")
public class ReviewController extends BaseController {

	/**
	 * 每页记录数
	 */
	private static final int PAGE_SIZE = 10;

	@Inject
	private OrderService orderService;
	@Inject
	private OrderItemService orderItemService;
	@Inject
	private ReviewService reviewService;

	/**
	 * 添加属性
	 */
	@ModelAttribute
	public void populateModel(Long reviewId, @CurrentUser Member currentUser, ModelMap model) {
		Review review = reviewService.find(reviewId);
		if (review != null && !currentUser.equals(review.getMember())) {
			throw new UnauthorizedException();
		}
		model.addAttribute("review", review);
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Integer pageNumber, @CurrentUser Member currentUser, ModelMap model) {
		Pageable pageable = new Pageable(pageNumber, PAGE_SIZE);
		model.addAttribute("page", reviewService.findPage(currentUser, null, null, null, null, pageable));
		return "member/review/list";
	}

	/**
	 * 列表
	 */
	@GetMapping(path = "/list", produces = MediaType.APPLICATION_JSON_VALUE)
	@JsonView(BaseEntity.BaseView.class)
	public ResponseEntity<?> list(Integer pageNumber, @CurrentUser Member currentUser) {
		Pageable pageable = new Pageable(pageNumber, PAGE_SIZE);
		return ResponseEntity.ok(reviewService.findPage(currentUser, null, null, null, null, pageable).getContent());
	}

	/**
	 * 发表
	 */
	@GetMapping("/add")
	public String add(Long orderId, @CurrentUser Member currentUser, ModelMap model) {
		Setting setting = SystemUtils.getSetting();
		if (!setting.getIsReviewEnabled()) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		Order order = orderService.find(orderId);
		if (order == null || !currentUser.equals(order.getMember()) || order.getIsReviewed() || CollectionUtils.isEmpty(order.getOrderItems())) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (!Order.Status.RECEIVED.equals(order.getStatus()) && !Order.Status.COMPLETED.equals(order.getStatus())) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		model.addAttribute("order", order);
		return "member/review/add";
	}

	/**
	 * 保存
	 */
	@PostMapping("/save")
	public ResponseEntity<?> save(Long orderId, ReviewEntryListForm reviewEntryListForm, @CurrentUser Member currentUser, HttpServletRequest request) {
		Setting setting = SystemUtils.getSetting();
		if (!setting.getIsReviewEnabled()) {
			return Results.unprocessableEntity("member.review.disabled");
		}
		Order order = orderService.find(orderId);
		if (order == null || !currentUser.equals(order.getMember()) || order.getIsReviewed() || CollectionUtils.isEmpty(order.getOrderItems())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (!Order.Status.RECEIVED.equals(order.getStatus()) && !Order.Status.COMPLETED.equals(order.getStatus())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		List<Entry> reviewEntries = reviewEntryListForm.getReviewEntryList();
		if (CollectionUtils.isEmpty(reviewEntries)) {
			return Results.UNPROCESSABLE_ENTITY;
		}

		for (Review.Entry reviewEntry : reviewEntries) {
			OrderItem orderItem = reviewEntry.getOrderItem();
			Review review = reviewEntry.getReview();
			if (!isValid(Review.Entry.class, "orderItem", orderItem) || !isValid(Review.Entry.class, "review", review)) {
				return Results.UNPROCESSABLE_ENTITY;
			}
			OrderItem pOrderItem = orderItemService.find(orderItem.getId());
			Sku sku = pOrderItem.getSku();
			if (sku == null) {
				continue;
			}
			if (!order.equals(pOrderItem.getOrder()) || !isValid(Review.class, "score", review.getScore()) || !isValid(Review.class, "content", review.getContent())) {
				return Results.UNPROCESSABLE_ENTITY;
			}
		}
		reviewService.create(order, reviewEntries, request.getRemoteAddr(), currentUser);
		return Results.ok(setting.getIsReviewCheck() ? "member.review.check" : "member.review.success");
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public ResponseEntity<?> delete(@ModelAttribute(binding = false) Review review) {
		if (review == null) {
			return Results.NOT_FOUND;
		}

		reviewService.delete(review);
		return Results.OK;
	}

	/**
	 * FormBean - 评论条目
	 * 
	 * @author SHOP++ Team
	 * @version 6.1
	 */
	public static class ReviewEntryListForm {

		/**
		 * 评论条目
		 */
		private List<Review.Entry> reviewEntryList;

		/**
		 * 获取评论条目
		 * 
		 * @return 评论条目
		 */
		public List<Review.Entry> getReviewEntryList() {
			return reviewEntryList;
		}

		/**
		 * 设置评论条目
		 * 
		 * @param reviewEntryList
		 *            评论条目
		 */
		public void setReviewEntryList(List<Review.Entry> reviewEntryList) {
			this.reviewEntryList = reviewEntryList;
		}

	}

}