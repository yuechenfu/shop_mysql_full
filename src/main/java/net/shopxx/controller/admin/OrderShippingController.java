/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: ARfmzfm3xrogfPMn3mv/iyUAZaoplM35
 */
package net.shopxx.controller.admin;

import javax.inject.Inject;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import net.shopxx.Pageable;
import net.shopxx.Results;
import net.shopxx.service.OrderShippingService;

/**
 * Controller - 订单发货
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Controller("adminOrderShippingController")
@RequestMapping("/admin/order_shipping")
public class OrderShippingController extends BaseController {

	@Inject
	private OrderShippingService orderShippingService;

	/**
	 * 查看
	 */
	@GetMapping("/view")
	public String view(Long id, ModelMap model) {
		model.addAttribute("shipping", orderShippingService.find(id));
		return "admin/order_shipping/view";
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Pageable pageable, ModelMap model) {
		model.addAttribute("page", orderShippingService.findPage(pageable));
		return "admin/order_shipping/list";
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public ResponseEntity<?> delete(Long[] ids) {
		orderShippingService.delete(ids);
		return Results.OK;
	}

}