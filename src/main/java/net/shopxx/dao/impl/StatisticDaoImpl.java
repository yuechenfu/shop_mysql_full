/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: esUuIIXTQ2fPkpv5MbGJe8bWiE5CBMqW
 */
package net.shopxx.dao.impl;

import java.math.BigDecimal;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import javax.persistence.criteria.Subquery;

import org.apache.commons.lang.time.DateUtils;
import org.springframework.stereotype.Repository;
import org.springframework.util.Assert;

import net.shopxx.dao.StatisticDao;
import net.shopxx.entity.Statistic;
import net.shopxx.entity.Store;

/**
 * Dao - 统计
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Repository
public class StatisticDaoImpl extends BaseDaoImpl<Statistic, Long> implements StatisticDao {

	@Override
	public boolean exists(Statistic.Type type, Store store, int year, int month, int day) {
		Assert.notNull(type, "[Assertion failed] - type is required; it must not be null");

		if (store != null) {
			String jpql = "select count(*) from Statistic statistic where statistic.type = :type and statistic.year = :year and statistic.month = :month and statistic.day = :day and statistic.store = :store";
			return entityManager.createQuery(jpql, Long.class).setParameter("type", type).setParameter("year", year).setParameter("month", month).setParameter("day", day).setParameter("store", store).getSingleResult() > 0;
		} else {
			String jpql = "select count(*) from Statistic statistic where statistic.type = :type and statistic.year = :year and statistic.month = :month and statistic.day = :day and statistic.store is null";
			return entityManager.createQuery(jpql, Long.class).setParameter("type", type).setParameter("year", year).setParameter("month", month).setParameter("day", day).getSingleResult() > 0;
		}
	}

	@Override
	public List<Statistic> analyze(Statistic.Type type, Store store, Statistic.Period period, Date beginDate, Date endDate) {
		Assert.notNull(type, "[Assertion failed] - type is required; it must not be null");
		Assert.notNull(period, "[Assertion failed] - period is required; it must not be null");

		CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
		CriteriaQuery<Statistic> criteriaQuery = criteriaBuilder.createQuery(Statistic.class);
		Root<Statistic> root = criteriaQuery.from(Statistic.class);
		Predicate restrictions = criteriaBuilder.conjunction();
		switch (type) {
		case REGISTER_MEMBER_COUNT:
		case REGISTER_BUSINESS_COUNT:
		case CREATE_ORDER_COUNT:
		case COMPLETE_ORDER_COUNT:
		case CREATE_ORDER_AMOUNT:
		case COMPLETE_ORDER_AMOUNT:
		case ADDED_MEMBER_CASH:
		case ADDED_BUSINESS_CASH:
		case ADDED_BAIL:
		case ADDED_PLATFORM_COMMISSION:
		case ADDED_DISTRIBUTION_COMMISSION: {
			switch (period) {
			case YEAR:
				criteriaQuery.select(criteriaBuilder.construct(Statistic.class, root.get("type"), root.get("year"), criteriaBuilder.sum(root.<BigDecimal>get("value"))));
				criteriaQuery.groupBy(root.get("type"), root.get("year"));
				break;
			case MONTH:
				criteriaQuery.select(criteriaBuilder.construct(Statistic.class, root.get("type"), root.get("year"), root.get("month"), criteriaBuilder.sum(root.<BigDecimal>get("value"))));
				criteriaQuery.groupBy(root.get("type"), root.get("year"), root.get("month"));
				break;
			case DAY:
				criteriaQuery.select(criteriaBuilder.construct(Statistic.class, root.get("type"), root.get("year"), root.get("month"), root.get("day"), root.<BigDecimal>get("value")));
				break;
			}
			break;
		}
		case MEMBER_BALANCE:
		case MEMBER_FROZEN_AMOUNT:
		case MEMBER_CASH:
		case BUSINESS_BALANCE:
		case BUSINESS_FROZEN_AMOUNT:
		case BUSINESS_CASH:
		case BAIL:
		case PLATFORM_COMMISSION:
		case DISTRIBUTION_COMMISSION: {
			Subquery<Statistic> subquery = criteriaQuery.subquery(Statistic.class);
			Root<Statistic> subqueryRoot = subquery.from(Statistic.class);
			switch (period) {
			case YEAR:
				subquery.select(subqueryRoot);
				subquery.where(criteriaBuilder.equal(subqueryRoot.get("type"), root.get("type")), criteriaBuilder.equal(subqueryRoot.get("year"), root.get("year")), criteriaBuilder.or(criteriaBuilder.greaterThan(subqueryRoot.<Integer>get("month"), root.<Integer>get("month")),
						criteriaBuilder.and(criteriaBuilder.equal(subqueryRoot.get("month"), root.get("month")), criteriaBuilder.greaterThan(subqueryRoot.<Integer>get("day"), root.<Integer>get("day")))));
				restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.exists(subquery).not());
				break;
			case MONTH:
				subquery.select(subqueryRoot);
				subquery.where(criteriaBuilder.equal(subqueryRoot.get("type"), root.get("type")), criteriaBuilder.equal(subqueryRoot.get("year"), root.get("year")), criteriaBuilder.equal(subqueryRoot.get("month"), root.get("month")),
						criteriaBuilder.greaterThan(subqueryRoot.<Integer>get("day"), root.<Integer>get("day")));
				restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.exists(subquery).not());
				break;
			case DAY:
				break;
			}
			break;
		}
		}
		restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("type"), type));
		if (store != null) {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.equal(root.get("store"), store));
		} else {
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.isNull(root.get("store")));
		}
		if (beginDate != null) {
			Calendar calendar = DateUtils.toCalendar(beginDate);
			int year = calendar.get(Calendar.YEAR);
			int month = calendar.get(Calendar.MONTH);
			int day = calendar.get(Calendar.DAY_OF_MONTH);
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.or(criteriaBuilder.greaterThan(root.<Integer>get("year"), year), criteriaBuilder.and(criteriaBuilder.equal(root.<Integer>get("year"), year), criteriaBuilder.greaterThan(root.<Integer>get("month"), month)),
					criteriaBuilder.and(criteriaBuilder.equal(root.<Integer>get("year"), year), criteriaBuilder.equal(root.<Integer>get("month"), month), criteriaBuilder.greaterThanOrEqualTo(root.<Integer>get("day"), day))));
		}
		if (endDate != null) {
			Calendar calendar = DateUtils.toCalendar(endDate);
			int year = calendar.get(Calendar.YEAR);
			int month = calendar.get(Calendar.MONTH);
			int day = calendar.get(Calendar.DAY_OF_MONTH);
			restrictions = criteriaBuilder.and(restrictions, criteriaBuilder.or(criteriaBuilder.lessThan(root.<Integer>get("year"), year), criteriaBuilder.and(criteriaBuilder.equal(root.<Integer>get("year"), year), criteriaBuilder.lessThan(root.<Integer>get("month"), month)),
					criteriaBuilder.and(criteriaBuilder.equal(root.<Integer>get("year"), year), criteriaBuilder.equal(root.<Integer>get("month"), month), criteriaBuilder.lessThanOrEqualTo(root.<Integer>get("day"), day))));
		}
		criteriaQuery.where(restrictions);
		return entityManager.createQuery(criteriaQuery).getResultList();
	}

}