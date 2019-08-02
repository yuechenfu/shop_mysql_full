/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: PmLGJQwOO9YHniNm9ZqHMst7T55bl4rA
 */
package net.shopxx.service.impl;

import java.math.BigDecimal;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.inject.Inject;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.time.DateUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import net.shopxx.dao.BusinessDao;
import net.shopxx.dao.BusinessDepositLogDao;
import net.shopxx.dao.DistributionCashDao;
import net.shopxx.dao.MemberDao;
import net.shopxx.dao.OrderDao;
import net.shopxx.dao.StatisticDao;
import net.shopxx.dao.StoreDao;
import net.shopxx.entity.Order;
import net.shopxx.entity.Statistic;
import net.shopxx.entity.Store;
import net.shopxx.service.StatisticService;

/**
 * Service - 统计
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Service
public class StatisticServiceImpl extends BaseServiceImpl<Statistic, Long> implements StatisticService {

	@Inject
	private StatisticDao statisticDao;
	@Inject
	private MemberDao memberDao;
	@Inject
	private BusinessDao businessDao;
	@Inject
	private OrderDao orderDao;
	@Inject
	private StoreDao storeDao;
	@Inject
	private BusinessDepositLogDao businessDepositLogDao;
	@Inject
	private DistributionCashDao distributionCashDao;

	@Override
	@Transactional(readOnly = true)
	public boolean exists(Statistic.Type type, Store store, int year, int month, int day) {
		return statisticDao.exists(type, store, year, month, day);
	}

	@Override
	public void collect(int year, int month, int day) {
		for (Statistic.Type type : Statistic.Type.values()) {
			collect(type, null, year, month, day);
		}
		for (int i = 0;; i += 100) {
			List<Store> stores = storeDao.findList(null, Store.Status.SUCCESS, null, null, i, 100);
			for (Store store : stores) {
				for (Statistic.Type type : Statistic.Type.values()) {
					switch (type) {
					case REGISTER_MEMBER_COUNT:
					case REGISTER_BUSINESS_COUNT:
					case MEMBER_BALANCE:
					case MEMBER_FROZEN_AMOUNT:
					case MEMBER_CASH:
					case ADDED_MEMBER_CASH:
					case BUSINESS_BALANCE:
					case BUSINESS_FROZEN_AMOUNT:
					case BUSINESS_CASH:
					case ADDED_BUSINESS_CASH:
					case BAIL:
					case ADDED_BAIL:
						break;
					case CREATE_ORDER_COUNT:
					case COMPLETE_ORDER_COUNT:
					case CREATE_ORDER_AMOUNT:
					case COMPLETE_ORDER_AMOUNT:
					case PLATFORM_COMMISSION:
					case ADDED_PLATFORM_COMMISSION:
					case DISTRIBUTION_COMMISSION:
					case ADDED_DISTRIBUTION_COMMISSION:
						collect(type, store, year, month, day);
					}
				}
			}
			storeDao.flush();
			storeDao.clear();
			if (stores.size() < 100) {
				break;
			}
		}
	}

	@Override
	public void collect(Statistic.Type type, Store store, int year, int month, int day) {
		Assert.notNull(type, "[Assertion failed] - type is required; it must not be null");
		Assert.state(month >= 0, "[Assertion failed] - month must be equal or greater than 0");
		Assert.state(day >= 0, "[Assertion failed] - day must be equal or greater than 0");

		switch (type) {
		case REGISTER_MEMBER_COUNT:
		case REGISTER_BUSINESS_COUNT:
		case MEMBER_BALANCE:
		case MEMBER_FROZEN_AMOUNT:
		case MEMBER_CASH:
		case ADDED_MEMBER_CASH:
		case BUSINESS_BALANCE:
		case BUSINESS_FROZEN_AMOUNT:
		case BUSINESS_CASH:
		case ADDED_BUSINESS_CASH:
		case BAIL:
		case ADDED_BAIL:
			if (statisticDao.exists(type, null, year, month, day)) {
				return;
			}
			break;
		case CREATE_ORDER_COUNT:
		case COMPLETE_ORDER_COUNT:
		case CREATE_ORDER_AMOUNT:
		case COMPLETE_ORDER_AMOUNT:
		case PLATFORM_COMMISSION:
		case ADDED_PLATFORM_COMMISSION:
		case DISTRIBUTION_COMMISSION:
		case ADDED_DISTRIBUTION_COMMISSION:
			if (statisticDao.exists(type, store, year, month, day)) {
				return;
			}
		}
		Calendar beginCalendar = Calendar.getInstance();
		beginCalendar.set(year, month, day);
		Date beginDate = DateUtils.truncate(beginCalendar.getTime(), Calendar.DAY_OF_MONTH);

		Calendar endCalendar = Calendar.getInstance();
		endCalendar.set(year, month, day);
		Date endDate = DateUtils.addMilliseconds(DateUtils.ceiling(endCalendar.getTime(), Calendar.DAY_OF_MONTH), -1);

		statisticDao.persist(getStatistic(type, store, beginDate, endDate, year, month, day));
	}

	@Override
	@Transactional(readOnly = true)
	public List<Statistic> analyze(Statistic.Type type, Store store, Statistic.Period period, Date beginDate, Date endDate) {
		List<Statistic> statistics = statisticDao.analyze(type, store, period, beginDate, endDate);
		Date now = new Date();
		Date todayMinimumDate = DateUtils.truncate(now, Calendar.DAY_OF_MONTH);

		if (!endDate.before(todayMinimumDate)) {
			Calendar todayMinimumCalendar = DateUtils.toCalendar(todayMinimumDate);
			int year = todayMinimumCalendar.get(Calendar.YEAR);
			int month = todayMinimumCalendar.get(Calendar.MONTH);
			int day = todayMinimumCalendar.get(Calendar.DAY_OF_MONTH);

			Date tomorrowMinimumDate = DateUtils.ceiling(now, Calendar.DAY_OF_MONTH);
			Date todayMaximumDate = DateUtils.addMilliseconds(tomorrowMinimumDate, -1);

			Statistic statistic = getStatistic(type, store, todayMinimumDate, todayMaximumDate, year, month, day);
			if (CollectionUtils.isEmpty(statistics)) {
				statistics.add(statistic);
				return statistics;
			}

			Statistic pStatistic = statistics.get(statistics.size() - 1);
			switch (period) {
			case YEAR:
				if (!pStatistic.getYear().equals(year)) {
					statistics.add(statistic);
					return statistics;
				}
				merge(statistics, statistic.getValue());
				break;
			case MONTH:
				if (!pStatistic.getYear().equals(year) || !pStatistic.getMonth().equals(month)) {
					statistics.add(statistic);
					return statistics;
				}
				merge(statistics, statistic.getValue());
				break;
			case DAY:
				statistics.add(statistic);
			}
		}
		return statistics;
	}

	/**
	 * 获取统计
	 * 
	 * @param type
	 *            类型
	 * @param store
	 *            店铺
	 * @param beginDate
	 *            起始日期
	 * @param endDate
	 *            结束日期
	 * @param year
	 *            年
	 * @param month
	 *            月
	 * @param day
	 *            日
	 * @return 获取统计
	 */
	private Statistic getStatistic(Statistic.Type type, Store store, Date beginDate, Date endDate, int year, int month, int day) {
		BigDecimal value = null;
		switch (type) {
		case REGISTER_MEMBER_COUNT:
			value = new BigDecimal(memberDao.count(beginDate, endDate));
			break;
		case REGISTER_BUSINESS_COUNT:
			value = new BigDecimal(businessDao.count(beginDate, endDate));
			break;
		case CREATE_ORDER_COUNT:
			value = new BigDecimal(orderDao.createOrderCount(store, beginDate, endDate));
			break;
		case COMPLETE_ORDER_COUNT:
			value = new BigDecimal(orderDao.completeOrderCount(store, beginDate, endDate));
			break;
		case CREATE_ORDER_AMOUNT:
			value = orderDao.createOrderAmount(store, beginDate, endDate);
			break;
		case COMPLETE_ORDER_AMOUNT:
			value = orderDao.completeOrderAmount(store, beginDate, endDate);
			break;
		case MEMBER_BALANCE:
			value = memberDao.totalBalance();
			break;
		case MEMBER_FROZEN_AMOUNT:
			value = memberDao.frozenTotalAmount();
			break;
		case MEMBER_CASH:
			value = distributionCashDao.cashTotalAmount(null, endDate);
			break;
		case ADDED_MEMBER_CASH:
			value = distributionCashDao.cashTotalAmount(beginDate, endDate);
			break;
		case BUSINESS_BALANCE:
			value = businessDao.totalBalance();
			break;
		case BUSINESS_FROZEN_AMOUNT:
			value = businessDao.frozenTotalAmount();
			break;
		case BUSINESS_CASH:
			value = businessDepositLogDao.cashTotalAmount(null, endDate);
			break;
		case ADDED_BUSINESS_CASH:
			value = businessDepositLogDao.cashTotalAmount(beginDate, endDate);
			break;
		case BAIL:
			value = storeDao.bailPaidTotalAmount();
			break;
		case ADDED_BAIL:
			value = storeDao.bailPaidTotalAmount(beginDate, endDate);
			break;
		case PLATFORM_COMMISSION:
			value = orderDao.grantedCommissionTotalAmount(store, Order.CommissionType.PLATFORM, null, endDate, Order.Status.COMPLETED);
			break;
		case ADDED_PLATFORM_COMMISSION:
			value = orderDao.grantedCommissionTotalAmount(store, Order.CommissionType.PLATFORM, beginDate, endDate, Order.Status.COMPLETED);
			break;
		case DISTRIBUTION_COMMISSION:
			value = orderDao.grantedCommissionTotalAmount(store, Order.CommissionType.DISTRIBUTION, beginDate, endDate, Order.Status.COMPLETED);
			break;
		case ADDED_DISTRIBUTION_COMMISSION:
			value = orderDao.grantedCommissionTotalAmount(store, Order.CommissionType.DISTRIBUTION, beginDate, endDate, Order.Status.COMPLETED);
		}

		Statistic statistic = new Statistic();
		statistic.setType(type);
		statistic.setYear(year);
		statistic.setMonth(month);
		statistic.setDay(day);
		statistic.setValue(value);
		statistic.setStore(store);
		return statistic;
	}

	/**
	 * 合并
	 * 
	 * @param statistics
	 *            统计
	 * @param value
	 *            值
	 */
	private void merge(List<Statistic> statistics, BigDecimal value) {
		Assert.notNull(value, "[Assertion failed] - value is required; it must not be null");
		Assert.notEmpty(statistics, "[Assertion failed] - statistics must not be empty: it must contain at least 1 element");

		Statistic statistic = statistics.get(statistics.size() - 1);
		Statistic.Type type = statistic.getType();
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
		case ADDED_DISTRIBUTION_COMMISSION:
			statistic.setValue(statistic.getValue().add(value));
			break;
		case MEMBER_BALANCE:
		case MEMBER_FROZEN_AMOUNT:
		case MEMBER_CASH:
		case BUSINESS_BALANCE:
		case BUSINESS_FROZEN_AMOUNT:
		case BUSINESS_CASH:
		case BAIL:
		case PLATFORM_COMMISSION:
		case DISTRIBUTION_COMMISSION:
			statistic.setValue(value);
		}
		statistics.set(statistics.size() - 1, statistic);
	}

}