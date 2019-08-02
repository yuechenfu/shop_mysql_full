/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: noTYaC7TmKOvu9mP2xH32KD9cDGXrRdt
 */
package net.shopxx.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import net.shopxx.dao.MessageDao;
import net.shopxx.dao.MessageGroupDao;
import net.shopxx.entity.Message;
import net.shopxx.entity.MessageGroup;
import net.shopxx.entity.MessageStatus;
import net.shopxx.entity.User;
import net.shopxx.service.MessageService;

/**
 * Service - 消息
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Service
public class MessageServiceImpl extends BaseServiceImpl<Message, Long> implements MessageService {

	@Inject
	private MessageDao messageDao;
	@Inject
	private MessageGroupDao messageGroupDao;

	@Override
	@Transactional(readOnly = true)
	public List<Message> findList(MessageGroup messageGroup, User user) {
		return messageDao.findList(messageGroup, user);
	}

	@Override
	@Transactional(readOnly = true)
	public Long unreadMessageCount(MessageGroup messageGroup, User user) {
		return messageDao.unreadMessageCount(messageGroup, user);
	}

	@Override
	public void consult(MessageGroup messageGroup, User currentUser) {
		Assert.notNull(messageGroup, "[Assertion failed] - messageGroup is required; it must not be null");
		Assert.notNull(currentUser, "[Assertion failed] - currentUser is required; it must not be null");

		if (currentUser.equals(messageGroup.getUser1())) {
			messageGroup.getUser1MessageStatus().setIsRead(true);
		} else {
			messageGroup.getUser2MessageStatus().setIsRead(true);
		}

		List<Message> messages = messageDao.findList(messageGroup, currentUser);
		for (Message message : messages) {
			if (currentUser.equals(message.getToUser())) {
				message.getToUserMessageStatus().setIsRead(true);
			}
		}
	}

	@Override
	public void send(User.Type type, User fromUser, User toUser, String content, String ip) {
		Assert.notNull(type, "[Assertion failed] - type is required; it must not be null");
		Assert.notNull(fromUser, "[Assertion failed] - fromUser is required; it must not be null");
		Assert.notNull(toUser, "[Assertion failed] - toUser is required; it must not be null");
		Assert.hasText(content, "[Assertion failed] - content must have text; it must not be null, empty, or blank");
		Assert.hasText(ip, "[Assertion failed] - ip must have text; it must not be null, empty, or blank");
		Assert.state(!fromUser.equals(toUser), "[Assertion failed] - fromUser must not be toUser");

		MessageGroup messageGroup = messageGroupDao.find(fromUser, toUser);
		if (messageGroup != null) {
			if (fromUser.equals(messageGroup.getUser1())) {
				messageGroup.setUser1MessageStatus(new MessageStatus(true, false));
				messageGroup.setUser2MessageStatus(new MessageStatus(false, false));
			} else {
				messageGroup.setUser1MessageStatus(new MessageStatus(false, false));
				messageGroup.setUser2MessageStatus(new MessageStatus(true, false));
			}
		} else {
			messageGroup = new MessageGroup();
			messageGroup.setUser1(fromUser);
			messageGroup.setUser2(toUser);
			messageGroup.setUser1MessageStatus(new MessageStatus(true, false));
			messageGroup.setUser2MessageStatus(new MessageStatus(false, false));
			messageGroupDao.persist(messageGroup);
		}

		Message message = new Message();
		message.setContent(content);
		message.setIp(ip);
		message.setFromUser(fromUser);
		message.setToUser(toUser);
		message.setFromUserMessageStatus(new MessageStatus(true, false));
		message.setToUserMessageStatus(new MessageStatus(false, false));
		message.setMessageGroup(messageGroup);
		messageDao.persist(message);
	}

	@Override
	public void reply(MessageGroup messageGroup, User fromUser, String content, String ip) {
		Assert.notNull(messageGroup, "[Assertion failed] - messageGroup is required; it must not be null");
		Assert.notNull(fromUser, "[Assertion failed] - fromUser is required; it must not be null");
		Assert.hasText(content, "[Assertion failed] - content must have text; it must not be null, empty, or blank");
		Assert.hasText(ip, "[Assertion failed] - ip must have text; it must not be null, empty, or blank");

		User toUser = null;
		if (fromUser.equals(messageGroup.getUser1())) {
			toUser = messageGroup.getUser2();
			messageGroup.getUser2MessageStatus().setIsRead(false);
			messageGroup.getUser2MessageStatus().setIsDeleted(false);
		} else {
			toUser = messageGroup.getUser1();
			messageGroup.getUser1MessageStatus().setIsRead(false);
			messageGroup.getUser1MessageStatus().setIsDeleted(false);
		}

		Message message = new Message();
		message.setContent(content);
		message.setIp(ip);
		message.setFromUser(fromUser);
		message.setToUser(toUser);
		message.setFromUserMessageStatus(new MessageStatus(true, false));
		message.setToUserMessageStatus(new MessageStatus(false, false));
		message.setMessageGroup(messageGroup);
		messageDao.persist(message);
	}

}