<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.couponCode.list")}[#if showPowered] - Powered By SHOP++[/#if]</title>
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
	<script src="${base}/resources/common/js/moment.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/scrollload.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/mobile/member/js/base.js"></script>
	<script id="scrollLoadTemplate" type="text/template">
		<%_.each(data, function(couponCode, i) {%>
			<div class="panel panel-default">
				<div class="panel-heading clearfix">
					<h5><%-couponCode.coupon.store.name%></h5>
					<span class="pull-right"><%-couponCode.coupon.name%></span>
				</div>
				<div class="panel-body">
					<div class="list-group small">
						<div class="list-group-item">
							${message("CouponCode.code")}
							<span class="pull-right"><%-couponCode.code%></span>
						</div>
						<div class="list-group-item">
							${message("CouponCode.usedDate")}
							<%if (couponCode.usedDate) {%>
								<span class="pull-right" title="<%-moment(new Date(couponCode.usedDate)).format("YYYY-MM-DD HH:mm:ss")%>"><%-moment(new Date(couponCode.usedDate)).format("YYYY-MM-DD")%></span>
							<%} else {%>
								<span class="pull-right">-</span>
							<%}%>
						</div>
						<div class="list-group-item">
							${message("member.couponCode.expire")}
							<%if (couponCode.coupon.endDate) {%>
								<span class="pull-right" title="<%-moment(new Date(couponCode.coupon.endDate)).format("YYYY-MM-DD HH:mm:ss")%>"><%-moment(new Date(couponCode.coupon.endDate)).format("YYYY-MM-DD")%></span>
							<%} else {%>
								<span class="pull-right">-</span>
							<%}%>
						</div>
						<div class="list-group-item">
							<%if (couponCode.coupon.hasExpired && !couponCode.isUsed) {%>
								<span class="text-gray-dark">${message("member.couponCode.expired")}</span>
							<%} else {%>
								<span class="text-orange"><%-couponCode.isUsed ? "${message("member.couponCode.used")}" : "${message("member.couponCode.unused")}"%></span>
							<%}%>
						</div>
					</div>
				</div>
				<%if (!couponCode.coupon.hasExpired && !couponCode.isUsed) {%>
					<div class="panel-footer text-right">
						<a class="btn btn-default btn-sm" href="${base}<%-couponCode.coupon.store.path%>">${message("member.couponCode.use")}</a>
					</div>
				<%}%>
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
					<h5>${message("member.couponCode.list")}</h5>
				</div>
			</div>
		</div>
	</header>
	<main>
		<div class="container-fluid">
			<div data-spy="scrollLoad" data-url="${base}/member/coupon_code/list?pageNumber=<%-pageNumber%>">
				<div id="scrollLoadContent"></div>
			</div>
		</div>
	</main>
</body>
</html>