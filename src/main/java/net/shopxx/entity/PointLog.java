/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: jqzSXDiPF5R9VXq1yxgUo+g4hlJZNOSZ
 */
package net.shopxx.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

import com.fasterxml.jackson.annotation.JsonView;

/**
 * Entity - 积分记录
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Entity
public class PointLog extends BaseEntity<Long> {

	private static final long serialVersionUID = -1758056800285585097L;

	/**
	 * 类型
	 */
	public enum Type {

		/**
		 * 积分赠送
		 */
		REWARD,

		/**
		 * 积分兑换
		 */
		EXCHANGE,

		/**
		 * 积分兑换撤销
		 */
		UNDO_EXCHANGE,

		/**
		 * 积分调整
		 */
		ADJUSTMENT
	}

	/**
	 * 类型
	 */
	@JsonView(BaseView.class)
	@Column(nullable = false, updatable = false)
	private PointLog.Type type;

	/**
	 * 获取积分
	 */
	@JsonView(BaseView.class)
	@Column(nullable = false, updatable = false)
	private Long credit;

	/**
	 * 扣除积分
	 */
	@JsonView(BaseView.class)
	@Column(nullable = false, updatable = false)
	private Long debit;

	/**
	 * 当前积分
	 */
	@JsonView(BaseView.class)
	@Column(nullable = false, updatable = false)
	private Long balance;

	/**
	 * 备注
	 */
	@JsonView(BaseView.class)
	@Column(updatable = false)
	private String memo;

	/**
	 * 会员
	 */
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false, updatable = false)
	private Member member;

	/**
	 * 获取类型
	 * 
	 * @return 类型
	 */
	public PointLog.Type getType() {
		return type;
	}

	/**
	 * 设置类型
	 * 
	 * @param type
	 *            类型
	 */
	public void setType(PointLog.Type type) {
		this.type = type;
	}

	/**
	 * 获取获取积分
	 * 
	 * @return 获取积分
	 */
	public Long getCredit() {
		return credit;
	}

	/**
	 * 设置获取积分
	 * 
	 * @param credit
	 *            获取积分
	 */
	public void setCredit(Long credit) {
		this.credit = credit;
	}

	/**
	 * 获取扣除积分
	 * 
	 * @return 扣除积分
	 */
	public Long getDebit() {
		return debit;
	}

	/**
	 * 设置扣除积分
	 * 
	 * @param debit
	 *            扣除积分
	 */
	public void setDebit(Long debit) {
		this.debit = debit;
	}

	/**
	 * 获取当前积分
	 * 
	 * @return 当前积分
	 */
	public Long getBalance() {
		return balance;
	}

	/**
	 * 设置当前积分
	 * 
	 * @param balance
	 *            当前积分
	 */
	public void setBalance(Long balance) {
		this.balance = balance;
	}

	/**
	 * 获取备注
	 * 
	 * @return 备注
	 */
	public String getMemo() {
		return memo;
	}

	/**
	 * 设置备注
	 * 
	 * @param memo
	 *            备注
	 */
	public void setMemo(String memo) {
		this.memo = memo;
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

}