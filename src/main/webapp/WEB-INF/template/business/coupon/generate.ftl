<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.coupon.generate")} - Powered By SHOP++</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/business/css/base.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/bootstrap-growl.js"></script>
	<script src="${base}/resources/common/js/jquery.nicescroll.js"></script>
	<script src="${base}/resources/common/js/jquery.validate.js"></script>
	<script src="${base}/resources/common/js/jquery.validate.additional.js"></script>
	<script src="${base}/resources/common/js/jquery.form.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/business/js/base.js"></script>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
			
				var $couponForm = $("#couponForm");
				var $totalCount = $(".total-count");
				var $count = $("#count");
				var totalCount = ${totalCount};
				
				// 表单验证
				$couponForm.validate({
					rules: {
						count: {
							required: true,
							integer: true,
							min: 1
						}
					},
					submitHandler: function(form) {
						totalCount += parseInt($count.val());
						$totalCount.text(totalCount);
						form.submit();
					}
				});
			
			});
			</script>
		[/#escape]
	[/#noautoesc]
</head>
<body class="business">
	[#include "/business/include/main_header.ftl" /]
	[#include "/business/include/main_sidebar.ftl" /]
	<main>
		<div class="container-fluid">
			<ol class="breadcrumb">
				<li>
					<a href="${base}/business/index">
						<i class="iconfont icon-homefill"></i>
						${message("common.breadcrumb.index")}
					</a>
				</li>
				<li class="active">${message("business.coupon.generate")}</li>
			</ol>
			<form id="couponForm" class="form-horizontal" action="${base}/business/coupon/download" method="post">
				<input name="couponId" type="hidden" value="${coupon.id}">
				<div class="panel panel-default">
					<div class="panel-heading">${message("business.coupon.generate")}</div>
					<div class="panel-body">
						<div class="row">
							<div class="col-xs-12 col-sm-6">
								<dl class="items dl-horizontal">
									<dt>${message("Coupon.name")}:</dt>
									<dd>${coupon.name}</dd>
									<dt>${message("Coupon.beginDate")}:</dt>
									<dd>
										[#if coupon.beginDate??]
											<span title="${coupon.beginDate?string("yyyy-MM-dd HH:mm:ss")}" data-toggle="tooltip">${coupon.beginDate?string("yyyy-MM-dd")}</span>
										[#else]
											-
										[/#if]
									</dd>
									<dt>${message("Coupon.endDate")}:</dt>
									<dd>
										[#if coupon.endDate??]
											<span title="${coupon.endDate?string("yyyy-MM-dd HH:mm:ss")}" data-toggle="tooltip">${coupon.endDate?string("yyyy-MM-dd")}</span>
										[#else]
											-
										[/#if]
									</dd>
									<dt>${message("business.coupon.totalCount")}:</dt>
									<dd class="total-count">${totalCount}</dd>
									<dt>${message("business.coupon.usedCount")}:</dt>
									<dd>${usedCount}</dd>
								</dl>
							</div>
						</div>
						<div class="form-group">
							<label class="col-xs-3 col-sm-2 control-label item-required" for="count">${message("business.coupon.count")}:</label>
							<div class="col-xs-9 col-sm-4">
								<input id="count" name="count" class="form-control" type="text" value="100" maxlength="9">
							</div>
						</div>
					</div>
					<div class="panel-footer">
						<div class="row">
							<div class="col-xs-9 col-sm-10 col-xs-offset-3 col-sm-offset-2">
								<button class="btn btn-primary" type="submit">${message("common.submit")}</button>
								<button class="btn btn-default" type="button" data-action="back">${message("common.back")}</button>
							</div>
						</div>
					</div>
				</div>
			</form>
		</div>
	</main>
</body>
</html>