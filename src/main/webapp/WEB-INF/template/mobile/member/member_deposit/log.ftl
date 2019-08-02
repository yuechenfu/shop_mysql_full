<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.memberDeposit.log")}[#if showPowered] - Powered By SHOP++[/#if]</title>
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
			function depositText(type) {
				switch (type) {
					case "RECHARGE":
						return "${message("BusinessDepositLog.Type.RECHARGE")}";
					case "ADJUSTMENT":
						return "${message("BusinessDepositLog.Type.ADJUSTMENT")}";
					case "ORDER_PAYMENT":
						return "${message("BusinessDepositLog.Type.ORDER_PAYMENT")}";
					case "ORDER_REFUNDS":
						return "${message("BusinessDepositLog.Type.ORDER_REFUNDS")}";
				}
			}
		%>
		<%_.each(data, function(depositLog, i) {%>
			<div class="list-group small">
				<div class="list-group-item">
					${message("common.createdDate")}:
					<span title="<%-moment(new Date(depositLog.createdDate)).format("YYYY-MM-DD HH:mm:ss")%>"><%-moment(new Date(depositLog.createdDate)).format("YYYY-MM-DD")%></span>
				</div>
				<div class="list-group-item">
					${message("MemberDepositLog.type")}
					<span class="pull-right"><%-depositText(depositLog.type)%></span>
				</div>
				<div class="list-group-item">
					${message("MemberDepositLog.credit")}
					<span class="pull-right"><%-$.currency(depositLog.credit, true)%></span>
				</div>
				<div class="list-group-item">
					${message("MemberDepositLog.debit")}
					<span class="pull-right"><%-$.currency(depositLog.debit, true)%></span>
				</div>
				<div class="list-group-item">
					${message("MemberDepositLog.balance")}
					<strong class="pull-right text-orange"><%-$.currency(depositLog.balance, true)%></strong>
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
					<h5>${message("member.memberDeposit.log")}</h5>
				</div>
			</div>
		</div>
	</header>
	<main>
		<div class="container-fluid">
			<div data-spy="scrollLoad" data-url="${base}/member/member_deposit/log?pageNumber=<%-pageNumber%>">
				<div id="scrollLoadContent"></div>
			</div>
		</div>
	</main>
</body>
</html>