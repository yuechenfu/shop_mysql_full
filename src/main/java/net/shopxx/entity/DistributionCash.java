/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: AlRCo7OQNLtT9K8bkBYLWJtoNyWByLQ8
 */
package net.shopxx.entity;

import java.math.BigDecimal;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.Length;

import com.fasterxml.jackson.annotation.JsonView;

/**
 * Entity - 分销提现
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Entity
public class DistributionCash extends BaseEntity<Long> {

	private static final long serialVersionUID = 8900377558490309014L;

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
		FAILED
	}

	/**
	 * 状态
	 */
	@JsonView(BaseView.class)
	@NotNull(groups = Save.class)
	@Column(nullable = false)
	private DistributionCash.Status status;

	/**
	 * 金额
	 */
	@JsonView(BaseView.class)
	@NotNull
	@Column(nullable = false, updatable = false, precision = 21, scale = 6)
	private BigDecimal amount;

	/**
	 * 收款银行
	 */
	@JsonView(BaseView.class)
	@NotNull
	@Length(max = 200)
	@Column(nullable = false, updatable = false)
	private String bank;

	/**
	 * 收款账号
	 */
	@JsonView(BaseView.class)
	@NotNull
	@Length(max = 200)
	@Column(nullable = false, updatable = false)
	private String account;

	/**
	 * 开户人
	 */
	@JsonView(BaseView.class)
	@NotNull
	@Length(max = 200)
	@Column(nullable = false, updatable = false)
	private String accountHolder;

	/**
	 * 分销员
	 */
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false)
	private Distributor distributor;

	/**
	 * 获取状态
	 * 
	 * @return 状态
	 */
	public DistributionCash.Status getStatus() {
		return status;
	}

	/**
	 * 设置状态
	 * 
	 * @param status
	 *            状态
	 */
	public void setStatus(DistributionCash.Status status) {
		this.status = status;
	}

	/**
	 * 获取金额
	 * 
	 * @return 金额
	 */
	public BigDecimal getAmount() {
		return amount;
	}

	/**
	 * 设置金额
	 * 
	 * @param amount
	 *            金额
	 */
	public void setAmount(BigDecimal amount) {
		this.amount = amount;
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

	/**
	 * 获取开户人
	 * 
	 * @return 开户人
	 */
	public String getAccountHolder() {
		return accountHolder;
	}

	/**
	 * 设置开户人
	 * 
	 * @param accountHolder
	 *            开户人
	 */
	public void setAccountHolder(String accountHolder) {
		this.accountHolder = accountHolder;
	}

	/**
	 * 获取分销员
	 * 
	 * @return 分销员
	 */
	public Distributor getDistributor() {
		return distributor;
	}

	/**
	 * 设置分销员
	 * 
	 * @param distributor
	 *            分销员
	 */
	public void setDistributor(Distributor distributor) {
		this.distributor = distributor;
	}

}