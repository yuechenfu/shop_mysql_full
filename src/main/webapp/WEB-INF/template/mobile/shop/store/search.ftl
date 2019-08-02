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
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
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
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/scrollload.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/mobile/shop/js/base.js"></script>
	<script id="scrollLoadTemplate" type="text/template">
		<%_.each(data, function(store, i) {%>
			<div class="media">
				<div class="media-left media-middle">
					<a href="${base}<%-store.path%>">
						<img class="media-object img-thumbnail center-block" src="<%-store.logo != null ? store.logo : "${setting.defaultStoreLogo}"%>" alt="<%-store.name%>">
					</a>
				</div>
				<div class="media-body media-middle">
					<h5 class="media-heading" title="<%-store.name%>"><%-store.name%></h5>
					<%if (store.type == "SELF") {%>
						<span class="label label-primary">${message("Store.Type.SELF")}</span>
					<%}%>
				</div>
				<div class="media-right media-middle">
					<a class="btn btn-default btn-sm" href="${base}<%-store.path%>">${message("shop.store.inShop")}</a>
				</div>
			</div>
		<%});%>
	</script>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
				
				var $productSearchForm = $("#productSearchForm");
				var $keyword = $("#productSearchForm [name='keyword']");
				var $scrollLoad = $("#scrollLoad");
				var data = {
					keyword: "${storeKeyword}"
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
				
				// 滚动加载
				$scrollLoad.scrollLoad({
					url: "${base}/store/search?pageNumber=<%-pageNumber%>",
					data: function() {
						return data;
					}
				});
			
			});
			</script>
		[/#escape]
	[/#noautoesc]
</head>
<body class="shop store-list">
	<header class="header-default" data-spy="scrollToFixed">
		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-1">
					<a href="javascript:;" data-action="back">
						<i class="iconfont icon-back"></i>
					</a>
				</div>
				<div class="col-xs-10">
					<form id="productSearchForm" action="${base}/store/search" method="get">
						<div class="input-group">
							<input name="keyword" class="form-control" type="text" value="${storeKeyword}" placeholder="${message("shop.store.search")}" x-webkit-speech="x-webkit-speech" x-webkit-grammar="builtin:search">
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
			<div id="scrollLoad" class="list">
				<div id="scrollLoadContent"></div>
			</div>
		</div>
	</main>
</body>
</html>