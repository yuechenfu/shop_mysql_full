<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("shop.cart.title")}[#if showPowered] - Powered By SHOP++[/#if]</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/bootstrap-spinner.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/cart.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/bootstrap-growl.js"></script>
	<script src="${base}/resources/common/js/bootbox.js"></script>
	<script src="${base}/resources/common/js/jquery.spinner.js"></script>
	<script src="${base}/resources/common/js/jquery.qrcode.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/velocity.js"></script>
	<script src="${base}/resources/common/js/velocity.ui.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/shop/js/base.js"></script>
	<script id="cartItemGroupFooterTemplate" type="text/template">
		<td colspan="5">
			<%if (!_.isEmpty(store.promotionNames)) {%>
				<dl class="clearfix">
					<dt>${message("shop.cart.promotion")}</dt>
					<%_.each(store.promotionNames, function(promotionName, i) {%>
						<dd class="text-overflow" title="<%-promotionName%>"><%-promotionName%></dd>
					<%});%>
				</dl>
			<%}%>
			<%if (!_.isEmpty(store.giftNames)) {%>
				<dl class="clearfix">
					<dt>${message("shop.cart.gift")}</dt>
					<%_.each(store.giftNames, function(giftName, i) {%>
						<dd class="text-overflow" title="<%-giftName%>"><%-giftName%></dd>
					<%});%>
				</dl>
			<%}%>
		</td>
	</script>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
				
				var $document = $(document);
				var $clear = $("#clear");
				var $redirectLogin = $("#redirectLogin");
				var $rewardPoint = $("#rewardPoint");
				var $discount = $("#discount");
				var $effectivePrice = $("#effectivePrice");
				var cartItemGroupFooterTemplate = _.template($("#cartItemGroupFooterTemplate").html());
				
				// 修改
				$document.on("success.shopxx.modifyCart", function(event, data) {
					var $element = $(event.target);
					
					if (!data.cartItem.isLowStock) {
						$element.closest("tr").find(".product-image strong").remove();
					}
					
					$element.closest("tr").find(".subtotal").text($.currency(data.cartItem.subtotal, true));
					$element.closest(".cart-item-group").find(".cart-item-group-footer").html(cartItemGroupFooterTemplate(data)).toggle(data.store.promotionNames.length > 0 || data.store.giftNames.length > 0);
					$rewardPoint.text(data.rewardPoint).closest("span").toggle(data.rewardPoint > 0);
					$discount.text($.currency(data.discount, true, true)).closest("span").toggle(data.discount > 0);
					$effectivePrice.text($.currency(data.effectivePrice, true, true));
				});
				
				// 移除
				$document.on("success.shopxx.removeCart", function(event, data) {
					var $element = $(event.target);
					
					$element.closest("tr").velocity("fadeOut", {
						complete: function() {
							var $cartItemGroup = $element.closest(".cart-item-group");
							
							$(this).remove();
							if ($cartItemGroup.find("[data-action='removeCart']").length < 1) {
								$cartItemGroup.remove();
							}
							if ($("[data-action='removeCart']").length < 1) {
								location.reload(true);
							}
							
							$cartItemGroup.find(".cart-item-group-footer").html(cartItemGroupFooterTemplate(data)).toggle(data.store.promotionNames.length > 0 || data.store.giftNames.length > 0);
							$rewardPoint.text(data.rewardPoint).closest("span").toggle(data.rewardPoint > 0);
							$discount.text($.currency(data.discount, true, true)).closest("span").toggle(data.discount > 0);
							$effectivePrice.text($.currency(data.effectivePrice, true, true));
						}
					});
				});
				
				// 清空
				$document.on("success.shopxx.clearCart", function() {
					location.reload(true);
				});
				
				// 重定向登录页面
				$redirectLogin.click(function() {
					$.redirectLogin({
						redirectUrl: Url.getLocation()
					});
				});
				
			});
			</script>
		[/#escape]
	[/#noautoesc]
</head>
<body class="shop cart-list">
	[#include "/shop/include/main_header.ftl" /]
	[#include "/shop/include/main_sidebar.ftl" /]
	<main>
		<div class="container">
			[#if currentCart?? && !currentCart.isEmpty()]
				<table>
					<thead>
						<tr>
							<th width="800">${message("shop.cart.sku")}</th>
							<th>${message("CartItem.price")}</th>
							<th>${message("CartItem.quantity")}</th>
							<th width="150">${message("CartItem.subtotal")}</th>
							<th>${message("common.action")}</th>
						</tr>
					</thead>
					[#list currentCart.cartItemGroup.entrySet() as entry]
						[#assign store = entry.key /]
						[#assign cartItems = entry.value /]
						<tbody class="cart-item-group">
							<tr class="cart-item-group-heading">
								<td colspan="5">
									<a href="${base}${store.path}" target="_blank">${store.name}</a>
									[#if store.type == "SELF"]
										<span class="label label-primary">${message("Store.Type.SELF")}</span>
									[/#if]
								</td>
							</tr>
							[#list cartItems as cartItem]
								<tr>
									<td>
										<div class="media">
											<div class="media-left media-middle">
												<a class="product-image" href="${base}${cartItem.sku.path}" title="${cartItem.sku.name}">
													<img class="media-object img-thumbnail" src="${cartItem.sku.thumbnail!setting.defaultThumbnailProductImage}" alt="${cartItem.sku.name}">
													[#if !cartItem.isMarketable]
														<strong>${message("shop.cart.notMarketable")}</strong>
													[#elseif cartItem.isLowStock]
														<strong>${message("shop.cart.lowStock")}</strong>
													[#elseif !store.isEnabled]
														<strong>${message("shop.cart.notActive")}</strong>
													[/#if]
												</a>
											</div>
											<div class="media-body media-middle">
												<h5 class="media-heading">
													<a href="${base}${cartItem.sku.path}" title="${cartItem.sku.name}">${cartItem.sku.name}</a>
												</h5>
												[#if cartItem.sku.specifications?has_content]
													<span class="small text-gray">[${cartItem.sku.specifications?join(", ")}]</span>
												[/#if]
											</div>
										</div>
									</td>
									<td>${currency(cartItem.price, true)}</td>
									<td>
										<div class="spinner input-group input-group-sm" data-trigger="spinner">
											<input class="form-control" type="text" value="${cartItem.quantity}" maxlength="5" data-rule="quantity" data-min="1" data-max="10000" data-action="modifyCart" data-sku-id="${cartItem.sku.id}">
											<span class="input-group-addon">
												<a class="spin-up" href="javascript:;" data-spin="up">
													<i class="fa fa-caret-up"></i>
												</a>
												<a class="spin-down" href="javascript:;" data-spin="down">
													<i class="fa fa-caret-down"></i>
												</a>
											</span>
										</div>
									</td>
									<td>
										<strong class="subtotal">${currency(cartItem.subtotal, true)}</strong>
									</td>
									<td>
										<a href="javascript:;" data-action="removeCart" data-sku-id="${cartItem.sku.id}">${message("common.delete")}</a>
									</td>
								</tr>
							[/#list]
							<tr class="cart-item-group-footer[#if !currentCart.getPromotionNames(store)?has_content && !currentCart.getGiftNames(store)?has_content] hidden-element[/#if]">
								<td colspan="5">
									[#if currentCart.getPromotionNames(store)?has_content]
										<dl class="clearfix">
											<dt>${message("shop.cart.promotion")}</dt>
											[#list currentCart.getPromotionNames(store) as promotionName]
												<dd class="text-overflow" title="${promotionName}">${promotionName}</dd>
											[/#list]
										</dl>
									[/#if]
									[#if currentCart.getGiftNames(store)?has_content]
										<dl class="clearfix">
											<dt>${message("shop.cart.gift")}</dt>
											[#list currentCart.getGiftNames(store) as giftName]
												<dd class="text-overflow" title="${giftName}">${giftName}</dd>
											[/#list]
										</dl>
									[/#if]
								</td>
							</tr>
						</tbody>
					[/#list]
				</table>
				<div class="bar">
					<div class="row">
						<div class="col-xs-1">
							<a id="clear" class="clear" href="javascript:;" data-action="clearCart">${message("shop.cart.clear")}</a>
						</div>
						<div class="col-xs-10 text-right">
							[#if !currentUser??]
								<a id="redirectLogin" class="redirect-login" href="javascript:;">${message("shop.cart.redirectLogin")}</a>
							[/#if]
							<span[#if currentCart.rewardPoint <= 0] class="hidden-element"[/#if]>
								${message("shop.cart.rewardPoint")}:
								<strong id="rewardPoint">${currentCart.rewardPoint}</strong>
							</span>
							<span[#if currentCart.discount <= 0] class="hidden-element"[/#if]>
								${message("shop.cart.discount")}:
								<strong id="discount">${currency(currentCart.discount, true, true)}</strong>
							</span>
							<span>
								${message("shop.cart.effectivePrice")}:
								<strong id="effectivePrice">${currency(currentCart.effectivePrice, true, true)}</strong>
							</span>
						</div>
						<div class="col-xs-1">
							<button class="btn btn-primary btn-lg btn-block" type="button" data-action="checkout">${message("shop.cart.checkout")}</button>
						</div>
					</div>
				</div>
			[#else]
				<p class="empty">
					<a href="${base}/">${message("shop.cart.empty")}</a>
				</p>
			[/#if]
		</div>
	</main>
	[#include "/shop/include/main_footer.ftl" /]
</body>
</html>