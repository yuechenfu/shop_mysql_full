/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: XUNoPSI3glU0kzkPm6LGoDBoOqFoZdmL
 */
package net.shopxx.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

/**
 * Entity - 订单记录
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Entity
public class OrderLog extends BaseEntity<Long> {

	private static final long serialVersionUID = -2704154761295319939L;

	/**
	 * 类型
	 */
	public enum Type {

		/**
		 * 订单创建
		 */
		CREATE,

		/**
		 * 订单修改
		 */
		MODIFY,

		/**
		 * 订单取消
		 */
		CANCEL,

		/**
		 * 订单审核
		 */
		REVIEW,

		/**
		 * 订单收款
		 */
		PAYMENT,

		/**
		 * 订单退款
		 */
		REFUNDS,

		/**
		 * 订单发货
		 */
		SHIPPING,

		/**
		 * 订单退货
		 */
		RETURNS,

		/**
		 * 订单收货
		 */
		RECEIVE,

		/**
		 * 订单完成
		 */
		COMPLETE,

		/**
		 * 订单失败
		 */
		FAIL
	}

	/**
	 * 类型
	 */
	@Column(nullable = false, updatable = false)
	private OrderLog.Type type;

	/**
	 * 详情
	 */
	@Column(updatable = false)
	private String detail;

	/**
	 * 订单
	 */
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "orders", nullable = false, updatable = false)
	private Order order;

	/**
	 * 获取类型
	 * 
	 * @return 类型
	 */
	public OrderLog.Type getType() {
		return type;
	}

	/**
	 * 设置类型
	 * 
	 * @param type
	 *            类型
	 */
	public void setType(OrderLog.Type type) {
		this.type = type;
	}

	/**
	 * 获取详情
	 * 
	 * @return 详情
	 */
	public String getDetail() {
		return detail;
	}

	/**
	 * 设置详情
	 * 
	 * @param detail
	 *            详情
	 */
	public void setDetail(String detail) {
		this.detail = detail;
	}

	/**
	 * 获取订单
	 * 
	 * @return 订单
	 */
	public Order getOrder() {
		return order;
	}

	/**
	 * 设置订单
	 * 
	 * @param order
	 *            订单
	 */
	public void setOrder(Order order) {
		this.order = order;
	}

}