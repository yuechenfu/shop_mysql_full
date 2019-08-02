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
	<link href="${base}/resources/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/order.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/bootstrap-growl.js"></script>
	<script src="${base}/resources/common/js/jquery.lSelect.js"></script>
	<script src="${base}/resources/common/js/jquery.qrcode.js"></script>
	<script src="${base}/resources/common/js/jquery.validate.js"></script>
	<script src="${base}/resources/common/js/jquery.validate.additional.js"></script>
	<script src="${base}/resources/common/js/jquery.form.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/velocity.js"></script>
	<script src="${base}/resources/common/js/velocity.ui.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/shop/js/base.js"></script>
	<script id="receiverListItemTemplate" type="text/template">
		<li<%=receiver.id == currentReceiverId ? ' class="active"' : ""%> data-receiver-id="<%-receiver.id%>">
			<h5 class="text-overflow" title="<%-receiver.consignee%>"><%-receiver.consignee%></h5>
			<p class="text-gray-dark"><%-receiver.phone%></p>
			<p class="text-overflow" title="<%-receiver.areaName%><%-receiver.address%>"><%-receiver.areaName%><%-receiver.address%></p>
			<p class="text-gray-dark"><%-receiver.zipCode%></p>
		</li>
	</script>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
				
				var $addReceiverForm = $("#addReceiverForm");
				var $addReceiverModal = $("#addReceiverModal");
				var $areaId = $("#areaId");
				var $receiver = $("#receiver");
				var $receiverList = $("#receiver .receiver-list");
				var $expandReceiver = $("#receiver .expand-receiver");
				var $orderForm = $("#orderForm");
				var $receiverId = $("#receiverId");
				var $paymentMethodId = $("#paymentMethodId");
				var $shippingMethodId = $("#shippingMethodId");
				var $paymentMethod = $("#paymentMethod");
				var $paymentMethodListItem = $("#paymentMethod .payment-method-list li");
				var $shippingMethod = $("#shippingMethod");
				var $shippingMethodListItem = $("#shippingMethod .shipping-method-list li");
				var $isInvoice = $("#isInvoice");
				var $invoiceTitle = $("#invoiceTitle");
				var $invoiceTaxNumber = $("#invoiceTaxNumber");
				var $couponName = $("#couponName");
				var $couponCode = $("#couponCode");
				var $balanceWrapper = $("#balanceWrapper");
				var $useBalance = $("#useBalance");
				var $balance = $("#balance");
				var $promotionDiscount = $("#promotionDiscount");
				var $couponDiscount = $("#couponDiscount");
				var $tax = $("#tax");
				var $freight = $("#freight");
				var $amountPayable = $("#amountPayable");
				var $exchangePoint = $("#exchangePoint");
				var receiverListItemTemplate = _.template($("#receiverListItemTemplate").html());
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
					$addReceiverModal.modal("hide");
					$(receiverListItemTemplate({
						currentReceiverId: data.id,
						receiver: data
					})).prependTo($receiverList).siblings().removeClass("active");
					if ($receiverList.find("li").length > 3 && !$receiver.hasClass("expanded")) {
						$expandReceiver.closest(".panel-footer").show();
					}
					calculate();
				});
				
				// 收货地址
				$receiverList.on("click", "li", function() {
					var $element = $(this);
					var receiverId = $element.data("receiver-id");
					
					$receiverId.val(receiverId);
					$element.addClass("active").siblings().removeClass("active");
					calculate();
				});
				
				// 收货地址
				$expandReceiver.click(function() {
					var $element = $(this);
					
					$element.closest(".panel-footer").hide();
					$receiver.addClass("expanded");
				});
				
				// 支付方式
				$paymentMethodListItem.click(function() {
					var $element = $(this);
					if ($element.hasClass("disabled")) {
						return;
					}
					
					var paymentMethodId = $element.data("payment-method-id");
					$paymentMethodId.val(paymentMethodId);
					$element.addClass("active").siblings().removeClass("active");
					
					$shippingMethodListItem.each(function() {
						var $element = $(this);
						var shippingMethodId = $element.data("shipping-method-id");
						
						if ($.inArray(paymentMethodId, paymentMethodIds[shippingMethodId]) >= 0) {
							$element.removeClass("disabled");
						} else {
							$element.addClass("disabled");
							if ($element.hasClass("active")) {
								$element.removeClass("active");
								$shippingMethodId.val("");
							}
						}
					});
					calculate();
				});
				
				// 配送方式
				$shippingMethodListItem.click(function() {
					var $element = $(this);
					if ($element.hasClass("disabled")) {
						return;
					}
					
					var shippingMethodId = $element.data("shipping-method-id");
					$shippingMethodId.val(shippingMethodId);
					$element.addClass("active").siblings().removeClass("active");
					
					$paymentMethodListItem.each(function() {
						var $element = $(this);
						var paymentMethodId = $element.data("payment-method-id");
						
						if ($.inArray(paymentMethodId, paymentMethodIds[shippingMethodId]) >= 0) {
							$element.removeClass("disabled");
						} else {
							$element.addClass("disabled");
							if ($element.hasClass("active")) {
								$element.removeClass("active");
								$paymentMethodId.val("");
							}
						}
					});
					calculate();
				});
				
				// 开具发票
				$isInvoice.change(function() {
					var $element = $(this);
					
					if ($element.is(":checked")) {
						if ($invoiceTitle.prop("disabled")) {
							$invoiceTitle.prop("disabled", false).closest(".form-group").velocity("slideDown");
							$invoiceTaxNumber.prop("disabled", false).closest(".form-group").velocity("slideDown");
						}
					} else {
						if (!$invoiceTitle.prop("disabled")) {
							$invoiceTitle.prop("disabled", true).closest(".form-group").velocity("slideUp");
							$invoiceTaxNumber.prop("disabled", true).closest(".form-group").velocity("slideUp");
						}
					}
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
				
				// 使用余额
				$useBalance.change(function() {
					var $element = $(this);
					
					if ($element.is(":checked")) {
						if ($balance.prop("disabled")) {
							$balance.prop("disabled", false).closest(".form-group").velocity("slideDown");
						}
					} else {
						if (!$balance.prop("disabled")) {
							$balance.prop("disabled", true).closest(".form-group").velocity("slideUp");
						}
					}
					calculate();
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
								$.removeCurrentCartQuantity();
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
							if ($paymentMethod.is(":hidden")) {
								$paymentMethod.velocity("slideDown");
							}
							$paymentMethodId.prop("disabled", false);
							if ($balanceWrapper.is(":hidden")) {
								$balanceWrapper.velocity("slideDown");
							}
						} else {
							if ($paymentMethod.is(":visible")) {
								$paymentMethod.velocity("slideUp");
							}
							$shippingMethodListItem.removeClass("disabled");
							$paymentMethodId.prop("disabled", true);
							if (parseFloat($balance.val()) <= 0) {
								if ($balanceWrapper.is(":visible")) {
									$balanceWrapper.velocity("slideUp");
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
	[#include "/shop/include/main_header.ftl" /]
	[#include "/shop/include/main_sidebar.ftl" /]
	<main>
		<div class="container">
			<form id="addReceiverForm" class="ajax-form form-horizontal" action="${base}/order/add_receiver" method="post">
				<div id="addReceiverModal" class="modal fade" tabindex="-1">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button class="close" type="button" data-dismiss="modal">&times;</button>
								<h5 class="modal-title">${message("shop.order.addReceiver")}</h5>
							</div>
							<div class="modal-body">
								<div class="form-group">
									<label class="col-xs-3 control-label item-required">${message("Receiver.consignee")}:</label>
									<div class="col-xs-8">
										<input name="consignee" class="form-control" type="text" maxlength="200">
									</div>
								</div>
								<div class="form-group">
									<label class="col-xs-3 control-label item-required">${message("Receiver.area")}:</label>
									<div class="col-xs-8">
										<input id="areaId" name="areaId" type="hidden">
									</div>
								</div>
								<div class="form-group">
									<label class="col-xs-3 control-label item-required">${message("Receiver.address")}:</label>
									<div class="col-xs-8">
										<input name="address" class="form-control" type="text" maxlength="200">
									</div>
								</div>
								<div class="form-group">
									<label class="col-xs-3 control-label item-required">${message("Receiver.zipCode")}:</label>
									<div class="col-xs-8">
										<input name="zipCode" class="form-control" type="text" maxlength="200">
									</div>
								</div>
								<div class="form-group">
									<label class="col-xs-3 control-label item-required">${message("Receiver.phone")}:</label>
									<div class="col-xs-8">
										<input name="phone" class="form-control" type="text" maxlength="200">
									</div>
								</div>
								<div class="form-group">
									<label class="col-xs-3 control-label">${message("common.setting")}:</label>
									<div class="col-xs-8">
										<div class="checkbox">
											<input name="_isDefault" type="hidden" value="false">
											<input id="isDefault" name="isDefault" type="checkbox" value="true">
											<label for="isDefault">${message("Receiver.isDefault")}</label>
										</div>
									</div>
								</div>
							</div>
							<div class="modal-footer">
								<button class="btn btn-primary" type="submit">${message("common.ok")}</button>
								<button class="btn btn-default" type="button" data-dismiss="modal">${message("common.cancel")}</button>
							</div>
						</div>
					</div>
				</div>
			</form>
			<form id="orderForm" class="ajax-form form-horizontal" action="${base}/order/create" method="post">
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
				[#if isDelivery]
					<div id="receiver" class="receiver panel panel-default">
						<div class="panel-heading">
							<h5>${message("shop.order.receiver")}</h5>
						</div>
						<div class="panel-body">
							<a class="add-receiver" href="#addReceiverModal" data-toggle="modal">
								<i class="iconfont icon-add"></i>
								${message("shop.order.addReceiver")}
							</a>
							<ul class="receiver-list">
								[#list currentUser.receivers as receiver]
									<li[#if receiver == defaultReceiver] class="active"[/#if] data-receiver-id="${receiver.id}">
										<h5 class="text-overflow" title="${receiver.consignee}">${receiver.consignee}</h5>
										<p class="text-gray-dark">${receiver.phone}</p>
										<p class="text-overflow" title="${receiver.areaName}${receiver.address}">${receiver.areaName}${receiver.address}</p>
										<p class="text-gray-dark">${receiver.zipCode}</p>
									</li>
								[/#list]
							</ul>
						</div>
						<div class="panel-footer[#if currentUser.receivers?size <= 3] hidden-element[/#if]">
							<a class="expand-receiver" href="javascript:;">
								<i class="iconfont icon-unfold"></i>
								${message("shop.order.expandReceiver")}
							</a>
						</div>
					</div>
				[/#if]
				<div id="paymentMethod" class="payment-method[#if amountPayable <= 0] hidden-element[/#if] panel panel-default">
					<div class="panel-heading">
						<h5>${message("Order.paymentMethod")}</h5>
					</div>
					<div class="panel-body">
						<ul class="payment-method-list">
							[#list paymentMethods as paymentMethod]
								<li[#if paymentMethod == defaultPaymentMethod] class="active"[/#if] data-payment-method-id="${paymentMethod.id}">
									[#if paymentMethod.icon?has_content]
										<img src="${paymentMethod.icon}" alt="${paymentMethod.name}">
									[/#if]
									${paymentMethod.name}
								</li>
							[/#list]
						</ul>
					</div>
				</div>
				[#if isDelivery]
					<div id="shippingMethod" class="shipping-method panel panel-default">
						<div class="panel-heading">
							<h5>${message("Order.shippingMethod")}</h5>
						</div>
						<div class="panel-body">
							<ul class="shipping-method-list">
								[#list shippingMethods as shippingMethod]
									<li[#if shippingMethod == defaultShippingMethod] class="active"[/#if] data-shipping-method-id="${shippingMethod.id}">
										[#if shippingMethod.icon?has_content]
											<img src="${shippingMethod.icon}" alt="${shippingMethod.name}">
										[/#if]
										${shippingMethod.name}
									</li>
								[/#list]
							</ul>
						</div>
					</div>
				[/#if]
				<div class="panel panel-default">
					<div class="panel-body">
						[#if orderType == "GENERAL"]
							[#if setting.isInvoiceEnabled]
								<div id="invoiceWrapper">
									<div class="form-group">
										<label class="col-xs-1 control-label">${message("shop.order.isInvoice")}</label>
										<div class="col-xs-1">
											<div class="checkbox">
												<input id="isInvoice" name="isInvoice" type="checkbox" value="true">
												<label></label>
											</div>
										</div>
										[#if setting.isTaxPriceEnabled]
											<div class="col-xs-10">
												<p class="text-gray form-control-static">${message("Order.tax")}: ${setting.taxRate * 100}%</p>
											</div>
										[/#if]
									</div>
									<div class="form-group hidden-element">
										<label class="col-xs-1 control-label">${message("shop.order.invoiceTitle")}</label>
										<div class="col-xs-4">
											<input id="invoiceTitle" name="invoiceTitle" class="form-control" type="text" value="${message("shop.order.defaultInvoiceTitle")}" maxlength="200" disabled>
										</div>
									</div>
									<div class="form-group hidden-element">
										<label class="col-xs-1 control-label">${message("shop.order.invoiceTaxNumber")}</label>
										<div class="col-xs-4">
											<input id="invoiceTaxNumber" name="invoiceTaxNumber" class="form-control" type="text" maxlength="200" disabled>
										</div>
									</div>
								</div>
							[/#if]
							<div class="form-group">
								<label class="col-xs-1 control-label">${message("shop.order.coupon")}</label>
								<div class="col-xs-4">
									<span id="couponName" class="coupon-name"></span>
									<input id="couponCode" name="code" class="form-control" type="text" maxlength="200" placeholder="${message("shop.order.couponCodePlaceholder")}">
								</div>
							</div>
						[/#if]
						[#if currentUser.availableBalance > 0]
							<div id="balanceWrapper"[#if amount <= 0] class="hidden-element"[/#if]>
								<div class="form-group">
									<label class="col-xs-1 control-label">${message("shop.order.useBalance")}</label>
									<div class="col-xs-1">
										<div class="checkbox">
											<input id="useBalance" name="useBalance" type="checkbox" value="true">
											<label></label>
										</div>
									</div>
									<div class="col-xs-10">
										<p class="text-gray form-control-static">${message("shop.order.balance")}: ${currency(currentUser.availableBalance, true, true)}</p>
									</div>
								</div>
								<div class="form-group hidden-element">
									<label class="col-xs-1 control-label">${message("shop.order.useAmount")}</label>
									<div class="col-xs-4">
										<input id="balance" name="balance" class="form-control" type="text" value="0" maxlength="16" onpaste="return false;" disabled>
									</div>
								</div>
							</div>
						[/#if]
						<div class="form-group">
							<label class="col-xs-1 control-label">${message("Order.memo")}</label>
							<div class="col-xs-4">
								<input name="memo" class="form-control" type="text" maxlength="200" placeholder="${message("shop.order.memoPlaceholder")}">
							</div>
						</div>
					</div>
				</div>
				<table>
					<thead>
						<tr>
							<th width="800">${message("shop.order.sku")}</th>
							<th>${message("OrderItem.price")}</th>
							<th>${message("OrderItem.quantity")}</th>
							<th width="150">${message("OrderItem.subtotal")}</th>
						</tr>
					</thead>
					[#list orders as order]
						<tbody class="order-item-group">
							<tr class="order-item-group-heading">
								<td colspan="4">
									<a href="${base}${order.store.path}" target="_blank">${order.store.name}</a>
									[#if order.store.type == "SELF"]
										<span class="label label-primary">${message("Store.Type.SELF")}</span>
									[/#if]
								</td>
							</tr>
							[#list order.orderItems as orderItem]
								<tr>
									<td>
										<div class="media">
											<div class="media-left media-middle">
												<a href="${base}${orderItem.sku.path}" title="${orderItem.sku.name}">
													<img class="media-object img-thumbnail" src="${orderItem.sku.thumbnail!setting.defaultThumbnailProductImage}" alt="${orderItem.sku.name}">
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
													<span class="small text-red">[${message("Product.Type." + orderItem.type)}]</span>
												[/#if]
											</div>
										</div>
									</td>
									<td>${currency(orderItem.price, true)}</td>
									<td>${orderItem.quantity}</td>
									<td>
										<strong>${currency(orderItem.subtotal, true)}</strong>
									</td>
								</tr>
							[/#list]
						</tbody>
					[/#list]
				</table>
				<div class="summary panel panel-default">
					<div class="panel-body">
						<dl class="dl-horizontal pull-right">
							[#if orderType == "GENERAL"]
								[#if rewardPoint > 0]
									<dt>${message("Order.rewardPoint")}:</dt>
									<dd>${rewardPoint}</dd>
								[/#if]
								<dt>${message("Order.promotionDiscount")}:</dt>
								<dd>
									<span id="promotionDiscount">${currency(promotionDiscount, true, true)}</span>
								</dd>
								<dt>${message("Order.couponDiscount")}:</dt>
								<dd>
									<span id="couponDiscount">${currency(couponDiscount, true, true)}</span>
								</dd>
								[#if setting.isInvoiceEnabled && setting.isTaxPriceEnabled]
									<dt>${message("Order.tax")}:</dt>
									<dd>
										<span id="tax">${currency(tax, true, true)}</span>
									</dd>
								[/#if]
							[/#if]
							[#if isDelivery]
								<dt>${message("Order.freight")}:</dt>
								<dd>
									<span id="freight">${currency(freight, true, true)}</span>
								</dd>
							[/#if]
						</dl>
					</div>
				</div>
				<div class="bar">
					<div class="row">
						<div class="col-xs-1">
							<a class="back" href="javascript:;" data-action="back">${message("common.back")}</a>
						</div>
						<div class="col-xs-10 text-right">
							[#if orderType == "GENERAL"]
								<span>
									${message("Order.amountPayable")}:
									<strong id="amountPayable">${currency(amountPayable, true, true)}</strong>
								</span>
							[#elseif orderType == "EXCHANGE"]
								<span>
									${message("Order.exchangePoint")}:
									<strong id="exchangePoint">${exchangePoint}</strong>
								</span>
							[/#if]
						</div>
						<div class="col-xs-1">
							<button class="btn btn-primary btn-lg btn-block" type="submit">${message("shop.order.checkout")}</button>
						</div>
					</div>
				</div>
			</form>
		</div>
	</main>
	[#include "/shop/include/main_footer.ftl" /]
</body>
</html>