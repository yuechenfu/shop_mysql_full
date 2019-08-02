/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: hyuNjaRi7bHtgJuzfilNDd0fmmfriw0V
 */
package net.shopxx.service.impl;

import java.util.List;
import java.util.Set;

import javax.inject.Inject;
import javax.persistence.LockModeType;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.Predicate;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import net.shopxx.dao.SkuDao;
import net.shopxx.dao.StockLogDao;
import net.shopxx.entity.Product;
import net.shopxx.entity.Product.Type;
import net.shopxx.entity.Sku;
import net.shopxx.entity.StockLog;
import net.shopxx.entity.Store;
import net.shopxx.service.SkuService;

/**
 * Service - SKU
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Service
public class SkuServiceImpl extends BaseServiceImpl<Sku, Long> implements SkuService {

	@Inject
	private SkuDao skuDao;
	@Inject
	private StockLogDao stockLogDao;

	@Override
	@Transactional(readOnly = true)
	public boolean snExists(String sn) {
		return skuDao.exists("sn", StringUtils.lowerCase(sn));
	}

	@Override
	@Transactional(readOnly = true)
	public Sku findBySn(String sn) {
		return skuDao.find("sn", StringUtils.lowerCase(sn));
	}

	@Override
	@Transactional(readOnly = true)
	public List<Sku> search(Store store, Product.Type type, String keyword, Set<Sku> excludes, Integer count) {
		return skuDao.search(store, type, keyword, excludes, count);
	}

	@Override
	@Transactional(readOnly = true)
	public List<Sku> findList(Store store, Type type, Set<Sku> matchs, Integer count) {
		return skuDao.findList(store, type, matchs, count);
	}

	@Override
	public void addStock(Sku sku, int amount, StockLog.Type type, String memo) {
		Assert.notNull(sku, "[Assertion failed] - sku is required; it must not be null");
		Assert.notNull(type, "[Assertion failed] - type is required; it must not be null");

		if (amount == 0) {
			return;
		}

		if (!LockModeType.PESSIMISTIC_WRITE.equals(skuDao.getLockMode(sku))) {
			skuDao.flush();
			skuDao.refresh(sku, LockModeType.PESSIMISTIC_WRITE);
		}

		Assert.notNull(sku.getStock(), "[Assertion failed] - sku stock is required; it must not be null");
		Assert.state(sku.getStock() + amount >= 0, "[Assertion failed] - sku stock must be equal or greater than 0");

		sku.setStock(sku.getStock() + amount);
		skuDao.flush();

		StockLog stockLog = new StockLog();
		stockLog.setType(type);
		stockLog.setInQuantity(amount > 0 ? amount : 0);
		stockLog.setOutQuantity(amount < 0 ? Math.abs(amount) : 0);
		stockLog.setStock(sku.getStock());
		stockLog.setMemo(memo);
		stockLog.setSku(sku);
		stockLogDao.persist(stockLog);
	}

	@Override
	public void addAllocatedStock(Sku sku, int amount) {
		Assert.notNull(sku, "[Assertion failed] - sku is required; it must not be null");

		if (amount == 0) {
			return;
		}

		if (!LockModeType.PESSIMISTIC_WRITE.equals(skuDao.getLockMode(sku))) {
			skuDao.flush();
			skuDao.refresh(sku, LockModeType.PESSIMISTIC_WRITE);
		}

		Assert.notNull(sku.getAllocatedStock(), "[Assertion failed] - sku allocatedStock is required; it must not be null");
		Assert.state(sku.getAllocatedStock() + amount >= 0, "[Assertion failed] - sku allocatedStock must be equal or greater than 0");

		sku.setAllocatedStock(sku.getAllocatedStock() + amount);
		skuDao.flush();
	}

	@Override
	@Transactional(readOnly = true)
	public void filter(List<Sku> skus) {
		CollectionUtils.filter(skus, new Predicate() {
			public boolean evaluate(Object object) {
				Sku sku = (Sku) object;
				return sku != null && sku.getStock() != null;
			}
		});
	}

}