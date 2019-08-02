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
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/payment.css" rel="stylesheet">
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
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/mobile/shop/js/base.js"></script>
	<script id="panelHeadingTemplate" type="text/template">
		<%if (isPaySuccess) {%>
			<i class="iconfont icon-check"></i>
			<span class="text-green">${message("shop.payment.success")}</span>
		<%} else {%>
			<span class="text-orange">${message("shop.payment.wait")}</span>
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
	<header class="header-default" data-spy="scrollToFixed">
		<h5>${message("shop.payment.payResult")}</h5>
	</header>
	<main>
		<div class="container-fluid">
			<div id="payConfirmModal" class="pay-confirm-modal modal fade" tabindex="-1">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title">${message("PayConfirmModal.payConfirm")}</h5>
						</div>
						<div class="modal-body">
							<a class="text-red" href="javascript:;" data-dismiss="modal">${message("PayConfirmModal.complete")}</a>
							[#if paymentTransaction.rePayUrl?has_content]
								<a href="${paymentTransaction.rePayUrl}">${message("PayConfirmModal.rePay")}</a>
							[#else]
								<a href="${base}/">${message("PayConfirmModal.problem")}</a>
							[/#if]
						</div>
					</div>
				</div>
			</div>
			<div class="panel panel-default">
				<div id="panelHeading" class="panel-heading"></div>
				<div class="panel-body">
					<p>
						${message("PaymentTransaction.amount")}
						<strong>${currency(paymentTransaction.amount, true, true)}</strong>
					</p>
					<dl>
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
	<footer class="footer-default" data-spy="scrollToFixed" data-bottom="0">
		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-3">
					<a href="${base}/">
						<i class="iconfont icon-home center-block"></i>
						<span class="center-block">${message("shop.footer.home")}</span>
					</a>
				</div>
				<div class="col-xs-3">
					<a href="${base}/product_category">
						<i class="iconfont icon-sort center-block"></i>
						<span class="center-block">${message("shop.footer.productCategory")}</span>
					</a>
				</div>
				<div class="col-xs-3">
					<a href="${base}/cart/list">
						<i class="iconfont icon-cart center-block"></i>
						<span class="center-block">${message("shop.footer.cart")}</span>
					</a>
				</div>
				<div class="col-xs-3">
					<a href="${base}/member/index">
						<i class="iconfont icon-people center-block"></i>
						<span class="center-block">${message("shop.footer.member")}</span>
					</a>
				</div>
			</div>
		</div>
	</footer>
</body>
</html>