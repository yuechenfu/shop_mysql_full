/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: u+/MbUZVd/h1WMDI0QNYRVLtodVgZPNy
 */
package net.shopxx.dao;

import java.util.List;

import net.shopxx.entity.Message;
import net.shopxx.entity.MessageGroup;
import net.shopxx.entity.User;

/**
 * Dao - 消息
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
public interface MessageDao extends BaseDao<Message, Long> {

	/**
	 * 查找
	 * 
	 * @param messageGroup
	 *            消息组
	 * @param user
	 *            用户
	 * @return 消息
	 */
	List<Message> findList(MessageGroup messageGroup, User user);

	/**
	 * 未读消息数量
	 * 
	 * @param messageGroup
	 *            消息组
	 * @param user
	 *            用户
	 * @return 未读消息数量
	 */
	Long unreadMessageCount(MessageGroup messageGroup, User user);

}