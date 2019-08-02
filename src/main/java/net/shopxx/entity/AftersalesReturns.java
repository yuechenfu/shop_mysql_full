/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: kvK8O0/0hQycuYmfCxABxh1EFKVzzdcW
 */
package net.shopxx.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.Length;

/**
 * Entity - 退货
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Entity
public class AftersalesReturns extends Aftersales {

	private static final long serialVersionUID = -1169192297186515973L;

	/**
	 * 退款方式
	 */
	public enum Method {

		/**
		 * 在线支付
		 */
		ONLINE,

		/**
		 * 线下支付
		 */
		OFFLINE,

		/**
		 * 预存款支付
		 */
		DEPOSIT
	}

	/**
	 * 退款方式
	 */
	@NotNull
	@Column(updatable = false)
	private AftersalesReturns.Method method;

	/**
	 * 收款银行
	 */
	@Length(max = 200)
	@Column(updatable = false)
	private String bank;

	/**
	 * 收款账号
	 */
	@Length(max = 200)
	@Column(updatable = false)
	private String account;

	/**
	 * 获取退款方式
	 * 
	 * @return 退款方式
	 */
	public AftersalesReturns.Method getMethod() {
		return method;
	}

	/**
	 * 设置退款方式
	 * 
	 * @param method
	 *            退款方式
	 */
	public void setMethod(AftersalesReturns.Method method) {
		this.method = method;
	}

	/**
	 * 获取收款银行
	 * 
	 * @return 收款银行
	 */
	public String getBank() {
		return bank;
	}

	/**
	 * 设置收款银行
	 * 
	 * @param bank
	 *            收款银行
	 */
	public void setBank(String bank) {
		this.bank = bank;
	}

	/**
	 * 获取收款账号
	 * 
	 * @return 收款账号
	 */
	public String getAccount() {
		return account;
	}

	/**
	 * 设置收款账号
	 * 
	 * @param account
	 *            收款账号
	 */
	public void setAccount(String account) {
		this.account = account;
	}

}