/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: XmPqOJl0Q5dU/TXi9YikZ/IeiMB5ZPyf
 */
package net.shopxx.dao.impl;

import java.util.List;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import org.springframework.stereotype.Repository;

import net.shopxx.Filter;
import net.shopxx.Order;
import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.InstantMessageDao;
import net.shopxx.entity.InstantMessage;
import net.shopxx.entity.InstantMessage.Type;
import net.shopxx.entity.Store;

/**
 * Dao - 即时通讯
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Repository
public class InstantMessageDaoImpl extends BaseDaoImpl<InstantMessage, Long> implements InstantMessageDao {

	@Override
	public List<InstantMessage> findList(Type type, Store store, Integer count, List<Filter> filters, List<Order> orders) {
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<InstantMessage> criteriaQuery = criteriaBuilder.createQuery(InstantMessage.class);
		Root<InstantMessage> root = criteriaQuery.from(InstantMessage.class);
		criteriaQuery.select(root);
		Predicate restrictions = criteriaBuilder.conjunction();
		if (type != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("type"), type));
		}
		if (store != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("store"), store));
		}
		criteriaQuery.where(restrictions);
		return super.findList(criteriaQuery, null, count, filters, orders);
	}

	@Override
	public Page<InstantMessage> findPage(Store store, Pageable pageable) {
		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<InstantMessage> criteriaQuery = criteriaBuilder.createQuery(InstantMessage.class);
		Root<InstantMessage> root = criteriaQuery.from(InstantMessage.class);
		criteriaQuery.select(root);
		Predicate restrictions = criteriaBuilder.conjunction();
		if (store != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("store"), store));
		}
		criteriaQuery.where(restrictions);
		return super.findPage(criteriaQuery, pageable);
	}

}