<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	[@seo type = "ARTICLE_SEARCH"]
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
	<link href="${base}/resources/mobile/shop/css/article.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/bootstrap-growl.js"></script>
	<script src="${base}/resources/common/js/jquery.scrolltofixed.js"></script>
	<script src="${base}/resources/common/js/moment.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/scrollload.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/mobile/shop/js/base.js"></script>
	<script id="scrollLoadTemplate" type="text/template">
		<%_.each(data, function(article, i) {%>
			<li>
				<a href="${base}<%-article.path%>">
					<h5 class="text-overflow" title="<%-article.title%>"><%-article.title%></h5>
					<p class="text-overflow" title="<%-article.text%>"><%-article.text%></p>
					<span class="text-gray" title="<%-moment(new Date(article.createdDate)).format("YYYY-MM-DD HH:mm:ss")%>"><%-moment(new Date(article.createdDate)).format("YYYY-MM-DD")%></span>
				</a>
			</li>
		<%});%>
	</script>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
				
				var $articleSearchForm = $("#articleSearchForm");
				var $keyword = $("#articleSearchForm [name='keyword']");
				var $scrollLoad = $("#scrollLoad");
				var data = {
					keyword: "${articleKeyword}"
				}
				
				// 搜索
				$articleSearchForm.submit(function() {
					if ($.trim($keyword.val()) == "") {
						return false;
					}
					
					data.keyword = $keyword.val();
					$scrollLoad.scrollLoad("refresh");
					return false;
				});
				
				// 滚动加载
				$scrollLoad.scrollLoad({
					url: "${base}/article/search?pageNumber=<%-pageNumber%>",
					data: function() {
						return data;
					}
				});
			
			});
			</script>
		[/#escape]
	[/#noautoesc]
</head>
<body class="shop article-list">
	<header class="header-default" data-spy="scrollToFixed">
		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-1">
					<a href="javascript:;" data-action="back">
						<i class="iconfont icon-back"></i>
					</a>
				</div>
				<div class="col-xs-10">
					<form id="articleSearchForm" action="${base}/article/search" method="get">
						<div class="input-group">
							<input name="keyword" class="form-control" type="text" value="${articleKeyword}" placeholder="${message("shop.article.search")}" x-webkit-speech="x-webkit-speech" x-webkit-grammar="builtin:search">
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
				<ul id="scrollLoadContent"></ul>
			</div>
		</div>
	</main>
</body>
</html>