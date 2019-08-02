<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.memberDeposit.recharge")}[#if showPowered] - Powered By SHOP++[/#if]</title>
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
	<script src="${base}/resources/common/js/jquery.validate.js"></script>
	<script src="${base}/resources/common/js/jquery.validate.additional.js"></script>
	<script src="${base}/resources/common/js/jquery.form.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/velocity.js"></script>
	<script src="${base}/resources/common/js/velocity.ui.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/mobile/member/js/base.js"></script>
	<style>
		.list-group .icon-roundcheck {
			font-size: 18px;
			-webkit-transition: color 0.5s;
			transition: color 0.5s;
		}
		
		.list-group-item {
			padding: 10px;
		}
		
		.list-group-item .media-object {
			width: 100px;
			overflow: hidden;
		}
		
		.list-group-item .media-object img {
			max-width: 100%;
			border: solid 1px #e8e8e8;
		}
		
		.list-group-item.active .icon-roundcheck {
			color: #dd0000;
		}
	</style>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
				
				var $rechargeForm = $("#rechargeForm");
				var $paymentPluginId = $("#paymentPluginId");
				var $rechargeAmount = $("#rechargeAmount");
				var $feeItem = $("#feeItem");
				var $fee = $("#fee");
				var $paymentPluginItem = $("#paymentPlugin div.list-group-item");
				
				// 充值金额
				$rechargeAmount.on("input propertychange change", function(event) {
					if (event.type != "propertychange" || event.originalEvent.propertyName == "value") {
						calculateFee();
					}
				});
				
				// 支付插件
				$paymentPluginItem.click(function() {
					var $element = $(this);
					var paymentPluginId = $element.data("payment-plugin-id");
					
					$element.addClass("active").siblings().removeClass("active");
					$paymentPluginId.val(paymentPluginId);
					calculateFee();
				});
				
				// 计算支付手续费
				var calculateFee = _.debounce(function() {
					if (!$.isNumeric($rechargeAmount.val()) || !$rechargeForm.validate().element($rechargeAmount)) {
						if ($feeItem.is(":visible")) {
							$feeItem.velocity("slideUp");
						}
						return;
					}
					$.ajax({
						url: "${base}/member/member_deposit/calculate_fee",
						type: "POST",
						data: {
							paymentPluginId: $paymentPluginId.val(),
							rechargeAmount: $rechargeAmount.val()
						},
						dataType: "json",
						success: function(data) {
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
				}, 200);
				
				// 表单验证
				$rechargeForm.validate({
					rules: {
						"paymentItemList[0].amount": {
							required: true,
							positive: true,
							decimal: {
								integer: 12,
								fraction: ${setting.priceScale}
							}
						}
					}
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
					<a href="${base}/member/index">
						<i class="iconfont icon-back"></i>
					</a>
				</div>
				<div class="col-xs-10">
					<h5>${message("member.memberDeposit.recharge")}</h5>
				</div>
			</div>
		</div>
	</header>
	<main>
		<div class="container-fluid">
			<form id="rechargeForm" action="${base}/payment" method="post">
				<input name="paymentItemList[0].type" type="hidden" value="DEPOSIT_RECHARGE">
				<input id="paymentPluginId" name="paymentPluginId" type="hidden" value="${defaultPaymentPlugin.id}">
				<input name="rePayUrl" type="hidden" value="${base}/member/member_deposit/recharge">
				<div class="list-group">
					<div class="list-group-item">
						<div class="form-group">
							<label class="item-required" for="rechargeAmount">${message("member.memberDeposit.rechargeAmount")}</label>
							<input id="rechargeAmount" name="paymentItemList[0].amount" class="form-control" type="text" maxlength="16" onpaste="return false;">
						</div>
					</div>
					<div id="feeItem" class="fee-item list-group-item hidden-element">
						${message("member.memberDeposit.fee")}:
						<span id="fee" class="text-red"></span>
					</div>
					<div class="list-group-item small">
						${message("member.memberDeposit.balance")}: <span class="text-red">${currency(currentUser.balance, true, true)}</span>
					</div>
				</div>
				[#if paymentPlugins??]
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
												<span class="small" title="${paymentPlugin.description}">${abbreviate(paymentPlugin.description, 30, "...")}</span>
											</div>
											<div class="media-right media-middle">
												<i class="iconfont icon-roundcheck"></i>
											</div>
										</div>
									</div>
								[/#list]
							</div>
						</div>
						<div class="panel-footer text-center">
							<button class="btn btn-primary" type="submit">${message("common.submit")}</button>
							<a class="btn btn-default" href="${base}/member/index">${message("common.back")}</a>
						</div>
					</div>
				[/#if]
			</form>
		</div>
	</main>
</body>
</html>