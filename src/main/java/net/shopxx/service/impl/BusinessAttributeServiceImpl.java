/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: IRTnEcRZzQsNeM+sWIToJWoTTjp6Z04N
 */
package net.shopxx.service.impl;

import java.util.Arrays;
import java.util.List;
import java.util.regex.Pattern;

import javax.inject.Inject;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import net.shopxx.Filter;
import net.shopxx.Order;
import net.shopxx.dao.BusinessAttributeDao;
import net.shopxx.entity.BusinessAttribute;
import net.shopxx.service.BusinessAttributeService;

/**
 * Service - 商家注册项
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Service
public class BusinessAttributeServiceImpl extends BaseServiceImpl<BusinessAttribute, Long> implements BusinessAttributeService {

	@Inject
	private BusinessAttributeDao businessAttributeDao;

	@Override
	@Transactional(readOnly = true)
	public Integer findUnusedPropertyIndex() {
		return businessAttributeDao.findUnusedPropertyIndex();
	}

	@Override
	@Transactional(readOnly = true)
	@Cacheable(value = "businessAttribute", condition = "#useCache")
	public List<BusinessAttribute> findList(Boolean isEnabled, Integer count, List<Filter> filters, List<Order> orders, boolean useCache) {
		return businessAttributeDao.findList(isEnabled, count, filters, orders);

	}

	@Override
	@Transactional(readOnly = true)
	@Cacheable(value = "businessAttribute", condition = "#useCache")
	public List<BusinessAttribute> findList(Boolean isEnabled, boolean useCache) {
		return businessAttributeDao.findList(isEnabled, null, null, null);
	}

	@Override
	@Transactional(readOnly = true)
	public boolean isValid(BusinessAttribute businessAttribute, String[] values) {
		Assert.notNull(businessAttribute, "[Assertion failed] - businessAttribute is required; it must not be null");
		Assert.notNull(businessAttribute.getType(), "[Assertion failed] - businessAttribute type is required; it must not be null");

		String value = ArrayUtils.isNotEmpty(values) ? values[0].trim() : null;
		switch (businessAttribute.getType()) {
		case NAME:
		case LICENSE_NUMBER:
		case LICENSE_IMAGE:
		case LEGAL_PERSON:
		case ID_CARD:
		case ID_CARD_IMAGE:
		case PHONE:
		case ORGANIZATION_CODE:
		case ORGANIZATION_IMAGE:
		case IDENTIFICATION_NUMBER:
		case TAX_IMAGE:
		case BANK_NAME:
		case BANK_ACCOUNT:
		case TEXT:
		case IMAGE:
		case DATE:
			if (businessAttribute.getIsRequired() && StringUtils.isEmpty(value)) {
				return false;
			}
			if (StringUtils.isNotEmpty(businessAttribute.getPattern()) && StringUtils.isNotEmpty(value) && !Pattern.compile(businessAttribute.getPattern()).matcher(value).matches()) {
				return false;
			}
			break;
		case SELECT:
			if (businessAttribute.getIsRequired() && StringUtils.isEmpty(value)) {
				return false;
			}
			if (CollectionUtils.isEmpty(businessAttribute.getOptions())) {
				return false;
			}
			if (StringUtils.isNotEmpty(value) && !businessAttribute.getOptions().contains(value)) {
				return false;
			}
			break;
		case CHECKBOX:
			if (businessAttribute.getIsRequired() && ArrayUtils.isEmpty(values)) {
				return false;
			}
			if (CollectionUtils.isEmpty(businessAttribute.getOptions())) {
				return false;
			}
			if (ArrayUtils.isNotEmpty(values) && !businessAttribute.getOptions().containsAll(Arrays.asList(values))) {
				return false;
			}
			break;
		}
		return true;
	}

	@Override
	@Transactional(readOnly = true)
	public Object toBusinessAttributeValue(BusinessAttribute businessAttribute, String[] values) {
		Assert.notNull(businessAttribute, "[Assertion failed] - businessAttribute is required; it must not be null");
		Assert.notNull(businessAttribute.getType(), "[Assertion failed] - businessAttribute type is required; it must not be null");

		if (ArrayUtils.isEmpty(values)) {
			return null;
		}

		String value = values[0].trim();
		switch (businessAttribute.getType()) {
		case NAME:
		case LICENSE_NUMBER:
		case LICENSE_IMAGE:
		case LEGAL_PERSON:
		case ID_CARD:
		case ID_CARD_IMAGE:
		case PHONE:
		case ORGANIZATION_CODE:
		case ORGANIZATION_IMAGE:
		case IDENTIFICATION_NUMBER:
		case TAX_IMAGE:
		case BANK_NAME:
		case BANK_ACCOUNT:
		case TEXT:
		case IMAGE:
		case DATE:
			return StringUtils.isNotEmpty(value) ? value : null;
		case SELECT:
			if (CollectionUtils.isNotEmpty(businessAttribute.getOptions()) && businessAttribute.getOptions().contains(value)) {
				return value;
			}
			break;
		case CHECKBOX:
			if (CollectionUtils.isNotEmpty(businessAttribute.getOptions()) && businessAttribute.getOptions().containsAll(Arrays.asList(values))) {
				return Arrays.asList(values);
			}
			break;
		}
		return null;
	}

	@Override
	@Transactional
	@CacheEvict(value = "businessAttribute", allEntries = true)
	public BusinessAttribute save(BusinessAttribute businessAttribute) {
		Assert.notNull(businessAttribute, "[Assertion failed] - businessAttribute is required; it must not be null");

		Integer unusedPropertyIndex = businessAttributeDao.findUnusedPropertyIndex();
		Assert.notNull(unusedPropertyIndex, "[Assertion failed] - unusedPropertyIndex is required; it must not be null");

		businessAttribute.setPropertyIndex(unusedPropertyIndex);

		return super.save(businessAttribute);
	}

	@Override
	@Transactional
	@CacheEvict(value = "businessAttribute", allEntries = true)
	public BusinessAttribute update(BusinessAttribute businessAttribute) {
		return super.update(businessAttribute);
	}

	@Override
	@Transactional
	@CacheEvict(value = "businessAttribute", allEntries = true)
	public BusinessAttribute update(BusinessAttribute businessAttribute, String... ignoreProperties) {
		return super.update(businessAttribute, ignoreProperties);
	}

	@Override
	@Transactional
	@CacheEvict(value = "businessAttribute", allEntries = true)
	public void delete(Long id) {
		super.delete(id);
	}

	@Override
	@Transactional
	@CacheEvict(value = "businessAttribute", allEntries = true)
	public void delete(Long... ids) {
		super.delete(ids);
	}

	@Override
	@Transactional
	@CacheEvict(value = "businessAttribute", allEntries = true)
	public void delete(BusinessAttribute businessAttribute) {
		if (businessAttribute != null) {
			businessAttributeDao.clearAttributeValue(businessAttribute);
		}

		super.delete(businessAttribute);
	}

}