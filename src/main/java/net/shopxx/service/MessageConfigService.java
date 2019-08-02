/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: 8V4YxZsEF5WAZ69P2aTZ0yFEYcMtlsZV
 */
package net.shopxx.service;

import net.shopxx.entity.MessageConfig;

/**
 * Service - 消息配置
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
public interface MessageConfigService extends BaseService<MessageConfig, Long> {

	/**
	 * 查找消息配置
	 * 
	 * @param type
	 *            类型
	 * @return 消息配置
	 */
	MessageConfig find(MessageConfig.Type type);

}