/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: 8kRJBDyyKnNd4jgOUpiWya0wUaA1TeFy
 */
package net.shopxx.controller.admin;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import net.shopxx.entity.Product;
import net.shopxx.service.ProductService;

/**
 * Controller - 商品排名
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Controller("adminProductRankingController")
@RequestMapping("/admin/product_ranking")
public class ProductRankingController extends BaseController {

	/**
	 * 默认排名类型
	 */
	private static final Product.RankingType DEFAULT_RANKING_TYPE = Product.RankingType.SCORE;

	/**
	 * 默认数量
	 */
	private static final int DEFAULT_SIZE = 10;

	@Inject
	private ProductService productService;

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(Model model) {
		model.addAttribute("rankingTypes", Product.RankingType.values());
		model.addAttribute("rankingType", DEFAULT_RANKING_TYPE);
		model.addAttribute("size", DEFAULT_SIZE);
		return "admin/product_ranking/list";
	}

	/**
	 * 数据
	 */
	@GetMapping("/data")
	public ResponseEntity<?> data(Product.RankingType rankingType, Integer size) {
		if (rankingType == null) {
			rankingType = DEFAULT_RANKING_TYPE;
		}
		if (size == null) {
			size = DEFAULT_SIZE;
		}
		List<Map<String, Object>> data = new ArrayList<>();
		for (Product product : productService.findList(rankingType, null, size)) {
			Object value = null;
			switch (rankingType) {
			case SCORE:
				value = product.getScore();
				break;
			case SCORE_COUNT:
				value = product.getScoreCount();
				break;
			case WEEK_HITS:
				value = product.getWeekHits();
				break;
			case MONTH_HITS:
				value = product.getMonthHits();
				break;
			case HITS:
				value = product.getHits();
				break;
			case WEEK_SALES:
				value = product.getWeekSales();
				break;
			case MONTH_SALES:
				value = product.getMonthSales();
				break;
			case SALES:
				value = product.getSales();
				break;
			}
			Map<String, Object> item = new HashMap<>();
			item.put("name", product.getName());
			item.put("value", value);
			data.add(item);
		}
		return ResponseEntity.ok(data);
	}

}