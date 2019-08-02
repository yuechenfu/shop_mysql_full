/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: YwlQFc9atYwmZ9nfXmRNWqWe7vP3fq0y
 */
package net.shopxx.service;

import net.shopxx.entity.AftersalesSetting;
import net.shopxx.entity.Store;

/**
 * Service - 售后设置
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
public interface AftersalesSettingService extends BaseService<AftersalesSetting, Long> {

	/**
	 * 通过店铺查找售后设置
	 * 
	 * @param store
	 *            店铺
	 * @return 售后设置
	 */
	AftersalesSetting findByStore(Store store);

}