<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business." + promotionPlugin.id + ".buy")} - Powered By SHOP++</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/awesome-bootstrap-checkbox.css" rel="stylesheet">
	<link href="${base}/resources/common/css/bootstrap-spinner.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/business/css/base.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/bootstrap-growl.js"></script>
	<script src="${base}/resources/common/js/moment.js"></script>
	<script src="${base}/resources/common/js/jquery.spinner.js"></script>
	<script src="${base}/resources/common/js/jquery.nicescroll.js"></script>
	<script src="${base}/resources/common/js/jquery.validate.js"></script>
	<script src="${base}/resources/common/js/jquery.validate.additional.js"></script>
	<script src="${base}/resources/common/js/jquery.form.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/velocity.js"></script>
	<script src="${base}/resources/common/js/velocity.ui.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/business/js/base.js"></script>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
				
				[#if currentStore.endDate??]
					var $payConfirmModal = $("#payConfirmModal");
					var $moneyOffPromotionForm = $("#moneyOffPromotionForm");
					var $paymentPluginId = $("#paymentPluginId");
					var $svcSn = $("#svcSn");
					var $spinner = $("[data-trigger='spinner']");
					var $months = $("#months");
					var $amount = $("#amount");
					var $feeItem = $("#feeItem");
					var $fee = $("#fee");
					var $useBalance = $("#useBalance");
					var $paymentPlugin = $("#paymentPlugin");
					var $paymentPluginItem = $("#paymentPlugin div.media");
					var currentEndDate = ${(pluginEndDate?long)!0};
					
					// 购买时长
					$spinner.spinner("changing", function(event, newValue, oldValue) {
						calculate();
					});
					
					// 使用余额
					$useBalance.change(function() {
						calculate();
					});
					
					// 支付插件
					$paymentPluginItem.click(function() {
						var $element = $(this);
						var paymentPluginId = $element.data("payment-plugin-id");
						
						$element.addClass("active").siblings().removeClass("active");
						$paymentPluginId.val(paymentPluginId);
						calculate();
					});
					
					// 计算
					var calculate = _.debounce(function() {
						if (!$moneyOffPromotionForm.valid()) {
							return;
						}
						$.ajax({
							url: "${base}/business/promotion_plugin/calculate",
							type: "GET",
							data: {
								promotionPluginId: "${promotionPlugin.id}",
								paymentPluginId: $paymentPluginId.val(),
								months: $months.val(),
								useBalance: $useBalance.prop("checked")
							},
							dataType: "json",
							success: function(data) {
								$amount.text($.currency(data.amount, true, true));
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
								if (data.amount > 0 && !data.useBalance) {
									if ($paymentPlugin.is(":hidden")) {
										$paymentPlugin.velocity("slideDown");
									}
								} else {
									if ($paymentPlugin.is(":visible")) {
										$paymentPlugin.velocity("slideUp");
									}
								}
							}
						});
					}, 200);
					
					calculate();
					
					// 检查到期日期
					setInterval(function() {
						$.ajax({
							url: "${base}/business/promotion_plugin/end_date?promotionPluginId=${promotionPlugin.id}",
							type: "GET",
							dataType: "json",
							success: function(data) {
								if (moment(data.endDate).isAfter(currentEndDate)) {
									location.href = "${base}/business/promotion_plugin/list?promotionPluginId=${promotionPlugin.id}";
								}
							}
						});
					}, 10000);
					
					// 表单验证
					$moneyOffPromotionForm.validate({
						submitHandler: function(form) {
							$.ajax({
								url: "${base}/business/promotion_plugin/buy",
								type: "POST",
								data: {
									promotionPluginId: "${promotionPlugin.id}",
									months: $months.val(),
									useBalance: $useBalance.prop("checked")
								},
								dataType: "json",
								async: false,
								success: function(data) {
									if (data.promotionPluginSvcSn != null) {
										$payConfirmModal.modal({
											backdrop: "static",
											keyboard: false
										}).modal("show");
										$svcSn.val(data.promotionPluginSvcSn);
										form.submit();
									} else {
										location.href = "${base}/business/promotion_plugin/list?promotionPluginId=${promotionPlugin.id}";
									}
								}
							});
						}
					});
				[/#if]
			
			});
			</script>
		[/#escape]
	[/#noautoesc]
</head>
<body class="business">
	[#include "/business/include/main_header.ftl" /]
	[#include "/business/include/main_sidebar.ftl" /]
	<main>
		<div class="container-fluid">
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
							<a class="btn btn-primary" href="${base}/business/promotion_plugin/list?promotionPluginId=${promotionPlugin.id}">${message("PayConfirmModal.complete")}</a>
							<a class="btn btn-default" href="${base}/">${message("PayConfirmModal.problem")}</a>
						</div>
					</div>
				</div>
			</div>
			<ol class="breadcrumb">
				<li>
					<a href="${base}/business/index">
						<i class="iconfont icon-homefill"></i>
						${message("common.breadcrumb.index")}
					</a>
				</li>
				<li class="active">${message("business." + promotionPlugin.id + ".buy")}</li>
			</ol>
			<form id="moneyOffPromotionForm" class="form-horizontal" action="${base}/payment" method="post" target="_blank">
				<input id="paymentPluginId" name="paymentPluginId" type="hidden" value="${defaultPaymentPlugin.id}">
				<input name="paymentItemList[0].type" type="hidden" value="SVC_PAYMENT">
				<input id="svcSn" name="paymentItemList[0].svcSn" type="hidden">
				<input name="rePayUrl" type="hidden" value="${base}/business/promotion_plugin/buy">
				<div class="panel panel-default">
					<div class="panel-heading">${message("business." + promotionPlugin.id + ".buy")}</div>
					<div class="panel-body">
						[#if currentStore.endDate??]
							[#if pluginEndDate??]
								<div class="form-group">
									<label class="col-xs-3 col-sm-2 control-label">${message("Store.moneyOffPromotionEndDate")}:</label>
									<div class="col-xs-9 col-sm-4">
										<p class="form-control-static text-orange">${pluginEndDate?string("yyyy-MM-dd HH:mm:ss")}</p>
									</div>
								</div>
							[/#if]
							<div class="form-group">
								<label class="col-xs-3 col-sm-2 control-label">${message("PromotionPlugin.serviceCharge")}:</label>
								<div class="col-xs-9 col-sm-4">
									<p class="form-control-static">${message("business." + promotionPlugin.id + ".serviceCharge", currency(promotionPlugin.serviceCharge, true, true))}</p>
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-3 col-sm-2 control-label item-required" for="months">${message("business." + promotionPlugin.id + ".months")}:</label>
								<div class="col-xs-9 col-sm-4">
									<div class="spinner input-group input-group-sm" title="${message("business." + promotionPlugin.id + ".monthsTitle")}" data-trigger="spinner" data-toggle="tooltip">
										<input id="months" class="form-control" type="text" maxlength="5" data-rule="quantity" data-min="1" data-max="99">
										<span class="input-group-addon">
											<a class="spin-up" href="javascript:;" data-spin="up">
												<i class="fa fa-caret-up"></i>
											</a>
											<a class="spin-down" href="javascript:;" data-spin="down">
												<i class="fa fa-caret-down"></i>
											</a>
										</span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-3 col-sm-2 control-label">${message("business." + promotionPlugin.id + ".amount")}:</label>
								<div class="col-xs-9 col-sm-4">
									<p id="amount" class="form-control-static text-red"></p>
								</div>
							</div>
							[#if promotionPlugin.serviceCharge > 0]
								<div id="feeItem" class="hidden-element form-group">
									<label class="col-xs-3 col-sm-2 control-label">${message("business." + promotionPlugin.id + ".fee")}:</label>
									<div class="col-xs-9 col-sm-4">
										<p id="fee" class="form-control-static text-red"></p>
									</div>
								</div>
								[#if currentUser.availableBalance > 0]
									<div class="form-group">
										<label class="col-xs-3 col-sm-2 control-label">${message("business." + promotionPlugin.id + ".useBalance")}:</label>
										<div class="col-xs-9 col-sm-4">
											<div class="checkbox">
												<input id="useBalance" name="useBalance" type="checkbox" value="true">
												<label></label>
											</div>
										</div>
									</div>
								[/#if]
								[#if paymentPlugins?has_content]
									<div id="paymentPlugin" class="payment-plugin hidden-element">
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
							[/#if]
						[#else]
							<span class="text-red">${message("business." + promotionPlugin.id + ".noBuy")}</span>
						[/#if]
					</div>
					<div class="panel-footer">
						<div class="row">
							<div class="col-xs-9 col-sm-10 col-xs-offset-3 col-sm-offset-2">
								[#if currentStore.endDate??]
									<button class="btn btn-primary" type="submit">${message("common.submit")}</button>
								[/#if]
								<button class="btn btn-default" type="button" data-action="back">${message("common.back")}</button>
							</div>
						</div>
					</div>
				</div>
			</form>
		</div>
	</main>
</body>
</html>