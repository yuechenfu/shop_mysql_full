<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("shop.payment.payResult")}[#if showPowered] - Powered By SHOP++[/#if]</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/payment.css" rel="stylesheet">
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
	<script id="panelHeadingTemplate" type="text/template">
		<%if (isPaySuccess) {%>
			<h3 class="panel-title text-green">
				<i class="iconfont icon-check"></i>
				${message("shop.payment.success")}
			</h3>
		<%} else {%>
			<h3 class="panel-title text-orange">${message("shop.payment.wait")}</h3>
		<%}%>
	</script>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
				
				var $payConfirmModal = $("#payConfirmModal");
				var $panelHeading = $("#panelHeading");
				var panelHeadingTemplate = _.template($("#panelHeadingTemplate").html());
				var payConfirmModalShow = _.once(function() {
					$payConfirmModal.modal({
						backdrop: "static",
						keyboard: false
					}).modal("show");
				});
				
				// 检查是否支付成功
				function checkIsPaySuccess() {
					$.ajax({
						url: "${base}/payment/is_pay_success",
						data: {
							paymentTransactionSn: "${paymentTransaction.sn}"
						},
						type: "GET",
						dataType: "json",
						cache: false,
						success: function(data) {
							if (!data.isPaySuccess) {
								payConfirmModalShow();
							} else {
								$payConfirmModal.modal("hide");
							}
							$panelHeading.html(panelHeadingTemplate({
								isPaySuccess: data.isPaySuccess
							}));
						}
					});
				}
				
				// 检查是否支付成功
				checkIsPaySuccess();
				
				setInterval(function() {
					checkIsPaySuccess();
				}, 5000);
			
			});
			</script>
		[/#escape]
	[/#noautoesc]
</head>
<body class="shop pay-result">
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
							<a class="btn btn-primary" href="javascript:;" data-dismiss="modal">${message("PayConfirmModal.complete")}</a>
							[#if paymentTransaction.rePayUrl?has_content]
								<a class="btn btn-default" href="${rePayUrl}">${message("PayConfirmModal.rePay")}</a>
							[#else]
								<a class="btn btn-default" href="${base}/">${message("PayConfirmModal.problem")}</a>
							[/#if]
						</div>
					</div>
				</div>
			</div>
			<div class="panel panel-default">
				<div id="panelHeading" class="panel-heading"></div>
				<div class="panel-body">
					<dl class="dl-horizontal">
						<dt>${message("PaymentTransaction.amount")}</dt>
						<dd>
							<strong class="text-red">${currency(paymentTransaction.amount, true, true)}</strong>
						</dd>
						<dt>${message("PaymentTransaction.sn")}</dt>
						<dd>${paymentTransaction.sn}</dd>
						[#if paymentTransaction.type??]
							<dt>${message("PaymentTransaction.type")}</dt>
							<dd>${message("PaymentTransaction.Type." + paymentTransaction.type)}</dd>
						[/#if]
						<dt>${message("shop.payment.paymentPluginName")}</dt>
						<dd>${paymentTransaction.paymentPluginName}</dd>
						[#if paymentTransaction.fee > 0]
							<dt>${message("PaymentTransaction.fee")}</dt>
							<dd>
								<span class="text-red">${currency(paymentTransaction.fee, true, true)}</span>
							</dd>
						[/#if]
					</dl>
				</div>
			</div>
		</div>
	</main>
	[#include "/shop/include/main_footer.ftl" /]
</body>
</html>