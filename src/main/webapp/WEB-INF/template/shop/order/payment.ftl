<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("shop.order.payment")}[#if showPowered] - Powered By SHOP++[/#if]</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/payment.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/order.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/jquery.qrcode.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/velocity.js"></script>
	<script src="${base}/resources/common/js/velocity.ui.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/shop/js/base.js"></script>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
			
				var $payConfirmModal = $("#payConfirmModal");
				var $paymentPluginId = $("#paymentPluginId");
				var $paymentPluginItem = $("#paymentPlugin .media");
				var $payAmount = $("#payAmount");
				var $payFee = $("#payFee");
				var $orderCollapse = $("#orderCollapse");
				var $summary = $("#summary");
				var $rePayUrl = $("#rePayUrl");
				var orderSns = [
					[#list orderSns as orderSn]
						"${orderSn}"[#if orderSn_has_next],[/#if]
					[/#list]
				];
				
				if (orderSns.length > 0) {
					$rePayUrl.val("${base}/order/payment?" + $.param({
						orderSns: orderSns
					}));
				}
				
				// 订单信息显示或隐藏
				$orderCollapse.click(function() {
					var $element = $(this);
					
					$element.find(".iconfont").toggleClass("icon-fold");
					$summary.slideToggle();
				});
				
				[#if online]
					// 订单锁定
					setInterval(function() {
						$.ajax({
							url: "${base}/order/lock",
							type: "POST",
							data: {
								orderSns: orderSns
							},
							dataType: "json",
							cache: false
						});
					}, 50000);
					
					// 检查等待付款
					setInterval(function() {
						$.ajax({
							url: "${base}/order/check_pending_payment",
							type: "GET",
							data: {
								orderSns: orderSns
							},
							dataType: "json",
							cache: false,
							success: function(data) {
								if (!data) {
									location.href = "${base}/member/order/list";
								}
							}
						});
					}, 10000);
				[/#if]
				
				// 支付插件
				$paymentPluginItem.click(function() {
					var $element = $(this);
					var paymentPluginId = $element.data("payment-plugin-id")
					
					$paymentPluginId.val(paymentPluginId);
					$element.addClass("active").siblings().removeClass("active");
					$.ajax({
						url: "${base}/order/calculate_amount",
						type: "GET",
						data: {
							paymentPluginId: paymentPluginId,
							orderSns: orderSns
						},
						dataType: "json",
						cache: false,
						success: function(data) {
							$payAmount.text($.currency(data.amount, true, true));
							if (data.fee > 0) {
								if ($payFee.parent().is(":hidden")) {
									$payFee.parent().velocity("fadeIn");
								}
								$payFee.text($.currency(data.fee, true, true));
							} else {
								$payFee.parent().velocity("fadeOut");
							}
						}
					});
				});
			
			});
			</script>
		[/#escape]
	[/#noautoesc]
</head>
<body class="shop payment">
	[#include "/shop/include/main_header.ftl" /]
	[#include "/shop/include/main_sidebar.ftl" /]
	<main>
		<div class="container">
			<div id="payConfirmModal" class="pay-confirm-modal modal fade" tabindex="-1">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title">${message("PayConfirmModal.payConfirm")}</h5>
						</div>
						<div class="modal-body">
							<p>
								<i class="iconfont icon-warn"></i>
								[#noautoesc]${message("PayConfirmModal.payPrimary")}[/#noautoesc]
							</p>
						</div>
						<div class="modal-footer">
							<a class="btn btn-primary" href="${base}/member/order/list">${message("PayConfirmModal.complete")}</a>
							<a class="btn btn-default" href="${base}/">${message("PayConfirmModal.problem")}</a>
						</div>
					</div>
				</div>
			</div>
			<form action="${base}/payment" method="post" target="_blank">
				[#list orderSns as orderSn]
					<input name="paymentItemList[${orderSn_index}].type" type="hidden" value="ORDER_PAYMENT">
					<input name="paymentItemList[${orderSn_index}].orderSn" type="hidden" value="${orderSn}">
				[/#list]
				<input id="rePayUrl" name="rePayUrl" type="hidden">
				<input id="paymentPluginId" name="paymentPluginId" type="hidden" value="${defaultPaymentPlugin.id}">
				<div class="panel panel-default">
					<div class="panel-body">
						<div class="order-payment-detail">
							<div class="media">
								<div class="media-left media-middle">
									<i class="iconfont icon-check"></i>
								</div>
								<div class="media-body media-middle">
									<div class="row">
										<div class="col-xs-7">
											[#if order.status == "PENDING_PAYMENT"]
												<h3>${message("shop.order.pendingPayment")}</h3>
											[#elseif order.status == "PENDING_REVIEW"]
												<h3>${message("shop.order.pendingReview")}</h3>
											[#else]
												<h3>${message("shop.order.pending")}</h3>
											[/#if]
											[#if amount?has_content]
												<span>
													${message("Order.amountPayable")}:
													<strong id="payAmount">${currency(amount, true, true)}</strong>
												</span>
											[/#if]
											[#if fee?has_content]
												<span[#if fee <= 0] class="hidden-element"[/#if]>
													${message("Order.fee")}:
													<span id="payFee">${currency(fee, true, true)}</span>
												</span>
											[/#if]
										</div>
										[#if expireDate?has_content]
											<div class="col-xs-5">
												<p>[#noautoesc]${message("shop.order.expireTips", expireDate?string("yyyy-MM-dd HH:mm:ss"))}[/#noautoesc]</p>
											</div>
										[/#if]
									</div>
								</div>
								<div class="media-right media-middle">
									<a id="orderCollapse" class="text-overflow" href="javascript:;" title="${message("shop.order.info")}">
										${message("shop.order.info")}
										<i class="iconfont icon-unfold"></i>
									</a>
								</div>
							</div>
							<dl id="summary" class="summary clearfix">
								<dt>${message("Order.sn")}:</dt>
								<dd>
									<ul>
										[#list orders as order]
											<li>
												<strong class="text-orange">${order.sn}</strong>
												<a href="${base}/member/order/view?orderSn=${order.sn}">[${message("shop.order.view")}]</a>
											</li>
										[/#list]
									</ul>
								</dd>
								<dt>${message("Order.shippingMethod")}:</dt>
								<dd>${shippingMethodName}</dd>
								<dt>${message("Order.paymentMethod")}:</dt>
								<dd>${paymentMethodName}</dd>
							</dl>
						</div>
						[#if paymentPlugins?has_content]
							<div id="paymentPlugin" class="payment-plugin">
								<div class="payment-plugin-heading">${message("common.paymentPlugin")}</div>
								<div class="payment-plugin-body clearfix">
									[#list paymentPlugins as paymentPlugin]
										<div class="media[#if paymentPlugin == defaultPaymentPlugin] active[/#if]" data-payment-plugin-id="${paymentPlugin.id}">
											<div class="media-left media-middle">
												<i class="iconfont icon-roundcheck"></i>
											</div>
											<div class="media-body media-middle">
												<div class="media-object">
													[#if paymentPlugin.logo?has_content]
														<img src="${paymentPlugin.logo}" alt="${paymentPlugin.displayName}">
													[#else]
														${paymentPlugin.displayName}
													[/#if]
												</div>
											</div>
										</div>
									[/#list]
								</div>
							</div>
						[/#if]
					</div>
					[#if online]
						<div class="panel-footer">
							<div class="row">
								<div class="col-xs-9 col-sm-10 col-xs-offset-3 col-sm-offset-2">
									<button class="btn btn-primary btn-lg" type="submit" data-toggle="modal" data-target="#payConfirmModal" data-backdrop="static">${message("shop.order.payNow")}</button>
								</div>
							</div>
						</div>
					[#else]
						<div class="panel-footer">
							[#noautoesc]
								[#list orders as order]
									[#if order.paymentMethod.content?has_content]
										<div class="payment-method">${order.paymentMethod.content}</div>
									[/#if]
								[/#list]
							[/#noautoesc]
						</div>
					[/#if]
				</div>
			</form>
		</div>
	</main>
	[#include "/shop/include/main_footer.ftl" /]
</body>
</html>