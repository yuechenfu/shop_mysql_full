/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: cVLj+NnSqas6D+zNY6wKHkw0TaPI1OZw
 */
package net.shopxx.interceptor;

import java.util.Date;

import javax.annotation.PostConstruct;
import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import net.shopxx.entity.Promotion;
import net.shopxx.entity.Store;
import net.shopxx.entity.StorePluginStatus;
import net.shopxx.exception.UnauthorizedException;
import net.shopxx.plugin.PromotionPlugin;
import net.shopxx.service.PluginService;
import net.shopxx.service.PromotionService;
import net.shopxx.service.StorePluginStatusService;
import net.shopxx.service.StoreService;
import net.shopxx.util.WebUtils;

/**
 * Interceptor - 促销插件
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
public class PromotionPluginInterceptor extends HandlerInterceptorAdapter {

	/**
	 * 默认促销购买URL
	 */
	public static final String DEFAULT_PROMOTION_BUY_URL = "/business/promotion_plugin/buy?%s=%s";

	/**
	 * 促销购买URL
	 */
	private String promotionBuyUrl = DEFAULT_PROMOTION_BUY_URL;

	/**
	 * 默认"促销插件ID"参数名称
	 */
	public static final String DEFAULT_PROMOTION_PLUGIN_ID_PARAMETER_NAME = "promotionPluginId";

	/**
	 * "促销插件ID"参数名称
	 */
	private String promotionPluginIdParameterName = DEFAULT_PROMOTION_PLUGIN_ID_PARAMETER_NAME;

	/**
	 * 默认促销插件Provider
	 */
	@Inject
	@Named("defaultPromotionPluginProvider")
	private PromotionPluginProvider defaultPromotionPluginProvider;

	/**
	 * 促销插件Provider
	 */
	private PromotionPluginProvider promotionPluginProvider;

	@Inject
	private StoreService storeService;
	@Inject
	private StorePluginStatusService storePluginStatusService;

	@PostConstruct
	public void init() {
		if (promotionPluginProvider == null) {
			promotionPluginProvider = defaultPromotionPluginProvider;
		}
	}

	/**
	 * 请求前处理
	 * 
	 * @param request
	 *            HttpServletRequest
	 * @param response
	 *            HttpServletResponse
	 * @param handler
	 *            处理器
	 * @return 是否继续执行
	 */
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		Store currentStore = storeService.getCurrent();
		if (currentStore == null) {
			throw new UnauthorizedException();
		}
		String handlerUrl = null;
		boolean promotionHasExpired = true;
		PromotionPlugin promotionPlugin = promotionPluginProvider.promotionPlugin(request, response, handlerUrl);
		if (promotionPlugin != null) {
			String promotionPluginId = promotionPlugin.getId();
			StorePluginStatus storePluginStatus = storePluginStatusService.find(currentStore, promotionPluginId);
			promotionHasExpired = !currentStore.isSelf() && ((storePluginStatus == null) || (storePluginStatus != null && !storePluginStatus.getEndDate().after(new Date())));
			handlerUrl = String.format(promotionBuyUrl, promotionPluginIdParameterName, promotionPluginId);
		}
		if (promotionPlugin == null || !promotionPlugin.getIsEnabled()) {
			throw new UnauthorizedException();
		}
		if (promotionHasExpired) {
			if (StringUtils.isNotEmpty(handlerUrl)) {
				WebUtils.sendRedirect(request, response, handlerUrl);
			}
			return false;
		}
		return true;
	}

	/**
	 * 获取促销购买URL
	 * 
	 * @return 促销购买URL
	 */
	public String getPromotionBuyUrl() {
		return promotionBuyUrl;
	}

	/**
	 * 设置促销购买URL
	 * 
	 * @param promotionBuyUrl
	 *            促销购买URL
	 */
	public void setPromotionBuyUrl(String promotionBuyUrl) {
		this.promotionBuyUrl = promotionBuyUrl;
	}

	/**
	 * 获取促销插件Provider
	 * 
	 * @return 促销插件Provider
	 */
	public PromotionPluginProvider getPromotionPluginProvider() {
		return promotionPluginProvider;
	}

	/**
	 * 设置促销插件Provider
	 * 
	 * @param promotionPluginProvider
	 *            促销插件Provider
	 */
	public void setPromotionPluginProvider(PromotionPluginProvider promotionPluginProvider) {
		this.promotionPluginProvider = promotionPluginProvider;
	}

	/**
	 * 获取"促销插件ID"参数名称
	 * 
	 * @return "促销插件ID"参数名称
	 */
	public String getPromotionPluginIdParameterName() {
		return promotionPluginIdParameterName;
	}

	/**
	 * 设置"促销插件ID"参数名称
	 * 
	 * @param promotionPluginIdParameterName
	 *            "促销插件ID"参数名称
	 */
	public void setPromotionPluginIdParameterName(String promotionPluginIdParameterName) {
		this.promotionPluginIdParameterName = promotionPluginIdParameterName;
	}

	/**
	 * 默认促销插件Provider
	 * 
	 * @author SHOP++ Team
	 * @version 6.1
	 */
	@Component("defaultPromotionPluginProvider")
	public static class DefaultPromotionPluginProvider implements PromotionPluginProvider {

		/**
		 * 默认"促销插件ID"参数名称
		 */
		public static final String DEFAULT_PROMOTION_PLUGIN_ID_PARAMETER_NAME = "promotionPluginId";

		/**
		 * "促销插件ID"参数名称
		 */
		private String promotionPluginIdParameterName = DEFAULT_PROMOTION_PLUGIN_ID_PARAMETER_NAME;

		@Inject
		private PluginService pluginService;

		@Override
		public PromotionPlugin promotionPlugin(HttpServletRequest request, HttpServletResponse response, Object handler) {
			String promotionPluginId = request.getParameter(promotionPluginIdParameterName);
			return StringUtils.isNotEmpty(promotionPluginId) ? pluginService.getPromotionPlugin(promotionPluginId) : null;
		}

		/**
		 * 获取"促销插件ID"参数名称
		 * 
		 * @return "促销插件ID"参数名称
		 */
		public String getPromotionPluginIdParameterName() {
			return promotionPluginIdParameterName;
		}

		/**
		 * 设置"促销插件ID"参数名称
		 * 
		 * @param promotionPluginIdParameterName
		 *            "促销插件ID"参数名称
		 */
		public void setPromotionPluginIdParameterName(String promotionPluginIdParameterName) {
			this.promotionPluginIdParameterName = promotionPluginIdParameterName;
		}

	}

	/**
	 * 通过促销ID获取促销插件Provider
	 *
	 * @author SHOP++ Team
	 * @version 6.1
	 */
	@Component("promotionIdPromotionPluginProvider")
	public static class PromotionIdPromotionPluginProvider implements PromotionPluginProvider {

		/**
		 * 默认"促销ID"参数名称
		 */
		public static final String DEFAULT_PROMOTION_ID_PARAMETER_NAME = "promotionId";

		/**
		 * "促销ID"参数名称
		 */
		private String promotionIdParameterName = DEFAULT_PROMOTION_ID_PARAMETER_NAME;

		@Inject
		private PluginService pluginService;
		@Inject
		private PromotionService promotionService;

		@Override
		public PromotionPlugin promotionPlugin(HttpServletRequest request, HttpServletResponse response, Object handler) {
			String promotionId = request.getParameter(promotionIdParameterName);
			Promotion promotion = promotionService.find(Long.valueOf(promotionId));
			return promotion != null && StringUtils.isNotEmpty(promotion.getPromotionPluginId()) ? pluginService.getPromotionPlugin(promotion.getPromotionPluginId()) : null;
		}

		/**
		 * 获取"促销ID"参数名称
		 *
		 * @return "促销ID"参数名称
		 */
		public String getPromotionIdParameterName() {
			return promotionIdParameterName;
		}

		/**
		 * 设置"促销ID"参数名称
		 *
		 * @param promotionIdParameterName
		 *            "促销ID"参数名称
		 */
		public void setPromotionIdParameterName(String promotionIdParameterName) {
			this.promotionIdParameterName = promotionIdParameterName;
		}

	}

}