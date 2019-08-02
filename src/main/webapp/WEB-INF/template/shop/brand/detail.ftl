<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	[@seo type = "BRAND_DETAIL"]
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
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/product.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/brand.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/jquery.lazyload.js"></script>
	<script src="${base}/resources/common/js/jquery.qrcode.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/velocity.js"></script>
	<script src="${base}/resources/common/js/velocity.ui.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/shop/js/base.js"></script>
</head>
<body class="shop brand-detail">
	[#include "/shop/include/main_header.ftl" /]
	[#include "/shop/include/main_sidebar.ftl" /]
	<main>
		<div class="container">
			<div class="row">
				<div class="col-xs-2">
					[#include "/shop/include/featured_product.ftl" /]
				</div>
				<div class="col-xs-10">
					<ol class="breadcrumb">
						<li>
							<a href="${base}/">
								<i class="iconfont icon-homefill"></i>
								${message("common.breadcrumb.index")}
							</a>
						</li>
						<li>
							<a href="${base}/brand/list/1">${message("shop.brand.title")}</a>
						</li>
						<li class="active">${brand.name}</li>
					</ol>
					<div class="detail">
						<div class="media">
							[#if brand.type == "IMAGE"]
								<div class="media-left media-middle">
									<a href="${brand.url}" target="_blank">
										<img src="${brand.logo}" alt="${brand.name}">
									</a>
								</div>
							[/#if]
							<div class="media-body media-middle">
								<h5 class="media-heading" title="${brand.name}">${brand.name}</h5>
								[#if brand.url?has_content]
									<a href="${brand.url}" target="_blank">${brand.url}</a>
								[/#if]
							</div>
						</div>
						[#if brand.introduction?has_content]
							[#noautoesc]
								<div class="brand-introduction">${brand.introduction}</div>
							[/#noautoesc]
						[/#if]
						[@product_list brandId = brand.id count = 10]
							[#if products?has_content]
								<div class="related-product">
									<div class="related-product-heading">
										<h5>${message("shop.brand.relatedProduct")}</h5>
									</div>
									<div class="related-product-body">
										<ul class="clearfix">
											[#list products as product]
												<li>
													<a href="${base}${product.path}" target="_blank">
														<img class="lazy-load img-responsive center-block" src="${base}/resources/common/images/transparent.png" alt="${product.name}" data-original="${product.thumbnail!setting.defaultThumbnailProductImage}">
													</a>
													<strong>
														[#if product.type == "GENERAL"]
															${currency(product.price, true)}
															[#if setting.isShowMarketPrice]
																<del>${currency(product.marketPrice, true)}</del>
															[/#if]
														[#elseif product.type == "EXCHANGE"]
															${message("Sku.exchangePoint")}: ${product.exchangePoint}
														[/#if]
													</strong>
													<a href="${base}${product.path}" target="_blank">
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
					</div>
				</div>
			</div>
		</div>
	</main>
	[#include "/shop/include/main_footer.ftl" /]
</body>
</html>