/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: WJ4t/UJV9QA11yJ/ZgjxD9XrpdACSrBj
 */
package net.shopxx.entity;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.PreRemove;
import javax.validation.constraints.NotNull;

/**
 * Entity - 分销员
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Entity
public class Distributor extends BaseEntity<Long> {

	private static final long serialVersionUID = 6365871724204736973L;

	/**
	 * 会员
	 */
	@NotNull
	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(nullable = false, updatable = false)
	private Member member;

	/**
	 * 上级分销员
	 */
	@ManyToOne(fetch = FetchType.LAZY)
	private Distributor parent;

	/**
	 * 下级分销员
	 */
	@OneToMany(mappedBy = "parent", fetch = FetchType.LAZY)
	private Set<Distributor> children = new HashSet<>();

	/**
	 * 分销提现
	 */
	@OneToMany(mappedBy = "distributor", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	private Set<DistributionCash> distributionCashs = new HashSet<>();

	/**
	 * 分销佣金
	 */
	@OneToMany(mappedBy = "distributor", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	private Set<DistributionCommission> distributionCommissions = new HashSet<>();

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
	 * 获取上级分销员
	 * 
	 * @return 上级分销员
	 */
	public Distributor getParent() {
		return parent;
	}

	/**
	 * 设置上级分销员
	 * 
	 * @param parent
	 *            上级分销员
	 */
	public void setParent(Distributor parent) {
		this.parent = parent;
	}

	/**
	 * 获取下级分销员
	 * 
	 * @return 下级分销员
	 */
	public Set<Distributor> getChildren() {
		return children;
	}

	/**
	 * 设置下级分销员
	 * 
	 * @param children
	 *            下级分销员
	 */
	public void setChildren(Set<Distributor> children) {
		this.children = children;
	}

	/**
	 * 获取分销提现
	 * 
	 * @return 分销提现
	 */
	public Set<DistributionCash> getDistributionCashs() {
		return distributionCashs;
	}

	/**
	 * 设置分销提现
	 * 
	 * @param distributionCashs
	 *            分销提现
	 */
	public void setDistributionCashs(Set<DistributionCash> distributionCashs) {
		this.distributionCashs = distributionCashs;
	}

	/**
	 * 获取分销佣金
	 * 
	 * @return 分销佣金
	 */
	public Set<DistributionCommission> getDistributionCommissions() {
		return distributionCommissions;
	}

	/**
	 * 设置分销佣金
	 * 
	 * @param distributionCommissions
	 *            分销佣金
	 */
	public void setDistributionCommissions(Set<DistributionCommission> distributionCommissions) {
		this.distributionCommissions = distributionCommissions;
	}

	/**
	 * 删除前处理
	 */
	@PreRemove
	public void preRemove() {
		Set<Distributor> distributors = getChildren();
		if (distributors != null) {
			for (Distributor distributor : distributors) {
				distributor.setParent(null);
			}
		}
	}

}