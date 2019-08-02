<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("shop.order.checkout")}[#if showPowered] - Powered By SHOP++[/#if]</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/awesome-bootstrap-checkbox.css" rel="stylesheet">
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
	<script src="${base}/resources/common/js/jquery.lSelect.js"></script>
	<script src="${base}/resources/common/js/jquery.validate.js"></script>
	<script src="${base}/resources/common/js/jquery.validate.additional.js"></script>
	<script src="${base}/resources/common/js/jquery.form.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/velocity.js"></script>
	<script src="${base}/resources/common/js/velocity.ui.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/mobile/shop/js/base.js"></script>
	<script id="currentReceiverTemplate" type="text/template">
		<div class="media">
			<div class="media-left media-middle">
				<i class="iconfont icon-location"></i>
			</div>
			<div class="media-body media-middle">
				<h5 class="media-heading">
					<%-currentReceiver.consignee%>
					<span class="pull-right"><%-currentReceiver.phone%></span>
				</h5>
				<span class="small"><%-currentReceiver.areaName%><%-currentReceiver.address%></span>
			</div>
			<div class="media-right media-middle">
				<i class="iconfont icon-right"></i>
			</div>
		</div>
	</script>
	<script id="receiverListTemplate" type="text/template">
		<%_.each(receivers, function(receiver, i) {%>
			<div class="<%-receiver.id == currentReceiverId ? "active " : ""%>list-group-item" data-receiver="<%-JSON.stringify(receiver)%>">
				<div class="media">
					<div class="media-body media-middle">
						<h5 class="media-heading">
							<%-receiver.consignee%>
							<span class="pull-right"><%-receiver.phone%></span>
						</h5>
						<span class="small"><%-receiver.areaName%><%-receiver.address%></span>
					</div>
					<div class="media-right media-middle">
						<i class="iconfont icon-roundcheck"></i>
					</div>
				</div>
			</div>
		<%});%>
	</script>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
				
				var $togglePage = $("[data-toggle='page']");
				var $toggleItem = $("[data-toggle='item']");
				var $scrollToFixedFooter = $("footer[data-spy='scrollToFixed']");
				var $selection = $("div.selection");
				var $orderForm = $("#orderForm");
				var $receiverId = $("#receiverId");
				var $paymentMethodId = $("#paymentMethodId");
				var $shippingMethodId = $("#shippingMethodId");
				var $currentReceiver = $("#currentReceiver");
				var $currentPaymentMethod = $("#currentPaymentMethod");
				var $currentShippingMethod = $("#currentShippingMethod");
				var $invoiceTitle = $("#invoiceTitle");
				var $couponName = $("#couponName");
				var $couponCode = $("#couponCode");
				var $useBalanceItem = $("#useBalanceItem");
				var $balance = $("#balance");
				var $promotionDiscount = $("#promotionDiscount");
				var $couponDiscount = $("#couponDiscount");
				var $tax = $("#tax");
				var $freight = $("#freight");
				var $amountPayable = $("#amountPayable");
				var $exchangePoint = $("#exchangePoint");
				var $receiverList = $("#receiverPage .list-group");
				var $addReceiverForm = $("#addReceiverForm");
				var $areaId = $("#areaId");
				var $paymentMethodItem = $("#paymentMethodPage .list-group-item");
				var $shippingMethodItem = $("#shippingMethodPage .list-group-item");
				var currentReceiverTemplate = _.template($("#currentReceiverTemplate").html());
				var receiverListTemplate = _.template($("#receiverListTemplate").html());
				var amount = ${amount};
				var amountPayable = ${amountPayable};
				var paymentMethodIds = {};
				[@compress single_line = true]
					[#list shippingMethods as shippingMethod]
						paymentMethodIds["${shippingMethod.id}"] = [
							[#list shippingMethod.paymentMethods as paymentMethod]
								${paymentMethod.id}[#if paymentMethod_has_next],[/#if]
							[/#list]
						];
					[/#list]
				[/@compress]
				
				[#if isDelivery]
					// 加载收货地址
					loadReceiver();
				[/#if]
				
				// 切换页面
				$togglePage.click(function() {
					var $element = $(this);
					
					togglePage($element.data("target"));
				});
				
				// 切换页面
				var toggling = false;
				function togglePage(target) {
					if (toggling) {
						return;
					}
					toggling = true;
					$(target).velocity("fadeIn", {
						begin: function() {
							$(this).css("z-index", 200);
							$scrollToFixedFooter.hide();
						},
						complete: function() {
							$scrollToFixedFooter.show().trigger("resize");
							$(this).siblings(".page:visible").hide().end().css("z-index", 100);
							toggling = false;
						}
					});
				}
				
				// 切换条目
				$toggleItem.click(function() {
					var $element = $(this);
					
					$element.toggleClass("active");
					$target = $($element.data("target"));
					if ($element.hasClass("active")) {
						$target.velocity("slideDown").find("input").prop("disabled", false);
					} else {
						$target.velocity("slideUp").find("input").prop("disabled", true);
					}
					calculate();
				});
				
				// 可选列表
				$selection.on("click", ".list-group-item", function() {
					var $element = $(this);
					if ($element.hasClass("disabled")) {
						return;
					}
					
					$element.addClass("active").siblings().removeClass("active");
					togglePage("#mainPage");
					calculate();
				});
				
				// 发票抬头
				$invoiceTitle.focus(function() {
					var $element = $(this);
					
					if ($.trim($element.val()) === "${message("shop.order.defaultInvoiceTitle")}") {
						$element.val("");
					}
				});
				
				// 发票抬头
				$invoiceTitle.blur(function() {
					var $element = $(this);
					
					if ($.trim($element.val()) === "") {
						$element.val("${message("shop.order.defaultInvoiceTitle")}");
					}
				});
				
				// 优惠券名称
				$couponName.click(function() {
					var $element = $(this);
					
					$element.velocity("fadeOut", {
						complete: function() {
							$couponCode.show().focus();
						}
					});
				});
				
				// 优惠码
				$couponCode.blur(function() {
					var $element = $(this);
					
					if ($.trim($element.val()) != "") {
						$.get("${base}/order/check_coupon", {
							[#if skuId??]
								skuId: ${skuId},
								quantity: ${quantity},
							[/#if]
							code: $element.val()
						}).done(function(data) {
							$couponCode.hide();
							$couponName.text(data.couponName).velocity("fadeIn", {
								display: "inline-block"
							});
							calculate();
						});
					} else {
						calculate();
					}
				});
				
				// 余额
				$balance.change(function() {
					var $element = $(this);
					
					if (/^\d+(\.\d{0,${setting.priceScale}})?$/.test($element.val())) {
						var max = ${currentUser.availableBalance} >= amount ? amount : ${currentUser.availableBalance};
						if (parseFloat($element.val()) > max) {
							$element.val(max);
						}
					} else {
						$element.val("0");
					}
					calculate();
				});
				
				// 收货地址列表
				$receiverList.on("click", ".list-group-item", function() {
					var $element = $(this);
					var receiver = $element.data("receiver");
					
					$receiverId.val(receiver.id);
					$currentReceiver.html(currentReceiverTemplate({
						currentReceiver: receiver
					}));
				});
				
				// 加载收货地址
				function loadReceiver() {
					$.get("${base}/order/receiver_list").done(function(data) {
						$receiverList.html(receiverListTemplate({
							currentReceiverId: $receiverId.val(),
							receivers: data
						}));
					});
				}
				
				// 地区选择
				$areaId.lSelect({
					url: "${base}/common/area"
				});
				
				// 添加收货地址表单验证
				$addReceiverForm.validate({
					rules: {
						consignee: "required",
						areaId: "required",
						address: "required",
						zipCode: {
							required: true,
							zipCode: true
						},
						phone: {
							required: true,
							phone: true
						}
					}
				});
				
				// 添加收货地址成功
				$addReceiverForm.on("success.shopxx.ajaxSubmit", function(event, data) {
					$receiverId.val(data.id);
					$currentReceiver.html(currentReceiverTemplate({
						currentReceiver: data
					}));
					loadReceiver();
					togglePage("#mainPage");
					calculate();
				});
				
				// 支付方式
				$paymentMethodItem.click(function() {
					var $element = $(this);
					if ($element.hasClass("disabled")) {
						return;
					}
					
					var paymentMethodId = $element.data("payment-method-id");
					var paymentMethodName = $element.data("payment-method-name");
					$paymentMethodId.val(paymentMethodId);
					$currentPaymentMethod.find("span.name").text(paymentMethodName);
					
					$shippingMethodItem.each(function() {
						var $element = $(this);
						var shippingMethodId = $element.data("shipping-method-id");
						
						if ($.inArray(paymentMethodId, paymentMethodIds[shippingMethodId]) >= 0) {
							$element.removeClass("disabled");
						} else {
							$element.addClass("disabled");
							if ($element.hasClass("active")) {
								$element.removeClass("active");
								$shippingMethodId.val("");
								$currentShippingMethod.find("span.name").text("${message("shop.order.choose")}");
							}
						}
					});
				});
				
				// 配送方式
				$shippingMethodItem.click(function() {
					var $element = $(this);
					if ($element.hasClass("disabled")) {
						return;
					}
					
					var shippingMethodId = $element.data("shipping-method-id");
					var shippingMethodName = $element.data("shipping-method-name");
					$shippingMethodId.val(shippingMethodId);
					$currentShippingMethod.find("span.name").text(shippingMethodName);
					
					$paymentMethodItem.each(function() {
						var $element = $(this);
						var paymentMethodId = $element.data("payment-method-id");
						
						if ($.inArray(paymentMethodId, paymentMethodIds[shippingMethodId]) >= 0) {
							$element.removeClass("disabled");
						} else {
							$element.addClass("disabled");
							if ($element.hasClass("active")) {
								$element.removeClass("active");
								$paymentMethodId.val("");
								$currentPaymentMethod.find("span.name").text("${message("shop.order.choose")}");
							}
						}
					});
				});
				
				// 订单表单验证
				$orderForm.validate({
					rules: {
						[#if isDelivery]
							receiverId: "required",
							shippingMethodId: "required",
						[/#if]
						paymentMethodId: {
							required: function() {
								return amountPayable > 0;
							}
						}
					},
					messages: {
						receiverId: {
							required: "${message("shop.order.receiverRequired")}"
						},
						shippingMethodId: {
							required: "${message("shop.order.shippingMethodRequired")}"
						},
						paymentMethodId: {
							required: "${message("shop.order.paymentMethodRequired")}"
						}
					},
					submitHandler: function(form) {
						$(form).ajaxSubmit({
							successRedirectUrl: function(redirectUrlParameterName, data, textStatus, xhr, $form) {
								if (amountPayable > 0) {
									return "${base}/order/payment?" + $.param({
										orderSns: data.orderSns
									});
								} else {
									return "${base}/member/order/list";
								}
							}
						});
					},
					invalidHandler: function(event, validator) {
						$.bootstrapGrowl(validator.errorList[0].message, {
							type: "warning"
						});
					},
					errorPlacement: $.noop
				});
				
				// 计算
				function calculate() {
					$.get("${base}/order/calculate", $orderForm.serialize()).done(function(data) {
						if (data.amount != amount) {
							$balance.val("0");
							amountPayable = data.amount;
						} else {
							amountPayable = data.amountPayable;
						}
						amount = data.amount;
						if (amountPayable > 0) {
							if ($currentPaymentMethod.is(":hidden")) {
								$currentPaymentMethod.velocity("slideDown");
							}
							$paymentMethodId.prop("disabled", false);
							if ($useBalanceItem.is(":hidden")) {
								$useBalanceItem.velocity("slideDown");
							}
						} else {
							if ($currentPaymentMethod.is(":visible")) {
								$currentPaymentMethod.velocity("slideUp");
							}
							$shippingMethodItem.removeClass("disabled");
							$paymentMethodId.prop("disabled", true);
							if (parseFloat($balance.val()) <= 0) {
								if ($useBalanceItem.is(":visible")) {
									$useBalanceItem.velocity("slideUp");
								}
								var $toggleItem = $useBalanceItem.find("[data-toggle='item']");
								if ($toggleItem.hasClass("active")) {
									$toggleItem.trigger("click");
								}
							}
						}
						$promotionDiscount.text($.currency(data.promotionDiscount, true, true));
						$couponDiscount.text($.currency(data.couponDiscount, true, true));
						$tax.text($.currency(data.tax, true, true));
						$freight.text($.currency(data.freight, true, true));
						$amountPayable.text($.currency(amountPayable, true, true));
						$exchangePoint.text(data.exchangePoint);
					});
				}
			
			});
			</script>
		[/#escape]
	[/#noautoesc]
</head>
<body class="shop order-checkout">
	<div id="mainPage" class="main-page page">
		<form id="orderForm" class="ajax-form" action="${base}/order/create" method="post">
			[#if skuId??]
				<input name="skuId" type="hidden" value="${skuId}">
				<input name="quantity" type="hidden" value="${quantity}">
			[#else]
				<input name="cartTag" type="hidden" value="${cart.tag}">
			[/#if]
			[#if isDelivery]
				<input id="receiverId" name="receiverId" type="hidden"[#if defaultReceiver??] value="${defaultReceiver.id}"[/#if]>
			[/#if]
			<input id="paymentMethodId" name="paymentMethodId" type="hidden"[#if defaultPaymentMethod??] value="${defaultPaymentMethod.id}"[/#if]>
			<input id="shippingMethodId" name="shippingMethodId" type="hidden"[#if defaultShippingMethod??] value="${defaultShippingMethod.id}"[/#if]>
			<input name="useBalance" type="hidden" value="false">
			<header class="header-default" data-spy="scrollToFixed">
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-1">
							<a href="javascript:;" data-action="back">
								<i class="iconfont icon-back"></i>
							</a>
						</div>
						<div class="col-xs-10">
							<h5>${message("shop.order.checkout")}</h5>
						</div>
					</div>
				</div>
			</header>
			<main>
				<div class="container-fluid">
					[#if isDelivery]
						<div id="currentReceiver" class="current-receiver" data-toggle="page" data-target="#receiverPage">
							<div class="media">
								<div class="media-left media-middle">
									<i class="iconfont icon-location"></i>
								</div>
								<div class="media-body media-middle">
									[#if defaultReceiver??]
										<h5 class="media-heading">
											${defaultReceiver.consignee}
											<span class="pull-right">${defaultReceiver.phone}</span>
										</h5>
										<span class="small">${defaultReceiver.areaName}${defaultReceiver.address}</span>
									[#else]
										<strong class="text-red">${message("shop.order.addReceiver")}</strong>
									[/#if]
								</div>
								<div class="media-right media-middle">
									<i class="iconfont icon-right"></i>
								</div>
							</div>
						</div>
					[/#if]
					<div class="list-group">
						<div id="currentPaymentMethod" class="[#if amountPayable <= 0]hidden-element [/#if]list-group-item text-right" data-toggle="page" data-target="#paymentMethodPage">
							<span class="pull-left">${message("Order.paymentMethod")}</span>
							<span class="name text-gray">${(defaultPaymentMethod.name)!message("shop.order.choose")}</span>
							<i class="iconfont icon-right"></i>
						</div>
						[#if isDelivery]
							<div id="currentShippingMethod" class="list-group-item text-right" data-toggle="page" data-target="#shippingMethodPage">
								<span class="pull-left">${message("Order.shippingMethod")}</span>
								<span class="name text-gray">${(defaultShippingMethod.name)!message("shop.order.choose")}</span>
								<i class="iconfont icon-right"></i>
							</div>
						[/#if]
						[#if orderType == "GENERAL"]
							[#if setting.isInvoiceEnabled]
								<div class="list-group-item">
									<div class="row">
										<div class="col-xs-3">${message("shop.order.isInvoice")}</div>
										<div class="col-xs-7">
											[#if setting.isTaxPriceEnabled]
												<span class="text-gray">${message("Order.tax")}: ${setting.taxRate * 100}%</span>
											[/#if]
										</div>
										<div class="col-xs-2 text-right">
											<i class="iconfont icon-roundcheck" data-toggle="item" data-target="#invoiceTitleItem"></i>
										</div>
									</div>
								</div>
								<div id="invoiceTitleItem" class="hidden-element list-group-item clearfix">
									<div class="invoice-title-item">
										<div class="row">
											<div class="col-xs-3">${message("shop.order.invoiceTitle")}</div>
											<div class="col-xs-9">
												<input id="invoiceTitle" name="invoiceTitle" type="text" value="${message("shop.order.defaultInvoiceTitle")}" maxlength="200" disabled>
											</div>
										</div>
									</div>
									<div class="invoice-title-item">
										<div class="row">
											<div class="col-xs-3">${message("shop.order.invoiceTaxNumber")}</div>
											<div class="col-xs-9">
												<input name="invoiceTaxNumber" type="text" maxlength="200" disabled>
											</div>
										</div>
									</div>
								</div>
							[/#if]
							<div class="list-group-item">
								<div class="row">
									<div class="col-xs-3">${message("shop.order.coupon")}</div>
									<div class="col-xs-9">
										<span id="couponName" class="coupon-name"></span>
										<input id="couponCode" name="code" type="text" maxlength="200" placeholder="${message("shop.order.couponCodePlaceholder")}">
									</div>
								</div>
							</div>
						[/#if]
						[#if currentUser.availableBalance > 0]
							<div id="useBalanceItem" class="[#if amount <= 0]hidden-element [/#if]list-group-item">
								<div class="row">
									<div class="col-xs-3">${message("shop.order.useBalance")}</div>
									<div class="col-xs-7">
										<span class="text-gray">${message("shop.order.balance")}: ${currency(currentUser.availableBalance, true, true)}</span>
									</div>
									<div class="col-xs-2 text-right">
										<i class="iconfont icon-roundcheck" data-toggle="item" data-target="#balanceItem"></i>
									</div>
								</div>
							</div>
							<div id="balanceItem" class="hidden-element list-group-item">
								<div class="row">
									<div class="col-xs-3">${message("shop.order.useAmount")}</div>
									<div class="col-xs-9">
										<input id="balance" name="balance" type="text" value="0" maxlength="16" onpaste="return false;" disabled>
									</div>
								</div>
							</div>
						[/#if]
						<div class="list-group-item">
							<div class="row">
								<div class="col-xs-3">${message("Order.memo")}</div>
								<div class="col-xs-9">
									<input name="memo" type="text" maxlength="200" placeholder="${message("shop.order.memoPlaceholder")}">
								</div>
							</div>
						</div>
					</div>
					<div class="list-group">
						[#list orders as order]
							<div class="list-group-item">
								<a href="${base}${order.store.path}">${order.store.name}</a>
							</div>
							[#list order.orderItems as orderItem]
								<div class="list-group-item">
									<div class="media">
										<div class="media-left media-middle">
											<a href="${base}${orderItem.sku.path}">
												<img class="media-object img-thumbnail" src="${orderItem.sku.thumbnail!setting.defaultThumbnailProductImage}" alt="${orderItem.name}">
											</a>
										</div>
										<div class="media-body media-middle">
											<h5 class="media-heading">
												<a href="${base}${orderItem.sku.path}" title="${orderItem.sku.name}">${orderItem.sku.name}</a>
											</h5>
											[#if orderItem.sku.specifications?has_content]
												<span class="small text-gray">[${orderItem.sku.specifications?join(", ")}]</span>
											[/#if]
											[#if orderItem.type != "GENERAL"]
												<strong class="small text-red">[${message("Product.Type." + orderItem.type)}]</strong>
											[/#if]
										</div>
										<div class="media-right media-middle text-right">
											${currency(orderItem.price, true)}
											<span class="small text-gray">&times; ${orderItem.quantity}</span>
										</div>
									</div>
								</div>
							[/#list]
						[/#list]
					</div>
					<div class="list-group">
						[#if orderType == "GENERAL"]
							[#if rewardPoint > 0]
								<div class="list-group-item small">
									${message("Order.rewardPoint")}
									<strong class="pull-right">${rewardPoint}</strong>
								</div>
							[/#if]
							<div class="list-group-item small">
								${message("Order.promotionDiscount")}
								<strong id="promotionDiscount" class="pull-right">${currency(promotionDiscount, true, true)}</strong>
							</div>
							<div class="list-group-item small">
								${message("Order.couponDiscount")}
								<strong id="couponDiscount" class="pull-right">${currency(couponDiscount, true, true)}</strong>
							</div>
							[#if setting.isInvoiceEnabled && setting.isTaxPriceEnabled]
								<div class="list-group-item small">
									${message("Order.tax")}
									<strong id="tax" class="pull-right">${currency(tax, true, true)}</strong>
								</div>
							[/#if]
						[/#if]
						[#if isDelivery]
							<div class="list-group-item small">
								${message("Order.freight")}
								<strong id="freight" class="pull-right">${currency(freight, true, true)}</strong>
							</div>
						[/#if]
					</div>
				</div>
			</main>
			<footer class="footer-default" data-spy="scrollToFixed" data-bottom="0">
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-9 text-right">
							[#if orderType == "GENERAL"]
								<span>
									${message("Order.amount")}:
									<strong id="amountPayable">${currency(amountPayable, true, true)}</strong>
								</span>
							[#elseif orderType == "EXCHANGE"]
								<span>
									${message("Order.exchangePoint")}:
									<strong id="exchangePoint">${exchangePoint}</strong>
								</span>
							[/#if]
						</div>
						<div class="col-xs-3">
							<button class="btn btn-red btn-flat btn-block" type="submit">${message("shop.order.checkout")}</button>
						</div>
					</div>
				</div>
			</footer>
		</form>
	</div>
	<div id="receiverPage" class="receiver-page page">
		<header class="header-default" data-spy="scrollToFixed">
			<div class="container-fluid">
				<div class="row">
					<div class="col-xs-1">
						<a href="javascript:;" data-toggle="page" data-target="#mainPage">
							<i class="iconfont icon-back"></i>
						</a>
					</div>
					<div class="col-xs-10">
						<h5>${message("shop.order.selectReceiver")}</h5>
					</div>
				</div>
			</div>
		</header>
		<main>
			<div class="selection list-group"></div>
		</main>
		<footer class="footer-default" data-spy="scrollToFixed" data-bottom="0">
			<button id="addReceiver" class="btn btn-red btn-flat btn-block" type="button" data-toggle="page" data-target="#addReceiverPage">${message("shop.order.addReceiver")}</button>
		</footer>
	</div>
	<div id="addReceiverPage" class="add-receiver-page page">
		<form id="addReceiverForm" class="ajax-form" action="${base}/order/add_receiver" method="post">
			<header class="header-default" data-spy="scrollToFixed">
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-1">
							<a href="javascript:;" data-toggle="page" data-target="#receiverPage">
								<i class="iconfont icon-back"></i>
							</a>
						</div>
						<div class="col-xs-10">
							<h5>${message("shop.order.addReceiver")}</h5>
						</div>
					</div>
				</div>
			</header>
			<main>
				<div class="form-group">
					<label class="item-required" for="consignee">${message("Receiver.consignee")}</label>
					<input id="consignee" name="consignee" class="form-control" type="text" maxlength="200">
				</div>
				<div class="form-group">
					<label class="item-required">${message("Receiver.area")}</label>
					<div class="input-group">
						<input id="areaId" name="areaId" type="hidden">
					</div>
				</div>
				<div class="form-group">
					<label class="item-required" for="address">${message("Receiver.address")}</label>
					<input id="address" name="address" class="form-control" type="text" maxlength="200">
				</div>
				<div class="form-group">
					<label class="item-required" for="zipCode">${message("Receiver.zipCode")}</label>
					<input id="zipCode" name="zipCode" class="form-control" type="text" maxlength="200">
				</div>
				<div class="form-group">
					<label class="item-required" for="phone">${message("Receiver.phone")}</label>
					<input id="phone" name="phone" class="form-control" type="text" maxlength="200">
				</div>
				<div class="form-group">
					<div class="checkbox">
						<input name="_isDefault" type="hidden" value="false">
						<input id="isDefault" name="isDefault" type="checkbox" value="true">
						<label for="isDefault">${message("Receiver.isDefault")}</label>
					</div>
				</div>
			</main>
			<footer class="footer-default" data-spy="scrollToFixed" data-bottom="0">
				<button class="btn btn-red btn-flat btn-block" type="submit">${message("shop.order.useAndSave")}</button>
			</footer>
		</form>
	</div>
	<div id="paymentMethodPage" class="payment-method-page page">
		<header class="header-default" data-spy="scrollToFixed">
			<div class="container-fluid">
				<div class="row">
					<div class="col-xs-1">
						<a href="javascript:;" data-toggle="page" data-target="#mainPage">
							<i class="iconfont icon-back"></i>
						</a>
					</div>
					<div class="col-xs-10">
						<h5>${message("Order.paymentMethod")}</h5>
					</div>
				</div>
			</div>
		</header>
		<main>
			<div class="selection list-group">
				[#list paymentMethods as paymentMethod]
					<div class="[#if paymentMethod == defaultPaymentMethod]active [/#if]list-group-item" data-payment-method-id="${paymentMethod.id}" data-payment-method-name="${paymentMethod.name}">
						<div class="media">
							<div class="media-left media-middle">
								<div class="media-object">
									[#if paymentMethod.icon?has_content]
										<img src="${paymentMethod.icon}" alt="${paymentMethod.name}">
									[/#if]
									${paymentMethod.name}
								</div>
							</div>
							<div class="media-body media-middle">
								<span class="small text-gray" title="${paymentMethod.description}">${abbreviate(paymentMethod.description, 30, "...")}</span>
							</div>
							<div class="media-right media-middle">
								<i class="iconfont icon-roundcheck"></i>
							</div>
						</div>
					</div>
				[/#list]
			</div>
		</main>
		<footer class="footer-default" data-spy="scrollToFixed" data-bottom="0">
			<button class="btn btn-red btn-flat btn-block" type="button" data-toggle="page" data-target="#mainPage">${message("shop.order.close")}</button>
		</footer>
	</div>
	<div id="shippingMethodPage" class="shipping-method-page page">
		<header class="header-default" data-spy="scrollToFixed">
			<div class="container-fluid">
				<div class="row">
					<div class="col-xs-1">
						<a href="javascript:;" data-toggle="page" data-target="#mainPage">
							<i class="iconfont icon-back"></i>
						</a>
					</div>
					<div class="col-xs-10">
						<h5>${message("Order.shippingMethod")}</h5>
					</div>
				</div>
			</div>
		</header>
		<main>
			<div class="selection list-group">
				[#list shippingMethods as shippingMethod]
					<div class="[#if shippingMethod == defaultShippingMethod]active [/#if]list-group-item" data-shipping-method-id="${shippingMethod.id}" data-shipping-method-name="${shippingMethod.name}">
						<div class="media">
							<div class="media-left media-middle">
								<div class="media-object">
									[#if shippingMethod.icon?has_content]
										<img src="${shippingMethod.icon}" alt="${shippingMethod.name}">
									[/#if]
									${shippingMethod.name}
								</div>
							</div>
							<div class="media-body media-middle">
								<span class="small text-gray" title="${shippingMethod.description}">${abbreviate(shippingMethod.description, 30, "...")}</span>
							</div>
							<div class="media-right media-middle">
								<i class="iconfont icon-roundcheck"></i>
							</div>
						</div>
					</div>
				[/#list]
			</div>
		</main>
		<footer class="footer-default" data-spy="scrollToFixed" data-bottom="0">
			<button class="btn btn-red btn-flat btn-block" type="button" data-toggle="page" data-target="#mainPage">${message("shop.order.close")}</button>
		</footer>
	</div>
</body>
</html>