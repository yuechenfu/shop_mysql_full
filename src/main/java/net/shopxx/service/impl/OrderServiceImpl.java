/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: 2r4m/J8Br3YIZbbAwPngS7Jpx+HdHnq1
 */
package net.shopxx.service.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.inject.Inject;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;
import org.hibernate.search.jpa.FullTextEntityManager;
import org.hibernate.search.jpa.Search;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import net.sf.ehcache.CacheManager;
import net.sf.ehcache.Ehcache;
import net.sf.ehcache.Element;
import net.shopxx.Filter;
import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.Setting;
import net.shopxx.dao.CartDao;
import net.shopxx.dao.DistributionCommissionDao;
import net.shopxx.dao.MemberDao;
import net.shopxx.dao.OrderDao;
import net.shopxx.dao.OrderLogDao;
import net.shopxx.dao.OrderPaymentDao;
import net.shopxx.dao.OrderRefundsDao;
import net.shopxx.dao.OrderReturnsDao;
import net.shopxx.dao.OrderShippingDao;
import net.shopxx.dao.ProductDao;
import net.shopxx.dao.SnDao;
import net.shopxx.dao.StoreDao;
import net.shopxx.entity.BusinessDepositLog;
import net.shopxx.entity.Cart;
import net.shopxx.entity.CartItem;
import net.shopxx.entity.Coupon;
import net.shopxx.entity.CouponCode;
import net.shopxx.entity.DistributionCommission;
import net.shopxx.entity.Distributor;
import net.shopxx.entity.Invoice;
import net.shopxx.entity.Member;
import net.shopxx.entity.MemberDepositLog;
import net.shopxx.entity.Order;
import net.shopxx.entity.Order.CommissionType;
import net.shopxx.entity.Order.Status;
import net.shopxx.entity.Order.Type;
import net.shopxx.entity.OrderItem;
import net.shopxx.entity.OrderLog;
import net.shopxx.entity.OrderPayment;
import net.shopxx.entity.OrderRefunds;
import net.shopxx.entity.OrderReturns;
import net.shopxx.entity.OrderReturnsItem;
import net.shopxx.entity.OrderShipping;
import net.shopxx.entity.OrderShippingItem;
import net.shopxx.entity.PaymentMethod;
import net.shopxx.entity.PointLog;
import net.shopxx.entity.Product;
import net.shopxx.entity.Receiver;
import net.shopxx.entity.ShippingMethod;
import net.shopxx.entity.Sku;
import net.shopxx.entity.Sn;
import net.shopxx.entity.StockLog;
import net.shopxx.entity.Store;
import net.shopxx.entity.User;
import net.shopxx.service.BusinessService;
import net.shopxx.service.CouponCodeService;
import net.shopxx.service.MailService;
import net.shopxx.service.MemberService;
import net.shopxx.service.OrderService;
import net.shopxx.service.ProductService;
import net.shopxx.service.ShippingMethodService;
import net.shopxx.service.SkuService;
import net.shopxx.service.SmsService;
import net.shopxx.service.UserService;
import net.shopxx.util.SystemUtils;

/**
 * Service - 订单
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Service
public class OrderServiceImpl extends BaseServiceImpl<Order, Long> implements OrderService {

	@PersistenceContext
	private EntityManager entityManager;
	@Inject
	private CacheManager cacheManager;
	@Inject
	private StoreDao storeDao;
	@Inject
	private MemberDao memberDao;
	@Inject
	private ProductDao productDao;
	@Inject
	private OrderDao orderDao;
	@Inject
	private OrderLogDao orderLogDao;
	@Inject
	private CartDao cartDao;
	@Inject
	private SnDao snDao;
	@Inject
	private OrderPaymentDao orderPaymentDao;
	@Inject
	private OrderRefundsDao orderRefundsDao;
	@Inject
	private OrderShippingDao orderShippingDao;
	@Inject
	private OrderReturnsDao orderReturnsDao;
	@Inject
	private DistributionCommissionDao distributionCommissionDao;
	@Inject
	private UserService userService;
	@Inject
	private MemberService memberService;
	@Inject
	private BusinessService businessService;
	@Inject
	private CouponCodeService couponCodeService;
	@Inject
	private ProductService productService;
	@Inject
	private SkuService skuService;
	@Inject
	private ShippingMethodService shippingMethodService;
	@Inject
	private MailService mailService;
	@Inject
	private SmsService smsService;

	@Override
	@Transactional(readOnly = true)
	public Order findBySn(String sn) {
		return orderDao.find("sn", StringUtils.lowerCase(sn));
	}

	@Override
	@Transactional(readOnly = true)
	public List<Order> findList(Order.Type type, Order.Status status, Store store, Member member, Product product, Boolean isPendingReceive, Boolean isPendingRefunds, Boolean isUseCouponCode, Boolean isExchangePoint, Boolean isAllocatedStock, Boolean hasExpired, Integer count, List<Filter> filters,
			List<net.shopxx.Order> orders) {
		return orderDao.findList(type, status, store, member, product, isPendingReceive, isPendingRefunds, isUseCouponCode, isExchangePoint, isAllocatedStock, hasExpired, count, filters, orders);
	}

	@Override
	@Transactional(readOnly = true)
	public Page<Order> findPage(Order.Type type, Order.Status status, Store store, Member member, Product product, Boolean isPendingReceive, Boolean isPendingRefunds, Boolean isUseCouponCode, Boolean isExchangePoint, Boolean isAllocatedStock, Boolean hasExpired, Pageable pageable) {
		return orderDao.findPage(type, status, store, member, product, isPendingReceive, isPendingRefunds, isUseCouponCode, isExchangePoint, isAllocatedStock, hasExpired, pageable);
	}

	@Override
	@Transactional(readOnly = true)
	public Long count(Type type, Status status, Store store, Member member, Product product, Boolean isPendingReceive, Boolean isPendingRefunds, Boolean isUseCouponCode, Boolean isExchangePoint, Boolean isAllocatedStock, Boolean hasExpired) {
		return orderDao.count(type, status, store, member, product, isPendingReceive, isPendingRefunds, isUseCouponCode, isExchangePoint, isAllocatedStock, hasExpired);
	}

	@Override
	@Transactional(readOnly = true)
	public Long count(Order.Type type, Order.Status status, Long storeId, Long memberId, Long productId, Boolean isPendingReceive, Boolean isPendingRefunds, Boolean isUseCouponCode, Boolean isExchangePoint, Boolean isAllocatedStock, Boolean hasExpired) {
		Store store = storeDao.find(storeId);
		if (storeId != null && store == null) {
			return 0L;
		}
		Member member = memberDao.find(memberId);
		if (memberId != null && member == null) {
			return 0L;
		}
		Product product = productDao.find(productId);
		if (productId != null && product == null) {
			return 0L;
		}

		return orderDao.count(type, status, store, member, product, isPendingReceive, isPendingRefunds, isUseCouponCode, isExchangePoint, isAllocatedStock, hasExpired);
	}

	@Override
	@Transactional(readOnly = true)
	public BigDecimal calculateTax(BigDecimal price, BigDecimal promotionDiscount, BigDecimal couponDiscount, BigDecimal offsetAmount) {
		Assert.notNull(price, "[Assertion failed] - price is required; it must not be null");
		Assert.state(price.compareTo(BigDecimal.ZERO) >= 0, "[Assertion failed] - price must be equal or greater than 0");
		Assert.state(promotionDiscount == null || promotionDiscount.compareTo(BigDecimal.ZERO) >= 0, "[Assertion failed] - promotionDiscount must be null or promotionDiscount must be equal or greater than 0");
		Assert.state(couponDiscount == null || couponDiscount.compareTo(BigDecimal.ZERO) >= 0, "[Assertion failed] - couponDiscount must be null or couponDiscount must be equal or greater than 0");

		Setting setting = SystemUtils.getSetting();
		if (!setting.getIsTaxPriceEnabled()) {
			return BigDecimal.ZERO;
		}
		BigDecimal amount = price;
		if (promotionDiscount != null) {
			amount = amount.subtract(promotionDiscount);
		}
		if (couponDiscount != null) {
			amount = amount.subtract(couponDiscount);
		}
		if (offsetAmount != null) {
			amount = amount.add(offsetAmount);
		}
		BigDecimal tax = amount.multiply(new BigDecimal(String.valueOf(setting.getTaxRate())));
		return tax.compareTo(BigDecimal.ZERO) >= 0 ? setting.setScale(tax) : BigDecimal.ZERO;
	}

	@Override
	@Transactional(readOnly = true)
	public BigDecimal calculateTax(Order order) {
		Assert.notNull(order, "[Assertion failed] - order is required; it must not be null");

		if (order.getInvoice() == null) {
			return BigDecimal.ZERO;
		}
		return calculateTax(order.getPrice(), order.getPromotionDiscount(), order.getCouponDiscount(), order.getOffsetAmount());
	}

	@Override
	@Transactional(readOnly = true)
	public BigDecimal calculateAmount(BigDecimal price, BigDecimal fee, BigDecimal freight, BigDecimal tax, BigDecimal promotionDiscount, BigDecimal couponDiscount, BigDecimal offsetAmount) {
		Assert.notNull(price, "[Assertion failed] - price is required; it must not be null");
		Assert.state(price.compareTo(BigDecimal.ZERO) >= 0, "[Assertion failed] - price must be equal or greater than 0");
		Assert.state(fee == null || fee.compareTo(BigDecimal.ZERO) >= 0, "[Assertion failed] - fee must be null or fee must be equal or greater than 0");
		Assert.state(freight == null || freight.compareTo(BigDecimal.ZERO) >= 0, "[Assertion failed] - freight must be null or freight must be equal or greater than 0");
		Assert.state(tax == null || tax.compareTo(BigDecimal.ZERO) >= 0, "[Assertion failed] - tax must be null or tax must be equal or greater than 0");
		Assert.state(promotionDiscount == null || promotionDiscount.compareTo(BigDecimal.ZERO) >= 0, "[Assertion failed] - promotionDiscount must be null or promotionDiscount must be equal or greater than 0");
		Assert.state(couponDiscount == null || couponDiscount.compareTo(BigDecimal.ZERO) >= 0, "[Assertion failed] - couponDiscount must be null or couponDiscount must be equal or greater than 0");

		Setting setting = SystemUtils.getSetting();
		BigDecimal amount = price;
		if (fee != null) {
			amount = amount.add(fee);
		}
		if (freight != null) {
			amount = amount.add(freight);
		}
		if (tax != null) {
			amount = amount.add(tax);
		}
		if (promotionDiscount != null) {
			amount = amount.subtract(promotionDiscount);
		}
		if (couponDiscount != null) {
			amount = amount.subtract(couponDiscount);
		}
		if (offsetAmount != null) {
			amount = amount.add(offsetAmount);
		}
		return amount.compareTo(BigDecimal.ZERO) >= 0 ? setting.setScale(amount) : BigDecimal.ZERO;
	}

	@Override
	@Transactional(readOnly = true)
	public BigDecimal calculateAmount(Order order) {
		Assert.notNull(order, "[Assertion failed] - order is required; it must not be null");

		return calculateAmount(order.getPrice(), order.getFee(), order.getFreight(), order.getTax(), order.getPromotionDiscount(), order.getCouponDiscount(), order.getOffsetAmount());
	}

	@Override
	@Transactional(readOnly = true)
	public boolean acquireLock(Order order, User user) {
		Assert.notNull(order, "[Assertion failed] - order is required; it must not be null");
		Assert.isTrue(!order.isNew(), "[Assertion failed] - order must not be new");
		Assert.notNull(user, "[Assertion failed] - user is required; it must not be null");
		Assert.isTrue(!user.isNew(), "[Assertion failed] - user must not be new");

		Long orderId = order.getId();
		Ehcache cache = cacheManager.getEhcache(Order.ORDER_LOCK_CACHE_NAME);
		cache.acquireWriteLockOnKey(orderId);
		try {
			Element element = cache.get(orderId);
			if (element != null && !user.getId().equals(element.getObjectValue())) {
				return false;
			}
			cache.put(new Element(orderId, user.getId()));
		} finally {
			cache.releaseWriteLockOnKey(orderId);
		}
		return true;
	}

	@Override
	@Transactional(readOnly = true)
	public boolean acquireLock(Order order) {
		User currentUser = userService.getCurrent();
		return currentUser != null && acquireLock(order, currentUser);
	}

	@Override
	@Transactional(readOnly = true)
	public void releaseLock(Order order) {
		Assert.notNull(order, "[Assertion failed] - order is required; it must not be null");
		Assert.isTrue(!order.isNew(), "[Assertion failed] - order must not be new");

		Ehcache cache = cacheManager.getEhcache(Order.ORDER_LOCK_CACHE_NAME);
		cache.remove(order.getId());
	}

	@Override
	public void expiredRefundHandle() {
		while (true) {
			List<Order> orders = orderDao.findList(null, null, null, null, null, null, true, null, null, null, true, 100, null, null);
			if (CollectionUtils.isNotEmpty(orders)) {
				for (Order order : orders) {
					expiredRefund(order);
				}
				orderDao.flush();
				orderDao.clear();
			}
			if (orders.size() < 100) {
				break;
			}
		}
	}

	@Override
	public void expiredRefund(Order order) {
		if (order == null || order.getRefundableAmount().compareTo(BigDecimal.ZERO) <= 0) {
			return;
		}

		OrderRefunds orderRefunds = new OrderRefunds();
		orderRefunds.setSn(snDao.generate(Sn.Type.ORDER_REFUNDS));
		orderRefunds.setMethod(OrderRefunds.Method.DEPOSIT);
		orderRefunds.setAmount(order.getRefundableAmount());
		orderRefunds.setOrder(order);
		orderRefundsDao.persist(orderRefunds);

		memberService.addBalance(order.getMember(), orderRefunds.getAmount(), MemberDepositLog.Type.ORDER_REFUNDS, null);

		order.setAmountPaid(order.getAmountPaid().subtract(orderRefunds.getAmount()));
		order.setRefundAmount(order.getRefundAmount().add(orderRefunds.getAmount()));

		OrderLog orderLog = new OrderLog();
		orderLog.setType(OrderLog.Type.REFUNDS);
		orderLog.setOrder(order);
		orderLogDao.persist(orderLog);

		mailService.sendRefundsOrderMail(order);
		smsService.sendRefundsOrderSms(order);
	}

	@Override
	public void undoExpiredUseCouponCode() {
		while (true) {
			List<Order> orders = orderDao.findList(null, null, null, null, null, null, null, true, null, null, true, 100, null, null);
			if (CollectionUtils.isNotEmpty(orders)) {
				for (Order order : orders) {
					undoUseCouponCode(order);
				}
				orderDao.flush();
				orderDao.clear();
			}
			if (orders.size() < 100) {
				break;
			}
		}
	}

	@Override
	public void undoExpiredExchangePoint() {
		while (true) {
			List<Order> orders = orderDao.findList(null, null, null, null, null, null, null, null, true, null, true, 100, null, null);
			if (CollectionUtils.isNotEmpty(orders)) {
				for (Order order : orders) {
					undoExchangePoint(order);
				}
				orderDao.flush();
				orderDao.clear();
			}
			if (orders.size() < 100) {
				break;
			}
		}
	}

	@Override
	public void releaseExpiredAllocatedStock() {
		FullTextEntityManager fullTextEntityManager = Search.getFullTextEntityManager(entityManager);
		while (true) {
			List<Order> orders = orderDao.findList(null, null, null, null, null, null, null, null, null, true, true, 100, null, null);
			if (CollectionUtils.isNotEmpty(orders)) {
				for (Order order : orders) {
					releaseAllocatedStock(order);
				}
				orderDao.flush();
				fullTextEntityManager.flushToIndexes();
				orderDao.clear();
				fullTextEntityManager.clear();
			}
			if (orders.size() < 100) {
				break;
			}
		}
	}

	@Override
	@Transactional(readOnly = true)
	public List<Order> generate(Order.Type type, Cart cart, Receiver receiver, PaymentMethod paymentMethod, ShippingMethod shippingMethod, CouponCode couponCode, Invoice invoice, BigDecimal balance, String memo) {
		Assert.notNull(type, "[Assertion failed] - type is required; it must not be null");
		Assert.notNull(cart, "[Assertion failed] - cart is required; it must not be null");
		Assert.notNull(cart.getMember(), "[Assertion failed] - cart member is required; it must not be null");
		Assert.state(!cart.isEmpty(), "[Assertion failed] - cart must not be empty");

		Setting setting = SystemUtils.getSetting();
		Member member = cart.getMember();
		BigDecimal price = BigDecimal.ZERO;
		BigDecimal discount = BigDecimal.ZERO;
		Long rewardPoint = 0L;
		BigDecimal couponDiscount = BigDecimal.ZERO;

		List<Order> orders = new ArrayList<>();
		for (Map.Entry<Store, Set<CartItem>> entry : cart.getCartItemGroup().entrySet()) {
			Store store = entry.getKey();
			Set<CartItem> cartItems = entry.getValue();

			price = cart.getPrice(store);
			discount = cart.getDiscount(store);
			rewardPoint = cart.getRewardPoint(store);
			couponDiscount = couponCode != null && cart.isCouponAllowed(store) && cart.isValid(store, couponCode) ? cart.getEffectivePrice(store).subtract(couponCode.getCoupon().calculatePrice(cart.getEffectivePrice(store), cart.getQuantity(store, false))) : BigDecimal.ZERO;
			Order order = new Order();
			order.setType(type);
			order.setPrice(price);
			order.setFee(BigDecimal.ZERO);
			order.setPromotionDiscount(discount);
			order.setOffsetAmount(BigDecimal.ZERO);
			order.setRefundAmount(BigDecimal.ZERO);
			order.setRewardPoint(rewardPoint);
			order.setExchangePoint(cart.getExchangePoint(store));
			order.setWeight(cart.getWeight(store, true, false));
			order.setQuantity(cart.getQuantity(store, true));
			order.setShippedQuantity(0);
			order.setReturnedQuantity(0);
			order.setMemo(memo);
			order.setIsUseCouponCode(false);
			order.setIsReviewed(false);
			order.setIsExchangePoint(false);
			order.setIsAllocatedStock(false);
			order.setInvoice(setting.getIsInvoiceEnabled() ? invoice : null);
			order.setPaymentMethod(paymentMethod);
			order.setMember(member);
			order.setStore(store);
			order.setPromotionNames(new ArrayList<>(cart.getPromotionNames(store)));
			order.setCoupons(new ArrayList<>(cart.getCoupons(store)));

			if (shippingMethod != null && shippingMethod.isSupported(paymentMethod) && cart.getIsDelivery(store)) {
				order.setFreight(!cart.isFreeShipping(store) ? shippingMethodService.calculateFreight(shippingMethod, store, receiver, cart.getWeight(store, true, true)) : BigDecimal.ZERO);
				order.setShippingMethod(shippingMethod);
			} else {
				order.setFreight(BigDecimal.ZERO);
				order.setShippingMethod(null);
			}

			if (couponCode != null && cart.isCouponAllowed(store) && cart.isValid(store, couponCode)) {
				order.setCouponDiscount(couponDiscount.compareTo(BigDecimal.ZERO) >= 0 ? couponDiscount : BigDecimal.ZERO);
				order.setCouponCode(couponCode);
			} else {
				order.setCouponDiscount(BigDecimal.ZERO);
				order.setCouponCode(null);
			}

			order.setTax(calculateTax(order));
			order.setAmount(calculateAmount(order));

			if (balance != null && balance.compareTo(BigDecimal.ZERO) > 0 && balance.compareTo(member.getAvailableBalance()) <= 0) {
				BigDecimal currentAmountPaid = balance.compareTo(order.getAmount()) > 0 ? order.getAmount() : balance;
				order.setAmountPaid(currentAmountPaid);
				balance = balance.subtract(currentAmountPaid);
			} else {
				order.setAmountPaid(BigDecimal.ZERO);
			}

			if (cart.getIsDelivery(store) && receiver != null) {
				order.setConsignee(receiver.getConsignee());
				order.setAreaName(receiver.getAreaName());
				order.setAddress(receiver.getAddress());
				order.setZipCode(receiver.getZipCode());
				order.setPhone(receiver.getPhone());
				order.setArea(receiver.getArea());
			}

			List<OrderItem> orderItems = order.getOrderItems();
			for (CartItem cartItem : cartItems) {
				Sku sku = cartItem.getSku();
				if (sku != null) {
					OrderItem orderItem = new OrderItem();
					orderItem.setSn(sku.getSn());
					orderItem.setName(sku.getName());
					orderItem.setType(sku.getType());
					orderItem.setPrice(cartItem.getPrice());
					orderItem.setWeight(sku.getWeight());
					orderItem.setIsDelivery(sku.getIsDelivery());
					orderItem.setThumbnail(sku.getThumbnail());
					orderItem.setQuantity(cartItem.getQuantity());
					orderItem.setShippedQuantity(0);
					orderItem.setReturnedQuantity(0);
					orderItem.setSku(cartItem.getSku());
					orderItem.setOrder(order);
					orderItem.setSpecifications(sku.getSpecifications());
					orderItems.add(orderItem);
				}
			}

			for (Sku gift : cart.getGifts(store)) {
				OrderItem orderItem = new OrderItem();
				orderItem.setSn(gift.getSn());
				orderItem.setName(gift.getName());
				orderItem.setType(gift.getType());
				orderItem.setPrice(BigDecimal.ZERO);
				orderItem.setWeight(gift.getWeight());
				orderItem.setIsDelivery(gift.getIsDelivery());
				orderItem.setThumbnail(gift.getThumbnail());
				orderItem.setQuantity(1);
				orderItem.setShippedQuantity(0);
				orderItem.setReturnedQuantity(0);
				orderItem.setSku(gift);
				orderItem.setOrder(order);
				orderItem.setSpecifications(gift.getSpecifications());
				orderItems.add(orderItem);
			}
			orders.add(order);
		}
		return orders;
	}

	@Override
	public List<Order> create(Order.Type type, final Cart cart, Receiver receiver, PaymentMethod paymentMethod, ShippingMethod shippingMethod, CouponCode couponCode, Invoice invoice, BigDecimal balance, String memo) {
		Assert.notNull(type, "[Assertion failed] - type is required; it must not be null");
		Assert.notNull(cart, "[Assertion failed] - cart is required; it must not be null");
		Assert.notNull(cart.getMember(), "[Assertion failed] - cart member is required; it must not be null");
		Assert.state(!cart.isEmpty(), "[Assertion failed] - cart must not be empty");

		if (cart.getIsDelivery()) {
			Assert.notNull(receiver, "[Assertion failed] - receiver is required; it must not be null");
			Assert.notNull(shippingMethod, "[Assertion failed] - shippingMethod is required; it must not be null");
			Assert.state(shippingMethod.isSupported(paymentMethod), "[Assertion failed] - shippingMethod must supported paymentMethod");
		} else {
			Assert.isNull(receiver, "[Assertion failed] - receiver must be null");
			Assert.isNull(shippingMethod, "[Assertion failed] - shippingMethod must be null");
		}

		for (CartItem cartItem : cart.getCartItems()) {
			Sku sku = cartItem.getSku();
			if (sku == null || !sku.getIsMarketable() || cartItem.getQuantity() > sku.getAvailableStock()) {
				throw new IllegalArgumentException();
			}
		}

		List<Order> orders = new ArrayList<>();
		for (Map.Entry<Store, Set<CartItem>> entry : cart.getCartItemGroup().entrySet()) {
			Store store = entry.getKey();
			Set<CartItem> cartItems = entry.getValue();

			for (Sku gift : cart.getGifts(store)) {
				if (!gift.getIsMarketable() || gift.getIsOutOfStock()) {
					throw new IllegalArgumentException();
				}
			}

			Setting setting = SystemUtils.getSetting();
			Member member = cart.getMember();
			Order order = new Order();
			order.setSn(snDao.generate(Sn.Type.ORDER));
			order.setType(type);
			order.setPrice(cart.getPrice(store));
			order.setFee(BigDecimal.ZERO);
			order.setFreight(cart.getIsDelivery(store) && !cart.isFreeShipping(store) ? shippingMethodService.calculateFreight(shippingMethod, store, receiver, cart.getWeight(store, true, true)) : BigDecimal.ZERO);
			order.setPromotionDiscount(cart.getDiscount(store));
			order.setOffsetAmount(BigDecimal.ZERO);
			order.setAmountPaid(BigDecimal.ZERO);
			order.setRefundAmount(BigDecimal.ZERO);
			order.setRewardPoint(cart.getRewardPoint(store));
			order.setExchangePoint(cart.getExchangePoint(store));
			order.setWeight(cart.getWeight(store, true, false));
			order.setQuantity(cart.getQuantity(store, true));
			order.setShippedQuantity(0);
			order.setReturnedQuantity(0);
			if (cart.getIsDelivery(store)) {
				order.setConsignee(receiver.getConsignee());
				order.setAreaName(receiver.getAreaName());
				order.setAddress(receiver.getAddress());
				order.setZipCode(receiver.getZipCode());
				order.setPhone(receiver.getPhone());
				order.setArea(receiver.getArea());
				order.setShippingMethod(shippingMethod);
			}
			order.setMemo(memo);
			order.setIsUseCouponCode(false);
			order.setIsReviewed(false);
			order.setIsExchangePoint(false);
			order.setIsAllocatedStock(false);
			order.setInvoice(setting.getIsInvoiceEnabled() ? invoice : null);
			order.setMember(member);
			order.setStore(store);
			order.setPromotionNames(cart.getPromotionNames(store));
			order.setCoupons(new ArrayList<>(cart.getCoupons(store)));

			if (couponCode != null && couponCode.getCoupon().getStore().equals(store)) {
				if (!cart.isCouponAllowed(store) || !cart.isValid(store, couponCode)) {
					throw new IllegalArgumentException();
				}
				BigDecimal couponDiscount = cart.getEffectivePrice(store).subtract(couponCode.getCoupon().calculatePrice(cart.getEffectivePrice(store), cart.getQuantity(store, false)));
				order.setCouponDiscount(couponDiscount.compareTo(BigDecimal.ZERO) >= 0 ? couponDiscount : BigDecimal.ZERO);
				order.setCouponCode(couponCode);
				useCouponCode(order);
			} else {
				order.setCouponDiscount(BigDecimal.ZERO);
			}

			order.setTax(calculateTax(order));
			order.setAmount(calculateAmount(order));
			if (balance != null && (balance.compareTo(BigDecimal.ZERO) < 0 || balance.compareTo(member.getAvailableBalance()) > 0)) {
				throw new IllegalArgumentException();
			}
			BigDecimal amountPayable = balance != null ? order.getAmount().subtract(balance) : order.getAmount();
			if (amountPayable.compareTo(BigDecimal.ZERO) > 0) {
				if (paymentMethod == null) {
					throw new IllegalArgumentException();
				}
				order.setStatus(PaymentMethod.Type.DELIVERY_AGAINST_PAYMENT.equals(paymentMethod.getType()) ? Order.Status.PENDING_PAYMENT : Order.Status.PENDING_REVIEW);
				order.setPaymentMethod(paymentMethod);
				if (paymentMethod.getTimeout() != null && Order.Status.PENDING_PAYMENT.equals(order.getStatus())) {
					order.setExpire(DateUtils.addMinutes(new Date(), paymentMethod.getTimeout()));
				}
			} else {
				order.setStatus(Order.Status.PENDING_REVIEW);
				order.setPaymentMethod(null);
			}

			List<OrderItem> orderItems = order.getOrderItems();
			for (CartItem cartItem : cartItems) {
				Sku sku = cartItem.getSku();
				OrderItem orderItem = new OrderItem();
				orderItem.setSn(sku.getSn());
				orderItem.setName(sku.getName());
				orderItem.setType(sku.getType());
				orderItem.setPrice(cartItem.getPrice());
				orderItem.setWeight(sku.getWeight());
				orderItem.setIsDelivery(sku.getIsDelivery());
				orderItem.setThumbnail(sku.getThumbnail());
				orderItem.setQuantity(cartItem.getQuantity());
				orderItem.setShippedQuantity(0);
				orderItem.setReturnedQuantity(0);
				orderItem.setPlatformCommissionTotals(sku.getPlatformCommission(store.getType()).multiply(new BigDecimal(cartItem.getQuantity())));
				orderItem.setDistributionCommissionTotals(sku.getMaxCommission().multiply(new BigDecimal(cartItem.getQuantity())));
				orderItem.setSku(cartItem.getSku());
				orderItem.setOrder(order);
				orderItem.setSpecifications(sku.getSpecifications());
				orderItems.add(orderItem);
			}

			for (Sku gift : cart.getGifts(store)) {
				OrderItem orderItem = new OrderItem();
				orderItem.setSn(gift.getSn());
				orderItem.setName(gift.getName());
				orderItem.setType(gift.getType());
				orderItem.setPrice(BigDecimal.ZERO);
				orderItem.setWeight(gift.getWeight());
				orderItem.setIsDelivery(gift.getIsDelivery());
				orderItem.setThumbnail(gift.getThumbnail());
				orderItem.setQuantity(1);
				orderItem.setShippedQuantity(0);
				orderItem.setReturnedQuantity(0);
				orderItem.setPlatformCommissionTotals(gift.getPlatformCommission(store.getType()).multiply(new BigDecimal("1")));
				orderItem.setDistributionCommissionTotals(gift.getMaxCommission().multiply(new BigDecimal("1")));
				orderItem.setSku(gift);
				orderItem.setOrder(order);
				orderItem.setSpecifications(gift.getSpecifications());
				orderItems.add(orderItem);
			}

			orderDao.persist(order);

			OrderLog orderLog = new OrderLog();
			orderLog.setType(OrderLog.Type.CREATE);
			orderLog.setOrder(order);
			orderLogDao.persist(orderLog);

			exchangePoint(order);
			if (Setting.StockAllocationTime.ORDER.equals(setting.getStockAllocationTime())
					|| (Setting.StockAllocationTime.PAYMENT.equals(setting.getStockAllocationTime()) && (order.getAmountPaid().compareTo(BigDecimal.ZERO) > 0 || order.getExchangePoint() > 0 || order.getAmountPayable().compareTo(BigDecimal.ZERO) <= 0))) {
				allocateStock(order);
			}

			if (balance != null && balance.compareTo(BigDecimal.ZERO) > 0) {
				OrderPayment orderPayment = new OrderPayment();
				orderPayment.setMethod(OrderPayment.Method.DEPOSIT);
				orderPayment.setFee(BigDecimal.ZERO);
				orderPayment.setOrder(order);
				BigDecimal currentAmount = balance.compareTo(order.getAmount()) > 0 ? order.getAmount() : balance;
				orderPayment.setAmount(currentAmount);
				balance = balance.subtract(currentAmount);
				payment(order, orderPayment);
			}

			mailService.sendCreateOrderMail(order);
			smsService.sendCreateOrderSms(order);
			orders.add(order);
		}

		if (!cart.isNew()) {
			cartDao.remove(cart);
		}
		return orders;
	}

	@Override
	public void modify(Order order) {
		Assert.notNull(order, "[Assertion failed] - order is required; it must not be null");
		Assert.isTrue(!order.isNew(), "[Assertion failed] - order must not be new");
		Assert.state(!order.hasExpired() && (Order.Status.PENDING_PAYMENT.equals(order.getStatus()) || Order.Status.PENDING_REVIEW.equals(order.getStatus())), "[Assertion failed] - order must not be expired and order status must be PENDING_PAYMENT, or order status must be PENDING_REVIEW");

		order.setAmount(calculateAmount(order));
		if (order.getAmountPayable().compareTo(BigDecimal.ZERO) <= 0) {
			order.setStatus(Order.Status.PENDING_REVIEW);
			order.setExpire(null);
		} else {
			if (order.getPaymentMethod() != null && PaymentMethod.Type.DELIVERY_AGAINST_PAYMENT.equals(order.getPaymentMethod().getType())) {
				order.setStatus(Order.Status.PENDING_PAYMENT);
			} else {
				order.setStatus(Order.Status.PENDING_REVIEW);
				order.setExpire(null);
			}
		}

		OrderLog orderLog = new OrderLog();
		orderLog.setType(OrderLog.Type.MODIFY);
		orderLog.setOrder(order);
		orderLogDao.persist(orderLog);

		mailService.sendUpdateOrderMail(order);
		smsService.sendUpdateOrderSms(order);
	}

	@Override
	public void cancel(Order order) {
		Assert.notNull(order, "[Assertion failed] - order is required; it must not be null");
		Assert.isTrue(!order.isNew(), "[Assertion failed] - order must not be new");
		Assert.state(!order.hasExpired() && (Order.Status.PENDING_PAYMENT.equals(order.getStatus()) || Order.Status.PENDING_REVIEW.equals(order.getStatus())), "[Assertion failed] - order must not be expired and order status must be PENDING_PAYMENT, or order status must be PENDING_REVIEW");

		order.setStatus(Order.Status.CANCELED);
		order.setExpire(null);

		undoUseCouponCode(order);
		undoExchangePoint(order);
		releaseAllocatedStock(order);

		if (order.getRefundableAmount().compareTo(BigDecimal.ZERO) > 0) {
			businessService.addBalance(order.getStore().getBusiness(), order.getRefundableAmount(), BusinessDepositLog.Type.ORDER_REFUNDS, null);
		}

		OrderLog orderLog = new OrderLog();
		orderLog.setType(OrderLog.Type.CANCEL);
		orderLog.setOrder(order);
		orderLogDao.persist(orderLog);

		mailService.sendCancelOrderMail(order);
		smsService.sendCancelOrderSms(order);
	}

	@Override
	public void review(Order order, boolean passed) {
		Assert.notNull(order, "[Assertion failed] - order is required; it must not be null");
		Assert.isTrue(!order.isNew(), "[Assertion failed] - order must not be new");
		Assert.state(!order.hasExpired() && Order.Status.PENDING_REVIEW.equals(order.getStatus()), "[Assertion failed] - order must not be expired and order status must be PENDING_REVIEW");

		if (passed) {
			order.setStatus(Order.Status.PENDING_SHIPMENT);
		} else {
			order.setStatus(Order.Status.DENIED);

			if (order.getRefundableAmount().compareTo(BigDecimal.ZERO) > 0) {
				businessService.addBalance(order.getStore().getBusiness(), order.getRefundableAmount(), BusinessDepositLog.Type.ORDER_REFUNDS, null);
			}
			undoUseCouponCode(order);
			undoExchangePoint(order);
			releaseAllocatedStock(order);
		}

		OrderLog orderLog = new OrderLog();
		orderLog.setType(OrderLog.Type.REVIEW);
		orderLog.setOrder(order);
		orderLogDao.persist(orderLog);

		mailService.sendReviewOrderMail(order);
		smsService.sendReviewOrderSms(order);
	}

	@Override
	public void payment(Order order, OrderPayment orderPayment) {
		Assert.notNull(order, "[Assertion failed] - order is required; it must not be null");
		Assert.isTrue(!order.isNew(), "[Assertion failed] - order must not be new");
		Assert.notNull(orderPayment, "[Assertion failed] - orderPayment is required; it must not be null");
		Assert.isTrue(orderPayment.isNew(), "[Assertion failed] - orderPayment must be new");
		Assert.notNull(orderPayment.getAmount(), "[Assertion failed] - orderPayment amount is required; it must not be null");
		Assert.state(orderPayment.getAmount().compareTo(BigDecimal.ZERO) > 0, "[Assertion failed] - orderPayment amount must be greater than 0");

		orderPayment.setSn(snDao.generate(Sn.Type.ORDER_PAYMENT));
		orderPayment.setOrder(order);
		orderPaymentDao.persist(orderPayment);

		if (order.getMember() != null && OrderPayment.Method.DEPOSIT.equals(orderPayment.getMethod())) {
			memberService.addBalance(order.getMember(), orderPayment.getEffectiveAmount().negate(), MemberDepositLog.Type.ORDER_PAYMENT, null);
		}

		Setting setting = SystemUtils.getSetting();
		if (Setting.StockAllocationTime.PAYMENT.equals(setting.getStockAllocationTime())) {
			allocateStock(order);
		}

		order.setAmountPaid(order.getAmountPaid().add(orderPayment.getEffectiveAmount()));
		order.setFee(order.getFee().add(orderPayment.getFee()));
		if (!order.hasExpired() && Order.Status.PENDING_PAYMENT.equals(order.getStatus()) && order.getAmountPayable().compareTo(BigDecimal.ZERO) <= 0) {
			order.setStatus(Order.Status.PENDING_REVIEW);
			order.setExpire(null);
		}

		OrderLog orderLog = new OrderLog();
		orderLog.setType(OrderLog.Type.PAYMENT);
		orderLog.setOrder(order);
		orderLogDao.persist(orderLog);

		mailService.sendPaymentOrderMail(order);
		smsService.sendPaymentOrderSms(order);
	}

	@Override
	public void refunds(Order order, OrderRefunds orderRefunds) {
		Assert.notNull(order, "[Assertion failed] - order is required; it must not be null");
		Assert.isTrue(!order.isNew(), "[Assertion failed] - order must not be new");
		Assert.state(order.getRefundableAmount().compareTo(BigDecimal.ZERO) > 0 || order.getIsAllowRefund(), "[Assertion failed] - order refundableAmount must be greater than 0 or order must allow refund");
		Assert.notNull(orderRefunds, "[Assertion failed] - orderRefunds is required; it must not be null");
		Assert.isTrue(orderRefunds.isNew(), "[Assertion failed] - orderRefunds must be new");
		Assert.state(order.getAmountPaid().compareTo(BigDecimal.ZERO) > 0 || orderRefunds.getAmount().compareTo(order.getAmountPaid()) <= 0, "[Assertion failed] - order amountPaid must be greater than 0 or orderRefunds must be equal or less than 0");
		Assert.notNull(orderRefunds.getAmount(), "[Assertion failed] - orderRefunds amount is required; it must not be null");
		Assert.state(orderRefunds.getAmount().compareTo(BigDecimal.ZERO) > 0 && (orderRefunds.getAmount().compareTo(order.getRefundableAmount()) <= 0 || order.getIsAllowRefund()),
				"[Assertion failed] - orderRefunds must be greater than 0 and order refundableAmount must be equal or less than refundableAmount or order must allow refund");
		Assert.state(!OrderRefunds.Method.DEPOSIT.equals(orderRefunds.getMethod()) || order.getStore().getBusiness().getBalance().compareTo(orderRefunds.getAmount()) >= 0, "[Assertion failed] - orderRefunds method must not be DEPOSIT or business balance must equal or greater than orderRefunds");

		orderRefunds.setSn(snDao.generate(Sn.Type.ORDER_REFUNDS));
		orderRefunds.setOrder(order);
		orderRefundsDao.persist(orderRefunds);

		if (OrderRefunds.Method.DEPOSIT.equals(orderRefunds.getMethod())) {
			memberService.addBalance(order.getMember(), orderRefunds.getAmount(), MemberDepositLog.Type.ORDER_REFUNDS, null);
			businessService.addBalance(order.getStore().getBusiness(), orderRefunds.getAmount().negate(), BusinessDepositLog.Type.ORDER_REFUNDS, null);
		}

		order.setAmountPaid(order.getAmountPaid().subtract(orderRefunds.getAmount()));
		order.setRefundAmount(order.getRefundAmount().add(orderRefunds.getAmount()));

		OrderLog orderLog = new OrderLog();
		orderLog.setType(OrderLog.Type.REFUNDS);
		orderLog.setOrder(order);
		orderLogDao.persist(orderLog);

		mailService.sendRefundsOrderMail(order);
		smsService.sendRefundsOrderSms(order);
	}

	@Override
	public void shipping(Order order, OrderShipping orderShipping) {
		Assert.notNull(order, "[Assertion failed] - order is required; it must not be null");
		Assert.isTrue(!order.isNew(), "[Assertion failed] - order must not be new");
		Assert.state(order.getShippableQuantity() > 0, "[Assertion failed] - order shippableQuantity must be greater than 0");
		Assert.notNull(orderShipping, "[Assertion failed] - orderShipping is required; it must not be null");
		Assert.isTrue(orderShipping.isNew(), "[Assertion failed] - orderShipping must be new");
		Assert.notEmpty(orderShipping.getOrderShippingItems(), "[Assertion failed] - orderShippingItems must not be empty: it must contain at least 1 element");

		orderShipping.setSn(snDao.generate(Sn.Type.ORDER_SHIPPING));
		orderShipping.setOrder(order);
		orderShippingDao.persist(orderShipping);

		Setting setting = SystemUtils.getSetting();
		if (Setting.StockAllocationTime.SHIP.equals(setting.getStockAllocationTime())) {
			allocateStock(order);
		}

		for (OrderShippingItem orderShippingItem : orderShipping.getOrderShippingItems()) {
			OrderItem orderItem = order.getOrderItem(orderShippingItem.getSn());
			if (orderItem == null || orderShippingItem.getQuantity() > orderItem.getShippableQuantity()) {
				throw new IllegalArgumentException();
			}
			orderItem.setShippedQuantity(orderItem.getShippedQuantity() + orderShippingItem.getQuantity());
			Sku sku = orderShippingItem.getSku();
			if (sku != null) {
				if (orderShippingItem.getQuantity() > sku.getStock()) {
					throw new IllegalArgumentException();
				}
				skuService.addStock(sku, -orderShippingItem.getQuantity(), StockLog.Type.STOCK_OUT, null);
				if (BooleanUtils.isTrue(order.getIsAllocatedStock())) {
					skuService.addAllocatedStock(sku, -orderShippingItem.getQuantity());
				}
			}
		}

		order.setShippedQuantity(order.getShippedQuantity() + orderShipping.getQuantity());
		if (order.getShippedQuantity() >= order.getQuantity()) {
			order.setStatus(Order.Status.SHIPPED);
			order.setIsAllocatedStock(false);
		}

		OrderLog orderLog = new OrderLog();
		orderLog.setType(OrderLog.Type.SHIPPING);
		orderLog.setOrder(order);
		orderLogDao.persist(orderLog);

		mailService.sendShippingOrderMail(order);
		smsService.sendShippingOrderSms(order);
	}

	@Override
	public void returns(Order order, OrderReturns orderReturns) {
		Assert.notNull(order, "[Assertion failed] - order is required; it must not be null");
		Assert.isTrue(!order.isNew(), "[Assertion failed] - order must not be new");
		Assert.state(order.getReturnableQuantity() > 0 || order.getIsAllowReturns(), "[Assertion failed] - order returnableQuantity must be greater than 0 or order must allow returns");
		Assert.notNull(orderReturns, "[Assertion failed] - orderReturns is required; it must not be null");
		Assert.isTrue(orderReturns.isNew(), "[Assertion failed] - orderReturns must not be new");
		Assert.notEmpty(orderReturns.getOrderReturnsItems(), "[Assertion failed] - orderReturnsItems must not be empty: it must contain at least 1 element");

		orderReturns.setSn(snDao.generate(Sn.Type.ORDER_RETURNS));
		orderReturns.setOrder(order);
		orderReturnsDao.persist(orderReturns);

		for (OrderReturnsItem orderReturnsItem : orderReturns.getOrderReturnsItems()) {
			OrderItem orderItem = order.getOrderItem(orderReturnsItem.getSn());
			if (orderItem == null || orderItem.getSku() == null || orderReturnsItem.getQuantity() > orderItem.getReturnableQuantity()) {
				throw new IllegalArgumentException();
			}
			skuService.addStock(orderItem.getSku(), orderReturnsItem.getQuantity(), StockLog.Type.STOCK_IN, null);
			orderItem.setReturnedQuantity(orderItem.getReturnedQuantity() + orderReturnsItem.getQuantity());
		}

		order.setReturnedQuantity(order.getReturnedQuantity() + orderReturns.getQuantity());

		OrderLog orderLog = new OrderLog();
		orderLog.setType(OrderLog.Type.RETURNS);
		orderLog.setOrder(order);
		orderLogDao.persist(orderLog);

		mailService.sendReturnsOrderMail(order);
		smsService.sendReturnsOrderSms(order);
	}

	@Override
	public void receive(Order order) {
		Assert.notNull(order, "[Assertion failed] - order is required; it must not be null");
		Assert.isTrue(!order.isNew(), "[Assertion failed] - order must not be new");
		Assert.state(!order.hasExpired() && Order.Status.SHIPPED.equals(order.getStatus()), "[Assertion failed] - order must not be expired and order status must be SHIPPED");

		order.setStatus(Order.Status.RECEIVED);

		OrderLog orderLog = new OrderLog();
		orderLog.setType(OrderLog.Type.RECEIVE);
		orderLog.setOrder(order);
		orderLogDao.persist(orderLog);

		mailService.sendReceiveOrderMail(order);
		smsService.sendReceiveOrderSms(order);
	}

	@Override
	@CacheEvict(value = { "product", "productCategory" }, allEntries = true)
	public void complete(Order order) {
		Assert.notNull(order, "[Assertion failed] - order is required; it must not be null");
		Assert.isTrue(!order.isNew(), "[Assertion failed] - order must not be new");
		Assert.state(!order.hasExpired() && Order.Status.RECEIVED.equals(order.getStatus()), "[Assertion failed] - order must not be expired and order status must be RECEIVED");

		Member member = order.getMember();
		if (order.getRewardPoint() > 0) {
			memberService.addPoint(member, order.getRewardPoint(), PointLog.Type.REWARD, null);
		}
		if (CollectionUtils.isNotEmpty(order.getCoupons())) {
			for (Coupon coupon : order.getCoupons()) {
				couponCodeService.generate(coupon, member);
			}
		}
		if (order.getAmountPaid().compareTo(BigDecimal.ZERO) > 0) {
			memberService.addAmount(member, order.getAmountPaid());
		}
		BigDecimal grantedDistributionCommissionTotals = BigDecimal.ZERO;
		BigDecimal orderDistributionCommission = order.getDistributionCommission();
		if (orderDistributionCommission.compareTo(BigDecimal.ZERO) > 0) {
			Setting setting = SystemUtils.getSetting();
			Distributor distributor = member.getDistributor();
			Double[] distributionCommissionRates = setting.getDistributionCommissionRates();
			if (distributor != null && ArrayUtils.isNotEmpty(distributionCommissionRates)) {
				for (double distributionCommissionRate : distributionCommissionRates) {
					Distributor parentDistributor = distributor.getParent();
					if (parentDistributor != null && distributionCommissionRate > 0) {
						BigDecimal amount = orderDistributionCommission.multiply(BigDecimal.valueOf(distributionCommissionRate).movePointLeft(2));
						memberService.addBalance(parentDistributor.getMember(), amount, MemberDepositLog.Type.DISTRIBUTION_COMMISSION, null);
						grantedDistributionCommissionTotals = grantedDistributionCommissionTotals.add(amount);
						distributor = parentDistributor;

						DistributionCommission distributionCommission = new DistributionCommission();
						distributionCommission.setAmount(amount);
						distributionCommission.setOrder(order);
						distributionCommission.setDistributor(distributor);
						distributionCommissionDao.persist(distributionCommission);
					}
				}
			}
		}
		BigDecimal settlementAmount = order.getSettlementAmount(grantedDistributionCommissionTotals);
		if (settlementAmount.compareTo(BigDecimal.ZERO) > 0) {
			businessService.addBalance(order.getStore().getBusiness(), settlementAmount, BusinessDepositLog.Type.ORDER_SETTLEMENT, null);
		}
		for (OrderItem orderItem : order.getOrderItems()) {
			Sku sku = orderItem.getSku();
			if (sku != null && sku.getProduct() != null) {
				productService.addSales(sku.getProduct(), orderItem.getQuantity());
			}
		}

		order.setStatus(Order.Status.COMPLETED);
		order.setCompleteDate(new Date());

		OrderLog orderLog = new OrderLog();
		orderLog.setType(OrderLog.Type.COMPLETE);
		orderLog.setOrder(order);
		orderLogDao.persist(orderLog);

		mailService.sendCompleteOrderMail(order);
		smsService.sendCompleteOrderSms(order);
	}

	@Override
	public void fail(Order order) {
		Assert.notNull(order, "[Assertion failed] - order is required; it must not be null");
		Assert.isTrue(!order.isNew(), "[Assertion failed] - order must not be new");
		Assert.state(!order.hasExpired() && (Order.Status.PENDING_SHIPMENT.equals(order.getStatus()) || Order.Status.SHIPPED.equals(order.getStatus()) || Order.Status.RECEIVED.equals(order.getStatus())),
				"[Assertion failed] - order must not be expired and order status must be PENDING_SHIPMENT, SHIPPED or RECEIVED");

		order.setStatus(Order.Status.FAILED);

		undoUseCouponCode(order);
		undoExchangePoint(order);
		releaseAllocatedStock(order);

		if (order.getRefundableAmount().compareTo(BigDecimal.ZERO) > 0) {
			businessService.addBalance(order.getStore().getBusiness(), order.getRefundableAmount(), BusinessDepositLog.Type.ORDER_REFUNDS, null);
		}

		OrderLog orderLog = new OrderLog();
		orderLog.setType(OrderLog.Type.FAIL);
		orderLog.setOrder(order);
		orderLogDao.persist(orderLog);

		mailService.sendFailOrderMail(order);
		smsService.sendFailOrderSms(order);
	}

	@Override
	@Transactional
	public void delete(Order order) {
		if (order != null && !Order.Status.COMPLETED.equals(order.getStatus())) {
			undoUseCouponCode(order);
			undoExchangePoint(order);
			releaseAllocatedStock(order);
		}

		super.delete(order);
	}

	/**
	 * 优惠码使用
	 * 
	 * @param order
	 *            订单
	 */
	private void useCouponCode(Order order) {
		if (order == null || BooleanUtils.isNotFalse(order.getIsUseCouponCode()) || order.getCouponCode() == null) {
			return;
		}
		CouponCode couponCode = order.getCouponCode();
		couponCode.setIsUsed(true);
		couponCode.setUsedDate(new Date());
		order.setIsUseCouponCode(true);
	}

	/**
	 * 优惠码使用撤销
	 * 
	 * @param order
	 *            订单
	 */
	private void undoUseCouponCode(Order order) {
		if (order == null || BooleanUtils.isNotTrue(order.getIsUseCouponCode()) || order.getCouponCode() == null) {
			return;
		}
		CouponCode couponCode = order.getCouponCode();
		couponCode.setIsUsed(false);
		couponCode.setUsedDate(null);
		order.setIsUseCouponCode(false);
		order.setCouponCode(null);
	}

	/**
	 * 积分兑换
	 * 
	 * @param order
	 *            订单
	 */
	private void exchangePoint(Order order) {
		if (order == null || BooleanUtils.isNotFalse(order.getIsExchangePoint()) || order.getExchangePoint() <= 0 || order.getMember() == null) {
			return;
		}
		memberService.addPoint(order.getMember(), -order.getExchangePoint(), PointLog.Type.EXCHANGE, null);
		order.setIsExchangePoint(true);
	}

	/**
	 * 积分兑换撤销
	 * 
	 * @param order
	 *            订单
	 */
	private void undoExchangePoint(Order order) {
		if (order == null || BooleanUtils.isNotTrue(order.getIsExchangePoint()) || order.getExchangePoint() <= 0 || order.getMember() == null) {
			return;
		}
		memberService.addPoint(order.getMember(), order.getExchangePoint(), PointLog.Type.UNDO_EXCHANGE, null);
		order.setIsExchangePoint(false);
	}

	/**
	 * 分配库存
	 * 
	 * @param order
	 *            订单
	 */
	private void allocateStock(Order order) {
		if (order == null || BooleanUtils.isNotFalse(order.getIsAllocatedStock())) {
			return;
		}
		if (order.getOrderItems() != null) {
			for (OrderItem orderItem : order.getOrderItems()) {
				Sku sku = orderItem.getSku();
				if (sku != null) {
					skuService.addAllocatedStock(sku, orderItem.getQuantity() - orderItem.getShippedQuantity());
				}
			}
		}
		order.setIsAllocatedStock(true);
	}

	/**
	 * 释放已分配库存
	 * 
	 * @param order
	 *            订单
	 */
	private void releaseAllocatedStock(Order order) {
		if (order == null || BooleanUtils.isNotTrue(order.getIsAllocatedStock())) {
			return;
		}
		if (order.getOrderItems() != null) {
			for (OrderItem orderItem : order.getOrderItems()) {
				Sku sku = orderItem.getSku();
				if (sku != null) {
					skuService.addAllocatedStock(sku, -(orderItem.getQuantity() - orderItem.getShippedQuantity()));
				}
			}
		}
		order.setIsAllocatedStock(false);
	}

	@Override
	@Transactional(readOnly = true)
	public Long completeOrderCount(Store store, Date beginDate, Date endDate) {
		return orderDao.completeOrderCount(store, beginDate, endDate);
	}

	@Override
	@Transactional(readOnly = true)
	public BigDecimal completeOrderAmount(Store store, Date beginDate, Date endDate) {
		return orderDao.completeOrderAmount(store, beginDate, endDate);
	}

	@Override
	@Transactional(readOnly = true)
	public BigDecimal grantedCommissionTotalAmount(Store store, CommissionType commissionType, Date beginDate, Date endDate, Status... statuses) {
		return orderDao.grantedCommissionTotalAmount(store, commissionType, beginDate, endDate, statuses);
	}

	@Override
	public void automaticReceive() {
		Date currentTime = new Date();
		for (int i = 0;; i += 100) {
			List<Order> orders = orderDao.findList(null, Order.Status.SHIPPED, null, null, null, null, null, null, null, null, false, i, 100, null, null);
			if (CollectionUtils.isNotEmpty(orders)) {
				for (Order order : orders) {
					OrderShipping orderShipping = orderShippingDao.findLast(order);
					Date automaticReceiveTime = DateUtils.addDays(orderShipping.getCreatedDate(), SystemUtils.getSetting().getAutomaticReceiveTime());
					if (automaticReceiveTime.compareTo(currentTime) < 0) {
						order.setStatus(Order.Status.RECEIVED);
					}
				}
				orderDao.flush();
				orderDao.clear();
			}
			if (orders.size() < 100) {
				break;
			}
		}
	}

}