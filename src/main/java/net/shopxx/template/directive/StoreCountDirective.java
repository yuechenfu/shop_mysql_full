/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: ZpgydQTO2ReNOZPaHwLPLxcrB45nUTN9
 */
package net.shopxx.template.directive;

import java.io.IOException;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Component;

import freemarker.core.Environment;
import freemarker.template.TemplateDirectiveBody;
import freemarker.template.TemplateException;
import freemarker.template.TemplateModel;
import net.shopxx.entity.Store;
import net.shopxx.service.StoreService;
import net.shopxx.util.FreeMarkerUtils;

/**
 * 模板指令 - 店铺数量
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Component
public class StoreCountDirective extends BaseDirective {

	/**
	 * "店铺类型"参数名称
	 */
	private static final String TYPE_PARAMETER_NAME = "type";

	/**
	 * "店铺状态"参数名称
	 */
	private static final String STATUS_PARAMETER_NAME = "status";

	/**
	 * "店铺是否启用"参数名称
	 */
	private static final String IS_ENABLED_PARAMETER_NAME = "isEnabled";

	/**
	 * "店铺是否过期"参数名称
	 */
	private static final String HAS_EXPIRED_PARAMETER_NAME = "hasExpired";

	/**
	 * 变量名称
	 */
	private static final String VARIABLE_NAME = "count";

	@Inject
	private StoreService storeService;

	/**
	 * 执行
	 * 
	 * @param env
	 *            环境变量
	 * @param params
	 *            参数
	 * @param loopVars
	 *            循环变量
	 * @param body
	 *            模板内容
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public void execute(Environment env, Map params, TemplateModel[] loopVars, TemplateDirectiveBody body) throws TemplateException, IOException {
		Store.Type type = FreeMarkerUtils.getParameter(TYPE_PARAMETER_NAME, Store.Type.class, params);
		Store.Status status = FreeMarkerUtils.getParameter(STATUS_PARAMETER_NAME, Store.Status.class, params);
		Boolean isEnabled = FreeMarkerUtils.getParameter(IS_ENABLED_PARAMETER_NAME, Boolean.class, params);
		Boolean hasExpired = FreeMarkerUtils.getParameter(HAS_EXPIRED_PARAMETER_NAME, Boolean.class, params);

		long count = storeService.count(type, status, isEnabled, hasExpired);
		setLocalVariable(VARIABLE_NAME, count, env, body);
	}

}