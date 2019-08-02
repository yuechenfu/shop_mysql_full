/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: obRA8c8APdxR4SL/xDduHmIHLnr4UBRk
 */
package net.shopxx.controller.common;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Controller - 错误
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Controller("commonErrorController")
@RequestMapping("/common/error")
public class ErrorController {

	/**
	 * 无此访问权限
	 */
	@GetMapping("/unauthorized")
	public String unauthorized() {
		return "common/error/unauthorized";
	}

	/**
	 * 资源未找到
	 */
	@GetMapping("/not_found")
	public String notFound() {
		return "common/error/not_found";
	}

	/**
	 * 验证码错误
	 */
	@GetMapping("/ncorrect_captcha")
	public String ncorrectCaptcha() {
		return "common/error/ncorrect_captcha";
	}

	/**
	 * CSRF令牌错误
	 */
	@GetMapping("/invalid_csrf_token")
	public String invalidCsrfToken() {
		return "common/error/invalid_csrf_token";
	}

	/**
	 * XSS错误
	 */
	@GetMapping("/invalid_xss")
	public String invalidXss() {
		return "common/error/invalid_xss";
	}

	/**
	 * 浏览器不支持错误
	 */
	@GetMapping("/unsupported_browser")
	public String unsupportedBrowser() {
		return "common/error/unsupported_browser";
	}

}