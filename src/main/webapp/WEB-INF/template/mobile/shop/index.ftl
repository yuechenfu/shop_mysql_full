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
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/jquery.bxslider.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/index.css" rel="stylesheet">
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
	<script id="memberInfoTemplate" type="text/template">
		<%if (currentUser != null && currentUser.type == "member") {%>
			<a href="${base}/member/index">
				<i class="iconfont icon-people"></i>
			</a>
		<%} else {%>
			<a href="${base}/member/login">${message("shop.index.login")}</a>
		<%}%>
	</script>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
				
				var $searchIcon = $("#searchIcon");
				var $searchPlaceholder = $("#searchPlaceholder");
				var $memberInfo = $("#memberInfo");
				var $search = $("#search");
				var $searchCollapse = $("#searchCollapse");
				var $searchForm = $("#searchForm");
				var $searchType = $("#searchForm [data-search-type]");
				var $keyword = $("#searchForm [name='keyword']");
				var $mainSlider = $("#mainSlider");
				var memberInfoTemplate = _.template($("#memberInfoTemplate").html());
				
				// 会员信息
				$memberInfo.html(memberInfoTemplate({
					currentUser: $.getCurrentUser()
				}));
				
				// 搜索
				$searchIcon.add($searchPlaceholder).click(function() {
					$search.velocity("transition.slideDownBigIn");
				});
				
				// 搜索
				$searchCollapse.click(function() {
					$search.velocity("transition.slideUpBigOut");
				});
				
				// 搜索
				$searchForm.submit(function() {
					if ($.trim($keyword.val()) == "") {
						return false;
					}
				});
				
				// 搜索类型
				$searchType.click(function() {
					var $element = $(this);
					var searchType = $element.data("search-type");
					
					$element.closest("div.input-group").find("[data-toggle='dropdown'] span:not(.caret)").text($element.text());
					
					switch (searchType) {
						case "product":
							$searchForm.attr("action", "${base}/product/search");
							break;
						case "store":
							$searchForm.attr("action", "${base}/store/search");
							break;
					}
				});
				
				// 主轮播广告
				$mainSlider.bxSlider({
					auto: true,
					controls: false
				});
			
			});
			</script>
		[/#escape]
	[/#noautoesc]
</head>
<body class="shop index">
	<header>
		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-2">
					<i id="searchIcon" class="iconfont icon-similar"></i>
				</div>
				<div class="col-xs-8">
					<div id="searchPlaceholder" class="search-placeholder">
						${message("shop.index.productSearchKeywordPlaceholder")}
						<i class="iconfont icon-search"></i>
					</div>
				</div>
				<div class="col-xs-2">
					<div id="memberInfo" class="member-info"></div>
				</div>
			</div>
			<div id="search" class="search">
				<div class="row">
					<div class="col-xs-1">
						<i id="searchCollapse" class="iconfont icon-fold"></i>
					</div>
					<div class="col-xs-10">
						<form id="searchForm" action="${base}/product/search" method="get">
							<div class="input-group">
								<div class="input-group-btn">
									<button class="btn btn-default" type="button" data-toggle="dropdown">
										<span>${message("shop.index.product")}</span>
										<span class="caret"></span>
									</button>
									<ul class="dropdown-menu">
										<li data-search-type="product">
											<a href="javascript:;">${message("shop.index.product")}</a>
										</li>
										<li data-search-type="store">
											<a href="javascript:;">${message("shop.index.store")}</a>
										</li>
									</ul>
								</div>
								<input name="keyword" class="form-control" type="text" placeholder="${message("shop.index.productSearchSubmit")}" x-webkit-speech="x-webkit-speech" x-webkit-grammar="builtin:search">
								<div class="input-group-btn">
									<button class="btn btn-default" type="submit">
										<i class="iconfont icon-search"></i>
									</button>
								</div>
							</div>
						</form>
					</div>
				</div>
				[#if setting.hotSearches?has_content]
					<dl class="hot-search clearfix">
						<dt>${message("shop.index.hotSearch")}</dt>
						[#list setting.hotSearches as hotSearch]
							<dd>
								<a href="${base}/product/search?keyword=${hotSearch?url}">${hotSearch}</a>
							</dd>
						[/#list]
					</dl>
				[/#if]
			</div>
		</div>
	</header>
	<main>
		<div class="container-fluid">
			[@ad_position id = 18]
				[#if adPosition??]
					[#noautoesc]${adPosition.resolveTemplate()}[/#noautoesc]
				[/#if]
			[/@ad_position]
			[@navigation_list navigationGroupId = 4 count = 8]
				[#if navigations?has_content]
					<nav class="clearfix">
						[#list navigations as navigation]
							<a href="${navigation.url}">
								[#switch navigation_index]
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
								${navigation.name}
							</a>
						[/#list]
					</nav>
				[/#if]
			[/@navigation_list]
			[@ad_position id = 19]
				[#if adPosition??]
					[#noautoesc]${adPosition.resolveTemplate()}[/#noautoesc]
				[/#if]
			[/@ad_position]
			[@ad_position id = 20]
				[#if adPosition??]
					[#noautoesc]${adPosition.resolveTemplate()}[/#noautoesc]
				[/#if]
			[/@ad_position]
			[@product_category_root_list count = 5]
				[#list productCategories as productCategory]
					[@product_list productCategoryId = productCategory.id productTagId = 1 count = 6]
						[#if products?has_content]
							<div class="featured-product">
								<div class="featured-product-heading">
									<h5>${productCategory.name}</h5>
								</div>
								<div class="featured-product-body">
									<ul class="clearfix">
										[#list products as product]
											<li>
												<a href="${base}${product.path}">
													<img class="lazy-load img-responsive center-block" src="${base}/resources/common/images/transparent.png" alt="${product.name}" data-original="${product.thumbnail!setting.defaultThumbnailProductImage}">
												</a>
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
			[/@product_category_root_list]
		</div>
	</main>
	<footer class="footer-default" data-spy="scrollToFixed" data-bottom="0">
		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-3">
					<a class="active" href="${base}/">
						<i class="iconfont icon-home center-block"></i>
						<span class="center-block">${message("shop.footer.home")}</span>
					</a>
				</div>
				<div class="col-xs-3">
					<a href="${base}/product_category">
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