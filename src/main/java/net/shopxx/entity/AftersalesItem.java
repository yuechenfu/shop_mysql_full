/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: a0KAqz4xvfJfNbzKManK94F9bgO6hlzz
 */
package net.shopxx.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;

import com.fasterxml.jackson.annotation.JsonView;

/**
 * Entity - 售后项
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Entity
public class AftersalesItem extends BaseEntity<Long> {

	private static final long serialVersionUID = -3285489579368368057L;

	/**
	 * 数量
	 */
	@JsonView(BaseView.class)
	@NotNull
	@Min(1)
	@Column(nullable = false, updatable = false)
	private Integer quantity;

	/**
	 * 订单项
	 */
	@JsonView(BaseView.class)
	@NotNull
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false, updatable = false)
	private OrderItem orderItem;

	/**
	 * 售后
	 */
	@NotNull
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false, updatable = false)
	private Aftersales aftersales;

	/**
	 * 获取数量
	 * 
	 * @return 数量
	 */
	public Integer getQuantity() {
		return quantity;
	}

	/**
	 * 设置数量
	 * 
	 * @param quantity
	 *            数量
	 */
	public void setQuantity(Integer quantity) {
		this.quantity = quantity;
	}

	/**
	 * 获取订单项
	 * 
	 * @return 订单项
	 */
	public OrderItem getOrderItem() {
		return orderItem;
	}

	/**
	 * 设置订单项
	 * 
	 * @param orderItem
	 *            订单项
	 */
	public void setOrderItem(OrderItem orderItem) {
		this.orderItem = orderItem;
	}

	/**
	 * 获取售后
	 * 
	 * @return 售后
	 */
	public Aftersales getAftersales() {
		return aftersales;
	}

	/**
	 * 设置售后
	 * 
	 * @param aftersales
	 *            售后
	 */
	public void setAftersales(Aftersales aftersales) {
		this.aftersales = aftersales;
	}

}