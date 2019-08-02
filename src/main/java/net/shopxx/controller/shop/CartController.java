/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: C6aL/6koX8hrjLAF7CSs8sOzM8f8lHDc
 */
package net.shopxx.controller.shop;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import net.shopxx.Results;
import net.shopxx.Setting;
import net.shopxx.entity.Cart;
import net.shopxx.entity.CartItem;
import net.shopxx.entity.Product;
import net.shopxx.entity.Sku;
import net.shopxx.entity.Store;
import net.shopxx.security.CurrentCart;
import net.shopxx.service.CartService;
import net.shopxx.service.SkuService;
import net.shopxx.util.SystemUtils;

/**
 * Controller - 购物车
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Controller("shopCartController")
@RequestMapping("/cart")
public class CartController extends BaseController {

	@Inject
	private SkuService skuService;
	@Inject
	private CartService cartService;

	/**
	 * 获取当前购物车
	 */
	@GetMapping("/get_current")
	public ResponseEntity<?> getCurrent(@CurrentCart Cart currentCart) {
		Map<String, Object> data = new HashMap<>();
		Setting setting = SystemUtils.getSetting();
		if (currentCart != null && !currentCart.isEmpty()) {
			data.put("quantity", currentCart.getQuantity(false));
			data.put("rewardPoint", currentCart.getRewardPoint());
			data.put("effectivePrice", currentCart.getEffectivePrice());
			data.put("discount", currentCart.getDiscount());
			List<Map<String, Object>> cartItems = new ArrayList<>();
			for (CartItem cartItem : currentCart) {
				Map<String, Object> item = new HashMap<>();
				Sku sku = cartItem.getSku();
				item.put("skuId", sku.getId());
				item.put("skuName", sku.getName());
				item.put("skuPath", sku.getPath());
				item.put("skuThumbnail", sku.getThumbnail() != null ? sku.getThumbnail() : setting.getDefaultThumbnailProductImage());
				item.put("price", cartItem.getPrice());
				item.put("quantity", cartItem.getQuantity());
				item.put("subtotal", cartItem.getSubtotal());
				cartItems.add(item);
			}
			data.put("cartItems", cartItems);
		}
		return ResponseEntity.ok(data);
	}

	/**
	 * 添加
	 */
	@PostMapping("/add")
	public ResponseEntity<?> add(Long skuId, Integer quantity, @CurrentCart Cart currentCart) {
		Map<String, Object> data = new HashMap<>();
		if (quantity == null || quantity < 1) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		Sku sku = skuService.find(skuId);
		if (sku == null) {
			return Results.unprocessableEntity("shop.cart.skuNotExist");
		}
		if (!Product.Type.GENERAL.equals(sku.getType())) {
			return Results.unprocessableEntity("shop.cart.skuNotForSale");
		}
		if (!sku.getIsActive()) {
			return Results.unprocessableEntity("shop.cart.skuNotActive");
		}
		if (!sku.getIsMarketable()) {
			return Results.unprocessableEntity("shop.cart.skuNotMarketable");
		}
		if (sku.getProduct().getStore().hasExpired()) {
			return Results.unprocessableEntity("shop.cart.skuNotBuyExpired");
		}

		int cartItemSize = 1;
		int skuQuantity = quantity;
		if (currentCart != null) {
			if (currentCart.contains(sku)) {
				CartItem cartItem = currentCart.getCartItem(sku);
				cartItemSize = currentCart.size();
				skuQuantity = cartItem.getQuantity() + quantity;
			} else {
				cartItemSize = currentCart.size() + 1;
				skuQuantity = quantity;
			}
		}
		if (Cart.MAX_CART_ITEM_SIZE != null && cartItemSize > Cart.MAX_CART_ITEM_SIZE) {
			return Results.unprocessableEntity("shop.cart.addCartItemSizeNotAllowed", Cart.MAX_CART_ITEM_SIZE);
		}
		if (CartItem.MAX_QUANTITY != null && skuQuantity > CartItem.MAX_QUANTITY) {
			return Results.unprocessableEntity("shop.cart.addQuantityNotAllowed", CartItem.MAX_QUANTITY);
		}
		if (skuQuantity > sku.getAvailableStock()) {
			return Results.unprocessableEntity("shop.cart.skuLowStock");
		}
		if (currentCart == null) {
			currentCart = cartService.create();
		}
		cartService.add(currentCart, sku, quantity);
		data.put("quantity", currentCart.getQuantity(false));
		data.put("rewardPoint", currentCart.getRewardPoint());
		data.put("effectivePrice", currentCart.getEffectivePrice());
		data.put("discount", currentCart.getDiscount());
		return ResponseEntity.ok(data);
	}

	/**
	 * 列表
	 */
	@GetMapping("/list")
	public String list() {
		return "shop/cart/list";
	}

	/**
	 * 修改
	 */
	@PostMapping("/modify")
	public ResponseEntity<?> modify(Long skuId, Integer quantity, @CurrentCart Cart currentCart) {
		Map<String, Object> data = new HashMap<>();
		if (quantity == null || quantity < 1) {
			return Results.UNPROCESSABLE_ENTITY;
		}
		Sku sku = skuService.find(skuId);
		if (sku == null) {
			return Results.unprocessableEntity("shop.cart.skuNotExist");
		}
		if (currentCart == null || currentCart.isEmpty()) {
			return Results.unprocessableEntity("shop.cart.notEmpty");
		}
		if (!currentCart.contains(sku)) {
			return Results.unprocessableEntity("shop.cart.cartItemNotExist");
		}
		if (!sku.getIsActive()) {
			return Results.unprocessableEntity("shop.cart.skuNotActive");
		}
		if (!sku.getIsMarketable()) {
			return Results.unprocessableEntity("shop.cart.skuNotMarketable");
		}
		if (CartItem.MAX_QUANTITY != null && quantity > CartItem.MAX_QUANTITY) {
			return Results.unprocessableEntity("shop.cart.addQuantityNotAllowed", CartItem.MAX_QUANTITY);
		}
		if (quantity > sku.getAvailableStock()) {
			return Results.unprocessableEntity("shop.cart.skuLowStock");
		}
		cartService.modify(currentCart, sku, quantity);

		data.put("quantity", currentCart.getQuantity(false));
		data.put("rewardPoint", currentCart.getRewardPoint());
		data.put("effectivePrice", currentCart.getEffectivePrice());
		data.put("discount", currentCart.getDiscount());

		Map<String, Object> cartItemMap = new HashMap<>();
		CartItem cartItem = currentCart.getCartItem(sku);
		cartItemMap.put("subtotal", cartItem.getSubtotal());
		cartItemMap.put("isLowStock", cartItem.getIsLowStock());
		data.put("cartItem", cartItemMap);

		Store store = sku.getStore();
		Map<String, Object> storeMap = new HashMap<>();
		storeMap.put("giftNames", currentCart.getGiftNames(store));
		storeMap.put("promotionNames", currentCart.getPromotionNames(store));
		data.put("store", storeMap);

		return ResponseEntity.ok(data);
	}

	/**
	 * 移除
	 */
	@PostMapping("/remove")
	public ResponseEntity<?> remove(Long skuId, @CurrentCart Cart currentCart) {
		Map<String, Object> data = new HashMap<>();
		Sku sku = skuService.find(skuId);
		if (sku == null) {
			return Results.unprocessableEntity("shop.cart.skuNotExist");
		}
		if (currentCart == null || currentCart.isEmpty()) {
			return Results.unprocessableEntity("shop.cart.notEmpty");
		}
		if (!currentCart.contains(sku)) {
			return Results.unprocessableEntity("shop.cart.cartItemNotExist");
		}
		Store store = sku.getProduct().getStore();
		cartService.remove(currentCart, sku);

		data.put("quantity", currentCart.getQuantity(false));
		data.put("rewardPoint", currentCart.getRewardPoint());
		data.put("effectivePrice", currentCart.getEffectivePrice());
		data.put("discount", currentCart.getDiscount());

		Map<String, Object> storeMap = new HashMap<>();
		storeMap.put("giftNames", currentCart.getGiftNames(store));
		storeMap.put("promotionNames", currentCart.getPromotionNames(store));
		data.put("store", storeMap);
		return ResponseEntity.ok(data);
	}

	/**
	 * 清空
	 */
	@PostMapping("/clear")
	public ResponseEntity<?> clear(@CurrentCart Cart currentCart) {
		if (currentCart != null) {
			cartService.clear(currentCart);
		}
		return Results.OK;
	}

}