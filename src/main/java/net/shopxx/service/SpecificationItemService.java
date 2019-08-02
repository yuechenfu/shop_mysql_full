/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: ShuPZcHXQ2sN7ju2aLVSVWiIsgsxIHi4
 */
package net.shopxx.service;

import java.util.List;

import net.shopxx.entity.SpecificationItem;

/**
 * Service - 规格项
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
public interface SpecificationItemService {

	/**
	 * 规格项过滤
	 * 
	 * @param specificationItems
	 *            规格项
	 */
	void filter(List<SpecificationItem> specificationItems);

}