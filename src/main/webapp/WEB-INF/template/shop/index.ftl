<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	[@seo type = "INDEX"]
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
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/jquery.bxslider.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/index.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/jquery.lazyload.js"></script>
	<script src="${base}/resources/common/js/jquery.bxslider.js"></script>
	<script src="${base}/resources/common/js/jquery.qrcode.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/velocity.js"></script>
	<script src="${base}/resources/common/js/velocity.ui.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/shop/js/base.js"></script>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
				
				var $window = $(window);
				var $topbar = $("#topbar");
				var $topbarProductSearchForm = $("#topbar form");
				var $topbarProductSearchKeyword = $("#topbar input[name='keyword']");
				var $mainSlider = $("#mainSlider");
				var $sideSlider = $("#sideSlider");
				var $featuredProductSlider = $(".featured-product .slider");
				var topbarHidden = true;
				
				// 顶部栏
				$window.scroll(_.throttle(function() {
					if ($window.scrollTop() > 500) {
						if (topbarHidden) {
							topbarHidden = false;
							$topbar.velocity("transition.slideDownIn", {
								duration: 500
							});
						}
					} else {
						if (!topbarHidden) {
							topbarHidden = true;
							$topbar.velocity("transition.slideUpOut", {
								duration: 500
							});
						}
					}
				}, 500));
				
				// 商品搜索
				$topbarProductSearchForm.submit(function() {
					if ($.trim($topbarProductSearchKeyword.val()) == "") {
						return false;
					}
				});
				
				// 主轮播广告
				$mainSlider.bxSlider({
					mode: "fade",
					auto: true,
					controls: false
				});
				
				// 侧边轮播广告
				$sideSlider.bxSlider({
					pager: false,
					auto: true,
					nextText: "&#xe6a3;",
					prevText: "&#xe679;"
				});
				
				// 推荐商品轮播广告
				$featuredProductSlider.bxSlider({
					pager: false,
					auto: true,
					nextText: "&#xe6a3;",
					prevText: "&#xe679;"
				});
			
			});
			</script>
		[/#escape]
	[/#noautoesc]
</head>
<body class="shop index">
	[#include "/shop/include/main_header.ftl" /]
	[#include "/shop/include/main_sidebar.ftl" /]
	<main>
		<div id="topbar" class="topbar">
			<div class="container">
				<div class="row">
					<div class="col-xs-4">
						<a href="${base}/">
							<img class="logo" src="${setting.logo}" alt="${setting.siteName}">
						</a>
					</div>
					<div class="col-xs-5">
						<div class="product-search">
							<form action="${base}/product/search" method="get">
								<input name="keyword" type="text" placeholder="${message("shop.index.productSearchKeywordPlaceholder")}" autocomplete="off" x-webkit-speech="x-webkit-speech" x-webkit-grammar="builtin:search">
								<button type="submit">
									<i class="iconfont icon-search"></i>
									${message("shop.index.productSearchSubmit")}
								</button>
							</form>
						</div>
					</div>
					<div class="col-xs-3">
						<div class="cart">
							<i class="iconfont icon-cart"></i>
							<a href="${base}/cart/list">${message("shop.index.cart")}</a>
							<em>0</em>
						</div>
					</div>
				</div>
			</div>
		</div>
		[@ad_position id = 2]
			[#if adPosition??]
				[#noautoesc]${adPosition.resolveTemplate()}[/#noautoesc]
			[/#if]
		[/@ad_position]
		<div class="container">
			<div class="row">
				<div class="col-xs-2">
					[@product_category_root_list count = 6]
						<div class="product-category-menu">
							<ul>
								[#list productCategories as productCategory]
									<li>
										[#switch productCategory_index]
											[#case 0]
												<i class="iconfont icon-mobile"></i>
												[#break /]
											[#case 1]
												<i class="iconfont icon-camera"></i>
												[#break /]
											[#case 2]
												<i class="iconfont icon-dress"></i>
												[#break /]
											[#case 3]
												<i class="iconfont icon-choiceness"></i>
												[#break /]
											[#case 4]
												<i class="iconfont icon-present"></i>
												[#break /]
											[#case 5]
												<i class="iconfont icon-evaluate"></i>
												[#break /]
											[#case 6]
												<i class="iconfont icon-favor"></i>
												[#break /]
											[#case 7]
												<i class="iconfont icon-like"></i>
												[#break /]
											[#default]
												<i class="iconfont icon-goodsfavor"></i>
										[/#switch]
										<a href="${base}${productCategory.path}">${productCategory.name}</a>
										[@product_category_children_list productCategoryId = productCategory.id recursive = false count = 4]
											<p>
												[#list productCategories as productCategory]
													<a href="${base}${productCategory.path}">${productCategory.name}</a>
												[/#list]
											</p>
										[/@product_category_children_list]
										[@product_category_children_list productCategoryId = productCategory.id recursive = false count = 8]
											<div class="product-category-menu-content">
												<div class="row">
													<div class="col-xs-9">
														[@promotion_list productCategoryId = productCategory.id hasEnded = false count = 6]
															[#if promotions?has_content]
																<ul class="promotion clearfix">
																	[#list promotions as promotion]
																		<li>
																			<a href="${base}${promotion.path}" title="${promotion.title}">${promotion.name}</a>
																			<i class="iconfont icon-right"></i>
																		</li>
																	[/#list]
																</ul>
															[/#if]
														[/@promotion_list]
														[#list productCategories as productCategory]
															<dl class="product-category clearfix">
																<dt class="text-overflow">
																	<a href="${base}${productCategory.path}" title="${productCategory.name}">${productCategory.name}</a>
																</dt>
																[@product_category_children_list productCategoryId = productCategory.id recursive = false]
																	[#list productCategories as productCategory]
																		<dd>
																			<a href="${base}${productCategory.path}">${productCategory.name}</a>
																		</dd>
																	[/#list]
																[/@product_category_children_list]
															</dl>
														[/#list]
													</div>
													<div class="col-xs-3">
														[@brand_list productCategoryId = productCategory.id type = "IMAGE" count = 10]
															[#if brands?has_content]
																<ul class="brand clearfix">
																	[#list brands as brand]
																		<li>
																			<a href="${base}${brand.path}" title="${brand.name}">
																				<img class="img-responsive center-block" src="${brand.logo}" alt="${brand.name}">
																			</a>
																		</li>
																	[/#list]
																</ul>
															[/#if]
														[/@brand_list]
														[@promotion_list productCategoryId = productCategory.id hasEnded = false count = 2]
															[#if promotions?has_content]
																<ul class="promotion-image">
																	[#list promotions as promotion]
																		<li>
																			[#if promotion.image?has_content]
																				<a href="${base}${promotion.path}" title="${promotion.title}">
																					<img class="img-responsive center-block" src="${promotion.image}" alt="${promotion.title}">
																				</a>
																			[/#if]
																		</li>
																	[/#list]
																</ul>
															[/#if]
														[/@promotion_list]
													</div>
												</div>
											</div>
										[/@product_category_children_list]
									</li>
								[/#list]
							</ul>
						</div>
					[/@product_category_root_list]
				</div>
				<div class="col-xs-2 col-xs-offset-8">
					[@article_category_root_list count = 2]
						[#if articleCategories?has_content]
							<div class="article">
								<ul class="nav nav-pills nav-justified">
									[#list articleCategories as articleCategory]
										<li[#if articleCategory_index == 0] class="active"[/#if]>
											<a href="#articleCategory_${articleCategory.id}" data-toggle="tab">${articleCategory.name}</a>
										</li>
									[/#list]
								</ul>
								<div class="tab-content">
									[#list articleCategories as articleCategory]
										<div id="articleCategory_${articleCategory.id}" class="tab-pane fade[#if articleCategory_index == 0] active in[/#if]">
											[@article_list articleCategoryId = articleCategory.id count = 5]
												<ul>
													[#list articles as article]
														<li class="text-overflow">
															<a href="${base}${article.path}" title="${article.title}" target="_blank">${abbreviate(article.title, 40)}</a>
														</li>
													[/#list]
												</ul>
											[/@article_list]
										</div>
									[/#list]
								</div>
							</div>
						[/#if]
					[/@article_category_root_list]
					[@ad_position id = 3]
						[#if adPosition??]
							[#noautoesc]${adPosition.resolveTemplate()}[/#noautoesc]
						[/#if]
					[/@ad_position]
				</div>
			</div>
			[@ad_position id = 4]
				[#if adPosition??]
					[#noautoesc]${adPosition.resolveTemplate()}[/#noautoesc]
				[/#if]
			[/@ad_position]
			[@ad_position id = 5]
				[#if adPosition??]
					[#noautoesc]${adPosition.resolveTemplate()}[/#noautoesc]
				[/#if]
			[/@ad_position]
			[@product_category_root_list count = 5]
				[#list productCategories as productCategory]
					[@product_list productCategoryId = productCategory.id productTagId = 1 count = 6]
						<div class="featured-product">
							<div class="featured-product-heading">
								<h4>
									${productCategory_index + 1}F
									<strong>${productCategory.name}</strong>
								</h4>
							</div>
							<div class="featured-product-body">
								<div class="row">
									<div class="col-xs-2">
										<div class="ad-product-category-wrapper">
											[#switch productCategory_index]
												[#case 0]
													[#assign featuredProductAdPositionId = 6 /]
													[#break /]
												[#case 1]
													[#assign featuredProductAdPositionId = 8 /]
													[#break /]
												[#case 2]
													[#assign featuredProductAdPositionId = 10 /]
													[#break /]
												[#case 3]
													[#assign featuredProductAdPositionId = 12 /]
													[#break /]
												[#case 4]
													[#assign featuredProductAdPositionId = 14 /]
											[/#switch]
											[@ad_position id = featuredProductAdPositionId]
												[#if adPosition??]
													[#noautoesc]${adPosition.resolveTemplate()}[/#noautoesc]
												[/#if]
											[/@ad_position]
											[@product_category_children_list productCategoryId = productCategory.id recursive = false count = 6]
												[#if productCategories?has_content]
													<ul class="product-category clearfix">
														[#list productCategories as productCategory]
															<li>
																<a href="${base}${productCategory.path}">${productCategory.name}</a>
															</li>
														[/#list]
													</ul>
												[/#if]
											[/@product_category_children_list]
										</div>
									</div>
									<div class="col-xs-4">
										<div class="slider-brand-wrapper">
											[#switch productCategory_index]
												[#case 0]
													[#assign featuredProductSliderAdPositionId = 7 /]
													[#break /]
												[#case 1]
													[#assign featuredProductSliderAdPositionId = 9 /]
													[#break /]
												[#case 2]
													[#assign featuredProductSliderAdPositionId = 11 /]
													[#break /]
												[#case 3]
													[#assign featuredProductSliderAdPositionId = 13 /]
													[#break /]
												[#case 4]
													[#assign featuredProductSliderAdPositionId = 15 /]
											[/#switch]
											[@ad_position id = featuredProductSliderAdPositionId]
												[#if adPosition??]
													[#noautoesc]${adPosition.resolveTemplate()}[/#noautoesc]
												[/#if]
											[/@ad_position]
											[@brand_list productCategoryId = productCategory.id type = "IMAGE" count = 8]
												[#if brands?has_content]
													<ul class="brand clearfix">
														[#list brands as brand]
															<li>
																<a href="${base}${brand.path}" title="${brand.name}">
																	<img class="img-responsive center-block" src="${brand.logo}" alt="${brand.name}">
																</a>
															</li>
														[/#list]
													</ul>
												[/#if]
											[/@brand_list]
										</div>
									</div>
									[#if products?has_content]
										<div class="col-xs-6">
											<ul class="product clearfix">
												[#list products as product]
													<li>
														<a href="${base}${product.path}" target="_blank">
															<img class="lazy-load img-responsive center-block" src="${base}/resources/common/images/transparent.png" alt="${product.name}" data-original="${product.thumbnail!setting.defaultThumbnailProductImage}">
															<h5 class="text-overflow" title="${product.name}">${product.name}</h5>
															[#if product.caption?has_content]
																<h6 class="text-overflow" title="${product.caption}">${product.caption}</h6>
															[/#if]
														</a>
													</li>
												[/#list]
											</ul>
										</div>
									[/#if]
								</div>
							</div>
						</div>
					[/@product_list]
				[/#list]
			[/@product_category_root_list]
			<div class="row">
				[@product_category_root_list count = 3]
					[#list productCategories as productCategory]
						[@product_list productCategoryId = productCategory.id productTagId = 1 count = 5]
							[#if products?has_content]
								<div class="col-xs-4">
									<div class="hot-product ${productCategory?item_parity}">
										<div class="hot-product-heading">${productCategory.name}</div>
										<div class="hot-product-body">
											<ul class="clearfix">
												[#list products as product]
													<li>
														<a href="${base}${product.path}" target="_blank">
															<h5 title="${product.name}">${abbreviate(product.name, 24)}</h5>
															[#if product.caption?has_content]
																<span title="${product.caption}">${abbreviate(product.caption, 24)}</span>
															[/#if]
															<img class="lazy-load img-responsive center-block" src="${base}/resources/common/images/transparent.png" alt="${product.name}" data-original="${product.thumbnail!setting.defaultThumbnailProductImage}">
														</a>
													</li>
												[/#list]
											</ul>
										</div>
									</div>
								</div>
							[/#if]
						[/@product_list]
					[/#list]
				[/@product_category_root_list]
			</div>
			[@ad_position id = 16]
				[#if adPosition??]
					[#noautoesc]${adPosition.resolveTemplate()}[/#noautoesc]
				[/#if]
			[/@ad_position]
			[@friend_link_list type = "IMAGE" count = 10]
				[#if friendLinks?has_content]
					<div class="row">
						<div class="col-xs-12">
							<div class="friend-link">
								<div class="friend-link-heading">${message("shop.index.friendLink")}</div>
								<div class="friend-link-body">
									<ul class="clearfix">
										[#list friendLinks as friendLink]
											<li>
												<a href="${friendLink.url}" title="${friendLink.name}" target="_blank">
													<img class="img-responsive center-block" src="${friendLink.logo}" alt="${friendLink.name}">
												</a>
											</li>
										[/#list]
									</ul>
								</div>
							</div>
						</div>
					</div>
				[/#if]
			[/@friend_link_list]
		</div>
	</main>
	[#include "/shop/include/main_footer.ftl" /]
</body>
</html>