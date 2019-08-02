/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: ZSSPtEtj8288mcbf/tNj8vSeV6gMqepG
 */
package net.shopxx.service.impl;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.inject.Inject;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.Predicate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.AftersalesDao;
import net.shopxx.dao.OrderItemDao;
import net.shopxx.entity.Aftersales;
import net.shopxx.entity.AftersalesItem;
import net.shopxx.entity.AftersalesReturns;
import net.shopxx.entity.Member;
import net.shopxx.entity.Order;
import net.shopxx.entity.OrderItem;
import net.shopxx.entity.OrderReturns;
import net.shopxx.entity.OrderReturnsItem;
import net.shopxx.entity.Store;
import net.shopxx.exception.ResourceNotFoundException;
import net.shopxx.service.AftersalesService;
import net.shopxx.service.OrderService;

/**
 * Service - 售后
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Service
public class AftersalesServiceImpl extends BaseServiceImpl<Aftersales, Long> implements AftersalesService {

	@Inject
	private AftersalesDao aftersalesDao;
	@Inject
	private OrderService orderService;
	@Inject
	private OrderItemDao orderItemDao;

	@Override
	@Transactional(readOnly = true)
	public List<Aftersales> findList(List<OrderItem> orderItems) {
		return aftersalesDao.findList(orderItems);
	}

	@Override
	@Transactional(readOnly = true)
	public Page<Aftersales> findPage(Aftersales.Type type, Aftersales.Status status, Member member, Store store, Pageable pageable) {
		return aftersalesDao.findPage(type, status, member, store, pageable);
	}

	@Override
	public void review(Aftersales aftersales, boolean passed) {
		Assert.notNull(aftersales, "[Assertion failed] - aftersales is required; it must not be null");
		Assert.state(Aftersales.Status.PENDING.equals(aftersales.getStatus()), "[Assertion failed] - aftersales status must be PENDING");

		if (passed) {
			aftersales.setStatus(Aftersales.Status.APPROVED);
		} else {
			aftersales.setStatus(Aftersales.Status.FAILED);
		}
	}

	@Override
	public void complete(Aftersales aftersales) {
		Assert.notNull(aftersales, "[Assertion failed] - aftersales is required; it must not be null");
		Assert.notEmpty(aftersales.getOrderItems(), "[Assertion failed] - aftersales orderItems must not be empty: it must contain at least 1 element");
		Assert.isTrue(Aftersales.Status.APPROVED.equals(aftersales.getStatus()), "[Assertion failed] - aftersales status must be APPROVED");

		if (Aftersales.Type.AFTERSALES_RETURNS.equals(aftersales.getType())) {
			completeReturns((AftersalesReturns) aftersales);
		}
		aftersales.setStatus(Aftersales.Status.COMPLETED);
	}

	@Override
	public void completeReturns(AftersalesReturns aftersalesReturns) {
		Assert.notNull(aftersalesReturns, "[Assertion failed] - aftersalesReturns is required; it must not be null");
		Assert.isTrue(Aftersales.Status.APPROVED.equals(aftersalesReturns.getStatus()), "[Assertion failed] - aftersalesReturns status must be APPROVED");
		Assert.state(CollectionUtils.isNotEmpty(aftersalesReturns.getOrderItems()), "[Assertion failed] - aftersalesReturns orderItems must not be empty: it must contain at least 1 element");

		List<OrderItem> orderItems = aftersalesReturns.getOrderItems();
		Order order = orderItems.get(0).getOrder();
		OrderReturns orderReturns = new OrderReturns();
		List<OrderReturnsItem> orderReturnsItems = new ArrayList<>();
		for (AftersalesItem aftersalesItem : aftersalesReturns.getAftersalesItems()) {
			OrderReturnsItem orderReturnsItem = new OrderReturnsItem();
			orderReturnsItem.setSn(aftersalesItem.getOrderItem().getSn());
			orderReturnsItem.setName(aftersalesItem.getOrderItem().getName());
			orderReturnsItem.setQuantity(aftersalesItem.getQuantity());
			orderReturnsItem.setOrderReturns(orderReturns);
			orderReturnsItem.setSpecifications(aftersalesItem.getOrderItem().getSpecifications());
			orderReturnsItems.add(orderReturnsItem);
		}
		orderReturns.setOrderReturnsItems(orderReturnsItems);
		orderReturns.setShippingMethod(order.getShippingMethod());
		orderReturns.setDeliveryCorp(aftersalesReturns.getDeliveryCorp());
		orderReturns.setTrackingNo(aftersalesReturns.getTrackingNo());
		orderReturns.setShipper(order.getMember().getDisplayName());
		orderService.returns(order, orderReturns);
	}

	@Override
	public void cancle(Aftersales aftersales) {
		Assert.notNull(aftersales, "[Assertion failed] - aftersales is required; it must not be null");
		Assert.isTrue(Aftersales.Status.PENDING.equals(aftersales.getStatus()) || Aftersales.Status.APPROVED.equals(aftersales.getStatus()), "[Assertion failed] - aftersales status must be PENDING or APPROVED");

		aftersales.setStatus(Aftersales.Status.CANCELED);
	}

	@Override
	public void filterNotActiveAftersalesItem(Aftersales aftersales) {
		for (Iterator<AftersalesItem> iterator = aftersales.getAftersalesItems().iterator(); iterator.hasNext();) {
			AftersalesItem aftersalesItem = iterator.next();
			if (aftersalesItem.getOrderItem() == null || aftersalesItem.getQuantity() == null) {
				iterator.remove();
				continue;
			}

			OrderItem orderItem = orderItemDao.find(aftersalesItem.getOrderItem().getId());
			if (orderItem == null) {
				throw new ResourceNotFoundException();
			}
			aftersalesItem.setOrderItem(orderItem);
			aftersalesItem.setAftersales(aftersales);
		}
	}

	@Override
	public boolean existsIllegalAftersalesItems(List<AftersalesItem> aftersalesItems) {

		return CollectionUtils.exists(aftersalesItems, new Predicate() {

			@Override
			public boolean evaluate(Object object) {
				AftersalesItem aftersalesItem = (AftersalesItem) object;
				return aftersalesItem == null || aftersalesItem.getOrderItem() == null || aftersalesItem.getOrderItem().getAllowApplyAftersalesQuantity() < aftersalesItem.getQuantity();
			}
		});
	}

}