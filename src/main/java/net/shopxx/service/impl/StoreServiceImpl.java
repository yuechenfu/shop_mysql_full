/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: X4i5CxytvWcifM1YWGrv8je8Y9h3F0sj
 */
package net.shopxx.service.impl;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import javax.inject.Inject;
import javax.persistence.EntityManager;
import javax.persistence.LockModeType;
import javax.persistence.PersistenceContext;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.Predicate;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.Sort;
import org.apache.lucene.search.SortField;
import org.hibernate.search.jpa.FullTextEntityManager;
import org.hibernate.search.jpa.FullTextQuery;
import org.hibernate.search.jpa.Search;
import org.hibernate.search.query.dsl.BooleanJunction;
import org.hibernate.search.query.dsl.QueryBuilder;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.dao.ProductDao;
import net.shopxx.dao.StoreDao;
import net.shopxx.entity.AftersalesSetting;
import net.shopxx.entity.Business;
import net.shopxx.entity.BusinessDepositLog;
import net.shopxx.entity.CategoryApplication;
import net.shopxx.entity.ProductCategory;
import net.shopxx.entity.Store;
import net.shopxx.entity.StorePluginStatus;
import net.shopxx.plugin.MoneyOffPromotionPlugin;
import net.shopxx.plugin.PromotionPlugin;
import net.shopxx.service.AftersalesSettingService;
import net.shopxx.service.BusinessService;
import net.shopxx.service.MailService;
import net.shopxx.service.SmsService;
import net.shopxx.service.StorePluginStatusService;
import net.shopxx.service.StoreService;
import net.shopxx.service.UserService;

/**
 * Service - 店铺
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Service
public class StoreServiceImpl extends BaseServiceImpl<Store, Long> implements StoreService {

	@PersistenceContext
	private EntityManager entityManager;

	@Inject
	private StoreDao storeDao;
	@Inject
	private ProductDao productDao;
	@Inject
	private UserService userService;
	@Inject
	private BusinessService businessService;
	@Inject
	private MailService mailService;
	@Inject
	private SmsService smsService;
	@Inject
	private AftersalesSettingService aftersalesSettingService;
	@Inject
	private StorePluginStatusService storePluginStatusService;

	@Override
	@Transactional(readOnly = true)
	public boolean nameExists(String name) {
		return storeDao.exists("name", name, true);
	}

	@Override
	@Transactional(readOnly = true)
	public boolean nameUnique(Long id, String name) {
		return storeDao.unique(id, "name", name, true);
	}

	@Override
	public boolean productCategoryExists(Store store, final ProductCategory productCategory) {
		Assert.notNull(productCategory, "[Assertion failed] - productCategory is required; it must not be null");
		Assert.notNull(store, "[Assertion failed] - store is required; it must not be null");

		return CollectionUtils.exists(store.getProductCategories(), new Predicate() {
			@Override
			public boolean evaluate(Object object) {
				ProductCategory storeProductCategory = (ProductCategory) object;
				return storeProductCategory != null && storeProductCategory == productCategory;
			}
		});
	}

	@Override
	@Transactional(readOnly = true)
	public Store findByName(String name) {
		return storeDao.find("name", name, true);
	}

	@Override
	@Transactional(readOnly = true)
	public List<Store> findList(Store.Type type, Store.Status status, Boolean isEnabled, Boolean hasExpired, Integer first, Integer count) {
		return storeDao.findList(type, status, isEnabled, hasExpired, first, count);
	}

	@Override
	@Transactional(readOnly = true)
	public List<ProductCategory> findProductCategoryList(Store store, CategoryApplication.Status status) {
		return storeDao.findProductCategoryList(store, status);
	}

	@Override
	@Transactional(readOnly = true)
	public Page<Store> findPage(Store.Type type, Store.Status status, Boolean isEnabled, Boolean hasExpired, Pageable pageable) {
		return storeDao.findPage(type, status, isEnabled, hasExpired, pageable);
	}

	@SuppressWarnings("unchecked")
	@Override
	@Transactional(propagation = Propagation.NOT_SUPPORTED)
	public Page<Store> search(String keyword, Pageable pageable) {
		if (StringUtils.isEmpty(keyword)) {
			return Page.emptyPage(pageable);
		}

		if (pageable == null) {
			pageable = new Pageable();
		}

		FullTextEntityManager fullTextEntityManager = Search.getFullTextEntityManager(entityManager);
		QueryBuilder queryBuilder = fullTextEntityManager.getSearchFactory().buildQueryBuilder().forEntity(Store.class).get();

		Query statusPhraseQuery = queryBuilder.phrase().onField("status").sentence(String.valueOf(Store.Status.SUCCESS)).createQuery();
		Query isEnabledPhraseQuery = queryBuilder.phrase().onField("isEnabled").sentence("true").createQuery();

		BooleanJunction<?> junction = queryBuilder.bool().must(statusPhraseQuery).must(isEnabledPhraseQuery);
		BooleanJunction<?> subJunction = queryBuilder.bool();
		if (keyword.length() < 5) {
			Query namePhraseQuery = queryBuilder.phrase().withSlop(3).onField("name").sentence(keyword).createQuery();
			Query keywordPhraseQuery = queryBuilder.phrase().withSlop(3).onField("keyword").sentence(keyword).createQuery();
			subJunction.should(namePhraseQuery).should(keywordPhraseQuery);
		} else {
			Query nameFuzzyQuery = queryBuilder.keyword().fuzzy().onField("name").ignoreAnalyzer().matching(keyword).createQuery();
			Query keywordFuzzyQuery = queryBuilder.keyword().fuzzy().onField("keyword").ignoreAnalyzer().matching(keyword).createQuery();
			subJunction.should(nameFuzzyQuery).should(keywordFuzzyQuery);
		}
		junction.must(subJunction.createQuery());

		FullTextQuery fullTextQuery = fullTextEntityManager.createFullTextQuery(junction.createQuery(), Store.class);
		fullTextQuery.setSort(new Sort(new SortField(null, SortField.Type.SCORE), new SortField("createdDate", SortField.Type.LONG, true)));
		fullTextQuery.setFirstResult((pageable.getPageNumber() - 1) * pageable.getPageSize());
		fullTextQuery.setMaxResults(pageable.getPageSize());
		return new Page<>(fullTextQuery.getResultList(), fullTextQuery.getResultSize(), pageable);
	}

	@SuppressWarnings("unchecked")
	@Override
	@Transactional(propagation = Propagation.NOT_SUPPORTED)
	public List<Store> search(String keyword) {
		if (StringUtils.isEmpty(keyword)) {
			return Collections.EMPTY_LIST;
		}

		FullTextEntityManager fullTextEntityManager = Search.getFullTextEntityManager(entityManager);
		QueryBuilder queryBuilder = fullTextEntityManager.getSearchFactory().buildQueryBuilder().forEntity(Store.class).get();

		Query statusPhraseQuery = queryBuilder.phrase().onField("status").sentence(String.valueOf(Store.Status.SUCCESS)).createQuery();
		Query isEnabledPhraseQuery = queryBuilder.phrase().onField("isEnabled").sentence("true").createQuery();

		BooleanJunction<?> junction = queryBuilder.bool().must(statusPhraseQuery).must(isEnabledPhraseQuery);
		BooleanJunction<?> subJunction = queryBuilder.bool();
		if (keyword.length() < 5) {
			Query namePhraseQuery = queryBuilder.phrase().withSlop(3).onField("name").sentence(keyword).createQuery();
			Query keywordPhraseQuery = queryBuilder.phrase().withSlop(3).onField("keyword").sentence(keyword).createQuery();
			subJunction.should(namePhraseQuery).should(keywordPhraseQuery);
		} else {
			Query nameFuzzyQuery = queryBuilder.keyword().fuzzy().onField("name").ignoreAnalyzer().matching(keyword).createQuery();
			Query keywordFuzzyQuery = queryBuilder.keyword().fuzzy().onField("keyword").ignoreAnalyzer().matching(keyword).createQuery();
			subJunction.should(nameFuzzyQuery).should(keywordFuzzyQuery);
		}
		junction.must(subJunction.createQuery());

		FullTextQuery fullTextQuery = fullTextEntityManager.createFullTextQuery(junction.createQuery(), Store.class);
		fullTextQuery.setSort(new Sort(new SortField(null, SortField.Type.SCORE), new SortField("createdDate", SortField.Type.LONG, true)));
		return fullTextQuery.getResultList();
	}

	@Override
	@Transactional(readOnly = true)
	public Store getCurrent() {
		Business currentUser = userService.getCurrent(Business.class);
		return currentUser != null ? currentUser.getStore() : null;
	}

	@Override
	@CacheEvict(value = "authorization", allEntries = true)
	public void addEndDays(Store store, int amount) {
		Assert.notNull(store, "[Assertion failed] - store is required; it must not be null");

		if (amount == 0) {
			return;
		}

		if (!LockModeType.PESSIMISTIC_WRITE.equals(storeDao.getLockMode(store))) {
			storeDao.flush();
			storeDao.refresh(store, LockModeType.PESSIMISTIC_WRITE);
		}

		Date now = new Date();
		Date currentEndDate = store.getEndDate();
		if (amount > 0) {
			store.setEndDate(DateUtils.addDays(currentEndDate.after(now) ? currentEndDate : now, amount));
		} else {
			store.setEndDate(DateUtils.addDays(currentEndDate, amount));
		}
		storeDao.flush();
	}

	@Override
	@CacheEvict(value = "authorization", allEntries = true)
	public void addBailPaid(Store store, BigDecimal amount) {
		Assert.notNull(store, "[Assertion failed] - store is required; it must not be null");
		Assert.notNull(amount, "[Assertion failed] - amount is required; it must not be null");

		if (amount.compareTo(BigDecimal.ZERO) == 0) {
			return;
		}

		if (!LockModeType.PESSIMISTIC_WRITE.equals(storeDao.getLockMode(store))) {
			storeDao.flush();
			storeDao.refresh(store, LockModeType.PESSIMISTIC_WRITE);
		}

		Assert.notNull(store.getBailPaid(), "[Assertion failed] - store bailPaid is required; it must not be null");
		Assert.state(store.getBailPaid().add(amount).compareTo(BigDecimal.ZERO) >= 0, "[Assertion failed] - store bailPaid must be equal or greater than 0");

		store.setBailPaid(store.getBailPaid().add(amount));
		storeDao.flush();
	}

	@Override
	@CacheEvict(value = "authorization", allEntries = true)
	public void review(Store store, boolean passed, String content) {
		Assert.notNull(store, "[Assertion failed] - store is required; it must not be null");
		Assert.state(Store.Status.PENDING.equals(store.getStatus()), "[Assertion failed] - store status must be PENDING");
		Assert.state(passed || StringUtils.isNotEmpty(content), "[Assertion failed] - passed or content must not be empty");

		if (passed) {
			BigDecimal serviceFee = store.getStoreRank().getServiceFee();
			BigDecimal bail = store.getStoreCategory().getBail();
			if (serviceFee.compareTo(BigDecimal.ZERO) <= 0 && bail.compareTo(BigDecimal.ZERO) <= 0) {
				store.setStatus(Store.Status.SUCCESS);
				store.setEndDate(DateUtils.addYears(new Date(), 1));
			} else {
				store.setStatus(Store.Status.APPROVED);
				store.setEndDate(new Date());
			}
			AftersalesSetting aftersalesSetting = new AftersalesSetting();
			aftersalesSetting.setStore(store);
			aftersalesSettingService.save(aftersalesSetting);

			smsService.sendApprovalStoreSms(store);
			mailService.sendApprovalStoreMail(store);
		} else {
			store.setStatus(Store.Status.FAILED);
			smsService.sendFailStoreSms(store, content);
			mailService.sendFailStoreMail(store, content);
		}
	}

	@Override
	public void buy(Store store, PromotionPlugin promotionPlugin, int months) {
		Assert.notNull(store, "[Assertion failed] - store is required; it must not be null");
		Assert.notNull(promotionPlugin, "[Assertion failed] - promotionPlugin is required; it must not be null");
		Assert.state(promotionPlugin.getIsEnabled(), "[Assertion failed] - promotionPlugin must be enabled");
		Assert.state(months > 0, "[Assertion failed] - months must be greater than 0");

		BigDecimal amount = promotionPlugin.getServiceCharge().multiply(new BigDecimal(months));
		Business business = store.getBusiness();
		Assert.state(business.getBalance() != null && business.getBalance().compareTo(amount) >= 0, "[Assertion failed] - business balance must not be null and be greater than 0");

		int days = months * 30;
		if (promotionPlugin instanceof MoneyOffPromotionPlugin) {
			StorePluginStatus storePluginStatus = storePluginStatusService.find(store, promotionPlugin.getId());
			if (storePluginStatus != null) {
				storePluginStatusService.addPluginEndDays(storePluginStatus, days);
			} else {
				storePluginStatusService.create(store, promotionPlugin.getId(), days);
			}
			businessService.addBalance(business, amount.negate(), BusinessDepositLog.Type.SVC_PAYMENT, null);
		}
	}

	@Override
	@CacheEvict(value = { "authorization", "product", "productCategory" }, allEntries = true)
	public void expiredStoreProcessing() {
		productDao.refreshExpiredStoreProductActive();
	}

	@Override
	@Transactional
	@CacheEvict(value = { "authorization", "product", "productCategory" }, allEntries = true)
	public Store update(Store store) {
		productDao.refreshActive(store);

		return super.update(store);
	}

	@Override
	@Transactional
	@CacheEvict(value = { "authorization", "product", "productCategory" }, allEntries = true)
	public Store update(Store store, String... ignoreProperties) {
		return super.update(store, ignoreProperties);
	}

	@Override
	@Transactional
	@CacheEvict(value = { "authorization", "product", "productCategory" }, allEntries = true)
	public void delete(Long id) {
		super.delete(id);
	}

	@Override
	@Transactional
	@CacheEvict(value = { "authorization", "product", "productCategory" }, allEntries = true)
	public void delete(Long... ids) {
		super.delete(ids);
	}

	@Override
	@Transactional
	@CacheEvict(value = { "authorization", "product", "productCategory" }, allEntries = true)
	public void delete(Store store) {
		super.delete(store);
	}

	@Override
	@Transactional(readOnly = true)
	public BigDecimal bailPaidTotalAmount() {
		return storeDao.bailPaidTotalAmount();
	}

	@Override
	@Transactional(readOnly = true)
	public Long count(Store.Type type, Store.Status status, Boolean isEnabled, Boolean hasExpired) {
		return storeDao.count(type, status, isEnabled, hasExpired);
	}

}