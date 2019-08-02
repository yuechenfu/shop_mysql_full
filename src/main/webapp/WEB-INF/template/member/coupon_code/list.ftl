<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.couponCode.list")} - Powered By SHOP++</title>
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
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/clipboard.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/member/js/base.js"></script>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
			
				var $clipboard = $("[data-clipboard]");
				
				// 复制
				if (Clipboard.isSupported()) {
					$clipboard.show();
				}
				
				// 复制
				$clipboard.tooltip({
					title: function() {
						return $(this).hasClass("copied") ? "${message("member.couponCode.copySuccess")}" : "${message("member.couponCode.copy")}";
					}
				});
				
				// 复制
				new Clipboard("[data-clipboard]").on("success", function(event) {
					$clipboard.removeClass("copied");
					$(event.trigger).addClass("copied").tooltip("show");
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
					<form action="${base}/member/coupon_code/list" method="get">
						<input name="pageNumber" type="hidden" value="${page.pageNumber}">
						<div class="panel panel-default">
							<div class="panel-heading">${message("member.couponCode.list")}</div>
							<div class="panel-body">
								[#if page.content?has_content]
									<ul class="coupon-list clearfix">
										[#list page.content as couponCode]
											<li>
												<div class="media">
													<div class="media-body">
														<h3 class="text-overflow[#if couponCode.coupon.hasExpired() && !couponCode.isUsed] text-gray[#else] text-purple-light[/#if]" title="${couponCode.coupon.name}">${couponCode.coupon.name}</h3>
														<span class="small[#if couponCode.coupon.hasExpired() && !couponCode.isUsed] text-gray[#else] text-purple-lighter[/#if]">${couponCode.coupon.store.name}</span>
														[#if couponCode.isUsed]
															<p class="text-gray-darker" title="${couponCode.usedDate?string("yyyy-MM-dd HH:mm:ss")}">${message("CouponCode.usedDate")}: ${couponCode.usedDate?string("yyyy-MM-dd")}</p>
														[#else]
															[#if !couponCode.coupon.beginDate?? && !couponCode.coupon.endDate??]
																<p class="text-gray-darker">${message("member.couponCode.noTimeLimit")}</p>
															[#else]
																<p class="text-gray-darker">
																	[#if couponCode.coupon.beginDate??]
																		<span title="${couponCode.coupon.beginDate?string("yyyy-MM-dd HH:mm:ss")}">${couponCode.coupon.beginDate?string("yyyy-MM-dd")}</span>
																	[#else]
																		-
																	[/#if]
																	<span> ~ </span>
																	[#if couponCode.coupon.endDate??]
																		<span title="${couponCode.coupon.endDate?string("yyyy-MM-dd HH:mm:ss")}">${couponCode.coupon.endDate?string("yyyy-MM-dd")}</span>
																	[#else]
																		-
																	[/#if]
																</p>
															[/#if]
														[/#if]
														<p class="code text-gray-dark">
															${message("CouponCode.code")}:
															<span title="${couponCode.code}">${abbreviate(couponCode.code, 20, "...")}</span>
															[#if !couponCode.coupon.hasExpired() && !couponCode.isUsed]
																<button class="btn btn-default btn-xs btn-icon" type="button" data-clipboard data-clipboard-text="${couponCode.code}">
																	<i class="iconfont icon-copy"></i>
																</button>
															[/#if]
														</p>
													</div>
													<div class="media-right">
														<div class="coupon-right[#if couponCode.isUsed] is-used[#elseif couponCode.coupon.hasExpired()] has-expired[/#if]">
															[#if couponCode.isUsed]
																<div class="circle-lg">
																	<div class="circle-sm">
																		<div class="status">${message("member.couponCode.used")}</div>
																	</div>
																</div>
															[#elseif couponCode.coupon.hasExpired()]
																<div class="circle-lg">
																	<div class="circle-sm">
																		<div class="status">${message("member.couponCode.expired")}</div>
																	</div>
																</div>
															[#else]
																<a href="${base}${couponCode.coupon.store.path}">
																	${message("member.couponCode.use")}
																	<i class="iconfont icon-unfold"></i>
																</a>
															[/#if]
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