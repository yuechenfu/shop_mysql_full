/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: X5PDiiRv5ZLmU9Io+1Wqgkbz0OTCvYK/
 */
package net.shopxx.entity;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.DiscriminatorColumn;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Inheritance;
import javax.persistence.JoinColumn;
import javax.persistence.Lob;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Transient;
import javax.validation.constraints.NotNull;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.Predicate;
import org.apache.commons.collections.Transformer;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;
import org.springframework.util.Assert;

import com.fasterxml.jackson.annotation.JsonView;

/**
 * Entity - 售后
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Entity
@Inheritance
@DiscriminatorColumn(name = "dtype")
public class Aftersales extends BaseEntity<Long> {

	private static final long serialVersionUID = 3822083093484759909L;

	/**
	 * 类型
	 */
	public enum Type {

		/**
		 * 维修
		 */
		AFTERSALES_REPAIR(AftersalesRepair.class),

		/**
		 * 换货
		 */
		AFTERSALES_REPLACEMENT(AftersalesReplacement.class),

		/**
		 * 退货
		 */
		AFTERSALES_RETURNS(AftersalesReturns.class);

		/**
		 * 类
		 */
		private Class<? extends Aftersales> clazz;

		/**
		 * 构造方法
		 * 
		 * @param clazz
		 *            类
		 */
		Type(Class<? extends Aftersales> clazz) {
			this.clazz = clazz;
		}

		/**
		 * 获取类
		 * 
		 * @return 类
		 */
		public Class<? extends Aftersales> getClazz() {
			return clazz;
		}

		/**
		 * 获取类型
		 * 
		 * @param clazz
		 *            类
		 * @return 类型
		 */
		public static Aftersales.Type getType(final Class<? extends Aftersales> clazz) {
			Assert.notNull(clazz, "[Assertion failed] - clazz is required; it must not be null");

			return (Aftersales.Type) CollectionUtils.find(Arrays.asList(Aftersales.Type.values()), new Predicate() {

				@Override
				public boolean evaluate(Object object) {
					Aftersales.Type type = (Aftersales.Type) object;
					return type != null && type.getClazz().equals(clazz);
				}

			});
		}

	}

	/**
	 * 状态
	 */
	public enum Status {

		/**
		 * 等待审核
		 */
		PENDING,

		/**
		 * 审核通过
		 */
		APPROVED,

		/**
		 * 审核失败
		 */
		FAILED,

		/**
		 * 已完成
		 */
		COMPLETED,

		/**
		 * 已取消
		 */
		CANCELED
	}

	/**
	 * 状态
	 */
	@JsonView(BaseView.class)
	@NotNull
	@Column(nullable = false)
	private Aftersales.Status status;

	/**
	 * 原因
	 */
	@NotEmpty
	@Lob
	@Column(nullable = false, updatable = false)
	private String reason;

	/**
	 * 物流公司
	 */
	private String deliveryCorp;

	/**
	 * 运单号
	 */
	@Length(max = 200)
	private String trackingNo;

	/**
	 * 物流公司代码
	 */
	private String deliveryCorpCode;

	/**
	 * 售后项
	 */
	@JsonView(BaseView.class)
	@NotEmpty
	@OneToMany(mappedBy = "aftersales", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
	private List<AftersalesItem> aftersalesItems = new ArrayList<>();

	/**
	 * 会员
	 */
	@NotNull
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false, updatable = false)
	private Member member;

	/**
	 * 店铺
	 */
	@JsonView(BaseView.class)
	@NotNull
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false, updatable = false)
	private Store store;

	/**
	 * 获取状态
	 * 
	 * @return 状态
	 */
	public Aftersales.Status getStatus() {
		return status;
	}

	/**
	 * 设置状态
	 * 
	 * @param status
	 *            状态
	 */
	public void setStatus(Aftersales.Status status) {
		this.status = status;
	}

	/**
	 * 获取原因
	 * 
	 * @return 原因
	 */
	public String getReason() {
		return reason;
	}

	/**
	 * 设置原因
	 * 
	 * @param reason
	 *            原因
	 */
	public void setReason(String reason) {
		this.reason = reason;
	}

	/**
	 * 获取物流公司
	 * 
	 * @return 物流公司
	 */
	public String getDeliveryCorp() {
		return deliveryCorp;
	}

	/**
	 * 设置物流公司
	 * 
	 * @param deliveryCorp
	 *            物流公司
	 */
	public void setDeliveryCorp(String deliveryCorp) {
		this.deliveryCorp = deliveryCorp;
	}

	/**
	 * 获取运单号
	 * 
	 * @return 运单号
	 */
	public String getTrackingNo() {
		return trackingNo;
	}

	/**
	 * 设置运单号
	 * 
	 * @param trackingNo
	 *            运单号
	 */
	public void setTrackingNo(String trackingNo) {
		this.trackingNo = trackingNo;
	}

	/**
	 * 获取物流公司代码
	 * 
	 * @return 物流公司代码
	 */
	public String getDeliveryCorpCode() {
		return deliveryCorpCode;
	}

	/**
	 * 设置物流公司代码
	 * 
	 * @param deliveryCorpCode
	 *            物流公司代码
	 */
	public void setDeliveryCorpCode(String deliveryCorpCode) {
		this.deliveryCorpCode = deliveryCorpCode;
	}

	/**
	 * 获取售后项
	 * 
	 * @return 售后项
	 */
	public List<AftersalesItem> getAftersalesItems() {
		return aftersalesItems;
	}

	/**
	 * 设置售后项
	 * 
	 * @param aftersalesItems
	 *            售后项
	 */
	public void setAftersalesItems(List<AftersalesItem> aftersalesItems) {
		this.aftersalesItems = aftersalesItems;
	}

	/**
	 * 获取会员
	 * 
	 * @return 会员
	 */
	public Member getMember() {
		return member;
	}

	/**
	 * 设置会员
	 * 
	 * @param member
	 *            会员
	 */
	public void setMember(Member member) {
		this.member = member;
	}

	/**
	 * 获取店铺
	 * 
	 * @return 店铺
	 */
	public Store getStore() {
		return store;
	}

	/**
	 * 设置店铺
	 * 
	 * @param store
	 *            店铺
	 */
	public void setStore(Store store) {
		this.store = store;
	}

	/**
	 * 设置物流公司
	 * 
	 * @param deliveryCorp
	 *            物流公司
	 */
	@Transient
	public void setDeliveryCorp(DeliveryCorp deliveryCorp) {
		setDeliveryCorp(deliveryCorp != null ? deliveryCorp.getName() : null);
	}

	/**
	 * 设置物流公司代码
	 * 
	 * @param deliveryCorp
	 *            物流公司
	 */
	@Transient
	public void setDeliveryCorpCode(DeliveryCorp deliveryCorp) {
		setDeliveryCorpCode(deliveryCorp != null ? deliveryCorp.getCode() : null);
	}

	/**
	 * 获取订单项
	 * 
	 * @return 订单项
	 */
	@JsonView(BaseView.class)
	@SuppressWarnings("unchecked")
	@Transient
	public List<OrderItem> getOrderItems() {
		return (List<OrderItem>) CollectionUtils.collect(getAftersalesItems(), new Transformer() {

			@Override
			public Object transform(Object object) {
				AftersalesItem aftersalesItem = (AftersalesItem) object;
				return aftersalesItem.getOrderItem();
			}

		});
	}

	/**
	 * 获取类型
	 * 
	 * @return 类型
	 */
	@JsonView(BaseView.class)
	@Transient
	public Aftersales.Type getType() {
		return Aftersales.Type.getType(getClass());
	}

}