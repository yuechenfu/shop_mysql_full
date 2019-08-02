<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.aftersales.list")} - Powered By SHOP++</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/base.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/aftersales.css" rel="stylesheet">
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
	<script src="${base}/resources/common/js/velocity.js"></script>
	<script src="${base}/resources/common/js/velocity.ui.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/mobile/member/js/base.js"></script>
	<script id="scrollLoadTemplate" type="text/template">
		<%
			function typeText(type) {
				switch (type) {
					case "AFTERSALES_REPAIR":
						return "${message("Aftersales.Type.AFTERSALES_REPAIR")}";
					case "AFTERSALES_REPLACEMENT":
						return "${message("Aftersales.Type.AFTERSALES_REPLACEMENT")}";
					case "AFTERSALES_RETURNS":
						return "${message("Aftersales.Type.AFTERSALES_RETURNS")}";
				}
			}
			
			function statusText(status) {
				switch (status) {
					case "PENDING":
						return "${message("Aftersales.Status.PENDING")}";
					case "APPROVED":
						return "${message("Aftersales.Status.APPROVED")}";
					case "FAILED":
						return "${message("Aftersales.Status.FAILED")}";
					case "COMPLETED":
						return "${message("Aftersales.Status.COMPLETED")}";
					case "CANCELED":
						return "${message("Aftersales.Status.CANCELED")}";
				}
			}
		%>
		<%_.each(data, function(aftersales, i) {%>
			<div class="panel panel-default">
				<div class="panel-heading">
					<span class="text-red"><%-typeText(aftersales.type)%></span>
					<span><%-aftersales.store.name%></span>
					<span title="<%-moment(new Date(aftersales.createdDate)).format("YYYY-MM-DD HH:mm:ss")%>"><%-moment(new Date(aftersales.createdDate)).format("YYYY-MM-DD")%></span>
					<span class="pull-right">
						<% if ( aftersales.status == "PENDING") {%>
							<span class="text-orange"><%-statusText(aftersales.status)%></span>
						<%} else if (aftersales.status == "FAILED") {%>
							<span class="text-red"><%-statusText(aftersales.status)%></span>
						<%} else if (aftersales.status == "CANCELED") {%>
							<span class="text-gray-dark"><%-statusText(aftersales.status)%></span>
						<%} else {%>
							<span class="text-green"><%-statusText(aftersales.status)%></span>
						<%}%>
					</span>
				</div>
				<div class="panel-body">
					<div class="list-group">
						<%_.each(aftersales.aftersalesItems, function(aftersalesItem, i) {%>
							<div class="list-group-item">
								<div class="media">
									<div class="media-left media-middle">
										<img class="media-object img-thumbnail" src="<%-aftersalesItem.orderItem.thumbnail != null ? aftersalesItem.orderItem.thumbnail : "${setting.defaultThumbnailProductImage}"%>" alt="<%-aftersalesItem.orderItem.name%>">
									</div>
									<div class="media-body media-middle">
										<p><%-aftersalesItem.orderItem.name%></p>
										<%if (aftersalesItem.orderItem.specifications.length > 0) {%>
											<span class="small text-gray">[<%-aftersalesItem.orderItem.specifications.join(", ")%>]</span>
										<%}%>
									</div>
									<div class="media-right media-middle text-right">
										<%-$.currency(aftersalesItem.orderItem.price, true)%>
										<span class="text-gray">&times;<%-aftersalesItem.quantity%></span>
									</div>
								</div>
							</div>
						<%});%>
					</div>
				</div>
				<div class="panel-footer text-right">
					<a class="btn btn-default btn-sm" href="view?aftersalesId=<%-aftersales.id%>">${message("common.view")}</a>
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
					<h5>${message("member.aftersales.list")}</h5>
				</div>
			</div>
		</div>
	</header>
	<main>
		<div class="container-fluid">
			<div data-spy="scrollLoad" data-url="${base}/member/aftersales/list?pageNumber=<%-pageNumber%>">
				<div id="scrollLoadContent"></div>
			</div>
		</div>
	</main>
</body>
</html>