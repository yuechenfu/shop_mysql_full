<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	[@seo type = "PRODUCT_SEARCH"]
		[#if seo.resolveKeywords()?has_content]
			<meta name="keywords" content="${seo.resolveKeywords()}">
		[/#if]
		[#if seo.resolveDescription()?has_content]
			<meta name="description" content="${seo.resolveDescription()}">
		[/#if]
		<title>${seo.resolveTitle()}[#if showPowered] - Powered By SHOP++[/#if]</title>
	[/@seo]
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/product.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/bootstrap-growl.js"></script>
	<script src="${base}/resources/common/js/jquery.scrolltofixed.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/scrollload.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/mobile/shop/js/base.js"></script>
	<script id="scrollLoadTemplate" type="text/template">
		<%_.each(data, function(product, i) {%>
			<li class="list-item">
				<a href="${base}<%-product.path%>">
					<img class="img-responsive center-block" src="<%-product.thumbnail != null ? product.thumbnail : "${setting.defaultThumbnailProductImage}"%>" alt="<%-product.name%>">
				</a>
				<strong>
					<%if (product.type == "GENERAL") {%>
						<%-$.currency(product.defaultSku.price, true)%>
					<%} else if (product.type == "EXCHANGE") {%>
						${message("Sku.exchangePoint")}: <%-product.defaultSku.exchangePoint%>
					<%}%>
				</strong>
				<a href="${base}<%-product.path%>">
					<h5 class="text-overflow" title="<%-product.name%>"><%-product.name%></h5>
					<%if ($.trim(product.caption) != "") {%>
						<h6 class="text-overflow" title="<%-product.caption%>"><%-product.caption%></h6>
					<%}%>
				</a>
				<p>
					<a href="${base}<%-product.store.path%>"><%-product.store.name%></a>
					<%if (product.store.type == "SELF") {%>
						<span class="label label-primary">${message("Store.Type.SELF")}</span>
					<%}%>
				</p>
			</li>
		<%});%>
	</script>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
				
				var $productSearchForm = $("#productSearchForm");
				var $keyword = $("#productSearchForm [name='keyword']");
				var $order = $("#order");
				var $orderType = $("#order a[data-order-type]");
				var $scrollLoad = $("#scrollLoad");
				var data = {
					keyword: "${productKeyword}",
					storeId: ${(store.id)!"null"},
					orderType: null
				}
				
				// 搜索
				$productSearchForm.submit(function() {
					if ($.trim($keyword.val()) == "") {
						return false;
					}
					
					data.keyword = $keyword.val();
					$scrollLoad.scrollLoad("refresh");
					return false;
				});
				
				// 排序
				$orderType.click(function() {
					var $element = $(this);
					if ($element.hasClass("active")) {
						return;
					}
					
					$order.find(".active").removeClass("active");
					$element.addClass("active");
					var $dropdown = $element.closest(".dropdown");
					if ($dropdown.length > 0) {
						$dropdown.find("a[data-toggle='dropdown'] span:not(.caret)").text($element.data("title"));
					}
					
					data.orderType = $element.data("order-type");
					$scrollLoad.scrollLoad("refresh");
				});
				
				// 滚动加载
				$scrollLoad.scrollLoad({
					url: "${base}/product/search?pageNumber=<%-pageNumber%>",
					data: function() {
						return data;
					}
				});
			
			});
			</script>
		[/#escape]
	[/#noautoesc]
</head>
<body class="shop product-list">
	<header class="header-default" data-spy="scrollToFixed">
		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-1">
					<a href="javascript:;" data-action="back">
						<i class="iconfont icon-back"></i>
					</a>
				</div>
				<div class="col-xs-10">
					<form id="productSearchForm" action="${base}/product/search" method="get">
						[#if store??]
							<input name="storeId" type="hidden" value="${store.id}">
						[/#if]
						<div class="input-group">
							<input name="keyword" class="form-control" type="text" value="${productKeyword}" placeholder="${message("shop.product.search")}" x-webkit-speech="x-webkit-speech" x-webkit-grammar="builtin:search">
							<div class="input-group-btn">
								<button class="btn btn-default" type="submit">
									<i class="iconfont icon-search"></i>
								</button>
							</div>
						</div>
					</form>
				</div>
				<div class="col-xs-1">
					<div class="dropdown">
						<a href="javascript:;" data-toggle="dropdown">
							<i class="iconfont icon-sort"></i>
						</a>
						<ul class="dropdown-menu dropdown-menu-right">
							<li>
								<a href="${base}/">
									<i class="iconfont icon-home"></i>
									${message("shop.header.home")}
								</a>
							</li>
							<li>
								<a href="${base}/cart/list">
									<i class="iconfont icon-cart"></i>
									${message("shop.header.cart")}
								</a>
							</li>
							<li>
								<a href="${base}/member/index">
									<i class="iconfont icon-people"></i>
									${message("shop.header.member")}
								</a>
							</li>
						</ul>
					</div>
				</div>
			</div>
			<div id="order" class="order">
				<div class="row">
					<div class="col-xs-3">
						<div class="dropdown">
							<a href="javascript:;" data-toggle="dropdown">
								<span>${message("shop.product.defaultTitle")}</span>
								<span class="caret"></span>
							</a>
							<ul class="dropdown-menu">
								<li>
									<a href="javascript:;" data-order-type="TOP_DESC" data-title="${message("shop.product.defaultTitle")}">${message("shop.product.default")}</a>
								</li>
								<li>
									<a href="javascript:;" data-order-type="PRICE_ASC" data-title="${message("shop.product.priceAscTitle")}">${message("shop.product.priceAsc")}</a>
								</li>
								<li>
									<a href="javascript:;" data-order-type="PRICE_DESC" data-title="${message("shop.product.priceDescTitle")}">${message("shop.product.priceDesc")}</a>
								</li>
							</ul>
						</div>
					</div>
					<div class="col-xs-3">
						<a href="javascript:;" data-order-type="SALES_DESC">
							${message("shop.product.salesDescTitle")}
							<i class="iconfont icon-shuzhixiajiang"></i>
						</a>
					</div>
					<div class="col-xs-3">
						<a href="javascript:;" data-order-type="SCORE_DESC">
							${message("shop.product.scoreDescTitle")}
							<i class="iconfont icon-shuzhixiajiang"></i>
						</a>
					</div>
					<div class="col-xs-3">
						<a class="disabled" href="javascript:;">
							${message("shop.product.filterTitle")}
							<i class="iconfont icon-filter"></i>
						</a>
					</div>
				</div>
			</div>
		</div>
	</header>
	<main>
		<div id="scrollLoad" class="list">
			<ul id="scrollLoadContent" class="clearfix"></ul>
		</div>
	</main>
</body>
</html>