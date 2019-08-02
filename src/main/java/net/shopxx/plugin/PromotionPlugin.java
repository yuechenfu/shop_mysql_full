/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: B9HRhrIj48O7Pa1uug/AOpKBpNGidiAO
 */
package net.shopxx.plugin;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;

import javax.inject.Inject;

import org.apache.commons.lang.builder.CompareToBuilder;
import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.springframework.stereotype.Component;

import net.shopxx.entity.Coupon;
import net.shopxx.entity.PluginConfig;
import net.shopxx.entity.Promotion;
import net.shopxx.entity.PromotionDefaultAttribute;
import net.shopxx.entity.Sku;
import net.shopxx.entity.Store;
import net.shopxx.service.PluginConfigService;

/**
 * Plugin - 促销插件
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
public abstract class PromotionPlugin implements Comparable<PromotionPlugin> {

	/**
	 * "显示名称"属性名称
	 */
	public static final String DISPLAY_NAME_ATTRIBUTE_NAME = "displayName";

	/**
	 * "描述"属性名称
	 */
	public static final String DESCRIPTION_ATTRIBUTE_NAME = "description";

	/**
	 * "服务费"属性名称
	 */
	public static final String SERVICE_CHARGE = "serviceCharge";

	@Inject
	private PluginConfigService pluginConfigService;

	/**
	 * 获取ID
	 * 
	 * @return ID
	 */
	public String getId() {
		return getClass().getAnnotation(Component.class).value();
	}

	/**
	 * 获取名称
	 * 
	 * @return 名称
	 */
	public abstract String getName();

	/**
	 * 获取安装URL
	 * 
	 * @return 安装URL
	 */
	public abstract String getInstallUrl();

	/**
	 * 获取卸载URL
	 * 
	 * @return 卸载URL
	 */
	public abstract String getUninstallUrl();

	/**
	 * 获取设置URL
	 * 
	 * @return 设置URL
	 */
	public abstract String getSettingUrl();

	/**
	 * 获取添加URL
	 * 
	 * @return 添加URL
	 */
	public abstract String getAddUrl();

	/**
	 * 获取编辑URL
	 * 
	 * @return 编辑URL
	 */
	public abstract String getEditUrl();

	/**
	 * 获取版本
	 * 
	 * @return 版本
	 */
	public String getVersion() {
		return "1.0";
	};

	/**
	 * 获取作者
	 * 
	 * @return 作者
	 */
	public String getAuthor() {
		return "SHOP++";
	};

	/**
	 * 获取是否已安装
	 * 
	 * @return 是否已安装
	 */
	public boolean getIsInstalled() {
		return pluginConfigService.pluginIdExists(getId());
	}

	/**
	 * 获取插件配置
	 * 
	 * @return 插件配置
	 */
	public PluginConfig getPluginConfig() {
		return pluginConfigService.findByPluginId(getId());
	}

	/**
	 * 获取是否启用
	 * 
	 * @return 是否启用
	 */
	public boolean getIsEnabled() {
		PluginConfig pluginConfig = getPluginConfig();
		return pluginConfig != null ? pluginConfig.getIsEnabled() : false;
	}

	/**
	 * 获取属性值
	 * 
	 * @param name
	 *            属性名称
	 * @return 属性值
	 */
	public String getAttribute(String name) {
		PluginConfig pluginConfig = getPluginConfig();
		return pluginConfig != null ? pluginConfig.getAttribute(name) : null;
	}

	/**
	 * 获取排序
	 * 
	 * @return 排序
	 */
	public Integer getOrder() {
		PluginConfig pluginConfig = getPluginConfig();
		return pluginConfig != null ? pluginConfig.getOrder() : null;
	}

	/**
	 * 获取显示名称
	 * 
	 * @return 显示名称
	 */
	public String getDisplayName() {
		PluginConfig pluginConfig = getPluginConfig();
		return pluginConfig != null ? pluginConfig.getAttribute(DISPLAY_NAME_ATTRIBUTE_NAME) : null;
	}

	/**
	 * 获取描述
	 * 
	 * @return 描述
	 */
	public String getDescription() {
		PluginConfig pluginConfig = getPluginConfig();
		return pluginConfig != null ? pluginConfig.getAttribute(DESCRIPTION_ATTRIBUTE_NAME) : null;
	}

	/**
	 * 获取服务费
	 * 
	 * @return 服务费
	 */
	public BigDecimal getServiceCharge() {
		PluginConfig pluginConfig = getPluginConfig();
		return pluginConfig != null && pluginConfig.getAttribute(SERVICE_CHARGE) != null ? new BigDecimal(pluginConfig.getAttribute(SERVICE_CHARGE)) : BigDecimal.ZERO;
	}

	/**
	 * 判断条件是否满足
	 * 
	 * @param promotion
	 *            促销
	 * @param price
	 *            小计价格
	 * @param quantity
	 *            小计数量
	 * @return 条件是否满足
	 */
	public boolean isConditionPassing(Promotion promotion, BigDecimal price, int quantity) {
		if (promotion != null && promotion.getPromotionDefaultAttribute() != null && price != null) {
			PromotionDefaultAttribute promotionDefaultAttribute = promotion.getPromotionDefaultAttribute();
			if ((promotionDefaultAttribute.getMinPrice() != null && price.compareTo(promotionDefaultAttribute.getMinPrice()) < 0) || (promotionDefaultAttribute.getMaxPrice() != null && price.compareTo(promotionDefaultAttribute.getMaxPrice()) > 0)) {
				return false;
			}
			if ((promotionDefaultAttribute.getMinQuantity() != null && quantity < promotionDefaultAttribute.getMinQuantity()) || (promotionDefaultAttribute.getMaxQuantity() != null && quantity > promotionDefaultAttribute.getMaxQuantity())) {
				return false;
			}
		}
		return true;
	}

	/**
	 * 计算调整值
	 * 
	 * @param promotion
	 *            促销
	 * @param price
	 *            SKU价格
	 * @param quantity
	 *            SKU数量
	 * @return 调整值
	 */
	public BigDecimal computeAdjustmentValue(Promotion promotion, BigDecimal price, int quantity) {
		return price;
	};

	/**
	 * 是否免运费
	 * 
	 * @param promotion
	 *            促销
	 * @return 是否免运费
	 */
	public boolean isFreeShipping(Promotion promotion) {
		return false;
	};

	/**
	 * 获取优惠券
	 * 
	 * @param promotion
	 *            促销
	 * @param store
	 *            店铺
	 * @return 优惠券
	 */
	@SuppressWarnings("unchecked")
	public List<Coupon> getCoupons(Promotion promotion, Store store) {
		return Collections.EMPTY_LIST;
	};

	/**
	 * 获取赠品
	 * 
	 * @param promotion
	 *            促销
	 * @param store
	 *            店铺
	 * @return 赠品
	 */
	@SuppressWarnings("unchecked")
	public List<Sku> getGifts(Promotion promotion, Store store) {
		return Collections.EMPTY_LIST;
	};

	/**
	 * 实现compareTo方法
	 * 
	 * @param promotionPlugin
	 *            登录插件
	 * @return 比较结果
	 */
	@Override
	public int compareTo(PromotionPlugin promotionPlugin) {
		if (promotionPlugin == null) {
			return 1;
		}
		return new CompareToBuilder().append(getOrder(), promotionPlugin.getOrder()).append(getId(), promotionPlugin.getId()).toComparison();
	}

	/**
	 * 重写equals方法
	 * 
	 * @param obj
	 *            对象
	 * @return 是否相等
	 */
	@Override
	public boolean equals(Object obj) {
		if (obj == null) {
			return false;
		}
		if (getClass() != obj.getClass()) {
			return false;
		}
		if (this == obj) {
			return true;
		}
		PromotionPlugin other = (PromotionPlugin) obj;
		return new EqualsBuilder().append(getId(), other.getId()).isEquals();
	}

	/**
	 * 重写hashCode方法
	 * 
	 * @return HashCode
	 */
	@Override
	public int hashCode() {
		return new HashCodeBuilder(17, 37).append(getId()).toHashCode();
	}

}