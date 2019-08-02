<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.couponCode.exchange")}[#if showPowered] - Powered By SHOP++[/#if]</title>
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
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/mobile/member/js/base.js"></script>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
				
				var $exchange = $("a.exchange");
				
				// 兑换
				$exchange.click(function() {
					var $element = $(this);
					var couponId = $element.data("coupon-id");
					
					bootbox.confirm("${message("member.couponCode.exchangeConfirm")}", function(result) {
						if (result == null || !result) {
							return;
						}
						
						$.ajax({
							url: "exchange",
							type: "POST",
							data: {
								couponId: couponId
							},
							dataType: "json",
							success: function(data) {
								$.bootstrapGrowl(data.message, {
									type: "success"
								});
								setTimeout(function() {
									location.href = "${base}/member/coupon_code/list";
								}, 3000);
							}
						});
					});
					return false;
				});
			
			});
			</script>
		[/#escape]
	[/#noautoesc]
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
					<h5>${message("member.couponCode.exchange")}</h5>
				</div>
			</div>
		</div>
	</header>
	<main>
		<div class="container-fluid">
			[#if page.content?has_content]
				[#list page.content as coupon]
					<div class="panel panel-default">
						<div class="panel-heading clearfix">
							<h5>${coupon.store.name}</h5>
							<span class="pull-right text-orange">${coupon.name}</span>
						</div>
						<div class="panel-body">
							<div class="list-group small">
								<div class="list-group-item">
									${message("Coupon.point")}
									<span class="pull-right">${coupon.point}</span>
								</div>
								<div class="list-group-item">
									${message("Coupon.beginDate")}
									<span class="pull-right">
										[#if coupon.beginDate??]${coupon.beginDate?string("yyyy-MM-dd HH:mm:ss")}[#else]-[/#if]
									</span>
								</div>
								<div class="list-group-item">
									${message("Coupon.endDate")}
									<span class="pull-right">
										[#if coupon.endDate??]${coupon.endDate?string("yyyy-MM-dd HH:mm:ss")}[#else]-[/#if]
									</span>
								</div>
							</div>
						</div>
						<div class="panel-footer text-right">
							<a class="exchange btn btn-default btn-sm" href="javascript:;" data-coupon-id="${coupon.id}">${message("member.couponCode.exchange")}</a>
						</div>
					</div>
				[/#list]
			[#else]
				<p class="no-result">${message("common.noResult")}</p>
			[/#if]
		</div>
	</main>
</body>
</html>