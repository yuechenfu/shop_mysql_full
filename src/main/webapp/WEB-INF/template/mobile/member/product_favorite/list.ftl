<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.productFavorite.list")}[#if showPowered] - Powered By SHOP++[/#if]</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/base.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/bootstrap-growl.js"></script>
	<script src="${base}/resources/common/js/jquery.scrolltofixed.js"></script>
	<script src="${base}/resources/common/js/bootbox.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/scrollload.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/velocity.js"></script>
	<script src="${base}/resources/common/js/velocity.ui.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/mobile/member/js/base.js"></script>
	<script id="scrollLoadTemplate" type="text/template">
		<%_.each(data, function(productFavorite, i) {%>
			<div class="panel panel-default">
				<div class="panel-heading">
					${message("Product.sn")}: <%-productFavorite.product.sn%>
					<%if (!productFavorite.product.isMarketable) {%>
						<span class="pull-right text-orange">${message("member.productFavorite.productNotMarketable")}</span>
					<%} else if (!productFavorite.product.isActive) {%>
						<span class="pull-right text-orange">${message("member.productFavorite.productNotActive")}</span>
					<%}%>
				</div>
				<div class="panel-body">
					<div class="media">
						<div class="media-left media-middle">
							<%if (productFavorite.product.isMarketable && productFavorite.product.isActive) {%>
								<a href="${base}<%-productFavorite.product.path%>" title="<%-productFavorite.product.name%>">
									<img class="media-object img-thumbnail" src="<%-productFavorite.product.thumbnail != null ? productFavorite.product.thumbnail : "${setting.defaultThumbnailProductImage}"%>" alt="<%-productFavorite.product.name%>">
								</a>
							<%} else {%>
								<a href="javascript:;" title="<%-productFavorite.product.name%>">
									<img class="media-object img-thumbnail" src="<%-productFavorite.product.thumbnail != null ? productFavorite.product.thumbnail : "${setting.defaultThumbnailProductImage}"%>" alt="<%-productFavorite.product.name%>">
								</a>
							<%}%>
						</div>
						<div class="media-body media-middle">
							<%if (productFavorite.product.isMarketable && productFavorite.product.isActive) {%>
								<a href="${base}<%-productFavorite.product.path%>"><%-productFavorite.product.name%></a>
							<%} else {%>
								<a href="javascript:;"><%-productFavorite.product.name%></a>
							<%}%>
						</div>
						<div class="media-right media-middle">
							<%-$.currency(productFavorite.product.price, true)%>
						</div>
					</div>
				</div>
				<div class="panel-footer text-right">
					<a class="btn btn-default btn-sm" href="javascript:;" data-action="delete" data-url="${base}/member/product_favorite/delete?productFavoriteId=<%-productFavorite.id%>">${message("common.delete")}</a>
				</div>
			</div>
		<%});%>
	</script>
</head>
<body class="member">
	<header class="header-default" data-spy="scrollToFixed">
		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-1">
					<a href="${base}/member/index">
						<i class="iconfont icon-back"></i>
					</a>
				</div>
				<div class="col-xs-10">
					<h5>${message("member.productFavorite.list")}</h5>
				</div>
			</div>
		</div>
	</header>
	<main>
		<div class="container-fluid">
			<div data-spy="scrollLoad" data-url="${base}/member/product_favorite/list?pageNumber=<%-pageNumber%>">
				<div id="scrollLoadContent"></div>
			</div>
		</div>
	</main>
</body>
</html>