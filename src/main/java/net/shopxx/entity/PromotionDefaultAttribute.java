/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: vr8ic91M51PlgscPs0z5V+IEn9IsZEjQ
 */
package net.shopxx.entity;

import java.math.BigDecimal;

import javax.persistence.DiscriminatorColumn;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Inheritance;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.validation.constraints.Digits;
import javax.validation.constraints.Min;

/**
 * Entity - 促销默认属性
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Entity
@DiscriminatorColumn(name = "dtype")
@Inheritance
public abstract class PromotionDefaultAttribute extends BaseEntity<Long> {

	private static final long serialVersionUID = -3322530806464137767L;

	/**
	 * 最小商品价格
	 */
	@Min(0)
	@Digits(integer = 12, fraction = 3)
	private BigDecimal minPrice;

	/**
	 * 最大商品价格
	 */
	@Min(0)
	@Digits(integer = 12, fraction = 3)
	private BigDecimal maxPrice;

	/**
	 * 最小商品数量
	 */
	@Min(0)
	private Integer minQuantity;

	/**
	 * 最大商品数量
	 */
	@Min(0)
	private Integer maxQuantity;

	/**
	 * 促销
	 */
	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false, updatable = false)
	private Promotion promotion;

	/**
	 * 获取最小商品价格
	 * 
	 * @return 最小商品价格
	 */
	public BigDecimal getMinPrice() {
		return minPrice;
	}

	/**
	 * 设置最小商品价格
	 * 
	 * @param minPrice
	 *            最小商品价格
	 */
	public void setMinPrice(BigDecimal minPrice) {
		this.minPrice = minPrice;
	}

	/**
	 * 获取最大商品价格
	 * 
	 * @return 最大商品价格
	 */
	public BigDecimal getMaxPrice() {
		return maxPrice;
	}

	/**
	 * 设置最大商品价格
	 * 
	 * @param maxPrice
	 *            最大商品价格
	 */
	public void setMaxPrice(BigDecimal maxPrice) {
		this.maxPrice = maxPrice;
	}

	/**
	 * 获取最小商品数量
	 * 
	 * @return 最小商品数量
	 */
	public Integer getMinQuantity() {
		return minQuantity;
	}

	/**
	 * 设置最小商品数量
	 * 
	 * @param minQuantity
	 *            最小商品数量
	 */
	public void setMinQuantity(Integer minQuantity) {
		this.minQuantity = minQuantity;
	}

	/**
	 * 获取最大商品数量
	 * 
	 * @return 最大商品数量
	 */
	public Integer getMaxQuantity() {
		return maxQuantity;
	}

	/**
	 * 设置最大商品数量
	 * 
	 * @param maxQuantity
	 *            最大商品数量
	 */
	public void setMaxQuantity(Integer maxQuantity) {
		this.maxQuantity = maxQuantity;
	}

	/**
	 * 获取促销
	 * 
	 * @return 促销
	 */
	public Promotion getPromotion() {
		return promotion;
	}

	/**
	 * 设置促销
	 * 
	 * @param promotion
	 *            促销
	 */
	public void setPromotion(Promotion promotion) {
		this.promotion = promotion;
	}

}