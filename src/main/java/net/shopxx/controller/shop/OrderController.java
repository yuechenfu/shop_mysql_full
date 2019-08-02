/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: 3WTubLTn0cQ6/Shs/+wdQOCJzQsW55dT
 */
package net.shopxx.controller.shop;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.inject.Inject;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.Predicate;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.annotation.JsonView;

import net.shopxx.Results;
import net.shopxx.entity.BaseEntity;
import net.shopxx.entity.Cart;
import net.shopxx.entity.CartItem;
import net.shopxx.entity.Coupon;
import net.shopxx.entity.CouponCode;
import net.shopxx.entity.Invoice;
import net.shopxx.entity.Member;
import net.shopxx.entity.Order;
import net.shopxx.entity.PaymentMethod;
import net.shopxx.entity.Product;
import net.shopxx.entity.Receiver;
import net.shopxx.entity.ShippingMethod;
import net.shopxx.entity.Sku;
import net.shopxx.entity.Store;
import net.shopxx.plugin.PaymentPlugin;
import net.shopxx.security.CurrentCart;
import net.shopxx.security.CurrentUser;
import net.shopxx.service.AreaService;
import net.shopxx.service.CouponCodeService;
import net.shopxx.service.OrderService;
import net.shopxx.service.PaymentMethodService;
import net.shopxx.service.PluginService;
import net.shopxx.service.ReceiverService;
import net.shopxx.service.ShippingMethodService;
import net.shopxx.service.SkuService;
import net.shopxx.util.WebUtils;

/**
 * Controller - 订单
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Controller("shopOrderController")
@RequestMapping("/order")
public class OrderController extends BaseController {

	@Inject
	private SkuService skuService;
	@Inject
	private AreaService areaService;
	@Inject
	private ReceiverService receiverService;
	@Inject
	private PaymentMethodService paymentMethodService;
	@Inject
	private ShippingMethodService shippingMethodService;
	@Inject
	private CouponCodeService couponCodeService;
	@Inject
	private OrderService orderService;
	@Inject
	private PluginService pluginService;

	/**
	 * 检查SKU
	 */
	@GetMapping("/check_sku")
	public ResponseEntity<?> checkSku(Long skuId, Integer quantity) {
		if (quantity == null || quantity < 1) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		Sku sku = skuService.find(skuId);
		if (sku == null) {
			return Results.unprocessableEntity("shop.order.skuNotExist");
		}
		if (Product.Type.GIFT.equals(sku.getType())) {
			return Results.unprocessableEntity("shop.order.skuNotForSale");
		}
		if (!sku.getIsActive()) {
			return Results.unprocessableEntity("shop.order.skuNotActive");
		}
		if (!sku.getIsMarketable()) {
			return Results.unprocessableEntity("shop.order.skuNotMarketable");
		}
		if (quantity > sku.getAvailableStock()) {
			return Results.unprocessableEntity("shop.order.skuLowStock");
		}
		if (sku.getProduct().getStore().hasExpired()) {
			return Results.unprocessableEntity("shop.order.skuNotBuyExpired");
		}
		return Results.OK;
	}

	/**
	 * 检查购物车
	 */
	@GetMapping("/check_cart")
	public ResponseEntity<?> checkCart(@CurrentCart Cart currentCart) {
		if (currentCart == null || currentCart.isEmpty()) {
			return Results.unprocessableEntity("shop.order.cartEmpty");
		}
		if (currentCart.hasNotActive()) {
			return Results.unprocessableEntity("shop.order.cartHasNotActive");
		}
		if (currentCart.hasNotMarketable()) {
			return Results.unprocessableEntity("shop.order.cartHasNotMarketable");
		}
		if (currentCart.hasLowStock()) {
			return Results.unprocessableEntity("shop.order.cartHasLowStock");
		}
		if (currentCart.hasExpiredProduct()) {
			return Results.unprocessableEntity("shop.order.cartHasExpiredProduct");
		}
		return Results.OK;
	}

	/**
	 * 收货地址列表
	 */
	@GetMapping("/receiver_list")
	@JsonView(BaseEntity.BaseView.class)
	public ResponseEntity<?> receiverList(@CurrentUser Member currentUser) {
		return ResponseEntity.ok(receiverService.findList(currentUser));
	}

	/**
	 * 添加收货地址
	 */
	@PostMapping("/add_receiver")
	@JsonView(BaseEntity.BaseView.class)
	public ResponseEntity<?> addReceiver(Receiver receiver, Long areaId, @CurrentUser Member currentUser) {
		receiver.setArea(areaService.find(areaId));
		if (!isValid(receiver)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (Receiver.MAX_RECEIVER_COUNT != null && currentUser.getReceivers().size() >= Receiver.MAX_RECEIVER_COUNT) {
			return Results.unprocessableEntity("shop.order.addReceiverCountNotAllowed", Receiver.MAX_RECEIVER_COUNT);
		}
		receiver.setAreaName(null);
		receiver.setMember(currentUser);
		return ResponseEntity.ok(receiverService.save(receiver));
	}

	/**
	 * 订单锁定
	 */
	@PostMapping("/lock")
	public @ResponseBody void lock(String[] orderSns, @CurrentUser Member currentUser) {
		for (String orderSn : orderSns) {
			Order order = orderService.findBySn(orderSn);
			if (order != null && currentUser.equals(order.getMember()) && order.getPaymentMethod() != null && PaymentMethod.Method.ONLINE.equals(order.getPaymentMethod().getMethod()) && order.getAmountPayable().compareTo(BigDecimal.ZERO) > 0) {
				orderService.acquireLock(order, currentUser);
			}
		}
	}

	/**
	 * 检查等待付款
	 */
	@GetMapping("/check_pending_payment")
	public @ResponseBody boolean checkPendingPayment(String[] orderSns, @CurrentUser final Member currentUser) {
		return ArrayUtils.isNotEmpty(orderSns) && CollectionUtils.exists(Arrays.asList(orderSns), new Predicate() {
			@Override
			public boolean evaluate(Object object) {
				String orderSn = (String) object;
				Order order = orderService.findBySn(orderSn);

				return order != null && currentUser.equals(order.getMember()) && order.getPaymentMethod() != null && PaymentMethod.Method.ONLINE.equals(order.getPaymentMethod().getMethod()) && order.getAmountPayable().compareTo(BigDecimal.ZERO) > 0;
			}
		});
	}

	/**
	 * 检查优惠券
	 */
	@GetMapping("/check_coupon")
	public ResponseEntity<?> checkCoupon(Long skuId, Integer quantity, String code, @CurrentUser Member currentUser, @CurrentCart Cart currentCart) {
		Map<String, Object> data = new HashMap<>();
		Cart cart;
		if (skuId != null) {
			Sku sku = skuService.find(skuId);
			if (sku == null) {
				return Results.UNPROCESSABLE_ENTITY;
			}
			if (!Product.Type.GENERAL.equals(sku.getType())) {
				return Results.UNPROCESSABLE_ENTITY;
			}
			if (quantity == null || quantity < 1) {
				return Results.UNPROCESSABLE_ENTITY;
			}

			cart = generateCart(currentUser, sku, quantity);
		} else {
			cart = currentCart;
		}

		if (cart == null || cart.isEmpty()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		CouponCode couponCode = couponCodeService.findByCode(code);
		if (couponCode == null) {
			return Results.unprocessableEntity("shop.order.couponCodeNotExist");
		}
		Coupon coupon = couponCode.getCoupon();
		if (coupon == null) {
			return Results.unprocessableEntity("shop.order.couponCodeNotExist");
		}
		if (couponCode.getIsUsed()) {
			return Results.unprocessableEntity("shop.order.couponCodeUsed");
		}
		if (!coupon.getIsEnabled()) {
			return Results.unprocessableEntity("shop.order.couponDisabled");
		}
		if (!coupon.hasBegun()) {
			return Results.unprocessableEntity("shop.order.couponNotBegin");
		}
		if (coupon.hasExpired()) {
			return Results.unprocessableEntity("shop.order.couponHasExpired");
		}
		Store store = coupon.getStore();
		if (!cart.isValid(store, coupon)) {
			return Results.unprocessableEntity("shop.order.couponInvalid");
		}
		if (!cart.isCouponAllowed(store)) {
			return Results.unprocessableEntity("shop.order.couponNotAllowed");
		}
		data.put("couponName", coupon.getName());
		return ResponseEntity.ok(data);
	}

	/**
	 * 结算
	 */
	@GetMapping("/checkout")
	public String checkout(Long skuId, Integer quantity, @CurrentUser Member currentUser, @CurrentCart Cart currentCart, ModelMap model) {
		Cart cart;
		Order.Type orderType;
		if (skuId != null) {
			Sku sku = skuService.find(skuId);
			if (sku == null) {
				return UNPROCESSABLE_ENTITY_VIEW;
			}
			if (Product.Type.GIFT.equals(sku.getType())) {
				return UNPROCESSABLE_ENTITY_VIEW;
			}
			if (quantity == null || quantity < 1) {
				return UNPROCESSABLE_ENTITY_VIEW;
			}

			cart = generateCart(currentUser, sku, quantity);

			switch (sku.getType()) {
			case GENERAL:
				orderType = Order.Type.GENERAL;
				break;
			case EXCHANGE:
				orderType = Order.Type.EXCHANGE;
				break;
			default:
				orderType = null;
				break;
			}
		} else {
			cart = currentCart;
			orderType = Order.Type.GENERAL;
		}
		if (cart == null || cart.isEmpty()) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (cart.hasNotActive()) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (cart.hasNotMarketable()) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (cart.hasLowStock()) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (cart.hasExpiredProduct()) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}
		if (orderType == null) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		Receiver defaultReceiver = receiverService.findDefault(currentUser);
		List<Order> orders = orderService.generate(orderType, cart, defaultReceiver, null, null, null, null, null, null);

		BigDecimal price = BigDecimal.ZERO;
		BigDecimal fee = BigDecimal.ZERO;
		BigDecimal freight = BigDecimal.ZERO;
		BigDecimal tax = BigDecimal.ZERO;
		BigDecimal promotionDiscount = BigDecimal.ZERO;
		BigDecimal couponDiscount = BigDecimal.ZERO;
		BigDecimal amount = BigDecimal.ZERO;
		BigDecimal amountPayable = BigDecimal.ZERO;
		Long rewardPoint = 0L;
		Long exchangePoint = 0L;
		boolean isDelivery = false;

		for (Order order : orders) {
			price = price.add(order.getPrice());
			fee = fee.add(order.getFee());
			freight = freight.add(order.getFreight());
			tax = tax.add(order.getTax());
			promotionDiscount = promotionDiscount.add(order.getPromotionDiscount());
			couponDiscount = couponDiscount.add(order.getCouponDiscount());
			amount = amount.add(order.getAmount());
			amountPayable = amountPayable.add(order.getAmountPayable());
			rewardPoint = rewardPoint + order.getRewardPoint();
			exchangePoint = exchangePoint + order.getExchangePoint();
			if (order.getIsDelivery()) {
				isDelivery = true;
			}
		}

		model.addAttribute("skuId", skuId);
		model.addAttribute("quantity", quantity);
		model.addAttribute("cart", cart);
		model.addAttribute("orderType", orderType);
		model.addAttribute("defaultReceiver", defaultReceiver);
		model.addAttribute("orders", orders);
		model.addAttribute("price", price);
		model.addAttribute("fee", fee);
		model.addAttribute("freight", freight);
		model.addAttribute("tax", tax);
		model.addAttribute("promotionDiscount", promotionDiscount);
		model.addAttribute("couponDiscount", couponDiscount);
		model.addAttribute("amount", amount);
		model.addAttribute("amountPayable", amountPayable);
		model.addAttribute("rewardPoint", rewardPoint);
		model.addAttribute("exchangePoint", exchangePoint);
		model.addAttribute("isDelivery", isDelivery);

		List<PaymentMethod> paymentMethods = new ArrayList<>();
		if (cart.contains(Store.Type.GENERAL)) {
			CollectionUtils.select(paymentMethodService.findAll(), new Predicate() {
				@Override
				public boolean evaluate(Object object) {
					PaymentMethod paymentMethod = (PaymentMethod) object;
					return paymentMethod != null && PaymentMethod.Method.ONLINE.equals(paymentMethod.getMethod());
				}
			}, paymentMethods);
		} else {
			paymentMethods = paymentMethodService.findAll();
		}
		model.addAttribute("paymentMethods", paymentMethods);
		model.addAttribute("shippingMethods", shippingMethodService.findAll());
		return "shop/order/checkout";
	}

	/**
	 * 计算
	 */
	@GetMapping("/calculate")
	public ResponseEntity<?> calculate(Long skuId, Integer quantity, Long receiverId, Long paymentMethodId, Long shippingMethodId, String code, String invoiceTitle, String invoiceTaxNumber, BigDecimal balance, String memo, @CurrentUser Member currentUser, @CurrentCart Cart currentCart) {
		Map<String, Object> data = new HashMap<>();
		Cart cart;
		Order.Type orderType;
		if (skuId != null) {
			Sku sku = skuService.find(skuId);
			if (sku == null) {
				return Results.UNPROCESSABLE_ENTITY;
			}
			if (Product.Type.GIFT.equals(sku.getType())) {
				return Results.UNPROCESSABLE_ENTITY;
			}
			if (quantity == null || quantity < 1) {
				return Results.UNPROCESSABLE_ENTITY;
			}

			cart = generateCart(currentUser, sku, quantity);

			switch (sku.getType()) {
			case GENERAL:
				orderType = Order.Type.GENERAL;
				break;
			case EXCHANGE:
				orderType = Order.Type.EXCHANGE;
				break;
			default:
				orderType = null;
				break;
			}
		} else {
			cart = currentCart;
			orderType = Order.Type.GENERAL;
		}
		if (cart == null || cart.isEmpty()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (cart.hasNotActive()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (cart.hasNotMarketable()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (cart.hasLowStock()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (cart.hasExpiredProduct()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (orderType == null) {
			return Results.UNPROCESSABLE_ENTITY;
		}

		Receiver receiver = receiverService.find(receiverId);
		if (receiver != null && !currentUser.equals(receiver.getMember())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (balance != null && balance.compareTo(BigDecimal.ZERO) < 0) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (balance != null && balance.compareTo(currentUser.getAvailableBalance()) > 0) {
			return Results.unprocessableEntity("shop.order.insufficientBalance");
		}
		PaymentMethod paymentMethod = paymentMethodService.find(paymentMethodId);
		if (cart.contains(Store.Type.GENERAL) && paymentMethod != null && PaymentMethod.Method.OFFLINE.equals(paymentMethod.getMethod())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		ShippingMethod shippingMethod = shippingMethodService.find(shippingMethodId);
		CouponCode couponCode = couponCodeService.findByCode(code);
		if (couponCode != null && couponCode.getCoupon() != null && !cart.isValid(couponCode.getCoupon().getStore(), couponCode)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		Invoice invoice = StringUtils.isNotEmpty(invoiceTitle) ? new Invoice(invoiceTitle, invoiceTaxNumber, null) : null;
		List<Order> orders = orderService.generate(orderType, cart, receiver, paymentMethod, shippingMethod, couponCode, invoice, balance, memo);

		BigDecimal price = BigDecimal.ZERO;
		BigDecimal fee = BigDecimal.ZERO;
		BigDecimal freight = BigDecimal.ZERO;
		BigDecimal tax = BigDecimal.ZERO;
		BigDecimal promotionDiscount = BigDecimal.ZERO;
		BigDecimal couponDiscount = BigDecimal.ZERO;
		BigDecimal amount = BigDecimal.ZERO;
		BigDecimal amountPayable = BigDecimal.ZERO;
		Long rewardPoint = 0L;
		Long exchangePoint = 0L;
		boolean isDelivery = false;

		for (Order order : orders) {
			price = price.add(order.getPrice());
			fee = fee.add(order.getFee());
			freight = freight.add(order.getFreight());
			tax = tax.add(order.getTax());
			promotionDiscount = promotionDiscount.add(order.getPromotionDiscount());
			couponDiscount = couponDiscount.add(order.getCouponDiscount());
			amount = amount.add(order.getAmount());
			amountPayable = amountPayable.add(order.getAmountPayable());
			rewardPoint = rewardPoint + order.getRewardPoint();
			exchangePoint = exchangePoint + order.getExchangePoint();
			if (order.getIsDelivery()) {
				isDelivery = true;
			}
		}

		data.put("price", price);
		data.put("fee", fee);
		data.put("freight", freight);
		data.put("tax", tax);
		data.put("promotionDiscount", promotionDiscount);
		data.put("couponDiscount", couponDiscount);
		data.put("amount", amount);
		data.put("amountPayable", amountPayable);
		data.put("rewardPoint", rewardPoint);
		data.put("exchangePoint", exchangePoint);
		data.put("isDelivery", isDelivery);
		return ResponseEntity.ok(data);
	}

	/**
	 * 创建
	 */
	@PostMapping("/create")
	public ResponseEntity<?> create(Long skuId, Integer quantity, String cartTag, Long receiverId, Long paymentMethodId, Long shippingMethodId, String code, String invoiceTitle, String invoiceTaxNumber, BigDecimal balance, String memo, @CurrentUser Member currentUser,
			@CurrentCart Cart currentCart) {
		Map<String, Object> data = new HashMap<>();
		Cart cart;
		Order.Type orderType;
		if (skuId != null) {
			Sku sku = skuService.find(skuId);
			if (sku == null) {
				return Results.UNPROCESSABLE_ENTITY;
			}
			if (Product.Type.GIFT.equals(sku.getType())) {
				return Results.UNPROCESSABLE_ENTITY;
			}
			if (quantity == null || quantity < 1) {
				return Results.UNPROCESSABLE_ENTITY;
			}

			cart = generateCart(currentUser, sku, quantity);

			switch (sku.getType()) {
			case GENERAL:
				orderType = Order.Type.GENERAL;
				break;
			case EXCHANGE:
				orderType = Order.Type.EXCHANGE;
				break;
			default:
				orderType = null;
				break;
			}
		} else {
			cart = currentCart;
			orderType = Order.Type.GENERAL;
		}
		if (cart == null || cart.isEmpty()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (cartTag != null && !StringUtils.equals(cart.getTag(), cartTag)) {
			return Results.unprocessableEntity("shop.order.cartHasChanged");
		}
		if (cart.hasNotActive()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (cart.hasNotMarketable()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (cart.hasLowStock()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (cart.hasExpiredProduct()) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (orderType == null) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		Receiver receiver = cart.getIsDelivery() ? receiverService.find(receiverId) : null;
		if (cart.getIsDelivery() && (receiver == null || !currentUser.equals(receiver.getMember()))) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (balance != null && balance.compareTo(BigDecimal.ZERO) < 0) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (balance != null && balance.compareTo(currentUser.getAvailableBalance()) > 0) {
			return Results.unprocessableEntity("shop.order.insufficientBalance");
		}
		if (currentUser.getPoint() < cart.getExchangePoint()) {
			return Results.unprocessableEntity("shop.order.lowPoint");
		}
		PaymentMethod paymentMethod = paymentMethodService.find(paymentMethodId);
		if (cart.contains(Store.Type.GENERAL) && paymentMethod != null && PaymentMethod.Method.OFFLINE.equals(paymentMethod.getMethod())) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		ShippingMethod shippingMethod = shippingMethodService.find(shippingMethodId);
		if (cart.getIsDelivery() && shippingMethod == null) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		CouponCode couponCode = couponCodeService.findByCode(code);
		if (couponCode != null && couponCode.getCoupon() != null && !cart.isValid(couponCode.getCoupon().getStore(), couponCode)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		Invoice invoice = StringUtils.isNotEmpty(invoiceTitle) ? new Invoice(invoiceTitle, invoiceTaxNumber, null) : null;
		List<Order> orders = orderService.create(orderType, cart, receiver, paymentMethod, shippingMethod, couponCode, invoice, balance, memo);
		List<String> orderSns = new ArrayList<>();
		for (Order order : orders) {
			if (order != null && order.getAmount().compareTo(order.getAmountPaid()) > 0 && order.getAmountPayable().compareTo(BigDecimal.ZERO) > 0) {
				orderSns.add(order.getSn());
			}
		}
		data.put("orderSns", orderSns);
		return ResponseEntity.ok(data);
	}

	/**
	 * 支付
	 */
	@GetMapping("/payment")
	public String payment(String[] orderSns, @CurrentUser Member currentUser, ModelMap model) {
		if (ArrayUtils.isEmpty(orderSns)) {
			return UNPROCESSABLE_ENTITY_VIEW;
		}

		List<PaymentPlugin> paymentPlugins = pluginService.getActivePaymentPlugins(WebUtils.getRequest());
		PaymentPlugin defaultPaymentPlugin = null;
		PaymentMethod orderPaymentMethod = null;
		BigDecimal fee = BigDecimal.ZERO;
		BigDecimal amount = BigDecimal.ZERO;
		boolean online = false;
		List<Order> orders = new ArrayList<>();
		for (String orderSn : orderSns) {
			Order order = orderService.findBySn(orderSn);
			if (order == null) {
				return UNPROCESSABLE_ENTITY_VIEW;
			}
			BigDecimal amountPayable = order.getAmountPayable();
			if (order.getAmount().compareTo(order.getAmountPaid()) <= 0 || amountPayable.compareTo(BigDecimal.ZERO) <= 0) {
				return "redirect:/member/order/list";
			}
			orderPaymentMethod = order.getPaymentMethod();
			if (!currentUser.equals(order.getMember()) || orderPaymentMethod == null) {
				return UNPROCESSABLE_ENTITY_VIEW;
			}
			if (PaymentMethod.Method.ONLINE.equals(orderPaymentMethod.getMethod())) {
				if (!orderService.acquireLock(order, currentUser)) {
					return "redirect:/member/order/list";
				}
				if (CollectionUtils.isNotEmpty(paymentPlugins)) {
					defaultPaymentPlugin = paymentPlugins.get(0);
				}
				online = true;
			} else {
				fee = fee.add(order.getFee());
				online = false;
			}
			amount = amount.add(amountPayable);
			orders.add(order);
		}
		if (online && defaultPaymentPlugin != null) {
			fee = defaultPaymentPlugin.calculateFee(amount).add(fee);
			amount = fee.add(amount);
			model.addAttribute("online", online);
			model.addAttribute("defaultPaymentPlugin", defaultPaymentPlugin);
			model.addAttribute("paymentPlugins", paymentPlugins);
		}
		if (CollectionUtils.isNotEmpty(orders)) {
			Order order = orders.get(0);
			model.addAttribute("shippingMethodName", order.getShippingMethodName());
			model.addAttribute("paymentMethodName", order.getPaymentMethodName());
			model.addAttribute("paymentMethod", orderPaymentMethod);
			model.addAttribute("expireDate", order.getExpire());
		}
		model.addAttribute("fee", fee);
		model.addAttribute("amount", amount);
		model.addAttribute("orders", orders);
		model.addAttribute("orderSns", Arrays.asList(orderSns));
		return "shop/order/payment";
	}

	/**
	 * 计算支付金额
	 */
	@GetMapping("/calculate_amount")
	public ResponseEntity<?> calculateAmount(String paymentPluginId, String[] orderSns, @CurrentUser Member currentUser) {
		Map<String, Object> data = new HashMap<>();
		if (ArrayUtils.isEmpty(orderSns)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		PaymentPlugin paymentPlugin = pluginService.getPaymentPlugin(paymentPluginId);
		BigDecimal amount = BigDecimal.ZERO;
		for (String orderSn : orderSns) {
			Order order = orderService.findBySn(orderSn);
			if (order == null || !currentUser.equals(order.getMember()) || paymentPlugin == null || !paymentPlugin.getIsEnabled()) {
				return Results.UNPROCESSABLE_ENTITY;
			}
			amount = amount.add(order.getAmountPayable());
		}
		BigDecimal fee = paymentPlugin.calculateFee(amount);
		data.put("fee", fee);
		data.put("amount", amount.add(fee));
		return ResponseEntity.ok(data);
	}

	/**
	 * 生成购物车
	 * 
	 * @param member
	 *            会员
	 * @param sku
	 *            SKU
	 * @param quantity
	 *            数量
	 * @return 购物车
	 */
	public Cart generateCart(Member member, Sku sku, Integer quantity) {
		Assert.notNull(member, "[Assertion failed] - member is required; it must not be null");
		Assert.notNull(sku, "[Assertion failed] - sku is required; it must not be null");
		Assert.state(!Product.Type.GIFT.equals(sku.getType()), "[Assertion failed] - sku type can't be GIFT");
		Assert.notNull(quantity, "[Assertion failed] - quantity is required; it must not be null");
		Assert.state(quantity > 0, "[Assertion failed] - quantity must be greater than 0");

		Cart cart = new Cart();
		Set<CartItem> cartItems = new HashSet<>();
		CartItem cartItem = new CartItem();
		cartItem.setSku(sku);
		cartItem.setQuantity(quantity);
		cartItems.add(cartItem);
		cartItem.setCart(cart);
		cart.setMember(member);
		cart.setCartItems(cartItems);
		return cart;
	}

}