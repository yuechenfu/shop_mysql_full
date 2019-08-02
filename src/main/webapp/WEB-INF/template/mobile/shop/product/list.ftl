<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	[#if productCategory??]
		[@seo type = "PRODUCT_LIST"]
			[#if productCategory.seoKeywords?has_content]
				<meta name="keywords" content="${productCategory.seoKeywords}">
			[#elseif seo.resolveKeywords()?has_content]
				<meta name="keywords" content="${seo.resolveKeywords()}">
			[/#if]
			[#if productCategory.seoDescription?has_content]
				<meta name="description" content="${productCategory.seoDescription}">
			[#elseif seo.resolveDescription()?has_content]
				<meta name="description" content="${seo.resolveDescription()}">
			[/#if]
			<title>[#if productCategory.seoTitle?has_content]${productCategory.seoTitle}[#else]${seo.resolveTitle()}[/#if][#if showPowered] - Powered By SHOP++[/#if]</title>
		[/@seo]
	[#else]
		<title>${message("shop.product.list")}[#if showPowered] - Powered By SHOP++[/#if]</title>
	[/#if]
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
	<script src="${base}/resources/common/js/velocity.js"></script>
	<script src="${base}/resources/common/js/velocity.ui.js"></script>
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
				
				var $filter = $("#filter");
				var $filterBrand = $("#filter a.brand");
				var $filterAttribute = $("#filter a.attribute");
				var $filterComplete = $("#filter button.filter-complete");
				var $productSearchForm = $("#productSearchForm");
				var $keyword = $("#productSearchForm [name='keyword']");
				var $order = $("#order");
				var $orderType = $("#order a[data-order-type]");
				var $filterButton = $("#filterButton");
				var $scrollLoad = $("#scrollLoad");
				var data = {
					type: "${(type)!(null)}",
					productCategoryId: ${(productCategory.id)!"null"},
					storeProductCategoryId: ${(storeProductCategory.id)!"null"},
					brandId: ${(brand.id)!"null"},
					promotionId: ${(promotion.id)!"null"},
					orderType: null
				}
				
				// 搜索
				$productSearchForm.submit(function() {
					if ($.trim($keyword.val()) == "") {
						return false;
					}
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
				
				// 筛选
				$filterButton.click(function() {
					var $element = $(this);
					if ($element.hasClass("disabled")) {
						return;
					}
					$filter.velocity("transition.slideRightBigIn").parent().velocity("fadeIn");
				});
				
				// 筛选
				$filterComplete.click(function() {
					$filter.velocity("transition.slideRightBigOut").parent().velocity("fadeOut");
				});
				
				// 筛选品牌
				$filterBrand.click(function() {
					var $element = $(this);
					
					if ($element.hasClass("active")) {
						$element.removeClass("active");
						data.brandId = null;
					} else {
						$element.addClass("active").parent().siblings("dd").find("a.active").removeClass("active");
						data.brandId = $element.data("brand-id");
					}
					
					$scrollLoad.scrollLoad("refresh");
					return false;
				});
				
				// 筛选属性
				$filterAttribute.click(function() {
					var $element = $(this);
					var attributeName = $element.data("attribute-name");
					var attributeOption = $element.data("attribute-option");
					
					if ($element.hasClass("active")) {
						$element.removeClass("active");
						data[attributeName] = null;
					} else {
						$element.addClass("active").parent().siblings("dd").find("a.active").removeClass("active");
						data[attributeName] = attributeOption;
					}
					
					$scrollLoad.scrollLoad("refresh");
					return false;
				});
				
				// 滚动加载
				$scrollLoad.scrollLoad({
					url: "${base}/product/list?pageNumber=<%-pageNumber%>",
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
	[#if productCategory??]
		[@product_category_children_list productCategoryId = productCategory.id recursive = false]
			[#assign filterProductCategories = productCategories /]
		[/@product_category_children_list]
		[@brand_list productCategoryId = productCategory.id]
			[#assign filterBrands = brands /]
		[/@brand_list]
		[@attribute_list productCategoryId = productCategory.id]
			[#assign filterAttributes = attributes /]
		[/@attribute_list]
		<div class="filter-wrapper">
			<div id="filter" class="filter">
				<div class="filter-content">
					<div class="filter-body">
						[#if filterProductCategories?has_content]
							<dl class="clearfix">
								<dt>${message("shop.product.productCategory")}</dt>
								[#list filterProductCategories as filterProductCategory]
									<dd>
										<a class="text-overflow" href="${base}${filterProductCategory.path}" title="${filterProductCategory.name}">${filterProductCategory.name}</a>
									</dd>
								[/#list]
							</dl>
						[/#if]
						[#if filterBrands?has_content]
							<dl class="clearfix">
								<dt>${message("shop.product.brand")}</dt>
								[#list filterBrands as filterBrand]
									<dd>
										<a class="brand[#if filterBrand == brand] active[/#if]" href="javascript:;" data-brand-id="${filterBrand.id}">${filterBrand.name}</a>
									</dd>
								[/#list]
							</dl>
						[/#if]
						[#list filterAttributes as filterAttribute]
							<dl class="clearfix">
								<dt>
									<span title="${filterAttribute.name}">${abbreviate(filterAttribute.name, 12, "...")}</span>
								</dt>
								[#list filterAttribute.options as option]
									<dd>
										<a class="attribute[#if attributeValueMap.get(filterAttribute) == option] active[/#if]" href="javascript:;" data-attribute-name="attribute_${filterAttribute.id}" data-attribute-option="${option}">${option}</a>
									</dd>
								[/#list]
							</dl>
						[/#list]
					</div>
					<div class="filter-footer">
						<button class="filter-complete btn btn-primary btn-lg btn-block" type="button">${message("shop.product.complete")}</button>
					</div>
				</div>
			</div>
		</div>
	[/#if]
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
						[#if storeProductCategory??]
							<input name="storeId" type="hidden" value="${storeProductCategory.store.id}">
						[/#if]
						<div class="input-group">
							<input name="keyword" class="form-control" type="text" placeholder="${message("shop.product.search")}" x-webkit-speech="x-webkit-speech" x-webkit-grammar="builtin:search">
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
						<a id="filterButton"[#if !filterProductCategories?has_content && !filterBrands?has_content && !filterAttributes?has_content] class="disabled"[/#if] href="javascript:;">
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