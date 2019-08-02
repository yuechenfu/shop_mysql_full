/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: 14pMr1rp2tFbSX8eHNtSo7JwACgF6Dk2
 */
package net.shopxx.controller.business;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

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

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.Results;
import net.shopxx.Setting;
import net.shopxx.entity.Area;
import net.shopxx.entity.Business;
import net.shopxx.entity.Invoice;
import net.shopxx.entity.Member;
import net.shopxx.entity.Order;
import net.shopxx.entity.OrderItem;
import net.shopxx.entity.OrderPayment;
import net.shopxx.entity.OrderRefunds;
import net.shopxx.entity.OrderReturns;
import net.shopxx.entity.OrderReturnsItem;
import net.shopxx.entity.OrderShipping;
import net.shopxx.entity.OrderShippingItem;
import net.shopxx.entity.PaymentMethod;
import net.shopxx.entity.ShippingMethod;
import net.shopxx.entity.Sku;
import net.shopxx.entity.Store;
import net.shopxx.exception.UnauthorizedException;
import net.shopxx.security.CurrentStore;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.AreaService;
import net.shopxx.service.DeliveryCorpService;
import net.shopxx.service.MemberService;
import net.shopxx.service.OrderService;
import net.shopxx.service.OrderShippingService;
import net.shopxx.service.PaymentMethodService;
import net.shopxx.service.ShippingMethodService;
import net.shopxx.util.SystemUtils;

/**
 * Controller - 订单
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Controller("businessOrderController")
@RequestMapping("/business/order")
public class OrderController extends BaseController {

	@Inject
	private AreaService areaService;
	@Inject
	private OrderService orderService;
	@Inject
	private ShippingMethodService shippingMethodService;
	@Inject
	private PaymentMethodService paymentMethodService;
	@Inject
	private DeliveryCorpService deliveryCorpService;
	@Inject
	private OrderShippingService orderShippingService;
	@Inject
	private MemberService memberService;

	/**
	 * 添加属性
	 */
	@ModelAttribute
	public void populateModel(Long orderId, @CurrentStore Store currentStore, ModelMap model) {
		Order order = orderService.find(orderId);
		if (order != null && !currentStore.equals(order.getStore())) {
			throw new UnauthorizedException();
		}
		model.addAttribute("order", order);
	}

	/**
	 * 获取订单锁
	 */
	@PostMapping("/acquire_lock")
	public @ResponseBody boolean acquireLock(@ModelAttribute(binding = false) Order order) {
		return order != null && orderService.acquireLock(order);
	}

	/**
	 * 计算
	 */
	@PostMapping("/calculate")
	public ResponseEntity<?> calculate(@ModelAttribute(binding = false) Order order, BigDecimal freight, BigDecimal tax, BigDecimal offsetAmount) {
		if (order == null) {
			return Results.UNPROCESSABLE_ENTITY;
		}

		Map<String, Object> data = new HashMap<>();
		data.put("amount", orderService.calculateAmount(order.getPrice(), order.getFee(), freight, tax, order.getPromotionDiscount(), order.getCouponDiscount(), offsetAmount));
		return ResponseEntity.ok(data);
	}

	/**
	 * 物流动态
	 */
	@GetMapping("/transit_step")
	public ResponseEntity<?> transitStep(Long shippingId, @CurrentStore Store currentStore) {
		Map<String, Object> data = new HashMap<>();
		OrderShipping orderShipping = orderShippingService.find(shippingId);
		if (orderShipping == null || !currentStore.equals(orderShipping.getOrder().getStore())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		Setting setting = SystemUtils.getSetting();
		if (StringUtils.isEmpty(setting.getKuaidi100Customer()) || StringUtils.isEmpty(setting.getKuaidi100Key()) || StringUtils.isEmpty(orderShipping.getDeliveryCorpCode()) || StringUtils.isEmpty(orderShipping.getTrackingNo())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		data.put("transitSteps", orderShippingService.getTransitSteps(orderShipping));
		return ResponseEntity.ok(data);
	}

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit(@ModelAttribute(binding = false) Order order, ModelMap model) {
		if (order == null || order.hasExpired() || (!Order.Status.PENDING_PAYMENT.equals(order.getStatus()) && !Order.Status.PENDING_REVIEW.equals(order.getStatus()))) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		model.addAttribute("paymentMethods", paymentMethodService.findAll());
		model.addAttribute("shippingMethods", shippingMethodService.findAll());
		model.addAttribute("order", order);
		return "business/order/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public ResponseEntity<?> update(@ModelAttribute(binding = false) Order order, Long areaId, Long paymentMethodId, Long shippingMethodId, BigDecimal freight, BigDecimal tax, BigDecimal offsetAmount, Long rewardPoint, String consignee, String address, String zipCode, String phone,
			String invoiceTitle, String invoiceTaxNumber, String memo, @CurrentUser Business currentUser) {
		Area area = areaService.find(areaId);
		PaymentMethod paymentMethod = paymentMethodService.find(paymentMethodId);
		ShippingMethod shippingMethod = shippingMethodService.find(shippingMethodId);

		if (order == null || !orderService.acquireLock(order)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (order.hasExpired() || (!Order.Status.PENDING_PAYMENT.equals(order.getStatus()) && !Order.Status.PENDING_REVIEW.equals(order.getStatus()))) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (order.getStatus().equals(Order.Status.PENDING_REVIEW) || order.getAmountPaid().compareTo(BigDecimal.ZERO) > 0) {
			Setting setting = SystemUtils.getSetting();
			offsetAmount = BigDecimal.ZERO;
			tax = setting.setScale(order.getTax());
			freight = setting.setScale(order.getFreight());
		}

		Invoice invoice = StringUtils.isNotEmpty(invoiceTitle) && StringUtils.isNotEmpty(invoiceTaxNumber) ? new Invoice(invoiceTitle, invoiceTaxNumber, null) : null;
		order.setTax(invoice != null ? tax : BigDecimal.ZERO);
		order.setOffsetAmount(offsetAmount);
		order.setRewardPoint(rewardPoint);
		order.setMemo(memo);
		order.setInvoice(invoice);
		order.setPaymentMethod(paymentMethod);
		if (order.getIsDelivery()) {
			order.setFreight(freight.compareTo(BigDecimal.ZERO) > 0 ? freight : BigDecimal.ZERO);
			order.setConsignee(consignee);
			order.setAddress(address);
			order.setZipCode(zipCode);
			order.setPhone(phone);
			order.setArea(area);
			order.setShippingMethod(shippingMethod);
			if (!isValid(order, Order.Delivery.class)) {
				return Results.UNPROCESSABLE_ENTITY;
			}
		} else {
			order.setFreight(BigDecimal.ZERO);
			order.setConsignee(null);
			order.setAreaName(null);
			order.setAddress(null);
			order.setZipCode(null);
			order.setPhone(null);
			order.setShippingMethodName(null);
			order.setArea(null);
			order.setShippingMethod(null);
			if (!isValid(order)) {
				return Results.UNPROCESSABLE_ENTITY;
			}
		}
		orderService.modify(order);

		return Results.OK;
	}

	/**
	 * 查看
	 */
	@GetMapping("/view")
	public String view(@ModelAttribute(binding = false) Order order, ModelMap model) {
		if (order == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		Setting setting = SystemUtils.getSetting();
		model.addAttribute("methods", OrderPayment.Method.values());
		model.addAttribute("refundsMethods", OrderRefunds.Method.values());
		model.addAttribute("paymentMethods", paymentMethodService.findAll());
		model.addAttribute("shippingMethods", shippingMethodService.findAll());
		model.addAttribute("deliveryCorps", deliveryCorpService.findAll());
		model.addAttribute("isKuaidi100Enabled", StringUtils.isNotEmpty(setting.getKuaidi100Customer()) && StringUtils.isNotEmpty(setting.getKuaidi100Key()));
		model.addAttribute("order", order);
		return "business/order/view";
	}

	/**
	 * 审核
	 */
	@PostMapping("/review")
	public ResponseEntity<?> review(@ModelAttribute(binding = false) Order order, Boolean passed, @CurrentUser Business currentUser) {
		if (order == null || order.hasExpired() || !Order.Status.PENDING_REVIEW.equals(order.getStatus()) || passed == null) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (!orderService.acquireLock(order, currentUser)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		orderService.review(order, passed);

		return Results.OK;
	}

	/**
	 * 收款
	 */
	@PostMapping("/payment")
	public ResponseEntity<?> payment(OrderPayment orderPaymentForm, @ModelAttribute(binding = false) Order order, Long paymentMethodId, @CurrentUser Business currentUser, @CurrentStore Store currentStore) {
		if (order == null || !Store.Type.SELF.equals(currentStore.getType())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		orderPaymentForm.setOrder(order);
		orderPaymentForm.setPaymentMethod(paymentMethodService.find(paymentMethodId));
		if (!isValid(orderPaymentForm)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (!orderService.acquireLock(order, currentUser)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		orderPaymentForm.setFee(BigDecimal.ZERO);
		orderService.payment(order, orderPaymentForm);

		return Results.OK;
	}

	/**
	 * 退款
	 */
	@PostMapping("/refunds")
	public ResponseEntity<?> refunds(OrderRefunds orderRefundsForm, @ModelAttribute(binding = false) Order order, Long paymentMethodId, @CurrentUser Business currentUser) {
		if (order == null || order.hasExpired()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (order.getRefundableAmount().compareTo(BigDecimal.ZERO) <= 0 && !order.getIsAllowRefund()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (orderRefundsForm.getAmount().compareTo(order.getAmountPaid()) > 0 || order.getAmountPaid().compareTo(BigDecimal.ZERO) <= 0) {
			return Results.UNPROCESSABLE_ENTITY;
		}

		orderRefundsForm.setOrder(order);
		orderRefundsForm.setPaymentMethod(paymentMethodService.find(paymentMethodId));
		if (!isValid(orderRefundsForm)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (OrderRefunds.Method.DEPOSIT.equals(orderRefundsForm.getMethod()) && orderRefundsForm.getAmount().compareTo(order.getStore().getBusiness().getAvailableBalance()) > 0) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (!orderService.acquireLock(order, currentUser)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		orderService.refunds(order, orderRefundsForm);

		return Results.OK;
	}

	/**
	 * 发货
	 */
	@PostMapping("/shipping")
	public ResponseEntity<?> shipping(OrderShipping orderShippingForm, @ModelAttribute(binding = false) Order order, Long shippingMethodId, Long deliveryCorpId, Long areaId, @CurrentUser Business currentUser) {
		if (order == null || order.getShippableQuantity() <= 0) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		boolean isDelivery = false;
		for (Iterator<OrderShippingItem> iterator = orderShippingForm.getOrderShippingItems().iterator(); iterator.hasNext();) {
			OrderShippingItem orderShippingItem = iterator.next();
			if (orderShippingItem == null || StringUtils.isEmpty(orderShippingItem.getSn()) || orderShippingItem.getQuantity() == null || orderShippingItem.getQuantity() <= 0) {
				iterator.remove();
				continue;
			}
			OrderItem orderItem = order.getOrderItem(orderShippingItem.getSn());
			if (orderItem == null || orderShippingItem.getQuantity() > orderItem.getShippableQuantity()) {
				return Results.UNPROCESSABLE_ENTITY;
			}
			Sku sku = orderItem.getSku();
			if (sku != null && orderShippingItem.getQuantity() > sku.getStock()) {
				return Results.UNPROCESSABLE_ENTITY;
			}
			orderShippingItem.setName(orderItem.getName());
			orderShippingItem.setIsDelivery(orderItem.getIsDelivery());
			orderShippingItem.setSku(sku);
			orderShippingItem.setOrderShipping(orderShippingForm);
			orderShippingItem.setSpecifications(orderItem.getSpecifications());
			if (orderItem.getIsDelivery()) {
				isDelivery = true;
			}
		}
		orderShippingForm.setOrder(order);
		orderShippingForm.setShippingMethod(shippingMethodService.find(shippingMethodId));
		orderShippingForm.setDeliveryCorp(deliveryCorpService.find(deliveryCorpId));
		orderShippingForm.setArea(areaService.find(areaId));
		if (isDelivery) {
			if (!isValid(orderShippingForm, OrderShipping.Delivery.class)) {
				return Results.UNPROCESSABLE_ENTITY;
			}
		} else {
			orderShippingForm.setShippingMethod((String) null);
			orderShippingForm.setDeliveryCorp((String) null);
			orderShippingForm.setDeliveryCorpUrl(null);
			orderShippingForm.setDeliveryCorpCode(null);
			orderShippingForm.setTrackingNo(null);
			orderShippingForm.setFreight(null);
			orderShippingForm.setConsignee(null);
			orderShippingForm.setArea((String) null);
			orderShippingForm.setAddress(null);
			orderShippingForm.setZipCode(null);
			orderShippingForm.setPhone(null);
			if (!isValid(orderShippingForm)) {
				return Results.UNPROCESSABLE_ENTITY;
			}
		}
		if (!orderService.acquireLock(order, currentUser)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		orderService.shipping(order, orderShippingForm);

		return Results.OK;
	}

	/**
	 * 退货
	 */
	@PostMapping("/returns")
	public ResponseEntity<?> returns(OrderReturns orderReturnsForm, @ModelAttribute(binding = false) Order order, Long shippingMethodId, Long deliveryCorpId, Long areaId, @CurrentUser Business currentUser) {
		if (order == null || order.getReturnableQuantity() <= 0) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		for (Iterator<OrderReturnsItem> iterator = orderReturnsForm.getOrderReturnsItems().iterator(); iterator.hasNext();) {
			OrderReturnsItem orderReturnsItem = iterator.next();
			if (orderReturnsItem == null || StringUtils.isEmpty(orderReturnsItem.getSn()) || orderReturnsItem.getQuantity() == null || orderReturnsItem.getQuantity() <= 0) {
				iterator.remove();
				continue;
			}
			OrderItem orderItem = order.getOrderItem(orderReturnsItem.getSn());
			if (orderItem == null || orderReturnsItem.getQuantity() > orderItem.getReturnableQuantity()) {
				return Results.UNPROCESSABLE_ENTITY;
			}
			orderReturnsItem.setName(orderItem.getName());
			orderReturnsItem.setOrderReturns(orderReturnsForm);
			orderReturnsItem.setSpecifications(orderItem.getSpecifications());
		}
		orderReturnsForm.setOrder(order);
		orderReturnsForm.setShippingMethod(shippingMethodService.find(shippingMethodId));
		orderReturnsForm.setDeliveryCorp(deliveryCorpService.find(deliveryCorpId));
		orderReturnsForm.setArea(areaService.find(areaId));
		if (!isValid(orderReturnsForm)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (!orderService.acquireLock(order, currentUser)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		orderService.returns(order, orderReturnsForm);

		return Results.OK;
	}

	/**
	 * 完成
	 */
	@PostMapping("/complete")
	public ResponseEntity<?> complete(@ModelAttribute(binding = false) Order order, @CurrentUser Business currentUser) {
		if (order == null || order.hasExpired() || !Order.Status.RECEIVED.equals(order.getStatus())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (!orderService.acquireLock(order, currentUser)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		orderService.complete(order);

		return Results.OK;
	}

	/**
	 * 失败
	 */
	@PostMapping("/fail")
	public ResponseEntity<?> fail(@ModelAttribute(binding = false) Order order, @CurrentUser Business currentUser) {
		if (order == null || order.hasExpired() || (!Order.Status.PENDING_SHIPMENT.equals(order.getStatus()) && !Order.Status.SHIPPED.equals(order.getStatus()) && !Order.Status.RECEIVED.equals(order.getStatus()))) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (!orderService.acquireLock(order, currentUser)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		orderService.fail(order);

		return Results.OK;
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Order.Type type, Order.Status status, String memberUsername, Boolean isPendingReceive, Boolean isPendingRefunds, Boolean isAllocatedStock, Boolean hasExpired, Pageable pageable, @CurrentStore Store currentStore, ModelMap model) {
		model.addAttribute("types", Order.Type.values());
		model.addAttribute("statuses", Order.Status.values());
		model.addAttribute("type", type);
		model.addAttribute("status", status);
		model.addAttribute("memberUsername", memberUsername);
		model.addAttribute("isPendingReceive", isPendingReceive);
		model.addAttribute("isPendingRefunds", isPendingRefunds);
		model.addAttribute("isAllocatedStock", isAllocatedStock);
		model.addAttribute("hasExpired", hasExpired);

		Member member = memberService.findByUsername(memberUsername);
		if (StringUtils.isNotEmpty(memberUsername) && member == null) {
			model.addAttribute("page", Page.emptyPage(pageable));
		} else {
			model.addAttribute("page", orderService.findPage(type, status, currentStore, member, null, isPendingReceive, isPendingRefunds, null, null, isAllocatedStock, hasExpired, pageable));
		}
		return "business/order/list";
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public ResponseEntity<?> delete(Long[] ids, @CurrentUser Business currentUser, @CurrentStore Store currentStore) {
		if (ids != null) {
			for (Long id : ids) {
				Order order = orderService.find(id);
				if (order == null || !currentStore.equals(order.getStore())) {
					return Results.UNPROCESSABLE_ENTITY;
				}
				if (!orderService.acquireLock(order, currentUser)) {
					return Results.unprocessableEntity("business.order.deleteLockedNotAllowed", order.getSn());
				}
				if (!order.canDelete()) {
					return Results.unprocessableEntity("business.order.deleteStatusNotAllowed", order.getSn());
				}
			}
			orderService.delete(ids);
		}
		return Results.OK;
	}

}