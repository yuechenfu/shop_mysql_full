/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: tyblJVnxXYlGwrasU5C6jckk9uUlRT9b
 */
package net.shopxx.entity;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

/**
 * Entity - 导航组
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Entity
public class NavigationGroup extends BaseEntity<Long> {

	private static final long serialVersionUID = -7911500541698399102L;

	/**
	 * 名称
	 */
	@NotEmpty
	@Length(max = 200)
	@Column(nullable = false)
	private String name;

	/**
	 * 导航
	 */
	@OneToMany(mappedBy = "navigationGroup", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	@OrderBy("order asc")
	private Set<Navigation> navigations = new HashSet<>();

	/**
	 * 获取名称
	 * 
	 * @return 名称
	 */
	public String getName() {
		return name;
	}

	/**
	 * 设置名称
	 * 
	 * @param name
	 *            名称
	 */
	public void setName(String name) {
		this.name = name;
	}

	/**
	 * 获取导航
	 * 
	 * @return 导航
	 */
	public Set<Navigation> getNavigations() {
		return navigations;
	}

	/**
	 * 设置导航
	 * 
	 * @param navigations
	 *            导航
	 */
	public void setNavigations(Set<Navigation> navigations) {
		this.navigations = navigations;
	}

}