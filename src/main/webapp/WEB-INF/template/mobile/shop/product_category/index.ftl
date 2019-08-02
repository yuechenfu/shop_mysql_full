<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("shop.productCategory.title")}[#if showPowered] - Powered By SHOP++[/#if]</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/product_category.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/bootstrap-growl.js"></script>
	<script src="${base}/resources/common/js/jquery.scrolltofixed.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/iscroll-probe.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/mobile/shop/js/base.js"></script>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			var sidebarScroll;
			var tabContentScroll;
			
			function loaded() {
				sidebarScroll = new IScroll("#sidebarWrapper", {
					scrollbars: true,
					fadeScrollbars: true,
					click: true
				});
				
				tabContentScroll = new IScroll("#tabContentWrapper", {
					scrollbars: true,
					fadeScrollbars: true,
					click: true
				});
			}
			
			document.addEventListener("touchmove", function(event) {
				event.preventDefault();
			}, false);
			
			$().ready(function() {
				
				var $sidebarTabItem = $("#sidebar a[data-toggle='tab']");
				
				// 侧边栏Tab项
				$sidebarTabItem.on("shown.bs.tab", function() {
					tabContentScroll.refresh();
					tabContentScroll.scrollTo(0, 0);
				});
			
			});
			</script>
		[/#escape]
	[/#noautoesc]
</head>
<body class="shop product-category" onload="loaded();">
	<header class="header-default" data-spy="scrollToFixed">
		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-1">
					<a href="javascript:;" data-action="back">
						<i class="iconfont icon-back"></i>
					</a>
				</div>
				<div class="col-xs-10">
					<h5>${message("shop.productCategory.title")}</h5>
				</div>
			</div>
		</div>
	</header>
	<div id="sidebarWrapper" class="sidebar-wrapper">
		<aside id="sidebar" class="sidebar">
			<ul class="nav nav-pills nav-stacked">
				[#list rootProductCategories as rootProductCategory]
					<li[#if rootProductCategory_index == 0] class="active"[/#if]>
						<a class="text-overflow" href="#detail_${rootProductCategory_index}" title="${rootProductCategory.name}" data-toggle="tab">${rootProductCategory.name}</a>
					</li>
				[/#list]
			</ul>
		</aside>
	</div>
	<main>
		<div id="tabContentWrapper" class="tab-content-wrapper">
			<div class="tab-content">
				[#list rootProductCategories as rootProductCategory]
					<div id="detail_${rootProductCategory_index}" class="detail tab-pane fade[#if rootProductCategory_index == 0] in active[/#if]">
						<div class="detail-heading">
							<h5>
								<a href="${base}${rootProductCategory.path}">${rootProductCategory.name}</a>
							</h5>
						</div>
						[#if rootProductCategory.children?has_content]
							<div class="detail-body">
								[#list rootProductCategory.children as productCategory]
									<dl class="clearfix">
										<dt>
											<a href="${base}${productCategory.path}">${productCategory.name}</a>
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
						[/#if]
					</div>
				[/#list]
			</div>
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
					<a class="active" href="${base}/product_category">
						<i class="iconfont icon-sort center-block"></i>
						<span class="center-block">${message("shop.footer.productCategory")}</span>
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