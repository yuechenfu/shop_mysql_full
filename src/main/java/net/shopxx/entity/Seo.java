/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: fix66u1MivxWEcpWNeDv7a4mff5LP0BT
 */
package net.shopxx.entity;

import java.io.IOException;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Transient;

import org.apache.commons.lang.StringUtils;
import org.hibernate.validator.constraints.Length;

import freemarker.core.Environment;
import freemarker.template.TemplateException;
import net.shopxx.util.FreeMarkerUtils;

/**
 * Entity - SEO设置
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Entity
public class Seo extends BaseEntity<Long> {

	private static final long serialVersionUID = -3503657242384822672L;

	/**
	 * 类型
	 */
	public enum Type {

		/**
		 * 首页
		 */
		INDEX,

		/**
		 * 文章列表
		 */
		ARTICLE_LIST,

		/**
		 * 文章搜索
		 */
		ARTICLE_SEARCH,

		/**
		 * 文章详情
		 */
		ARTICLE_DETAIL,

		/**
		 * 商品列表
		 */
		PRODUCT_LIST,

		/**
		 * 商品搜索
		 */
		PRODUCT_SEARCH,

		/**
		 * 商品详情
		 */
		PRODUCT_DETAIL,

		/**
		 * 品牌列表
		 */
		BRAND_LIST,

		/**
		 * 品牌详情
		 */
		BRAND_DETAIL,

		/**
		 * 店铺首页
		 */
		STORE_INDEX,

		/**
		 * 店铺搜索
		 */
		STORE_SEARCH
	}

	/**
	 * 类型
	 */
	@Column(nullable = false, updatable = false, unique = true)
	private Seo.Type type;

	/**
	 * 页面标题
	 */
	@Length(max = 200)
	private String title;

	/**
	 * 页面关键词
	 */
	@Length(max = 200)
	private String keywords;

	/**
	 * 页面描述
	 */
	@Length(max = 200)
	private String description;

	/**
	 * 获取类型
	 * 
	 * @return 类型
	 */
	public Seo.Type getType() {
		return type;
	}

	/**
	 * 设置类型
	 * 
	 * @param type
	 *            类型
	 */
	public void setType(Seo.Type type) {
		this.type = type;
	}

	/**
	 * 获取页面标题
	 * 
	 * @return 页面标题
	 */
	public String getTitle() {
		return title;
	}

	/**
	 * 设置页面标题
	 * 
	 * @param title
	 *            页面标题
	 */
	public void setTitle(String title) {
		this.title = title;
	}

	/**
	 * 获取页面关键词
	 * 
	 * @return 页面关键词
	 */
	public String getKeywords() {
		return keywords;
	}

	/**
	 * 设置页面关键词
	 * 
	 * @param keywords
	 *            页面关键词
	 */
	public void setKeywords(String keywords) {
		if (keywords != null) {
			keywords = keywords.replaceAll("[,\\s]*,[,\\s]*", ",").replaceAll("^,|,$", StringUtils.EMPTY);
		}
		this.keywords = keywords;
	}

	/**
	 * 获取页面描述
	 * 
	 * @return 页面描述
	 */
	public String getDescription() {
		return description;
	}

	/**
	 * 设置页面描述
	 * 
	 * @param description
	 *            页面描述
	 */
	public void setDescription(String description) {
		this.description = description;
	}

	/**
	 * 解析页面标题
	 * 
	 * @return 页面标题
	 */
	@Transient
	public String resolveTitle() {
		try {
			Environment environment = FreeMarkerUtils.getCurrentEnvironment();
			return FreeMarkerUtils.process(getTitle(), environment != null ? environment.getDataModel() : null);
		} catch (IOException e) {
			return null;
		} catch (TemplateException e) {
			return null;
		}
	}

	/**
	 * 解析页面关键词
	 * 
	 * @return 页面关键词
	 */
	@Transient
	public String resolveKeywords() {
		try {
			Environment environment = FreeMarkerUtils.getCurrentEnvironment();
			return FreeMarkerUtils.process(getKeywords(), environment != null ? environment.getDataModel() : null);
		} catch (IOException e) {
			return null;
		} catch (TemplateException e) {
			return null;
		}
	}

	/**
	 * 解析页面描述
	 * 
	 * @return 页面描述
	 */
	@Transient
	public String resolveDescription() {
		try {
			Environment environment = FreeMarkerUtils.getCurrentEnvironment();
			return FreeMarkerUtils.process(getDescription(), environment != null ? environment.getDataModel() : null);
		} catch (IOException e) {
			return null;
		} catch (TemplateException e) {
			return null;
		}
	}

}