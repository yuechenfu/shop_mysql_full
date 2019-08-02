/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: lQn9drBc4c6Z0HSDvopq8kyfIfK/eqb1
 */
package net.shopxx.entity;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.DiscriminatorColumn;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Inheritance;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.UniqueConstraint;
import javax.validation.constraints.NotNull;

import com.fasterxml.jackson.annotation.JsonView;

/**
 * Entity - 用户
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Entity
@DiscriminatorColumn(name = "dtype")
@Table(name = "Users", uniqueConstraints = { @UniqueConstraint(columnNames = { "dtype", "username" }), @UniqueConstraint(columnNames = { "dtype", "email" }), @UniqueConstraint(columnNames = { "dtype", "mobile" }) })
@Inheritance
public abstract class User extends BaseEntity<Long> {

	private static final long serialVersionUID = 400776999956262L;

	/**
	 * 类型
	 */
	public enum Type {

		/**
		 * 会员
		 */
		MEMBER,

		/**
		 * 商家
		 */
		BUSINESS
	}

	/**
	 * "登录失败尝试次数"缓存名称
	 */
	public static final String FAILED_LOGIN_ATTEMPTS_CACHE_NAME = "failedLoginAttempts";

	/**
	 * 是否启用
	 */
	@NotNull
	@Column(nullable = false)
	private Boolean isEnabled;

	/**
	 * 是否锁定
	 */
	@Column(nullable = false)
	private Boolean isLocked;

	/**
	 * 锁定日期
	 */
	private Date lockDate;

	/**
	 * 最后登录IP
	 */
	private String lastLoginIp;

	/**
	 * 最后登录日期
	 */
	private Date lastLoginDate;

	/**
	 * 社会化用户
	 */
	@OneToMany(mappedBy = "user", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	private Set<SocialUser> socialUsers = new HashSet<>();

	/**
	 * 支付事务
	 */
	@OneToMany(mappedBy = "user", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	private Set<PaymentTransaction> paymentTransactions = new HashSet<>();

	/**
	 * 审计日志
	 */
	@OneToMany(mappedBy = "user", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	private Set<AuditLog> auditLogs = new HashSet<>();

	/**
	 * 发送的消息
	 */
	@OneToMany(mappedBy = "fromUser", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	private Set<Message> fromMessages = new HashSet<>();

	/**
	 * 接收的消息
	 */
	@OneToMany(mappedBy = "toUser", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	private Set<Message> toMessages = new HashSet<>();

	/**
	 * 用户1的消息组
	 */
	@OneToMany(mappedBy = "user1", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	private Set<MessageGroup> user1MessageGroups = new HashSet<>();

	/**
	 * 用户2的消息组
	 */
	@OneToMany(mappedBy = "user2", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	private Set<MessageGroup> user2MessageGroups = new HashSet<>();

	/**
	 * 获取是否启用
	 * 
	 * @return 是否启用
	 */
	public Boolean getIsEnabled() {
		return isEnabled;
	}

	/**
	 * 设置是否启用
	 * 
	 * @param isEnabled
	 *            是否启用
	 */
	public void setIsEnabled(Boolean isEnabled) {
		this.isEnabled = isEnabled;
	}

	/**
	 * 获取是否锁定
	 * 
	 * @return 是否锁定
	 */
	public Boolean getIsLocked() {
		return isLocked;
	}

	/**
	 * 设置是否锁定
	 * 
	 * @param isLocked
	 *            是否锁定
	 */
	public void setIsLocked(Boolean isLocked) {
		this.isLocked = isLocked;
	}

	/**
	 * 获取锁定日期
	 * 
	 * @return 锁定日期
	 */
	public Date getLockDate() {
		return lockDate;
	}

	/**
	 * 设置锁定日期
	 * 
	 * @param lockDate
	 *            锁定日期
	 */
	public void setLockDate(Date lockDate) {
		this.lockDate = lockDate;
	}

	/**
	 * 获取最后登录IP
	 * 
	 * @return 最后登录IP
	 */
	public String getLastLoginIp() {
		return lastLoginIp;
	}

	/**
	 * 设置最后登录IP
	 * 
	 * @param lastLoginIp
	 *            最后登录IP
	 */
	public void setLastLoginIp(String lastLoginIp) {
		this.lastLoginIp = lastLoginIp;
	}

	/**
	 * 获取最后登录日期
	 * 
	 * @return 最后登录日期
	 */
	public Date getLastLoginDate() {
		return lastLoginDate;
	}

	/**
	 * 设置最后登录日期
	 * 
	 * @param lastLoginDate
	 *            最后登录日期
	 */
	public void setLastLoginDate(Date lastLoginDate) {
		this.lastLoginDate = lastLoginDate;
	}

	/**
	 * 获取社会化用户
	 * 
	 * @return 社会化用户
	 */
	public Set<SocialUser> getSocialUsers() {
		return socialUsers;
	}

	/**
	 * 设置社会化用户
	 * 
	 * @param socialUsers
	 *            社会化用户
	 */
	public void setSocialUsers(Set<SocialUser> socialUsers) {
		this.socialUsers = socialUsers;
	}

	/**
	 * 获取支付事务
	 * 
	 * @return 支付事务
	 */
	public Set<PaymentTransaction> getPaymentTransactions() {
		return paymentTransactions;
	}

	/**
	 * 设置支付事务
	 * 
	 * @param paymentTransactions
	 *            支付事务
	 */
	public void setPaymentTransactions(Set<PaymentTransaction> paymentTransactions) {
		this.paymentTransactions = paymentTransactions;
	}

	/**
	 * 获取审计日志
	 * 
	 * @return 审计日志
	 */
	public Set<AuditLog> getAuditLogs() {
		return auditLogs;
	}

	/**
	 * 设置审计日志
	 * 
	 * @param auditLogs
	 *            审计日志
	 */
	public void setAuditLogs(Set<AuditLog> auditLogs) {
		this.auditLogs = auditLogs;
	}

	/**
	 * 获取发送的消息
	 * 
	 * @return 发送的消息
	 */
	public Set<Message> getFromMessages() {
		return fromMessages;
	}

	/**
	 * 设置发送的消息
	 * 
	 * @param fromMessages
	 *            发送的消息
	 */
	public void setFromMessages(Set<Message> fromMessages) {
		this.fromMessages = fromMessages;
	}

	/**
	 * 获取接收的消息
	 * 
	 * @return 接收的消息
	 */
	public Set<Message> getToMessages() {
		return toMessages;
	}

	/**
	 * 设置接收的消息
	 * 
	 * @param toMessages
	 *            接收的消息
	 */
	public void setToMessages(Set<Message> toMessages) {
		this.toMessages = toMessages;
	}

	/**
	 * 获取用户1的消息组
	 * 
	 * @return 用户1的消息组
	 */
	public Set<MessageGroup> getUser1MessageGroups() {
		return user1MessageGroups;
	}

	/**
	 * 设置用户1的消息组
	 * 
	 * @param user1MessageGroups
	 *            用户1的消息组
	 */
	public void setUser1MessageGroups(Set<MessageGroup> user1MessageGroups) {
		this.user1MessageGroups = user1MessageGroups;
	}

	/**
	 * 获取用户2的消息组
	 * 
	 * @return 用户2的消息组
	 */
	public Set<MessageGroup> getUser2MessageGroups() {
		return user2MessageGroups;
	}

	/**
	 * 设置用户2的消息组
	 * 
	 * @param user2MessageGroups
	 *            用户2的消息组
	 */
	public void setUser2MessageGroups(Set<MessageGroup> user2MessageGroups) {
		this.user2MessageGroups = user2MessageGroups;
	}

	/**
	 * 获取显示名称
	 * 
	 * @return 显示名称
	 */
	@JsonView(BaseView.class)
	@Transient
	public abstract String getDisplayName();

	/**
	 * 获取身份
	 * 
	 * @return 身份
	 */
	@Transient
	public abstract Object getPrincipal();

	/**
	 * 获取凭证
	 * 
	 * @return 凭证
	 */
	@Transient
	public abstract Object getCredentials();

	/**
	 * 判断凭证是否正确
	 * 
	 * @param credentials
	 *            凭证
	 * @return 凭证是否正确
	 */
	@Transient
	public abstract boolean isValidCredentials(Object credentials);

}