/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: ZkQjQo/sJci57ndZjubXRCtUsKW8sY+j
 */
package net.shopxx.service;

import java.util.List;

import net.shopxx.entity.ParameterValue;

/**
 * Service - 参数值
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
public interface ParameterValueService {

	/**
	 * 参数值过滤
	 * 
	 * @param parameterValues
	 *            参数值
	 */
	void filter(List<ParameterValue> parameterValues);

}