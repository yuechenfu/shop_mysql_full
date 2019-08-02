<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("shop.payment.pay")} - Powered By SHOP++</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/jquery.qrcode.js"></script>
	<style>
		.pay {
			background-color: #333333;
		}
		
		.pay .thumbnail {
			width: 276px;
			margin: 200px auto;
			border-radius: 0px;
			border: none;
			background-color: transparent;
		}
		
		.pay .thumbnail h5 {
			margin-bottom: 20px;
			color: #ffffff;
		}
		
		.pay .thumbnail .qrcode {
			padding: 6px;
			margin-bottom: 20px;
			background-color: #ffffff;
		}
		
		.pay .thumbnail .caption p {
			padding: 15px 10px;
			color: #ffffff;
			font-size: 14px;
			border-radius: 100px;
			background-color: #232323;
		}
	</style>	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
			
				var paymentTransactionSn = "${paymentTransactionSn}";
				var $qrcode = $("#qrcode");
				
				// 二维码
				$qrcode.qrcode({
					width: 256,
					height: 256,
					text: "${codeUrl}"
				});
				
				// 检查是否支付成功
				setInterval(function() {
					$.ajax({
						url: "${base}/payment/is_pay_success",
						data: {
							paymentTransactionSn: paymentTransactionSn
						},
						type: "GET",
						dataType: "json",
						cache: false,
						success: function(data) {
							if (data.isPaySuccess) {
								location.href = "${base}/payment/post_pay_" + paymentTransactionSn;
							}
						}
					});
				}, 10000);
			
			});
			</script>
		[/#escape]
	[/#noautoesc]
</head>
<body class="pay">
	<div class="thumbnail text-center">
		<h5>${message("shop.payment.weixinNativePayment")}</h5>
		<div id="qrcode" class="qrcode"></div>
		<div class="caption">
			<p>${message("shop.payment.weixinNativePaymentHint")}</p>
		</div>
	</div>
</body>
</html>