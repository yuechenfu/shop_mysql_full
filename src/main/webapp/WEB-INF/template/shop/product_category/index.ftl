<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("shop.productCategory.title")} - Powered By SHOP++</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/product_category.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/bootstrap-growl.js"></script>
	<script src="${base}/resources/common/js/jquery.lazyload.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
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
			
				var $body = $("body");
				var $sidebar = $("#sidebar");
				var $sidebarNavItem = $("#sidebar .nav li a");
				
				// 侧边栏
				$sidebar.affix({
					offset: {
						top: function() {
							return $sidebar.parent().offset().top - 15;
						}
					}
				});
				
				// 侧边栏导航
				$sidebarNavItem.click(function() {
					var $element = $(this);
					var $target = $($element.attr("href"));
					
					$body.velocity("stop").velocity("scroll", {
						duration: 500,
						offset: $target.offset().top
					});
					return false;
				});
			
			});
			</script>
		[/#escape]
	[/#noautoesc]
</head>
<body class="shop product-category" data-spy="scroll" data-target="#sidebar">
	[#include "/shop/include/main_header.ftl" /]
	[#include "/shop/include/main_sidebar.ftl" /]
	<main>
		<div class="container">
			<div class="row">
				<div class="col-xs-2">
					<div id="sidebar" class="sidebar">
						<ul class="nav">
							[#list rootProductCategories as rootProductCategory]
								<li>
									<a href="#productCategory_${rootProductCategory_index}">
										[#switch rootProductCategory_index]
											[#case 0]
												<i class="iconfont icon-mobile text-blue"></i>
												[#break /]
											[#case 1]
												<i class="iconfont icon-camera text-purple"></i>
												[#break /]
											[#case 2]
												<i class="iconfont icon-dress text-orange"></i>
												[#break /]
											[#case 3]
												<i class="iconfont icon-choiceness text-green"></i>
												[#break /]
											[#case 4]
												<i class="iconfont icon-present text-yellow"></i>
												[#break /]
											[#case 5]
												<i class="iconfont icon-evaluate text-pink"></i>
												[#break /]
											[#case 6]
												<i class="iconfont icon-favor text-red"></i>
												[#break /]
											[#case 7]
												<i class="iconfont icon-like text-cyan"></i>
												[#break /]
											[#default]
												<i class="iconfont icon-goodsfavor text-blue"></i>
										[/#switch]
										${rootProductCategory.name}
									</a>
								</li>
							[/#list]
						</ul>
					</div>
				</div>
				<div class="col-xs-10">
					<ol class="breadcrumb">
						<li>
							<a href="${base}/">
								<i class="iconfont icon-homefill"></i>
								${message("common.breadcrumb.index")}
							</a>
						</li>
						<li class="active">${message("shop.productCategory.title")}</li>
					</ol>
					[#list rootProductCategories as rootProductCategory]
						<div id="productCategory_${rootProductCategory_index}" class="panel panel-default">
							<div class="panel-heading">
								<h5>
									<a class="text-red" href="${base}${rootProductCategory.path}" target="_blank">${rootProductCategory.name}</a>
								</h5>
							</div>
							<div class="panel-body">
								[#if rootProductCategory.children?has_content]
									<div class="child-category">
										[#list rootProductCategory.children as productCategory]
											<dl class="dl-horizontal clearfix">
												<dt>
													<a class="text-red-light" href="${base}${productCategory.path}" target="_blank">
														${productCategory.name}
														<i class="iconfont icon-right"></i>
													</a>
												</dt>
												[@product_category_children_list productCategoryId = productCategory.id recursive = false]
													[#if productCategories?has_content]
														<dd>
															<ul class="clearfix">
																[#list productCategories as productCategory]
																	<li>
																		<a href="${base}${productCategory.path}" target="_blank">${productCategory.name}</a>
																	</li>
																[/#list]
															</ul>
														</dd>
													[/#if]
												[/@product_category_children_list]
											</dl>
										[/#list]
									</div>
								[/#if]
								[@product_list productCategoryId = rootProductCategory.id recursive = false count = 5]
									[#if products?has_content]
										<div class="related-product">
											<div class="related-product-heading">
												<h5>${message("shop.productCategory.relatedProduct")}</h5>
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
					[/#list]
				</div>
			</div>
		</div>
	</main>
	[#include "/shop/include/main_footer.ftl" /]
</body>
</html>