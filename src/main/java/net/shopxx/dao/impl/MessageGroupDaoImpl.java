/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: 3Jau/XFN/ztSz3Pd4nFw+YrfhLj6WRk8
 */
package net.shopxx.dao.impl;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import org.springframework.stereotype.Repository;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.MessageGroupDao;
import net.shopxx.entity.MessageGroup;
import net.shopxx.entity.User;

/**
 * Dao - 消息组
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Repository
public class MessageGroupDaoImpl extends BaseDaoImpl<MessageGroup, Long> implements MessageGroupDao {

	@Override
	public Page<MessageGroup> findPage(User user, Pageable pageable) {
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<MessageGroup> criteriaQuery = criteriaBuilder.createQuery(MessageGroup.class);
		Root<MessageGroup> root = criteriaQuery.from(MessageGroup.class);
		criteriaQuery.select(root);
		Predicate restrictions = criteriaBuilder.conjunction();
		if (user != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.or(criteriaBuilder.and(criteriaBuilder.equal(root.get("user1"), user), criteriaBuilder.equal(root.get("user1MessageStatus").get("isDeleted"), false)),
					criteriaBuilder.and(criteriaBuilder.equal(root.get("user2"), user), criteriaBuilder.equal(root.get("user2MessageStatus").get("isDeleted"), false))));
		}
		criteriaQuery.where(restrictions);
		return super.findPage(criteriaQuery, pageable);
	}

	@Override
	public MessageGroup find(User user1, User user2) {
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<MessageGroup> criteriaQuery = criteriaBuilder.createQuery(MessageGroup.class);
		Root<MessageGroup> root = criteriaQuery.from(MessageGroup.class);
		criteriaQuery.select(root);
		Predicate restrictions = criteriaBuilder.conjunction();
		if (user1 != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.or(criteriaBuilder.and(criteriaBuilder.equal(root.get("user1"), user1)), criteriaBuilder.and(criteriaBuilder.equal(root.get("user2"), user1))));
		}
		if (user2 != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.or(criteriaBuilder.and(criteriaBuilder.equal(root.get("user1"), user2)), criteriaBuilder.and(criteriaBuilder.equal(root.get("user2"), user2))));
		}
		criteriaQuery.where(restrictions);
		try {
			return entityManager.createQuery(criteriaQuery).getSingleResult();
		} catch (Exception e) {
			return null;
		}
	}

}