<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.order.list")} - Powered By SHOP++</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/member/css/base.css" rel="stylesheet">
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
	<script src="${base}/resources/common/js/velocity.js"></script>
	<script src="${base}/resources/common/js/velocity.ui.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/member/js/base.js"></script>
</head>
<body class="member order">
	[#include "/shop/include/main_header.ftl" /]
	<main>
		<div class="container">
			<div class="row">
				<div class="col-xs-2">
					[#include "/member/include/main_menu.ftl" /]
				</div>
				<div class="col-xs-10">
					<form action="${base}/member/order/list" method="get">
						<input name="status" type="hidden" value="${status}">
						<input name="hasExpired" type="hidden" value="${(hasExpired?string("true", "false"))!}">
						<input name="pageNumber" type="hidden" value="${page.pageNumber}">
						<div class="order-list panel panel-default">
							<div class="panel-heading">${message("member.order.list")}</div>
							<div class="panel-body">
								[#if page.content?has_content]
									<ul class="media-list">
										[#list page.content as order]
											<li class="media">
												<div class="media-left media-middle">
													<ul class="media-list">
														[#list order.orderItems as orderItem]
															<li class="media">
																<div class="media-left media-middle">
																	[#if orderItem.sku??]
																		<a href="${base}${orderItem.sku.path}" target="_blank" title="${orderItem.name}">
																			<img class="media-object img-thumbnail" src="${orderItem.thumbnail!setting.defaultThumbnailProductImage}" alt="${orderItem.name}">
																		</a>
																	[#else]
																		<img class="media-object img-thumbnail" src="${orderItem.thumbnail!setting.defaultThumbnailProductImage}" alt="${orderItem.name}" title="${orderItem.name}">
																	[/#if]
																</div>
																<div class="media-body media-middle">
																	<h5 class="media-heading">
																		[#if orderItem.sku??]
																			<a href="${base}${orderItem.sku.path}" title="${orderItem.name}" target="_blank">${orderItem.name}</a>
																		[#else]
																			${orderItem.name}
																		[/#if]
																	</h5>
																	[#if orderItem.specifications?has_content]
																		<span class="text-gray">[${orderItem.specifications?join(", ")}]</span>
																	[/#if]
																	<p class="text-gray-dark">${currency(orderItem.price, true)} &times; ${orderItem.quantity}</p>
																</div>
															</li>
															[#if orderItem_index == 2]
																[#break /]
															[/#if]
														[/#list]
													</ul>
												</div>
												<div class="media-body media-middle">
													<ul>
														<li>
															<strong class="[#if order.status == "PENDING_SHIPMENT" || order.status == "PENDING_REVIEW" || order.status == "PENDING_PAYMENT"]text-orange[#elseif order.status == "FAILED" || order.status == "DENIED"]text-red[#elseif order.status == "CANCELED"]text-gray-dark[#else]text-green[/#if]">${message("Order.Status." + order.status)}</strong>
															[#if order.hasExpired()]
																<span class="text-gray-dark">(${message("member.order.hasExpired")})</span>
															[/#if]
														</li>
														<li>
															<span class="text-gray-dark">${message("Order.sn")}: ${order.sn}</span>
														</li>
														<li>
															<span class="text-gray-dark">
																<i class="iconfont icon-shop"></i>
																${order.store.name}
															</span>
															<span class="text-gray" title="${order.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${order.createdDate}</span>
														</li>
													</ul>
												</div>
												<div class="media-right media-middle">
													<strong class="text-red pull-left">${currency(order.amount, true)}</strong>
													<a class="btn btn-default btn-icon pull-right" href="${base}/member/order/view?orderSn=${order.sn}" title="${message("common.view")}">
														<i class="iconfont icon-search"></i>
													</a>
													[#if setting.isReviewEnabled && !order.isReviewed && (order.status == "RECEIVED" || order.status == "COMPLETED")]
														<a class="btn btn-default btn-icon pull-right" href="${base}/member/review/add?orderId=${order.id}" title="${message("member.order.review")}">
															<i class="iconfont icon-comment"></i>
														</a>
													[/#if]
													[#if order.type == "GENERAL" && (order.status == "RECEIVED" || order.status == "COMPLETED")]
														<a class="btn btn-default btn-icon pull-right" href="${base}/member/aftersales/apply?orderId=${order.id}" title="${message("member.order.aftersalesApply")}">
															<i class="iconfont icon-text"></i>
														</a>
													[/#if]
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