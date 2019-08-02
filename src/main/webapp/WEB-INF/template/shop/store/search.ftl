<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	[@seo type = "STORE_SEARCH"]
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
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/product.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/store.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/bootstrap-growl.js"></script>
	<script src="${base}/resources/common/js/jquery.lazyload.js"></script>
	<script src="${base}/resources/common/js/jquery.qrcode.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/velocity.js"></script>
	<script src="${base}/resources/common/js/velocity.ui.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/shop/js/base.js"></script>
</head>
<body class="shop store-search">
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
						<li class="active">${message("shop.store.searchPath", storeKeyword)}</li>
					</ol>
					[#if page.content?has_content]
						<form id="storeForm" action="${base}/store/search" method="get">
							<input name="keyword" type="hidden" value="${storeKeyword}">
							<ul class="store-search-item">
								[#list page.content as store]
									<li>
										<div class="row">
											<div class="col-xs-6">
												<div class="media">
													<div class="media-left media-middle">
														<a href="${base}${store.path}" title="${store.name}" target="_blank">
															<img class="img-responsive center-block" src="${store.logo!setting.defaultStoreLogo}" alt="${store.name}">
														</a>
													</div>
													<div class="media-body media-middle">
														<h5 class="media-heading text-overflow">
															<a href="${base}${store.path}" title="${store.name}" target="_blank">${store.name}</a>
														</h5>
														[#if store.productCategories?has_content]
															<p class="text-overflow">
																${message("shop.store.productCategories")}:
																[#list store.productCategories as prouductCategory]
																	<span>${prouductCategory.name}</span>
																[/#list]
															</p>
														[/#if]
														[#if store.introduction?has_content]
															<p class="text-overflow" title="${store.introduction}">${message("shop.store.introduction")}: ${store.introduction}</p>
														[/#if]
													</div>
												</div>
											</div>
											<div class="col-xs-6">
												<ul class="product-thumbnail clearfix">
													[@product_list storeId = store.id count = 4]
														[#if products?has_content]
															[#list products as product]
																<li>
																	<a href="${base}${product.path}" title="${product.name}">
																		<img class="img-responsive center-block" src="${product.thumbnail!setting.defaultThumbnailProductImage}" alt="${product.name}">
																		<p class="text-overflow" title="${product.name}">${product.name}</p>
																	</a>
																</li>
															[/#list]
														[/#if]
													[/@product_list]
												</ul>
											</div>
										</div>
									</li>
								[/#list]
							</ul>
							[@pagination pageNumber = page.pageNumber totalPages = page.totalPages]
								[#if totalPages > 1]
									<div class="text-right">
										[#include "/shop/include/pagination.ftl" /]
									</div>
								[/#if]
							[/@pagination]
						</form>
					[#else]
						<div class="no-result">
							[#noautoesc]${message("shop.store.noSearchResult", storeKeyword?html)}[/#noautoesc]
						</div>
					[/#if]
				</div>
			</div>
		</div>
	</main>
	[#include "/shop/include/main_footer.ftl" /]
</body>
</html>