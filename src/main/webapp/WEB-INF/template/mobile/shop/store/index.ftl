<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	[@seo type = "STORE_INDEX"]
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
	<link href="${base}/resources/common/css/jquery.bxslider.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/store.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/bootstrap-growl.js"></script>
	<script src="${base}/resources/common/js/jquery.scrolltofixed.js"></script>
	<script src="${base}/resources/common/js/jquery.lazyload.js"></script>
	<script src="${base}/resources/common/js/jquery.bxslider.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/velocity.js"></script>
	<script src="${base}/resources/common/js/velocity.ui.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/mobile/shop/js/base.js"></script>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
				
				var $storeProductCategory = $("#storeProductCategory");
				var $closeStoreProductCategory = $("#closeStoreProductCategory");
				var $productSearchForm = $("#productSearchForm");
				var $keyword = $("#productSearchForm [name='keyword']");
				var $mainSlider = $("#mainSlider");
				var $showStoreProductCategory = $("#showStoreProductCategory");
				
				// 店铺商品分类
				$closeStoreProductCategory.click(function() {
					$storeProductCategory.velocity("transition.slideRightBigOut").parent().velocity("fadeOut");
				});
				
				// 搜索
				$productSearchForm.submit(function() {
					if ($.trim($keyword.val()) == "") {
						return false;
					}
				});
				
				// 店铺广告图片
				$mainSlider.bxSlider({
					auto: true,
					controls: false
				});
				
				// 店铺商品分类
				$showStoreProductCategory.click(function() {
					$storeProductCategory.velocity("transition.slideRightBigIn").parent().velocity("fadeIn");
				});
			
			});
			</script>
		[/#escape]
	[/#noautoesc]
</head>
<body class="shop store-index">
	[@store_product_category_root_list storeId = store.id]
		[#if storeProductCategories?has_content]
			<div class="store-product-category-wrapper">
				<div id="storeProductCategory" class="store-product-category">
					<div class="store-product-category-content">
						<div class="store-product-category-body">
							[#list storeProductCategories as storeProductCategory]
								<dl class="clearfix">
									<dt>
										<a href="${base}${storeProductCategory.path}" title="${storeProductCategory.name}">${abbreviate(storeProductCategory.name, 15, "...")}</a>
									</dt>
									[@store_product_category_children_list storeProductCategoryId = storeProductCategory.id storeId = store.id recursive = false]
										[#list storeProductCategories as storeProductCategory]
											<dd>
												<a class="text-overflow" href="${base}${storeProductCategory.path}" title="${storeProductCategory.name}">${storeProductCategory.name}</a>
											</dd>
										[/#list]
									[/@store_product_category_children_list]
								</dl>
							[/#list]
						</div>
						<div class="store-product-category-footer">
							<button id="closeStoreProductCategory" class="btn btn-primary btn-lg btn-block" type="button">${message("shop.store.close")}</button>
						</div>
					</div>
				</div>
			</div>
		[/#if]
	[/@store_product_category_root_list]
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
						<input name="storeId" type="hidden" value="${store.id}">
						<div class="input-group">
							<input name="keyword" class="form-control" type="text" placeholder="${message("shop.store.search")}" x-webkit-speech="x-webkit-speech" x-webkit-grammar="builtin:search">
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
		</div>
	</header>
	<main>
		<div class="container-fluid">
			<div class="media">
				<div class="media-left media-middle">
					<img class="media-object img-thumbnail" src="${store.logo!setting.defaultStoreLogo}" alt="${store.name}">
				</div>
				<div class="media-body media-middle">
					<h5 class="media-heading" title="${store.name}">${store.name}</h5>
					[#if store.type == "SELF"]
						<span class="label label-primary">${message("Store.Type.SELF")}</span>
					[/#if]
				</div>
				<div class="media-right media-middle">
					<a id="addStoreFavorite" class="label label-primary" href="javascript:;" data-action="addStoreFavorite" data-store-id="${store.id}">
						<i class="iconfont icon-like"></i>
						${message("shop.store.addStoreFavorite")}
					</a>
				</div>
			</div>
			[@store_ad_image_list storeId = store.id]
				[#if storeAdImages?has_content]
					<ul id="mainSlider">
						[#list storeAdImages as storeAdImage]
							<li>
								[#if storeAdImage.url?has_content]
									<a href="${storeAdImage.url}" title="${storeAdImage.title}">
										<img src="${storeAdImage.image}" alt="${storeAdImage.title}">
									</a>
								[#else]
									<img src="${storeAdImage.image}" alt="${storeAdImage.title}">
								[/#if]
							</li>
						[/#list]
					</ul>
				[/#if]
			[/@store_ad_image_list]
			[@store_product_tag_list storeId = store.id count = 10]
				[#if storeProductTags?has_content]
					[#list storeProductTags as storeProductTag]
						[@product_list storeId = store.id storeProductTagId = storeProductTag.id count = 18]
							[#if products?has_content]
								<div class="featured-product">
									<div class="featured-product-heading">
										<h5>${storeProductTag.name}</h5>
									</div>
									<div class="featured-product-body">
										<ul class="clearfix">
											[#list products as product]
												[#assign defaultSku = product.defaultSku /]
												<li>
													<a href="${base}${product.path}">
														<img class="lazy-load img-responsive center-block" src="${base}/resources/common/images/transparent.png" alt="${product.name}" data-original="${product.thumbnail!setting.defaultThumbnailProductImage}">
													</a>
													<strong>
														[#if product.type == "GENERAL"]
															${currency(defaultSku.price, true)}
														[#elseif product.type == "EXCHANGE"]
															${message("Sku.exchangePoint")}: ${defaultSku.exchangePoint}
														[/#if]
													</strong>
													<a href="${base}${product.path}">
														<h5 class="text-overflow" title="${product.name}">${product.name}</h5>
														[#if product.caption?has_content]
															<h6 class="text-overflow" title="${product.caption}">${product.caption}</h6>
														[/#if]
													</a>
												</li>
											[/#list]
										</ul>
									</div>
								</div>
							[/#if]
						[/@product_list]
					[/#list]
				[/#if]
			[/@store_product_tag_list]
		</div>
	</main>
	<footer class="footer-default" data-spy="scrollToFixed" data-bottom="0">
		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-3">
					<a href="${base}/">
						<i class="iconfont icon-home center-block"></i>
						<span class="center-block">${message("shop.footer.home")}</span>
					</a>
				</div>
				<div class="col-xs-3">
					<a id="showStoreProductCategory" href="javascript:;">
						<i class="iconfont icon-sort center-block"></i>
						<span class="center-block">${message("shop.store.storeProductCategory")}</span>
					</a>
				</div>
				<div class="col-xs-3">
					<a href="${base}/cart/list">
						<i class="iconfont icon-cart center-block"></i>
						<span class="center-block">${message("shop.footer.cart")}</span>
					</a>
				</div>
				<div class="col-xs-3">
					<a href="${base}/member/index">
						<i class="iconfont icon-people center-block"></i>
						<span class="center-block">${message("shop.footer.member")}</span>
					</a>
				</div>
			</div>
		</div>
	</footer>
</body>
</html>