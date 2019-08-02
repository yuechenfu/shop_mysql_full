<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.couponCode.exchange")} - Powered By SHOP++</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/member/css/base.css" rel="stylesheet">
	<link href="${base}/resources/member/css/coupon.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/bootstrap-growl.js"></script>
	<script src="${base}/resources/common/js/bootbox.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/member/js/base.js"></script>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
				
				var $exchange = $("a.exchange");
				
				// 兑换
				$exchange.click(function() {
					var $element = $(this);
					
					bootbox.confirm("${message("member.couponCode.exchangeConfirm")}", function(result) {
						if (result == null || !result) {
							return;
						}
						
						$.ajax({
							url: "${base}/member/coupon_code/exchange",
							type: "POST",
							data: {
								couponId: $element.data("coupon-id")
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
<body class="member coupon">
	[#include "/shop/include/main_header.ftl" /]
	<main>
		<div class="container">
			<div class="row">
				<div class="col-xs-2">
					[#include "/member/include/main_menu.ftl" /]
				</div>
				<div class="col-xs-10">
					<form action="${base}/member/coupon_code/exchange" method="post">
						<input name="pageNumber" type="hidden" value="${page.pageNumber}">
						<div class="panel panel-default">
							<div class="panel-heading">${message("member.couponCode.exchange")}</div>
							<div class="panel-body">
								[#if page.content?has_content]
									<ul class="coupon-exchange-list clearfix">
										[#list page.content as coupon]
											<li>
												<div class="media">
													<div class="media-body">
														<h3 class="text-overflow text-cyan-light" title="${coupon.name}">${coupon.name}</h3>
														<em class="small text-cyan-lighter">${coupon.store.name}</em>
														<p class="text-gray-darker">${message("Coupon.point")}: ${coupon.point}</p>
														[#if !coupon.beginDate?? && !coupon.endDate??]
															<p class="text-gray-dark">${message("member.couponCode.noTimeLimit")}</p>
														[#else]
															<p class="text-gray-dark">
																[#if coupon.beginDate??]
																	<span title="${coupon.beginDate?string("yyyy-MM-dd HH:mm:ss")}">${coupon.beginDate?string("yyyy-MM-dd")}</span>
																[#else]
																	-
																[/#if]
																<span> ~ </span>
																[#if coupon.endDate??]
																	<span title="${coupon.endDate?string("yyyy-MM-dd HH:mm:ss")}">${coupon.endDate?string("yyyy-MM-dd")}</span>
																[#else]
																	-
																[/#if]
															</p>
														[/#if]
													</div>
													<div class="media-right">
														<div class="coupon-right">
															<a class="exchange" href="javascript:;" data-coupon-id="${coupon.id}">${message("member.couponCode.get")}</a>
														</div>
													</div>
												</div>
											</li>
										[/#list]
									</ul>
								[#else]
									<p class="text-gray">${message("common.noResult")}</p>
								[/#if]
							</div>
							[@pagination pageNumber = page.pageNumber totalPages = page.totalPages]
								[#if totalPages > 1]
									<div class="panel-footer text-right clearfix">
										[#include "/member/include/pagination.ftl" /]
									</div>
								[/#if]
							[/@pagination]
						</div>
					</form>
				</div>
			</div>
		</div>
	</main>
	[#include "/shop/include/main_footer.ftl" /]
</body>
</html>