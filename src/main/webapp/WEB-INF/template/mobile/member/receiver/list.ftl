<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.receiver.list")}[#if showPowered] - Powered By SHOP++[/#if]</title>
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
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/velocity.js"></script>
	<script src="${base}/resources/common/js/velocity.ui.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/mobile/member/js/base.js"></script>
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
					<h5>${message("member.receiver.list")}</h5>
				</div>
			</div>
		</div>
	</header>
	<main>
		<div class="container-fluid">
			[#if page.content?has_content]
				[#list page.content as receiver]
					<div class="panel panel-default">
						<div class="panel-body">
							<div class="list-group">
								<div class="list-group-item">
									<div class="media">
										<h5 class="media-heading">
											<span title="${receiver.consignee}">${abbreviate(receiver.consignee, 30, "...")}</span>
											<span class="pull-right">${receiver.phone}</span>
										</h5>
										<span class="small" title="${receiver.areaName}${receiver.address}">${receiver.areaName}${abbreviate(receiver.address, 30, "...")}</span>
									</div>
								</div>
								<div class="list-group-item">
									<span class="small text-orange">${message("Receiver.isDefault")}: ${receiver.isDefault?string(message("member.receiver.true"), message("member.receiver.false"))}</span>
								</div>
							</div>
						</div>
						<div class="panel-footer text-right">
							<a class="btn btn-default btn-sm" href="edit?receiverId=${receiver.id}">${message("common.edit")}</a>
							<a class="btn btn-default btn-sm" href="javascript:;" data-action="delete" data-url="${base}/member/receiver/delete?receiverId=${receiver.id}">${message("common.delete")}</a>
						</div>
					</div>
				[/#list]
			[#else]
				<p class="no-result">${message("common.noResult")}</p>
			[/#if]
		</div>
	</main>
	<footer class="footer-action footer-default" data-spy="scrollToFixed" data-bottom="0">
		<div class="container-fluid">
			<a class="btn btn-primary btn-flat btn-block" href="${base}/member/receiver/add">${message("member.receiver.add")}</a>
		</div>
	</footer>
</body>
</html>