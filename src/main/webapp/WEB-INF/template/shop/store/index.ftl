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
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/jquery.bxslider.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/store.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/bootstrap-growl.js"></script>
	<script src="${base}/resources/common/js/jquery.lazyload.js"></script>
	<script src="${base}/resources/common/js/jquery.bxslider.js"></script>
	<script src="${base}/resources/common/js/jquery.qrcode.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
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
				
				var $productSearchForm = $("#productSearchForm");
				var $keyword = $("#productSearchForm [name='keyword']");
				var $mainSlider = $("#mainSlider");
				
				// 搜索
				$productSearchForm.submit(function() {
					if ($.trim($keyword.val()) == "") {
						return false;
					}
				});
				
				// 店铺广告图片
				$mainSlider.bxSlider({
					mode: "fade",
					auto: true,
					controls: false
				});
			
			});
			</script>
		[/#escape]
	[/#noautoesc]
</head>
<body class="shop store-index">
	[#include "/shop/include/main_header.ftl" /]
	[#include "/shop/include/main_sidebar.ftl" /]
	<main>
		<div class="container">
			<div class="row">
				<div class="col-xs-2">
					[#include "/shop/include/store_summary.ftl" /]
					[#include "/shop/include/store_product_search.ftl" /]
					[#include "/shop/include/store_product_category.ftl" /]
				</div>
				<div class="col-xs-10">
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
								[@product_list storeId = store.id storeProductTagId = storeProductTag.id count = 20]
									[#if products?has_content]
										<div class="hot-product">
											<div class="hot-product-heading">
												<h5>${storeProductTag.name}</h5>
											</div>
											<div class="hot-product-body">
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
			</div>
		</div>
	</main>
	[#include "/shop/include/main_footer.ftl" /]
</body>
</html>