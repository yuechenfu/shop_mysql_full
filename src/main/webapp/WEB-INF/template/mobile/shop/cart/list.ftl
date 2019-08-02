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
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/cart.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/bootstrap-growl.js"></script>
	<script src="${base}/resources/common/js/jquery.scrolltofixed.js"></script>
	<script src="${base}/resources/common/js/bootbox.js"></script>
	<script src="${base}/resources/common/js/jquery.spinner.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/velocity.js"></script>
	<script src="${base}/resources/common/js/velocity.ui.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/mobile/shop/js/base.js"></script>
	<script id="cartItemGroupFooterTemplate" type="text/template">
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
	</script>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
				
				var $document = $(document);
				var $modify = $("#modify");
				var $spinner = $("[data-trigger='spinner']");
				var $removeCart = $("[data-action='removeCart']");
				var $redirectLogin = $("#redirectLogin");
				var $effectivePrice = $("#effectivePrice");
				var $clear = $("#clear");
				var cartItemGroupFooterTemplate = _.template($("#cartItemGroupFooterTemplate").html());
				
				// 修改
				$modify.click(function() {
					var $element = $(this);
					
					$element.toggleClass("active");
					if ($element.hasClass("active")) {
						$element.text("${message("shop.cart.complete")}");
						$removeCart.add($clear).velocity("fadeIn", {
							display: "block",
							begin: function() {
								$spinner.hide();
							}
						});
					} else {
						$element.text("${message("shop.cart.modify")}");
						$removeCart.add($clear).velocity("fadeOut", {
							complete: function() {
								$spinner.show();
							}
						});
					}
				});
				
				// 修改
				$document.on("success.shopxx.modifyCart", function(event, data) {
					var $element = $(event.target);
					
					if (!data.cartItem.isLowStock) {
						$element.closest(".media").find(".product-image strong").remove();
					}
					
					$element.closest(".cart-item-group").find(".cart-item-group-footer").html(cartItemGroupFooterTemplate(data)).toggle(data.store.promotionNames.length > 0 || data.store.giftNames.length > 0);
					$effectivePrice.text($.currency(data.effectivePrice, true, true));
				});
				
				// 移除
				$document.on("success.shopxx.removeCart", function(event, data) {
					var $element = $(event.target);
					
					$element.closest(".media").velocity("fadeOut", {
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
	<header class="header-default" data-spy="scrollToFixed">
		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-1">
					<a href="javascript:;" data-action="back">
						<i class="iconfont icon-back"></i>
					</a>
				</div>
				<div class="col-xs-10">
					<h5>${message("shop.cart.title")}</h5>
				</div>
				[#if currentCart?? && !currentCart.isEmpty()]
					<div class="col-xs-1">
						<a id="modify" href="javascript:;">${message("shop.cart.modify")}</a>
					</div>
				[/#if]
			</div>
		</div>
	</header>
	<main>
		<div class="container-fluid">
			[#if currentCart?? && !currentCart.isEmpty()]
				[#if !currentUser??]
					<p class="tips">
						<a id="redirectLogin" href="javascript:;">${message("shop.cart.redirectLogin")}</a>
					</p>
				[/#if]
				[#list currentCart.cartItemGroup.entrySet() as entry]
					[#assign store = entry.key /]
					[#assign cartItems = entry.value /]
					<div class="cart-item-group panel panel-default">
						<div class="panel-heading">
							<a href="${base}${store.path}">${store.name}</a>
							[#if store.type == "SELF"]
								<span class="label label-primary">${message("Store.Type.SELF")}</span>
							[/#if]
						</div>
						<div class="panel-body">
							<ul class="media-list">
								[#list cartItems as cartItem]
									<li class="media">
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
											<strong>${currency(cartItem.price, true)}</strong>
										</div>
										<div class="media-right media-middle text-right">
											<div class="spinner input-group input-group-sm" data-trigger="spinner">
												<span class="input-group-addon" data-spin="down">-</span>
												<input class="form-control" type="text" value="${cartItem.quantity}" maxlength="5" data-rule="quantity" data-min="1" data-max="10000" data-action="modifyCart" data-sku-id="${cartItem.sku.id}">
												<span class="input-group-addon" data-spin="up">+</span>
											</div>
											<button class="hidden-element btn btn-default btn-sm" type="button" data-action="removeCart" data-sku-id="${cartItem.sku.id}">${message("common.delete")}</button>
										</div>
									</li>
								[/#list]
							</ul>
						</div>
						<div class="cart-item-group-footer panel-footer[#if !currentCart.getPromotionNames(store)?has_content && !currentCart.getGiftNames(store)?has_content] hidden-element[/#if]">
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
						</div>
					</div>
				[/#list]
			[#else]
				<p class="empty">
					<a href="${base}/">${message("shop.cart.empty")}</a>
				</p>
			[/#if]
		</div>
	</main>
	<footer class="footer-default" data-spy="scrollToFixed" data-bottom="0">
		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-6 text-left">
					[#if currentCart?? && !currentCart.isEmpty()]
						<span>
							${message("shop.cart.effectivePrice")}:
							<strong id="effectivePrice">${currency(currentCart.effectivePrice, true, true)}</strong>
						</span>
					[/#if]
				</div>
				<div class="col-xs-3">
					<button id="clear" class="clear btn btn-orange btn-lg btn-block" type="button" data-action="clearCart">${message("shop.cart.clear")}</button>
				</div>
				<div class="col-xs-3">
					<button class="btn btn-red btn-lg btn-block" type="button" data-action="checkout"[#if !currentCart?? || currentCart.isEmpty()] disabled[/#if]>${message("shop.cart.checkout")}</button>
				</div>
			</div>
		</div>
	</footer>
</body>
</html>