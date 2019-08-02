/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: 64/bFAcBsGdt9lEKma9WxiNLbeEmRNLG
 */
package net.shopxx.controller.shop;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Controller - Js
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Controller("shopJsController")
@RequestMapping({ "/resources/shop/js", "/resources/mobile/shop/js" })
public class JsController {

	@Value("${javascript_content_type}")
	private String javascriptContentType;

	/**
	 * 共用
	 */
	@GetMapping("/common.js")
	public String common(HttpServletResponse response) {
		response.setContentType(javascriptContentType);
		return "shop/js/common";
	}

}