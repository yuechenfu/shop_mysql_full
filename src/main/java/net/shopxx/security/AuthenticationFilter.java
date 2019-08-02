/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: EuEDH2/kHyikKyBPeGja2T7euieD3eQj
 */
package net.shopxx.security;

import java.net.URLEncoder;

import javax.inject.Inject;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.DisabledAccountException;
import org.apache.shiro.authc.IncorrectCredentialsException;
import org.apache.shiro.authc.LockedAccountException;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.filter.authc.FormAuthenticationFilter;
import org.springframework.context.ApplicationEventPublisher;

import net.shopxx.Results;
import net.shopxx.entity.User;
import net.shopxx.event.UserLoggedInEvent;
import net.shopxx.service.UserService;
import net.shopxx.util.WebUtils;

/**
 * Security - 认证过滤器
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
public class AuthenticationFilter extends FormAuthenticationFilter {

	/**
	 * "重定向URL"参数名称
	 */
	private static final String REDIRECT_URL_PARAMETER_NAME = "redirectUrl";

	/**
	 * 用户类型
	 */
	private Class<? extends User> userClass;

	@Inject
	private ApplicationEventPublisher applicationEventPublisher;
	@Inject
	private UserService userService;

	/**
	 * 创建令牌
	 * 
	 * @param servletRequest
	 *            ServletRequest
	 * @param servletResponse
	 *            ServletResponse
	 * @return 令牌
	 */
	@Override
	protected org.apache.shiro.authc.AuthenticationToken createToken(ServletRequest servletRequest, ServletResponse servletResponse) {
		String username = getUsername(servletRequest);
		String password = getPassword(servletRequest);
		boolean rememberMe = isRememberMe(servletRequest);
		String host = getHost(servletRequest);
		return new UserAuthenticationToken(getUserClass(), username, password, rememberMe, host);
	}

	/**
	 * 是否允许访问
	 * 
	 * @param servletRequest
	 *            ServletRequest
	 * @param servletResponse
	 *            ServletResponse
	 * @param mappedValue
	 *            映射值
	 * @return 是否允许访问
	 */
	@Override
	protected boolean isAccessAllowed(ServletRequest servletRequest, ServletResponse servletResponse, Object mappedValue) {
		Subject subject = getSubject(servletRequest, servletResponse);
		Object principal = subject != null ? subject.getPrincipal() : null;
		if (principal != null && !getUserClass().isAssignableFrom(principal.getClass())) {
			return false;
		}
		return super.isAccessAllowed(servletRequest, servletResponse, mappedValue);
	}

	/**
	 * 拒绝访问处理
	 * 
	 * @param servletRequest
	 *            ServletRequest
	 * @param servletResponse
	 *            ServletResponse
	 * @return 是否继续处理
	 */
	@Override
	protected boolean onAccessDenied(ServletRequest servletRequest, ServletResponse servletResponse) throws Exception {
		HttpServletRequest request = (HttpServletRequest) servletRequest;
		HttpServletResponse response = (HttpServletResponse) servletResponse;

		if (isLoginRequest(request, response)) {
			if (isLoginSubmission(request, response)) {
				return executeLogin(request, response);
			} else {
				return true;
			}
		} else {
			if (WebUtils.isAjaxRequest(request)) {
				Results.unauthorized(response, "common.message.unauthorized");
				return false;
			}
			saveRequest(request);
			String loginUrl = getLoginUrl();
			if (StringUtils.equalsIgnoreCase(request.getMethod(), "GET")) {
				String redirectUrl = request.getRequestURI() + (StringUtils.isNotEmpty(request.getQueryString()) ? "?" + request.getQueryString() : "");
				loginUrl += StringUtils.contains(loginUrl, "?") ? "&" : "?" + REDIRECT_URL_PARAMETER_NAME + "=" + URLEncoder.encode(redirectUrl, "UTF-8");
			}
			WebUtils.sendRedirect(request, response, loginUrl);
			return false;
		}
	}

	/**
	 * 登录成功处理
	 * 
	 * @param authenticationToken
	 *            令牌
	 * @param subject
	 *            Subject
	 * @param servletRequest
	 *            ServletRequest
	 * @param servletResponse
	 *            ServletResponse
	 * @return 是否继续处理
	 */
	@Override
	protected boolean onLoginSuccess(org.apache.shiro.authc.AuthenticationToken authenticationToken, Subject subject, ServletRequest servletRequest, ServletResponse servletResponse) throws Exception {
		HttpServletRequest request = (HttpServletRequest) servletRequest;
		HttpServletResponse response = (HttpServletResponse) servletResponse;

		applicationEventPublisher.publishEvent(new UserLoggedInEvent(this, userService.getCurrent()));

		if (WebUtils.isAjaxRequest(request)) {
			Results.ok(response, Results.DEFAULT_OK_MESSAGE);
			return false;
		}
		return super.onLoginSuccess(authenticationToken, subject, servletRequest, servletResponse);
	}

	/**
	 * 登录失败处理
	 * 
	 * @param authenticationToken
	 *            令牌
	 * @param authenticationException
	 *            认证异常
	 * @param servletRequest
	 *            ServletRequest
	 * @param servletResponse
	 *            ServletResponse
	 * @return 是否继续处理
	 */
	@Override
	protected boolean onLoginFailure(org.apache.shiro.authc.AuthenticationToken authenticationToken, AuthenticationException authenticationException, ServletRequest servletRequest, ServletResponse servletResponse) {
		HttpServletRequest request = (HttpServletRequest) servletRequest;
		HttpServletResponse response = (HttpServletResponse) servletResponse;
		if (WebUtils.isAjaxRequest(request)) {
			String errorMessage = null;
			if (authenticationException instanceof UnknownAccountException) {
				errorMessage = "common.login.unknownAccount";
			} else if (authenticationException instanceof LockedAccountException) {
				errorMessage = "common.login.lockedAccount";
			} else if (authenticationException instanceof DisabledAccountException) {
				errorMessage = "common.login.disabledAccount";
			} else if (authenticationException instanceof IncorrectCredentialsException) {
				errorMessage = "common.login.incorrectCredentials";
			}
			if (errorMessage != null) {
				Results.unprocessableEntity(response, errorMessage);
			}
			return false;
		}
		return super.onLoginFailure(authenticationToken, authenticationException, servletRequest, servletResponse);
	}

	/**
	 * 获取用户类型
	 * 
	 * @return 用户类型
	 */
	public Class<? extends User> getUserClass() {
		return userClass;
	}

	/**
	 * 设置用户类型
	 * 
	 * @param userClass
	 *            用户类型
	 */
	public void setUserClass(Class<? extends User> userClass) {
		this.userClass = userClass;
	}

}