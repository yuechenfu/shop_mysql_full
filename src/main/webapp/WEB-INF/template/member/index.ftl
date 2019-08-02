<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.index.title")} - Powered By SHOP++</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/member/css/base.css" rel="stylesheet">
	<link href="${base}/resources/member/css/index.css" rel="stylesheet">
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
<body class="member index">
	[#include "/shop/include/main_header.ftl" /]
	<main>
		<div class="container">
			<div class="row">
				<div class="col-xs-2">
					[#include "/member/include/main_menu.ftl" /]
				</div>
				<div class="col-xs-10">
					<div class="summary panel panel-default">
						<div class="panel-body">
							<div class="media">
								<div class="media-left media-middle text-nowrap">
									<ul>
										<li>${message("member.index.welcome", currentUser.username)}</li>
										<li>
											${message("member.index.memberRank")}:
											<span class="text-red">${currentUser.memberRank.name}</span>
										</li>
										<li>
											${message("member.index.balance")}:
											<span class="text-red">${currency(currentUser.balance, true, true)}</span>
										</li>
										[#if currentUser.frozenAmount > 0 ]
											<li>
												${message("member.index.frozenAmount")}:
												<span class="text-gray">${currency(currentUser.frozenAmount, true, true)}</span>
											</li>
										[/#if]
										<li>${message("member.index.amount")}: ${currency(currentUser.amount, true, true)}</li>
										<li>
											${message("member.index.point")}: ${currentUser.point}
											<a class="text-gray" href="${base}/member/coupon_code/exchange">[${message("member.index.exchange")}]</a>
										</li>
									</ul>
								</div>
								<div class="media-body media-middle">
									<ul>
										<li>
											<a href="${base}/member/order/list?status=PENDING_PAYMENT&hasExpired=false">
												<div class="media">
													<div class="media-left">
														<i class="iconfont icon-pay bg-blue-light"></i>
													</div>
													<div class="media-body media-middle">
														[@order_count memberId = currentUser.id status = "PENDING_PAYMENT" hasExpired = false]
															<h1 class="text-blue-light media-heading">${count}</h1>
														[/@order_count]
														<p>${message("Order.Status.PENDING_PAYMENT")}</p>
													</div>
												</div>
											</a>
										</li>
										<li>
											<a href="${base}/member/order/list?status=PENDING_SHIPMENT&hasExpired=false">
												<div class="media">
													<div class="media-left">
														<i class="iconfont icon-deliver bg-orange-light"></i>
													</div>
													<div class="media-body media-middle">
														[@order_count memberId = currentUser.id status = "PENDING_SHIPMENT" hasExpired = false]
															<h1 class="text-orange-light media-heading">${count}</h1>
														[/@order_count]
														<p>${message("Order.Status.PENDING_SHIPMENT")}</p>
													</div>
												</div>
											</a>
										</li>
										<li>
											<a href="${base}/member/order/list?status=SHIPPED">
												<div class="media">
													<div class="media-left">
														<i class="iconfont icon-expressman bg-yellow-light"></i>
													</div>
													<div class="media-body media-middle">
														[@order_count memberId = currentUser.id status = "SHIPPED"]
															<h1 class="text-yellow-light media-heading">${count}</h1>
														[/@order_count]
														<p>${message("Order.Status.SHIPPED")}</p>
													</div>
												</div>
											</a>
										</li>
										<li>
											<a href="${base}/member/order/list?status=COMPLETED">
												<div class="media">
													<div class="media-left">
														<i class="iconfont icon-check bg-green-light"></i>
													</div>
													<div class="media-body media-middle">
														[@order_count memberId = currentUser.id status = "COMPLETED"]
															<h1 class="text-green-light media-heading">${count}</h1>
														[/@order_count]
														<p>${message("Order.Status.COMPLETED")}</p>
													</div>
												</div>
											</a>
										</li>
									</ul>
								</div>
							</div>
						</div>
					</div>
					<div class="order panel panel-default">
						<div class="panel-heading">
							${message("member.index.order")}
							[#if newOrders?has_content]
								<a class="pull-right text-gray small" href="${base}/member/order/list">
									${message("member.index.more")}
									<i class="iconfont icon-right"></i>
								</a>
							[/#if]
						</div>
						<div class="panel-body">
							[#if newOrders?has_content]
								<ul class="media-list">
									[#list newOrders as order]
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
														<strong class="[#if order.status == "PENDING_SHIPMENT" || order.status == "PENDING_REVIEW" || order.status == "PENDING_PAYMENT"]text-orange[#elseif order.status == "FAILED"]text-red[#else]text-green[/#if]">${message("Order.Status." + order.status)}</strong>
														[#if order.hasExpired()]
															<span class="text-gray-dark">(${message("member.index.hasExpired")})</span>
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
											</div>
										</li>
									[/#list]
								</ul>
							[#else]
								<p class="text-gray">${message("common.noResult")}</p>
							[/#if]
						</div>
					</div>
					[@product_favorite memberId = currentUser.id]
						<div class="product-favorite panel panel-default">
							<div class="panel-heading">
								${message("member.index.productFavorite")}
								[#if productFavorites?has_content]
									<a class="pull-right text-gray small" href="${base}/member/product_favorite/list">
										${message("member.index.more")}
										<i class="iconfont icon-right"></i>
									</a>
								[/#if]
							</div>
							<div class="panel-body">
								[#if productFavorites?has_content]
									<div class="row">
										[#list productFavorites as productFavorite]
											<div class="col-xs-2">
												<a class="thumbnail" href="[#if productFavorite.product.isMarketable && productFavorite.product.isActive]${base}${productFavorite.product.path}[#else]javascript:;[/#if]" target="_blank" title="${productFavorite.product.name}">
													[#if !productFavorite.product.isMarketable]
														<em>${message("member.index.productNotMarketable")}</em>
													[#elseif !productFavorite.product.isActive]
														<em>${message("member.index.productNotActive")}</em>
													[/#if]
													<img class="img-responsive center-block" src="${productFavorite.product.thumbnail!setting.defaultThumbnailProductImage}" alt="${productFavorite.product.name}">
													<div class="text-overflow caption text-center">${productFavorite.product.name}</div>
												</a>
											</div>
											[#if productFavorite_index == 5]
												[#break /]
											[/#if]
										[/#list]
									</div>
								[#else]
									<p class="text-gray">${message("common.noResult")}</p>
								[/#if]
							</div>
						</div>
					[/@product_favorite]
					[@store_favorite memberId = currentUser.id]
						<div class="store-favorite panel panel-default">
							<div class="panel-heading">
								${message("member.index.storeFavorite")}
								[#if storeFavorites?has_content]
									<a class="pull-right text-gray small" href="${base}/member/store_favorite/list">
										${message("member.index.more")}
										<i class="iconfont icon-right"></i>
									</a>
								[/#if]
							</div>
							<div class="panel-body">
								[#if storeFavorites?has_content]
									<div class="row">
										[#list storeFavorites as storeFavorite]
											<div class="col-xs-2">
												<a class="thumbnail" href="${base}${storeFavorite.store.path}" target="_blank" title="${storeFavorite.store.name}">
													[#if !storeFavorite.store.isEnabled]
														<em>${message("member.index.storeNotActive")}</em>
													[#elseif storeFavorite.store.hasExpired()]
														<em>${message("member.index.storeHasExpired")}</em>
													[/#if]
													<img class="img-responsive center-block" src="${storeFavorite.store.logo!setting.defaultStoreLogo}" alt="${storeFavorite.store.name}">
													<div class="text-overflow caption text-center">${storeFavorite.store.name}</div>
												</a>
											</div>
											[#if storeFavorite_index == 5]
												[#break /]
											[/#if]
										[/#list]
									</div>
								[#else]
									<p class="text-gray">${message("common.noResult")}</p>
								[/#if]
							</div>
						</div>
					[/@store_favorite]
				</div>
			</div>
		</div>
	</main>
	[#include "/shop/include/main_footer.ftl" /]
</body>
</html>