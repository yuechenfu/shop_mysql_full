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
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/order.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/bootstrap-growl.js"></script>
	<script src="${base}/resources/common/js/jquery.scrolltofixed.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/velocity.js"></script>
	<script src="${base}/resources/common/js/velocity.ui.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/mobile/shop/js/base.js"></script>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
				
				var $amountPayable = $("#amountPayable");
				var $feeItem = $("#feeItem");
				var $fee = $("#fee");
				var $paymentPluginId = $("#paymentPluginId");
				var $rePayUrl = $("#rePayUrl");
				var $paymentPluginItem = $("#paymentPlugin div.list-group-item");
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
				
				[#if online]
					// 获取订单锁
					function acquireLock() {
						$.ajax({
							url: "${base}/order/lock",
							type: "POST",
							data: {
								orderSns: orderSns
							},
							dataType: "json"
						});
					}
					
					// 获取订单锁
					acquireLock();
					setInterval(function() {
						acquireLock();
					}, 50000);
					
					// 支付插件项
					$paymentPluginItem.click(function() {
						var $element = $(this);
						$element.addClass("active").siblings().removeClass("active");
						var paymentPluginId = $element.data("payment-plugin-id");
						$paymentPluginId.val(paymentPluginId);
						calculateAmount();
					});
					
					calculateAmount();
					
					// 计算金额
					function calculateAmount() {
						$.ajax({
							url: "${base}/order/calculate_amount",
							type: "GET",
							data: {
								orderSns: orderSns,
								paymentPluginId: $paymentPluginId.val()
							},
							dataType: "json",
							success: function(data) {
								$amountPayable.text($.currency(data.amount, true, true));
								if (data.fee > 0) {
									$fee.text($.currency(data.fee, true, true));
									if ($feeItem.is(":hidden")) {
										$feeItem.velocity("slideDown");
									}
								} else {
									if ($feeItem.is(":visible")) {
										$feeItem.velocity("slideUp");
									}
								}
							}
						});
					}
				[/#if]
			
			});
			</script>
		[/#escape]
	[/#noautoesc]
</head>
<body class="shop order-payment">
	<header class="header-default" data-spy="scrollToFixed">
		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-1">
					<a href="javascript:;" data-action="back">
						<i class="iconfont icon-back"></i>
					</a>
				</div>
				<div class="col-xs-10">
					<h5>${message("shop.order.payment")}</h5>
				</div>
			</div>
		</div>
	</header>
	<main>
		<div class="container-fluid">
			<div class="list-group">
				[#list orders as order]
					<div class="list-group-item small">
						${message("Order.sn")}: ${order.sn}
						<a class="pull-right text-gray" href="${base}/member/order/view?orderSn=${order.sn}">[${message("shop.order.view")}]</a>
					</div>
				[/#list]
			</div>
			<div class="list-group">
				<div class="list-group-item small">
					[#if order.status == "PENDING_PAYMENT"]
						${message("shop.order.pendingPayment")}
					[#elseif order.status == "PENDING_REVIEW"]
						${message("shop.order.pendingReview")}
					[#else]
						${message("shop.order.pending")}
					[/#if]
				</div>
				[#if expireDate?has_content]
					<div class="list-group-item small">
						<p class="text-orange">[#noautoesc]${message("shop.order.expireTips", expireDate?string("yyyy-MM-dd HH:mm:ss"))}[/#noautoesc]</p>
					</div>
				[/#if]
			</div>
			<div class="list-group">
				[#if online]
					<div class="list-group-item">
						${message("Order.amountPayable")}
						<strong id="amountPayable" class="pull-right text-red"></strong>
					</div>
					<div id="feeItem" class="fee-item list-group-item">
						${message("Order.fee")}
						<strong id="fee" class="pull-right text-red"></strong>
					</div>
				[#else]
					<div class="list-group-item">
						${message("Order.amountPayable")}
						<strong id="amountPayable" class="pull-right text-red">${currency(amount, true, true)}</strong>
					</div>
				[/#if]
				<div class="list-group-item">
					${message("Order.shippingMethod")}
					<span class="pull-right">${shippingMethodName!"-"}</span>
				</div>
				<div class="list-group-item">
					${message("Order.paymentMethod")}
					<span class="pull-right">${paymentMethodName!"-"}</span>
				</div>
			</div>
			[#if online]
				[#if paymentPlugins?has_content]
					<form action="${base}/payment" method="post">
						[#list orderSns as orderSn]
							<input name="paymentItemList[${orderSn_index}].type" type="hidden" value="ORDER_PAYMENT">
							<input name="paymentItemList[${orderSn_index}].orderSn" type="hidden" value="${orderSn}">
						[/#list]
						<input id="paymentPluginId" name="paymentPluginId" type="hidden" value="${defaultPaymentPlugin.id}">
						<input id="rePayUrl" name="rePayUrl" type="hidden">
						<div class="panel panel-default">
							<div class="panel-heading">${message("common.paymentPlugin")}</div>
							<div class="panel-body">
								<div id="paymentPlugin" class="list-group">
									[#list paymentPlugins as paymentPlugin]
										<div class="[#if paymentPlugin == defaultPaymentPlugin]active [/#if]list-group-item" data-payment-plugin-id="${paymentPlugin.id}">
											<div class="media">
												<div class="media-left media-middle">
													<div class="media-object">
														[#if paymentPlugin.logo?has_content]
															<img src="${paymentPlugin.logo}" alt="${paymentPlugin.displayName}">
														[#else]
															${paymentPlugin.displayName}
														[/#if]
													</div>
												</div>
												<div class="media-body media-middle">
													<span class="small text-gray" title="${paymentPlugin.description}">${abbreviate(paymentPlugin.description, 30, "...")}</span>
												</div>
												<div class="media-right media-middle">
													<i class="iconfont icon-roundcheck"></i>
												</div>
											</div>
										</div>
									[/#list]
								</div>
							</div>
							<div class="panel-footer">
								<button class="btn btn-lg btn-red btn-flat btn-block" type="submit">${message("shop.order.payNow")}</button>
							</div>
						</div>
					</form>
				[/#if]
			[#else]
				[#noautoesc]
					[#list orders as order]
						[#if order.paymentMethod.content?has_content]
							<div class="panel panel-default">${order.paymentMethod.content}</div>
						[/#if]
					[/#list]
				[/#noautoesc]
			[/#if]
		</div>
	</main>
</body>
</html>