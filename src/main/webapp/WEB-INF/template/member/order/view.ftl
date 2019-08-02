<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.order.view")} - Powered By SHOP++</title>
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
	<script src="${base}/resources/common/js/bootbox.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/velocity.js"></script>
	<script src="${base}/resources/common/js/velocity.ui.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/member/js/base.js"></script>
	<style>
		.order-detail .action .btn {
			margin-right: 10px;
		}
		
		.order-detail .action .btn:last-child {
			margin-right: 0px;
		}
		
		.order-detail h5 {
			line-height: 30px;
			font-size: 14px;
		}
		
		.order-detail dt {
			line-height: 30px;
		}
		
		.order-detail dd {
			width: 50%;
			line-height: 30px;
			float: left;
		}
	</style>
	<script id="transitStepTemplate" type="text/template">
		<%if (_.isEmpty(data.transitSteps)) {%>
			<p class="text-gray">${message("common.noResult")}</p>
		<%} else {%>
			<%_.each(data.transitSteps, function(transitStep, i) {%>
				<div class="list-item">
					<p class="text-gray"><%-transitStep.time%></p>
					<p><%-transitStep.context%></p>
				</div>
			<%});%>
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
							orderSn: "${order.sn}"
						},
						dataType: "json",
						cache: false,
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
							cache: false,
							success: function() {
								location.reload(true);
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
							cache: false,
							success: function() {
								location.reload(true);
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
	[#include "/shop/include/main_header.ftl" /]
	<main>
		<div class="container">
			<div id="transitStepModal" class="modal fade" tabindex="-1">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<button class="close" type="button" data-dismiss="modal">&times;</button>
							<h5 class="modal-title">${message("member.order.transitStep")}</h5>
						</div>
						<div class="modal-body"></div>
						<div class="modal-footer">
							<button class="btn btn-default" type="button" data-dismiss="modal">${message("member.order.close")}</button>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-xs-2">
					[#include "/member/include/main_menu.ftl" /]
				</div>
				<div class="col-xs-10">
					<form action="${base}/member/order/view" method="get">
						<div class="order-detail panel panel-default">
							<div class="panel-heading">${message("member.order.view")}</div>
							<div class="panel-body">
								<div class="list-group">
									<div class="list-group-item clearfix">
										<span class="pull-left">${message("Order.sn")}: ${order.sn}</span>
										<span class="action pull-right">
											[#if setting.isReviewEnabled && !order.isReviewed && (order.status == "RECEIVED" || order.status == "COMPLETED")]
												<a class="btn btn-default" href="${base}/member/review/add?orderId=${order.id}">${message("member.order.review")}</a>
											[/#if]
											[#if order.type == "GENERAL" && (order.status == "RECEIVED" || order.status == "COMPLETED")]
												<a class="btn btn-default" href="${base}/member/aftersales/apply?orderId=${order.id}">${message("member.order.aftersalesApply")}</a>
											[/#if]
											[#if order.paymentMethod?? && order.amountPayable > 0]
												<a id="payment" class="btn btn-primary" href="javascript:;">${message("member.order.payment")}</a>
											[/#if]
											[#if !order.hasExpired() && (order.status == "PENDING_PAYMENT" || order.status == "PENDING_REVIEW")]
												<a id="cancel" class="btn btn-default" href="javascript:;">${message("member.order.cancel")}</a>
											[/#if]
											[#if !order.hasExpired() && order.status == "SHIPPED"]
												<a id="receive" class="btn btn-default" href="javascript:;">${message("member.order.receive")}</a>
											[/#if]
										</span>
									</div>
									<div class="list-group-item">
										[#if order.hasExpired()]
											<h5 class="text-gray-dark">${message("member.order.hasExpired")}</h5>
										[#else]
											<h5 class="[#if order.status == "PENDING_SHIPMENT" || order.status == "PENDING_REVIEW" || order.status == "PENDING_PAYMENT"]text-orange[#elseif order.status == "FAILED" || order.status == "DENIED"]text-red[#elseif order.status == "CANCELED"]text-gray-dark[#else]text-green[/#if]">${message("Order.Status." + order.status)}</h5>
										[/#if]
										<p>
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
											[#if order.expire?? && !order.hasExpired()]
												<span class="text-orange">(${message("Order.expire")}: ${order.expire?string("yyyy-MM-dd HH:mm:ss")})</span>
											[/#if]
										</p>
									</div>
									<div class="list-group-item">
										<dl class="clearfix">
											<dt>${message("member.order.info")}</dt>
											<dd>
												${message("common.createdDate")}:
												<span class="text-gray-darker">${order.createdDate?string("yyyy-MM-dd HH:mm:ss")}</span>
											</dd>
											[#if order.paymentMethodName??]
												<dd>
													${message("Order.paymentMethod")}:
													<span class="text-gray-darker">${order.paymentMethodName}</span>
												</dd>
											[/#if]
											[#if order.shippingMethodName??]
												<dd>
													${message("Order.shippingMethod")}:
													<span class="text-gray-darker">${order.shippingMethodName}</span>
												</dd>
											[/#if]
											<dd>
												${message("Order.price")}:
												<span class="text-gray-darker">${currency(order.price, true, true)}</span>
											</dd>
											[#if order.fee > 0]
												<dd>
													${message("Order.fee")}:
													<span class="text-gray-darker">${currency(order.fee, true, true)}</span>
												</dd>
											[/#if]
											[#if order.freight > 0]
												<dd>
													${message("Order.freight")}:
													<span class="text-gray-darker">${currency(order.freight, true, true)}</span>
												</dd>
											[/#if]
											[#if order.promotionDiscount > 0]
												<dd>
													${message("Order.promotionDiscount")}:
													<span class="text-gray-darker">${currency(order.promotionDiscount, true, true)}</span>
												</dd>
											[/#if]
											[#if order.couponDiscount > 0]
												<dd>
													${message("Order.couponDiscount")}:
													<span class="text-gray-darker">${currency(order.couponDiscount, true, true)}</span>
												</dd>
											[/#if]
											[#if order.offsetAmount != 0]
												<dd>
													${message("Order.offsetAmount")}:
													<span class="text-gray-darker">${currency(order.offsetAmount, true, true)}</span>
												</dd>
											[/#if]
											<dd>
												${message("Order.amount")}:
												<span class="text-gray-darker">${currency(order.amount, true, true)}</span>
											</dd>
											[#if order.amountPaid > 0]
												<dd>
													${message("Order.amountPaid")}:
													<span class="text-red">${currency(order.amountPaid, true, true)}</span>
												</dd>
											[/#if]
											[#if order.refundAmount > 0]
												<dd>
													${message("Order.refundAmount")}:
													<span class="text-gray-darker">${currency(order.refundAmount, true, true)}</span>
												</dd>
											[/#if]
											[#if order.amountPayable > 0]
												<dd>
													${message("Order.amountPayable")}:
													<span class="text-red">${currency(order.amountPayable, true, true)}</span>
												</dd>
											[/#if]
											[#if order.rewardPoint > 0]
												<dd>
													${message("Order.rewardPoint")}:
													<span class="text-gray-darker">${order.rewardPoint}</span>
												</dd>
											[/#if]
											[#if order.exchangePoint > 0]
												<dd>
													${message("Order.exchangePoint")}:
													<span class="text-gray-darker">${order.exchangePoint}</span>
												</dd>
											[/#if]
											[#if order.couponCode??]
												<dd>
													${message("member.order.coupon")}:
													<span class="text-gray-darker">${order.couponCode.coupon.name}</span>
												</dd>
											[/#if]
											[#if order.promotionNames?has_content]
												<dd>
													${message("member.order.promotion")}:
													<span class="text-gray-darker">${order.promotionNames?join(", ")}</span>
												</dd>
											[/#if]
											[#if order.memo?has_content]
												<dd>
													${message("Order.memo")}:
													<span class="text-gray-darker">${order.memo}</span>
												</dd>
											[/#if]
										</dl>
									</div>
									[#if order.invoice??]
										<div class="list-group-item">
											<dl class="clearfix">
												<dt>${message("member.order.invoiceInfo")}</dt>
												<dd>
													${message("Invoice.title")}:
													<span class="text-gray-darker">${order.invoice.title}</span>
												</dd>
												<dd>
													${message("Invoice.taxNumber")}:
													<span class="text-gray-darker">${order.invoice.taxNumber}</span>
												</dd>
												<dd>
													${message("Order.tax")}:
													<span class="text-gray-darker">${currency(order.tax, true, true)}</span>
												</dd>
											</dl>
										</div>
									[/#if]
									[#if order.isDelivery]
										<div class="list-group-item">
											<dl class="clearfix">
												<dt>${message("member.order.receiveInfo")}</dt>
												<dd>
													${message("Order.consignee")}:
													<span class="text-gray-darker">${order.consignee}</span>
												</dd>
												<dd>
													${message("Order.zipCode")}:
													<span class="text-gray-darker">${order.zipCode}</span>
												</dd>
												<dd>
													${message("Order.address")}:
													<span class="text-gray-darker">${order.areaName}${order.address}</span>
												</dd>
												<dd>
													${message("Order.phone")}:
													<span class="text-gray-darker">${order.phone}</span>
												</dd>
											</dl>
										</div>
									[/#if]
									[#if order.orderShippings?has_content]
										<div class="list-group-item">
											<dl class="clearfix">
												<dt>${message("member.order.transitStepInfo")}</dt>
												[#list order.orderShippings as orderShipping]
													<dd>
														${message("OrderShipping.deliveryCorp")}:
														[#if orderShipping.deliveryCorpUrl??]
															<a href="${orderShipping.deliveryCorpUrl}" target="_blank">${orderShipping.deliveryCorp}</a>
														[#else]
															${orderShipping.deliveryCorp!"-"}
														[/#if]
													</dd>
													<dd>
														${message("OrderShipping.trackingNo")}:
														${orderShipping.trackingNo!"-"}
														[#if isKuaidi100Enabled && orderShipping.deliveryCorpCode?has_content && orderShipping.trackingNo?has_content]
															<a class="transit-step text-orange" href="javascript:;" data-order-shipping-sn="${orderShipping.sn}">[${message("member.order.transitStep")}]</a>
														[/#if]
													</dd>
													<dd>${message("member.order.deliveryDate")}: ${orderShipping.createdDate?string("yyyy-MM-dd HH:mm:ss")}</dd>
													<dd>&nbsp;</dd>
												[/#list]
											</dl>
										</div>
									[/#if]
								</div>
							</div>
						</div>
						<div class="panel panel-default">
							<div class="panel-body">
								<table class="table">
									<thead>
										<tr>
											<th>${message("member.order.product")}</th>
											<th>${message("OrderItem.name")}</th>
											<th>${message("OrderItem.price")}</th>
											<th>${message("OrderItem.quantity")}</th>
											<th>${message("OrderItem.subtotal")}</th>
										</tr>
									</thead>
									<tbody>
										[#list order.orderItems as orderItem]
											<tr>
												<td>
													[#if orderItem.sku??]
														<a href="${base}${orderItem.sku.path}" title="${orderItem.name}" target="_blank">
															<img class="img-thumbnail" src="${orderItem.thumbnail!setting.defaultThumbnailProductImage}" alt="${orderItem.name}">
														</a>
													[#else]
														<img class="img-thumbnail" src="${orderItem.thumbnail!setting.defaultThumbnailProductImage}" alt="${orderItem.name}">
													[/#if]
												</td>
												<td>
													[#if orderItem.sku??]
														<a href="${base}${orderItem.sku.path}" target="_blank">${orderItem.name}</a>
													[#else]
														${orderItem.name}
													[/#if]
													[#if orderItem.specifications?has_content]
														<span class="text-gray">[${orderItem.specifications?join(", ")}]</span>
													[/#if]
													[#if orderItem.type != "GENERAL"]
														<span class="text-red">[${message("Product.Type." + orderItem.type)}]</span>
													[/#if]
												</td>
												<td>
													[#if orderItem.type == "GENERAL"]
														${currency(orderItem.price, true)}
													[#else]
														-
													[/#if]
												</td>
												<td>${orderItem.quantity}</td>
												<td>
													[#if orderItem.type == "GENERAL"]
														${currency(orderItem.subtotal, true)}
													[#else]
														-
													[/#if]
												</td>
											</tr>
										[/#list]
									</tbody>
								</table>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</main>
	[#include "/shop/include/main_footer.ftl" /]
</body>
</html>