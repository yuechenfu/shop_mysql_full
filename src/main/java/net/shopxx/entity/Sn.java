/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: 69VCuKa/9qbrgal1V+cN8dg0QUOEOYzc
 */
package net.shopxx.entity;

import javax.persistence.Column;
import javax.persistence.Entity;

/**
 * Entity - 序列号
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Entity
public class Sn extends BaseEntity<Long> {

	private static final long serialVersionUID = -2330598144835706164L;

	/**
	 * 类型
	 */
	public enum Type {

		/**
		 * 商品
		 */
		PRODUCT,

		/**
		 * 订单
		 */
		ORDER,

		/**
		 * 订单支付
		 */
		ORDER_PAYMENT,

		/**
		 * 订单退款
		 */
		ORDER_REFUNDS,

		/**
		 * 订单发货
		 */
		ORDER_SHIPPING,

		/**
		 * 订单退货
		 */
		ORDER_RETURNS,

		/**
		 * 支付事务
		 */
		PAYMENT_TRANSACTION,

		/**
		 * 平台服务
		 */
		PLATFORM_SERVICE
	}

	/**
	 * 类型
	 */
	@Column(nullable = false, updatable = false, unique = true)
	private Sn.Type type;

	/**
	 * 末值
	 */
	@Column(nullable = false)
	private Long lastValue;

	/**
	 * 获取类型
	 * 
	 * @return 类型
	 */
	public Sn.Type getType() {
		return type;
	}

	/**
	 * 设置类型
	 * 
	 * @param type
	 *            类型
	 */
	public void setType(Sn.Type type) {
		this.type = type;
	}

	/**
	 * 获取末值
	 * 
	 * @return 末值
	 */
	public Long getLastValue() {
		return lastValue;
	}

	/**
	 * 设置末值
	 * 
	 * @param lastValue
	 *            末值
	 */
	public void setLastValue(Long lastValue) {
		this.lastValue = lastValue;
	}

}