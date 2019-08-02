/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: AG5ALMIAYur/26qDPmeUjqSX/LApVPx6
 */
package net.shopxx.service;

import java.util.List;

import net.shopxx.entity.SpecificationItem;
import net.shopxx.entity.SpecificationValue;

/**
 * Service - 规格值
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
public interface SpecificationValueService {

	/**
	 * 规格值验证
	 * 
	 * @param specificationItems
	 *            规格项
	 * @param specificationValues
	 *            规格值
	 * @return 验证结果
	 */
	boolean isValid(List<SpecificationItem> specificationItems, List<SpecificationValue> specificationValues);

}