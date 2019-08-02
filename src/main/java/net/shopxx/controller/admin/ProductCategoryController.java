/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: IRP/DOlXMsjV3hpSYNbwvriz3XAcr0T/
 */
package net.shopxx.controller.admin;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.inject.Inject;

import org.apache.commons.lang.StringUtils;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import net.shopxx.Results;
import net.shopxx.entity.Product;
import net.shopxx.entity.ProductCategory;
import net.shopxx.entity.Promotion;
import net.shopxx.service.BrandService;
import net.shopxx.service.ProductCategoryService;
import net.shopxx.service.PromotionService;

/**
 * Controller - 商品分类
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Controller("adminProductCategoryController")
@RequestMapping("/admin/product_category")
public class ProductCategoryController extends BaseController {

	@Inject
	private ProductCategoryService productCategoryService;
	@Inject
	private BrandService brandService;
	@Inject
	private PromotionService promotionService;

	/**
	 * 促销选择
	 */
	@GetMapping("/promotion_select")
	public ResponseEntity<?> promotionSelect(String keyword) {
		List<Map<String, Object>> data = new ArrayList<>();
		if (StringUtils.isEmpty(keyword)) {
			return ResponseEntity.ok(data);
		}
		List<Promotion> promotions = promotionService.search(keyword, null, null);
		for (Promotion promotion : promotions) {
			Map<String, Object> item = new HashMap<>();
			item.put("id", promotion.getId());
			item.put("name", promotion.getName());
			item.put("storeName", promotion.getStore().getName());
			data.add(item);
		}
		return ResponseEntity.ok(data);
	}

	/**
	 * 添加
	 */
	@GetMapping("/add")
	public String add(ModelMap model) {
		model.addAttribute("productCategoryTree", productCategoryService.findTree());
		model.addAttribute("brands", brandService.findAll());
		model.addAttribute("promotions", promotionService.findAll());
		return "admin/product_category/add";
	}

	/**
	 * 保存
	 */
	@PostMapping("/save")
	public ResponseEntity<?> save(ProductCategory productCategory, Long parentId, Long[] brandIds, Long[] promotionIds) {
		productCategory.setParent(productCategoryService.find(parentId));
		productCategory.setBrands(new HashSet<>(brandService.findList(brandIds)));
		productCategory.setPromotions(new HashSet<>(promotionService.findList(promotionIds)));
		if (!isValid(productCategory)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		productCategory.setTreePath(null);
		productCategory.setGrade(null);
		productCategory.setChildren(null);
		productCategory.setProducts(null);
		productCategory.setParameters(null);
		productCategory.setAttributes(null);
		productCategory.setSpecifications(null);
		productCategory.setStores(null);
		productCategory.setCategoryApplications(null);
		productCategoryService.save(productCategory);
		return Results.OK;
	}

	/**
	 * 编辑
	 */
	@GetMapping("/edit")
	public String edit(Long id, ModelMap model) {
		ProductCategory productCategory = productCategoryService.find(id);
		model.addAttribute("productCategoryTree", productCategoryService.findTree());
		model.addAttribute("brands", brandService.findAll());
		model.addAttribute("promotions", promotionService.findAll());
		model.addAttribute("productCategory", productCategory);
		model.addAttribute("children", productCategoryService.findChildren(productCategory, true, null));
		return "admin/product_category/edit";
	}

	/**
	 * 更新
	 */
	@PostMapping("/update")
	public ResponseEntity<?> update(ProductCategory productCategory, Long parentId, Long[] brandIds, Long[] promotionIds) {
		productCategory.setParent(productCategoryService.find(parentId));
		productCategory.setBrands(new HashSet<>(brandService.findList(brandIds)));
		productCategory.setPromotions(new HashSet<>(promotionService.findList(promotionIds)));
		if (!isValid(productCategory)) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		if (productCategory.getParent() != null) {
			ProductCategory parent = productCategory.getParent();
			if (parent.equals(productCategory)) {
				return Results.UNPROCESSABLE_ENTITY;
			}
			List<ProductCategory> children = productCategoryService.findChildren(parent, true, null);
			if (children != null && children.contains(parent)) {
				return Results.UNPROCESSABLE_ENTITY;
			}
		}
		productCategoryService.update(productCategory, "stores", "categoryApplications", "treePath", "grade", "children", "product", "parameters", "attributes", "specifications");
		return Results.OK;
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list(ModelMap model) {
		model.addAttribute("productCategoryTree", productCategoryService.findTree());
		return "admin/product_category/list";
	}

	/**
	 * 删除
	 */
	@PostMapping("/delete")
	public ResponseEntity<?> delete(Long id) {
		ProductCategory productCategory = productCategoryService.find(id);
		if (productCategory == null) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		Set<ProductCategory> children = productCategory.getChildren();
		if (children != null && !children.isEmpty()) {
			return Results.unprocessableEntity("admin.productCategory.deleteExistChildrenNotAllowed");
		}
		Set<Product> products = productCategory.getProducts();
		if (products != null && !products.isEmpty()) {
			return Results.unprocessableEntity("admin.productCategory.deleteExistProductNotAllowed");
		}
		productCategoryService.delete(id);
		return Results.OK;
	}

}