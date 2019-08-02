/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: eKkKxWoHZgiqwW4p5VkAYuyknmbnEgQb
 */
package net.shopxx.audit;

import java.util.HashMap;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.core.annotation.AnnotationUtils;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import net.shopxx.entity.AuditLog;
import net.shopxx.service.AuditLogService;
import net.shopxx.service.UserService;
import net.shopxx.util.SpringUtils;

/**
 * Audit - 审计日志拦截器
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
public class AuditLogInterceptor extends HandlerInterceptorAdapter {

	@Inject
	private AuditLogService auditLogService;
	@Inject
	private UserService userService;

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
		if (handler instanceof HandlerMethod) {
			HandlerMethod handlerMethod = (HandlerMethod) handler;
			Audit audit = AnnotationUtils.findAnnotation(handlerMethod.getMethod(), Audit.class);
			if (audit != null) {
				AuditLog auditLog = new AuditLog();
				auditLog.setAction(SpringUtils.getMessage(audit.action()));
				auditLog.setIp(request.getRemoteAddr());
				auditLog.setRequestUrl(String.valueOf(request.getRequestURL()));
				auditLog.setParameters(new HashMap<>(request.getParameterMap()));
				auditLog.setUser(userService.getCurrent());
				request.setAttribute(AuditLog.AUDIT_LOG_ATTRIBUTE_NAME, auditLog);
			}
		}
		return super.preHandle(request, response, handler);
	}

	/**
	 * 请求后处理
	 * 
	 * @param request
	 *            HttpServletRequest
	 * @param response
	 *            HttpServletResponse
	 * @param handler
	 *            处理器
	 * @param modelAndView
	 *            数据视图
	 */
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
		if (handler instanceof HandlerMethod) {
			HandlerMethod handlerMethod = (HandlerMethod) handler;
			Audit audit = AnnotationUtils.findAnnotation(handlerMethod.getMethod(), Audit.class);
			if (audit != null) {
				AuditLog auditLog = (AuditLog) request.getAttribute(AuditLog.AUDIT_LOG_ATTRIBUTE_NAME);
				if (auditLog != null && auditLog.isNew()) {
					auditLogService.create(auditLog);
				}
			}
		}
	}

}