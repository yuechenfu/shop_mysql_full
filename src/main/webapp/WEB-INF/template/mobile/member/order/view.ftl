<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.order.view")}[#if showPowered] - Powered By SHOP++[/#if]</title>
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
	<style>
		footer.footer-default {
			text-align: right;
		}
		
		footer.footer-default .btn {
			margin-right: 10px;
		}
	</style>
	<script id="transitStepTemplate" type="text/template">
		<%if (_.isEmpty(data.transitSteps)) {%>
			<p class="text-gray">${message("common.noResult")}</p>
		<%} else {%>
			<div class="list-group">
				<%_.each(data.transitSteps, function(transitStep, i) {%>
					<div class="list-group-item small">
						<p class="text-gray"><%-transitStep.time%></p>
						<p><%-transitStep.context%></p>
					</div>
				<%});%>
			</div>
		<%}%>
	</script>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
				
				var $payment = $("#payment");
				var $cancel = $("#cancel");
				var $receive = $("#receive");
				var $transitStep = $("a.transit-step");
				var $transitStepModal = $("#transitStepModal");
				var $transitStepModalBody = $("#transitStepModal div.modal-body");
				var transitStepTemplate = _.template($("#transitStepTemplate").html());
				
				// 订单支付
				$payment.click(function() {
					$.ajax({
						url: "${base}/member/order/check_lock",
						type: "POST",
						data: {
							orderSn: ${order.sn}
						},
						dataType: "json",
						success: function() {
							location.href = "${base}/order/payment?orderSns=${order.sn}";
						}
					});
					return false;
				});
				
				// 订单取消
				$cancel.click(function() {
					bootbox.confirm("${message("member.order.cancelConfirm")}", function(result) {
						if (result == null || !result) {
							return;
						}
						
						$.ajax({
							url: "${base}/member/order/cancel?orderSn=${order.sn}",
							type: "POST",
							dataType: "json",
							success: function() {
								location.reload();
							}
						});
					});
					return false;
				});
				
				// 订单收货
				$receive.click(function() {
					bootbox.confirm("${message("member.order.receiveConfirm")}", function(result) {
						if (result == null || !result) {
							return;
						}
						
						$.ajax({
							url: "${base}/member/order/receive?orderSn=${order.sn}",
							type: "POST",
							dataType: "json",
							success: function() {
								location.reload();
							}
						});
					});
					return false;
				});
				
				// 物流动态
				$transitStep.click(function() {
					var $element = $(this);
					
					$.ajax({
						url: "${base}/member/order/transit_step",
						type: "GET",
						data: {
							orderShippingSn: $element.data("order-shipping-sn")
						},
						dataType: "json",
						beforeSend: function() {
							$transitStepModalBody.empty();
							$transitStepModal.modal();
						},
						success: function(data) {
							$transitStepModalBody.html(transitStepTemplate({
								data: data
							}));
						}
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
					<a href="${base}/member/order/list">
						<i class="iconfont icon-back"></i>
					</a>
				</div>
				<div class="col-xs-10">
					<h5>${message("member.order.view")}</h5>
				</div>
			</div>
		</div>
	</header>
	<main>
		<div class="container-fluid">
			<div id="transitStepModal" class="transit-step-modal modal fade" tabindex="-1">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<button class="close" type="button" data-dismiss="modal">&times;</button>
							<h5 class="modal-title">${message("member.order.transitStep")}</h5>
						</div>
						<div class="modal-body"></div>
						<div class="modal-footer">
							<button class="btn btn-default btn-sm" type="button" data-dismiss="modal">${message("member.order.close")}</button>
						</div>
					</div>
				</div>
			</div>
			<div class="list-group">
				<div class="list-group-item">
					<span class="small">${message("Order.sn")}: ${order.sn}</span>
					[#if order.hasExpired()]
						<span class="pull-right text-gray-dark">${message("member.order.hasExpired")}</span>
					[#else]
						<span class="pull-right[#if order.status == "PENDING_SHIPMENT" || order.status == "PENDING_REVIEW" || order.status == "PENDING_PAYMENT"] text-orange[#elseif order.status == "FAILED" || order.status == "DENIED"] text-red[#elseif order.status == "CANCELED"] text-gray-dark[#else] text-green[/#if]">${message("Order.Status." + order.status)}</span>
					[/#if]
				</div>
			</div>
			<div class="list-group small">
				<div class="list-group-item">
					[#if order.hasExpired()]
						${message("member.order.hasExpiredTips")}
					[#elseif order.status == "PENDING_PAYMENT"]
						${message("member.order.pendingPaymentTips")}
					[#elseif order.status == "PENDING_REVIEW"]
						${message("member.order.pendingReviewTips")}
					[#elseif order.status == "PENDING_SHIPMENT"]
						${message("member.order.pendingShipmentTips")}
					[#elseif order.status == "SHIPPED"]
						${message("member.order.shippedTips")}
					[#elseif order.status == "RECEIVED"]
						${message("member.order.receivedTips")}
					[#elseif order.status == "COMPLETED"]
						${message("member.order.completedTips")}
					[#elseif order.status == "FAILED"]
						${message("member.order.failedTips")}
					[#elseif order.status == "CANCELED"]
						${message("member.order.canceledTips")}
					[#elseif order.status == "DENIED"]
						${message("member.order.deniedTips")}
					[/#if]
				</div>
				[#if order.expire?? && !order.hasExpired()]
					<div class="list-group-item text-orange">${message("Order.expire")}: ${order.expire?string("yyyy-MM-dd HH:mm:ss")}</div>
				[/#if]
			</div>
			[#if order.isDelivery]
				<div class="list-group">
					<div class="list-group-item">
						${message("Order.consignee")}: ${order.consignee}
						<span class="pull-right">${message("Order.phone")}: ${order.phone}</span>
					</div>
					<div class="list-group-item">${message("Order.address")}: ${order.areaName}${order.address}</div>
				</div>
			[/#if]
			<div class="list-group">
				<div class="list-group-item">${message("Store.name")}: ${order.store.name}</div>
				[#list order.orderItems as orderItem]
					<div class="list-group-item">
						<div class="media">
							<div class="media-left media-middle">
								<a href="${base}${orderItem.sku.path}">
									<img class="media-object img-thumbnail" src="${orderItem.thumbnail!setting.defaultThumbnailProductImage}" alt="${orderItem.name}">
								</a>
							</div>
							<div class="media-body media-middle">
								<h5 class="media-heading">
									<a href="${base}${orderItem.sku.path}">${orderItem.name}</a>
								</h5>
								[#if orderItem.specifications?has_content]
									<span class="small text-gray">[${orderItem.specifications?join(", ")}]</span>
								[/#if]
								[#if orderItem.type != "GENERAL"]
									<span class="small text-red">[${message("Product.Type." + orderItem.type)}]</span>
								[/#if]
							</div>
							<div class="media-right media-middle text-right">
								${currency(orderItem.price, true)}
								<span class="small text-gray">&times; ${orderItem.quantity}</span>
							</div>
						</div>
					</div>
				[/#list]
				<div class="list-group-item small">${message("common.createdDate")}: ${order.createdDate?string("yyyy-MM-dd HH:mm:ss")}</div>
			</div>
			<div class="list-group small">
				<div class="list-group-item">
					${message("member.order.quantity", order.quantity)}
					<span class="pull-right">
						${message("Order.amount")}:
						<span class="text-red">${currency(order.amount, true, true)}</span>
					</span>
				</div>
				[#if order.paymentMethodName?has_content || order.shippingMethodName?has_content]
					<div class="list-group-item">
						${message("Order.paymentMethod")}: ${(order.paymentMethodName)!"-"}
						<span class="pull-right">${message("Order.shippingMethod")}: ${(order.shippingMethodName)!"-"}</span>
					</div>
				[/#if]
				[#if order.invoice??]
					<div class="list-group-item">
						${message("Invoice.title")}: ${order.invoice.title}
						[#if order.tax > 0]
							<span class="pull-right">${message("Order.tax")}: ${currency(order.tax, true, true)}</span>
						[/#if]
					</div>
					<div class="list-group-item">${message("Invoice.taxNumber")}: ${order.invoice.taxNumber}</div>
				[/#if]
			</div>
			[#if order.orderShippings?has_content]
				<div class="list-group small">
					[#list order.orderShippings as orderShipping]
						<div class="list-group-item">
							${message("OrderShipping.deliveryCorp")}:
							[#if orderShipping.deliveryCorp??]
								${orderShipping.deliveryCorp}
							[#else]
								${orderShipping.deliveryCorp!"-"}
							[/#if]
							[#if isKuaidi100Enabled && orderShipping.deliveryCorpCode?has_content && orderShipping.trackingNo?has_content]
								<a class="transit-step" href="javascript:;" data-order-shipping-sn="${orderShipping.sn}">[${message("common.view")}]</a>
							[/#if]
							<span class="pull-right">
								${message("OrderShipping.trackingNo")}:
								[#if orderShipping.trackingNo??]
									${orderShipping.trackingNo}
								[#else]
									${orderShipping.trackingNo!"-"}
								[/#if]
							</span>
						</div>
					[/#list]
				</div>
			[/#if]
			<div class="list-group small">
				[#if order.fee > 0]
					<div class="list-group-item">
						${message("Order.fee")}
						<span class="pull-right">${currency(order.fee, true, true)}</span>
					</div>
				[/#if]
				[#if order.freight > 0]
					<div class="list-group-item">
						${message("Order.freight")}
						<span class="pull-right">${currency(order.freight, true, true)}</span>
					</div>
				[/#if]
				[#if order.promotionDiscount > 0]
					<div class="list-group-item">
						${message("Order.promotionDiscount")}
						<span class="pull-right">${currency(order.promotionDiscount, true, true)}</span>
					</div>
				[/#if]
				[#if order.couponDiscount > 0]
					<div class="list-group-item">
						${message("Order.couponDiscount")}
						<span class="pull-right">${currency(order.couponDiscount, true, true)}</span>
					</div>
				[/#if]
				[#if order.offsetAmount != 0]
					<div class="list-group-item">
						${message("Order.offsetAmount")}
						<span class="pull-right">${currency(order.offsetAmount, true, true)}</span>
					</div>
				[/#if]
				[#if order.amountPaid > 0]
					<div class="list-group-item">
						${message("Order.amountPaid")}
						<span class="pull-right">${currency(order.amountPaid, true, true)}</span>
					</div>
				[/#if]
				[#if order.refundAmount > 0]
					<div class="list-group-item">
						${message("Order.refundAmount")}
						<span class="pull-right">${currency(order.refundAmount, true, true)}</span>
					</div>
				[/#if]
				[#if order.amountPayable > 0]
					<div class="list-group-item">
						${message("Order.amountPayable")}
						<span class="pull-right text-red">${currency(order.amountPayable, true, true)}</span>
					</div>
				[/#if]
				[#if order.rewardPoint > 0]
					<div class="list-group-item">
						${message("Order.rewardPoint")}
						<span class="pull-right">${order.rewardPoint}</span>
					</div>
				[/#if]
				[#if order.exchangePoint > 0]
					<div class="list-group-item">
						${message("Order.exchangePoint")}
						<span class="pull-right text-red">${order.exchangePoint}</span>
					</div>
				[/#if]
				[#if order.couponCode??]
					<div class="list-group-item">
						${message("member.order.coupon")}
						<span class="pull-right">${order.couponCode.coupon.name}</span>
					</div>
				[/#if]
				[#if order.promotionNames?has_content]
					<div class="list-group-item">
						${message("member.order.promotion")}
						<span class="pull-right">${order.promotionNames?join(", ")}</span>
					</div>
				[/#if]
				[#if order.memo?has_content]
					<div class="list-group-item">
						${message("Order.memo")}
						<span class="pull-right">${order.memo}</span>
					</div>
				[/#if]
			</div>
		</div>
	</main>
	[#if (setting.isReviewEnabled && !order.isReviewed && (order.status == "RECEIVED" || order.status == "COMPLETED")) || (order.status == "RECEIVED" || order.status == "COMPLETED") || (order.paymentMethod?? && order.amountPayable > 0) || (!order.hasExpired() && (order.status == "PENDING_PAYMENT" || order.status == "PENDING_REVIEW")) || (!order.hasExpired() && order.status == "SHIPPED")]
		<footer class="footer-default" data-spy="scrollToFixed" data-bottom="0">
			[#if setting.isReviewEnabled && !order.isReviewed && (order.status == "RECEIVED" || order.status == "COMPLETED")]
				<a class="btn btn-default" href="${base}/member/review/add?orderId=${order.id}">${message("member.order.review")}</a>
			[/#if]
			[#if order.isReviewed && (order.status == "RECEIVED" || order.status == "COMPLETED")]
				<a class="btn btn-default" href="${base}/member/review/list">${message("member.order.viewReview")}</a>
			[/#if]
			[#if order.type == "GENERAL" && (order.status == "RECEIVED" || order.status == "COMPLETED")]
				<a class="btn btn-default" href="${base}/member/aftersales/apply?orderId=${order.id}">${message("member.order.aftersalesApply")}</a>
			[/#if]
			[#if !order.hasExpired() && (order.status == "PENDING_PAYMENT" || order.status == "PENDING_REVIEW")]
				<a id="cancel" class="btn btn-default btn-sm" href="javascript:;">${message("member.order.cancel")}</a>
			[/#if]
			[#if order.paymentMethod?? && order.amountPayable > 0]
				<a id="payment" class="btn btn-default btn-sm" href="javascript:;">${message("member.order.payment")}</a>
			[/#if]
			[#if !order.hasExpired() && order.status == "SHIPPED"]
				<a id="receive" class="btn btn-default btn-sm" href="javascript:;">${message("member.order.receive")}</a>
			[/#if]
		</footer>
	[/#if]
</body>
</html>