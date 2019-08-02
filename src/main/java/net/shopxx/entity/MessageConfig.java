/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: BVoFPmHepyBKFXe7SKArjViblqcdDd3Z
 */
package net.shopxx.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.validation.constraints.NotNull;

/**
 * Entity - 消息配置
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Entity
public class MessageConfig extends BaseEntity<Long> {

	private static final long serialVersionUID = -5214678967755261831L;

	/**
	 * 类型
	 */
	public enum Type {

		/**
		 * 会员注册
		 */
		REGISTER_MEMBER,

		/**
		 * 订单创建
		 */
		CREATE_ORDER,

		/**
		 * 订单更新
		 */
		UPDATE_ORDER,

		/**
		 * 订单取消
		 */
		CANCEL_ORDER,

		/**
		 * 订单审核
		 */
		REVIEW_ORDER,

		/**
		 * 订单收款
		 */
		PAYMENT_ORDER,

		/**
		 * 订单退款
		 */
		REFUNDS_ORDER,

		/**
		 * 订单发货
		 */
		SHIPPING_ORDER,

		/**
		 * 订单退货
		 */
		RETURNS_ORDER,

		/**
		 * 订单收货
		 */
		RECEIVE_ORDER,

		/**
		 * 订单完成
		 */
		COMPLETE_ORDER,

		/**
		 * 订单失败
		 */
		FAIL_ORDER,

		/**
		 * 商家注册
		 */
		REGISTER_BUSINESS,

		/**
		 * 店铺审核成功
		 */
		APPROVAL_STORE,

		/**
		 * 店铺审核失败
		 */
		FAIL_STORE
	}

	/**
	 * 类型
	 */
	@Column(nullable = false, updatable = false, unique = true)
	private MessageConfig.Type type;

	/**
	 * 是否启用邮件
	 */
	@NotNull
	@Column(nullable = false)
	private Boolean isMailEnabled;

	/**
	 * 是否启用短信
	 */
	@NotNull
	@Column(nullable = false)
	private Boolean isSmsEnabled;

	/**
	 * 获取类型
	 * 
	 * @return 类型
	 */
	public MessageConfig.Type getType() {
		return type;
	}

	/**
	 * 设置类型
	 * 
	 * @param type
	 *            类型
	 */
	public void setType(MessageConfig.Type type) {
		this.type = type;
	}

	/**
	 * 获取是否启用邮件
	 * 
	 * @return 是否启用邮件
	 */
	public Boolean getIsMailEnabled() {
		return isMailEnabled;
	}

	/**
	 * 设置是否启用邮件
	 * 
	 * @param isMailEnabled
	 *            是否启用邮件
	 */
	public void setIsMailEnabled(Boolean isMailEnabled) {
		this.isMailEnabled = isMailEnabled;
	}

	/**
	 * 获取是否启用短信
	 * 
	 * @return 是否启用短信
	 */
	public Boolean getIsSmsEnabled() {
		return isSmsEnabled;
	}

	/**
	 * 设置是否启用短信
	 * 
	 * @param isSmsEnabled
	 *            是否启用短信
	 */
	public void setIsSmsEnabled(Boolean isSmsEnabled) {
		this.isSmsEnabled = isSmsEnabled;
	}

}