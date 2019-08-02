/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: 4pq9V4UZ+av+Rz+StcSrQPCrnumzZdOF
 */
package net.shopxx.plugin;

import java.math.BigDecimal;
import java.math.MathContext;

import javax.persistence.Entity;
import javax.validation.constraints.Digits;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;

import org.springframework.stereotype.Component;

import groovy.lang.Binding;
import groovy.lang.GroovyShell;
import net.shopxx.entity.Promotion;
import net.shopxx.entity.PromotionDefaultAttribute;

/**
 * Plugin - 满减折扣
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Component("moneyOffPromotionPlugin")
public class MoneyOffPromotionPlugin extends PromotionPlugin {

	/**
	 * 重复金额减免表达式
	 */
	public static final String DUPLICATE_AMOUNT_OFF_EXPRESSION = "price-((price/%s) as int) * %s";

	@Override
	public String getName() {
		return "满减折扣";
	}

	@Override
	public String getInstallUrl() {
		return "/admin/plugin/money_off_promotion/install";
	}

	@Override
	public String getUninstallUrl() {
		return "/admin/plugin/money_off_promotion/uninstall";
	}

	@Override
	public String getSettingUrl() {
		return "/admin/plugin/money_off_promotion/setting";
	}

	@Override
	public String getAddUrl() {
		return "/business/money_off_promotion/add";
	}

	@Override
	public String getEditUrl() {
		return "/business/money_off_promotion/edit";
	}

	@Override
	public BigDecimal computeAdjustmentValue(Promotion promotion, BigDecimal price, int quantity) {
		if (promotion != null && price != null && price.compareTo(BigDecimal.ZERO) > 0 && quantity > 0) {
			BigDecimal result = BigDecimal.ZERO;
			MoneyOffPromotionPlugin.MoneyOffAttribute moneyOffAttribute = (MoneyOffPromotionPlugin.MoneyOffAttribute) promotion.getPromotionDefaultAttribute();
			BigDecimal discounValue = moneyOffAttribute.getDiscounValue();
			BigDecimal conditionValue = moneyOffAttribute.getConditionValue();
			if (moneyOffAttribute.getDiscountType() == null || discounValue == null || discounValue.compareTo(BigDecimal.ZERO) <= 0) {
				return price;
			}
			switch (moneyOffAttribute.getDiscountType()) {
			case FIX_PRICE:
				result = discounValue;
				break;
			case AMOUNT_OFF:
				result = price.subtract(discounValue);
				break;
			case PERCENT_OFF:
				result = price.multiply(discounValue);
				break;
			case DUPLICATE_AMOUNT_OFF:
				if (conditionValue == null || conditionValue.compareTo(BigDecimal.ZERO) <= 0) {
					return price;
				}
				try {
					Binding binding = new Binding();
					binding.setVariable("price", price);
					GroovyShell groovyShell = new GroovyShell(binding);
					result = new BigDecimal(String.valueOf(groovyShell.evaluate(String.format(DUPLICATE_AMOUNT_OFF_EXPRESSION, conditionValue, discounValue))), MathContext.DECIMAL32);
				} catch (Exception e) {
					return price;
				}
				break;
			}
			if (result.compareTo(price) > 0) {
				return price;
			}
			return result.compareTo(BigDecimal.ZERO) > 0 ? result : BigDecimal.ZERO;
		}
		return price;
	}

	/**
	 * 满减折扣属性
	 * 
	 * @author SHOP++ Team
	 * @version 6.1
	 */
	@Entity(name = "MoneyOffAttribute")
	public static class MoneyOffAttribute extends PromotionDefaultAttribute {

		private static final long serialVersionUID = 8274749416652276603L;

		/**
		 * 减免类型
		 */
		public enum DiscountType {

			/**
			 * 固定价格
			 */
			FIX_PRICE,

			/**
			 * 金额减免
			 */
			AMOUNT_OFF,

			/**
			 * 百分比减免
			 */
			PERCENT_OFF,

			/**
			 * 重复金额减免
			 */
			DUPLICATE_AMOUNT_OFF
		}

		/**
		 * 条件值
		 */
		@Min(0)
		@Digits(integer = 12, fraction = 3)
		private BigDecimal conditionValue;

		/**
		 * 减免类型
		 */
		@NotNull
		private MoneyOffAttribute.DiscountType discountType;

		/**
		 * 折扣值
		 */
		@NotNull
		@Min(0)
		@Digits(integer = 12, fraction = 3)
		private BigDecimal discounValue;

		/**
		 * 获取条件值
		 * 
		 * @return 条件值
		 */
		public BigDecimal getConditionValue() {
			return conditionValue;
		}

		/**
		 * 设置条件值
		 * 
		 * @param conditionValue
		 *            条件值
		 */
		public void setConditionValue(BigDecimal conditionValue) {
			this.conditionValue = conditionValue;
		}

		/**
		 * 获取折扣类型
		 * 
		 * @return 折扣类型
		 */
		public MoneyOffAttribute.DiscountType getDiscountType() {
			return discountType;
		}

		/**
		 * 设置折扣类型
		 * 
		 * @param discountType
		 *            折扣类型
		 */
		public void setDiscountType(MoneyOffAttribute.DiscountType discountType) {
			this.discountType = discountType;
		}

		/**
		 * 获取折扣值
		 * 
		 * @return 折扣值
		 */
		public BigDecimal getDiscounValue() {
			return discounValue;
		}

		/**
		 * 设置折扣值
		 * 
		 * @param discounValue
		 *            折扣值
		 */
		public void setDiscounValue(BigDecimal discounValue) {
			this.discounValue = discounValue;
		}

	}

}