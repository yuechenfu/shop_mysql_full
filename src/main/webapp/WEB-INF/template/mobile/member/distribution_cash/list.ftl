<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.distributionCash.list")}[#if showPowered] - Powered By SHOP++[/#if]</title>
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
		<%
			function statusText(status) {
				switch (status) {
					case "PENDING":
						return "${message("DistributionCash.Status.PENDING")}";
					case "APPROVED":
						return "${message("DistributionCash.Status.APPROVED")}";
					case "FAILED":
						return "${message("DistributionCash.Status.FAILED")}";
				}
			}
		%>
		<%_.each(data, function(distributionCash, i) {%>
			<div class="list-group">
				<div class="list-group-item">
					${message("common.createdDate")}:
					<span title="<%-moment(new Date(distributionCash.createdDate)).format("YYYY-MM-DD HH:mm:ss")%>"><%-moment(new Date(distributionCash.createdDate)).format("YYYY-MM-DD")%></span>
				</div>
				<div class="list-group-item">
					${message("DistributionCash.amount")}
					<span class="pull-right"><%-$.currency(distributionCash.amount, true)%></span>
				</div>
				<div class="list-group-item">
					${message("DistributionCash.bank")}
					<span class="pull-right"><%-distributionCash.bank%></span>
				</div>
				<div class="list-group-item">
					${message("DistributionCash.account")}
					<span class="pull-right"><%-distributionCash.account%></span>
				</div>
				<div class="list-group-item">
					${message("DistributionCash.accountHolder")}
					<span class="pull-right"><%-distributionCash.accountHolder%></span>
				</div>
				<div class="list-group-item">
					${message("DistributionCash.status")}
					<span class="pull-right">
						<% if ( distributionCash.status == "PENDING") {%>
							<span class="text-orange"><%-statusText(distributionCash.status)%></span>
						<%} else if (distributionCash.status == "FAILED") {%>
							<span class="text-red"><%-statusText(distributionCash.status)%></span>
						<%} else {%>
							<span class="text-green"><%-statusText(distributionCash.status)%></span>
						<%}%>
					</span>
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
					<h5>${message("member.distributionCash.list")}</h5>
				</div>
			</div>
		</div>
	</header>
	<main>
		<div class="container-fluid">
			<div data-spy="scrollLoad" data-url="${base}/member/distribution_cash/list?pageNumber=<%-pageNumber%>">
				<div id="scrollLoadContent"></div>
			</div>
		</div>
	</main>
	<footer class="footer-action footer-default" data-spy="scrollToFixed" data-bottom="0">
		<div class="container-fluid">
			<a class="btn btn-primary btn-flat btn-block" href="${base}/member/distribution_cash/application">${message("member.distributionCash.application")}</a>
		</div>
	</footer>
</body>
</html>