<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.aftersales.apply")} - Powered By SHOP++</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/awesome-bootstrap-checkbox.css" rel="stylesheet">
	<link href="${base}/resources/common/css/bootstrap-spinner.css" rel="stylesheet">
	<link href="${base}/resources/common/css/bootstrap-select.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/member/css/base.css" rel="stylesheet">
	<link href="${base}/resources/member/css/aftersales.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/bootstrap-growl.js"></script>
	<script src="${base}/resources/common/js/bootstrap-select.js"></script>
	<script src="${base}/resources/common/js/jquery.spinner.js"></script>
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
	<script src="${base}/resources/member/js/base.js"></script>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
				
				var $aftersalesReturnForm = $("#aftersalesReturnForm");
				var $aftersalesReplacementForm = $("#aftersalesReplacementForm");
				var $aftersalesRepairForm = $("#aftersalesRepairForm");
				var $selectedItem = $("tbody td .checkbox input:checkbox")
				var $gift = $("div.gift");
				var $giftItem = $("div.gift ul li");
				var $method = $("#method");
				var $bank = $("#bank");
				var $account = $("#account");
				var $areaId = $("input.area-id");
				
				$selectedItem.change(function() {
					var $element = $(this);
					var $submit = $element.closest("div.tab-pane").find("button:submit");
					var checked = $element.closest("table.table").find("tbody input:checked").length < 1;
					
					$submit.prop("disabled", checked);
				});
				
				// 赠品
				if ($giftItem.length < 1) {
					$gift.hide();
				}
				
				// 退款方式
				$method.change(function() {
					switch ($method.val()) {
						case "ONLINE":
							$bank.add($account).prop("disabled", false).closest("div.form-group").velocity("slideDown");
							break;
						case "OFFLINE":
							$bank.add($account).prop("disabled", true).closest("div.form-group").velocity("slideUp");
							break;
						case "DEPOSIT":
							$bank.add($account).prop("disabled", true).closest("div.form-group").velocity("slideUp");
							break;
					}
				});
				
				// 地区选择
				$areaId.lSelect({
					url: "${base}/common/area"
				});
				
				// 表单验证
				$aftersalesReturnForm.validate({
					rules: {
						reason: "required",
						method: "required",
						bank: "required",
						account: "required"
					},
					submitHandler: function(form) {
						$(form).ajaxSubmit({
							successRedirectUrl: "${base}/member/aftersales/list"
						});
					}
				});
				
				// 表单验证
				$aftersalesReplacementForm.validate({
					rules: {
						reason: "required",
						consignee: "required",
						areaId: "required",
						address: "required",
						phone: {
							required: true,
							phone: true
						}
					},
					submitHandler: function(form) {
						$(form).ajaxSubmit({
							successRedirectUrl: "${base}/member/aftersales/list"
						});
					}
				});
				
				// 表单验证
				$aftersalesRepairForm.validate({
					rules: {
						reason: "required",
						consignee: "required",
						areaId: "required",
						address: "required",
						phone: {
							required: true,
							phone: true
						}
					},
					submitHandler: function(form) {
						$(form).ajaxSubmit({
							successRedirectUrl: "${base}/member/aftersales/list"
						});
					}
				});
			
			});
			</script>
		[/#escape]
	[/#noautoesc]
</head>
<body class="member aftersales">
	[#include "/shop/include/main_header.ftl" /]
	<main>
		<div class="container">
			<div class="row">
				<div class="col-xs-2">
					[#include "/member/include/main_menu.ftl" /]
				</div>
				<div class="col-xs-10">
					<div class="aftersales-apply panel panel-default">
						<div class="panel-heading">${message("member.aftersales.apply")}</div>
						<div class="panel-body">
							<ul class="nav nav-tabs">
								<li class="active">
									<a href="#repair" data-toggle="tab">${message("member.aftersales.repair")}</a>
								</li>
								<li>
									<a href="#replacement" data-toggle="tab">${message("member.aftersales.replacement")}</a>
								</li>
								<li>
									<a href="#return" data-toggle="tab">${message("member.aftersales.returns")}</a>
								</li>
							</ul>
							<div class="tab-content">
								<div id="repair" class="tab-pane active">
									<form id="aftersalesRepairForm" class="form-horizontal" action="${base}/member/aftersales_repair/repair" method="post">
										<input name="orderId" type="hidden" value="${order.id}">
										[#assign repairTips = order.store.aftersalesSetting.repairTips /]
										[#if repairTips?has_content]
											<div class="panel panel-default">
												<div class="panel-heading">${message("member.aftersales.repairTips")}</div>
												<div class="panel-body">
													[#noautoesc]
														${repairTips}
													[/#noautoesc]
												</div>
											</div>
										[/#if]
										[#if previousAftersales?has_content]
											<div class="panel panel-default">
												<div class="panel-heading">${message("member.aftersales.hasApplied")}</div>
												<div class="panel-body">
													<table class="table">
														<thead>
															<tr>
																<th>${message("member.aftersalesItem.sku")}</th>
																<th>${message("member.aftersales.type")}</th>
																<th>${message("member.aftersales.status")}</th>
																<th>${message("common.action")}</th>
															</tr>
														</thead>
														<tbody>
															[#list previousAftersales as aftersales]
																<tr>
																	<td>
																		[#list aftersales.orderItems as orderItem]
																			[#if orderItem.sku??]
																				<a href="${base}${orderItem.sku.path}" title="${orderItem.name}" target="_blank">
																					<img class="img-thumbnail" src="${orderItem.thumbnail!setting.defaultThumbnailProductImage}" alt="${orderItem.name}">
																				</a>
																			[#else]
																				<img class="img-thumbnail" src="${orderItem.thumbnail!setting.defaultThumbnailProductImage}" alt="${orderItem.name}">
																			[/#if]
																			[#if orderItem_index == 2]
																				[#break /]
																			[/#if]
																		[/#list]
																	</td>
																	<td>${message("Aftersales.Type." + aftersales.type)}</td>
																	<td>
																		<span class="[#if aftersales.status == "FAILED"]text-red[#elseif aftersales.status == "PENDING"]text-orange[#else]text-green[/#if]">${message("Aftersales.Status." + aftersales.status)}</span>
																	</td>
																	<td>
																		<a class="btn btn-default btn-icon" href="${base}/member/aftersales/view?aftersalesId=${aftersales.id}" title="${message("common.view")}">
																			<i class="iconfont icon-search"></i>
																		</a>
																	</td>
																</tr>
															[/#list]
														</tbody>
													</table>
												</div>
											</div>
										[/#if]
										<div class="panel panel-default">
											<div class="panel-heading">${message("member.aftersales.chooseRepairSku")}</div>
											<div class="panel-body">
												<table class="table">
													<thead>
														<tr>
															<th>
																<div class="checkbox">
																	<input type="checkbox" value="true" data-toggle="checkAll" data-target="input.repair-item:enabled">
																	<label></label>
																</div>
															</th>
															<th>${message("Aftersales.store")}</th>
															<th>${message("member.aftersalesItem.sku")}</th>
															<th>${message("member.aftersalesItem.name")}</th>
															<th>${message("AftersalesItem.quantity")}</th>
															<th>${message("member.aftersalesItem.price")}</th>
														</tr>
													</thead>
													<tbody>
														[#list order.orderItems as orderItem]
															[#if orderItem.type == "GENERAL"]
																<tr>
																	<td>
																		<div class="checkbox">
																			<input name="aftersalesItems[${orderItem_index}].orderItem.id" class="repair-item" type="checkbox" value="${orderItem.id}"[#if orderItem.allowApplyAftersalesQuantity <= 0] disabled[/#if]>
																			<label></label>
																		</div>
																	</td>
																	<td>${order.store.name}</td>
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
																	</td>
																	<td>
																		<div class="spinner input-group input-group-sm" data-trigger="spinner">
																			<input name="aftersalesItems[${orderItem_index}].quantity" class="form-control" type="text" maxlength="5" data-rule="quantity" data-min="1" data-max="[#if orderItem.allowApplyAftersalesQuantity > 0]${orderItem.allowApplyAftersalesQuantity}[#else]1[/#if]">
																			<span class="input-group-addon">
																				<a class="spin-up" href="javascript:;" data-spin="up">
																					<i class="fa fa-caret-up"></i>
																				</a>
																				<a class="spin-down" href="javascript:;" data-spin="down">
																					<i class="fa fa-caret-down"></i>
																				</a>
																			</span>
																		</div>
																	</td>
																	<td>${currency(orderItem.price, true)}</td>
																</tr>
															[/#if]
														[/#list]
													</tbody>
												</table>
											</div>
										</div>
										<div class="gift panel panel-default">
											<div class="panel-heading">${message("member.aftersales.returnGift")}</div>
											<div class="panel-body">
												<ul class="clearfix">
													[#list order.orderItems as orderItem]
														[#if orderItem.type == "GIFT"]
															<li>
																[#if orderItem.sku??]
																	<a href="${base}${orderItem.sku.path}" target="_blank">${orderItem.name}</a>
																[#else]
																	${orderItem.name}
																[/#if]
																<span class="text-red">[${message("Product.Type." + orderItem.type)}]</span>
																<span>&times;${orderItem.quantity}[#if orderItem_has_next] ,[/#if]</span>
															</li>
														[/#if]
													[/#list]
												</ul>
											</div>
										</div>
										<div class="panel panel-default">
											<div class="panel-heading">${message("member.aftersales.reason")}</div>
											<div class="panel-body">
												<div class="form-group">
													<label class="col-xs-3 col-sm-2 control-label item-required" for="repairReason">${message("Aftersales.reason")}:</label>
													<div class="col-xs-9 col-sm-4">
														<textarea id="repairReason" name="reason" class="form-control" rows="5"></textarea>
													</div>
												</div>
											</div>
										</div>
										<div class="panel panel-default">
											<div class="panel-heading">${message("member.aftersales.contact")}</div>
											<div class="panel-body">
												<div class="form-group">
													<label class="col-xs-3 col-sm-2 control-label item-required" for="repairConsignee">${message("AftersalesRepair.consignee")}:</label>
													<div class="col-xs-9 col-sm-4">
														<input id="repairConsignee" name="consignee" class="form-control" type="text" maxlength="200">
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-3 col-sm-2 control-label item-required">${message("AftersalesRepair.area")}:</label>
													<div class="col-xs-9 col-sm-10">
														<div class="input-group">
															<input name="areaId" class="area-id" type="hidden">
														</div>
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-3 col-sm-2 control-label item-required" for="repairAddress">${message("AftersalesRepair.address")}:</label>
													<div class="col-xs-9 col-sm-4">
														<input id="repairAddress" name="address" class="form-control" type="text" maxlength="200">
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-3 col-sm-2 control-label item-required" for="repairPhone">${message("AftersalesRepair.phone")}:</label>
													<div class="col-xs-9 col-sm-4">
														<input id="repairPhone" name="phone" class="form-control" type="text" maxlength="200">
													</div>
												</div>
											</div>
										</div>
										<div class="panel panel-default">
											<div class="panel-footer">
												<div class="row">
													<div class="col-xs-9 col-sm-10 col-xs-offset-3 col-sm-offset-2">
														<button class="submit btn btn-primary" type="submit" disabled>${message("member.aftersales.submit")}</button>
														<a class="btn btn-default" href="${base}/member/order/list">${message("common.back")}</a>
													</div>
												</div>
											</div>
										</div>
									</form>
								</div>
								<div id="replacement" class="tab-pane">
									<form id="aftersalesReplacementForm" class="form-horizontal" action="${base}/member/aftersales_replacement/replacement" method="post">
										<input name="orderId" type="hidden" value="${order.id}">
										[#assign replacementTips = order.store.aftersalesSetting.replacementTips /]
										[#if replacementTips?has_content]
											<div class="panel panel-default">
												<div class="panel-heading">${message("member.aftersales.replacementTips")}</div>
												<div class="panel-body">
													[#noautoesc]
														${replacementTips}
													[/#noautoesc]
												</div>
											</div>
										[/#if]
										[#if previousAftersales?has_content]
											<div class="panel panel-default">
												<div class="panel-heading">${message("member.aftersales.hasApplied")}</div>
												<div class="panel-body">
													<table class="table">
														<thead>
															<tr>
																<th>${message("member.aftersalesItem.sku")}</th>
																<th>${message("member.aftersales.type")}</th>
																<th>${message("member.aftersales.status")}</th>
																<th>${message("common.action")}</th>
															</tr>
														</thead>
														<tbody>
															[#list previousAftersales as aftersales]
																<tr>
																	<td>
																		[#list aftersales.orderItems as orderItem]
																			[#if orderItem.sku??]
																				<a href="${base}${orderItem.sku.path}" title="${orderItem.name}" target="_blank">
																					<img class="img-thumbnail" src="${orderItem.thumbnail!setting.defaultThumbnailProductImage}" alt="${orderItem.name}">
																				</a>
																			[#else]
																				<img class="img-thumbnail" src="${orderItem.thumbnail!setting.defaultThumbnailProductImage}" alt="${orderItem.name}">
																			[/#if]
																			[#if orderItem_index == 2]
																				[#break /]
																			[/#if]
																		[/#list]
																	</td>
																	<td>${message("Aftersales.Type." + aftersales.type)}</td>
																	<td>
																		<span class="[#if aftersales.status == "FAILED"]text-red[#elseif aftersales.status == "PENDING"]text-orange[#else]text-green[/#if]">${message("Aftersales.Status." + aftersales.status)}</span>
																	</td>
																	<td>
																		<a class="btn btn-default btn-icon" href="${base}/member/aftersales/view?aftersalesId=${aftersales.id}" title="${message("common.view")}">
																			<i class="iconfont icon-search"></i>
																		</a>
																	</td>
																</tr>
															[/#list]
														</tbody>
													</table>
												</div>
											</div>
										[/#if]
										<div class="panel panel-default">
											<div class="panel-heading">${message("member.aftersales.chooseReplacementSku")}</div>
											<div class="panel-body">
												<table class="table">
													<thead>
														<tr>
															<th>
																<div class="checkbox">
																	<input type="checkbox" value="true" data-toggle="checkAll" data-target="input.replace-item:enabled">
																	<label></label>
																</div>
															</th>
															<th>${message("Aftersales.store")}</th>
															<th>${message("member.aftersalesItem.sku")}</th>
															<th>${message("member.aftersalesItem.name")}</th>
															<th>${message("AftersalesItem.quantity")}</th>
															<th>${message("member.aftersalesItem.price")}</th>
														</tr>
													</thead>
													<tbody>
														[#list order.orderItems as orderItem]
															[#if orderItem.type == "GENERAL"]
																<tr>
																	<td>
																		<div class="checkbox">
																			<input name="aftersalesItems[${orderItem_index}].orderItem.id" class="replace-item" type="checkbox" value="${orderItem.id}"[#if orderItem.allowApplyAftersalesQuantity <= 0] disabled[/#if]>
																			<label></label>
																		</div>
																	</td>
																	<td>${order.store.name}</td>
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
																	</td>
																	<td>
																		<div class="spinner input-group input-group-sm" data-trigger="spinner">
																			<input name="aftersalesItems[${orderItem_index}].quantity" class="form-control" type="text" maxlength="5" data-rule="quantity" data-min="1" data-max="[#if orderItem.allowApplyAftersalesQuantity > 0]${orderItem.allowApplyAftersalesQuantity}[#else]1[/#if]">
																			<span class="input-group-addon">
																				<a class="spin-up" href="javascript:;" data-spin="up">
																					<i class="fa fa-caret-up"></i>
																				</a>
																				<a class="spin-down" href="javascript:;" data-spin="down">
																					<i class="fa fa-caret-down"></i>
																				</a>
																			</span>
																		</div>
																	</td>
																	<td>${currency(orderItem.price, true)}</td>
																</tr>
															[/#if]
														[/#list]
													</tbody>
												</table>
											</div>
										</div>
										<div class="gift panel panel-default">
											<div class="panel-heading">${message("member.aftersales.returnGift")}</div>
											<div class="panel-body">
												<ul class="clearfix">
													[#list order.orderItems as orderItem]
														[#if orderItem.type == "GIFT"]
															<li>
																[#if orderItem.sku??]
																	<a href="${base}${orderItem.sku.path}" target="_blank">${orderItem.name}</a>
																[#else]
																	${orderItem.name}
																[/#if]
																<span class="text-red">[${message("Product.Type." + orderItem.type)}]</span>
																<span>&times;${orderItem.quantity}[#if orderItem_has_next] ,[/#if]</span>
															</li>
														[/#if]
													[/#list]
												</ul>
											</div>
										</div>
										<div class="panel panel-default">
											<div class="panel-heading">${message("member.aftersales.reason")}</div>
											<div class="panel-body">
												<div class="form-group">
													<label class="col-xs-3 col-sm-2 control-label item-required" for="replaceReason">${message("Aftersales.reason")}:</label>
													<div class="col-xs-9 col-sm-4">
														<textarea id="replaceReason" name="reason" class="form-control" rows="5"></textarea>
													</div>
												</div>
											</div>
										</div>
										<div class="panel panel-default">
											<div class="panel-heading">${message("member.aftersales.contact")}</div>
											<div class="panel-body">
												<div class="form-group">
													<label class="col-xs-3 col-sm-2 control-label item-required" for="replaceConsignee">${message("AftersalesReplacement.consignee")}:</label>
													<div class="col-xs-9 col-sm-4">
														<input id="replaceConsignee" name="consignee" class="form-control" type="text" maxlength="200">
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-3 col-sm-2 control-label item-required">${message("AftersalesReplacement.area")}:</label>
													<div class="col-xs-9 col-sm-10">
														<div class="input-group">
															<input name="areaId" class="area-id" type="hidden">
														</div>
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-3 col-sm-2 control-label item-required" for="replaceAddress">${message("AftersalesReplacement.address")}:</label>
													<div class="col-xs-9 col-sm-4">
														<input id="replaceAddress" name="address" class="form-control" type="text" maxlength="200">
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-3 col-sm-2 control-label item-required" for="replacePhone">${message("AftersalesReplacement.phone")}:</label>
													<div class="col-xs-9 col-sm-4">
														<input id="replacePhone" name="phone" class="form-control" type="text" maxlength="200">
													</div>
												</div>
											</div>
										</div>
										<div class="panel panel-default">
											<div class="panel-footer">
												<div class="row">
													<div class="col-xs-9 col-sm-10 col-xs-offset-3 col-sm-offset-2">
														<button class="submit btn btn-primary" type="submit" disabled>${message("member.aftersales.submit")}</button>
														<a class="btn btn-default" href="${base}/member/order/list">${message("common.back")}</a>
													</div>
												</div>
											</div>
										</div>
									</form>
								</div>
								<div id="return" class="tab-pane">
									<form id="aftersalesReturnForm" class="form-horizontal" action="${base}/member/aftersales_returns/returns" method="post">
										<input name="orderId" type="hidden" value="${order.id}">
										[#assign returnsTips = order.store.aftersalesSetting.returnsTips /]
										[#if returnsTips?has_content]
											<div class="panel panel-default">
												<div class="panel-heading">${message("member.aftersales.returnsTips")}</div>
												<div class="panel-body">
													[#noautoesc]
														${returnsTips}
													[/#noautoesc]
												</div>
											</div>
										[/#if]
										[#if previousAftersales?has_content]
											<div class="panel panel-default">
												<div class="panel-heading">${message("member.aftersales.hasApplied")}</div>
												<div class="panel-body">
													<table class="table">
														<thead>
															<tr>
																<th>${message("member.aftersalesItem.sku")}</th>
																<th>${message("member.aftersales.type")}</th>
																<th>${message("member.aftersales.status")}</th>
																<th>${message("common.action")}</th>
															</tr>
														</thead>
														<tbody>
															[#list previousAftersales as aftersales]
																<tr>
																	<td>
																		[#list aftersales.orderItems as orderItem]
																			[#if orderItem.sku??]
																				<a href="${base}${orderItem.sku.path}" title="${orderItem.name}" target="_blank">
																					<img class="img-thumbnail" src="${orderItem.thumbnail!setting.defaultThumbnailProductImage}" alt="${orderItem.name}">
																				</a>
																			[#else]
																				<img class="img-thumbnail" src="${orderItem.thumbnail!setting.defaultThumbnailProductImage}" alt="${orderItem.name}">
																			[/#if]
																			[#if orderItem_index == 2]
																				[#break /]
																			[/#if]
																		[/#list]
																	</td>
																	<td>${message("Aftersales.Type." + aftersales.type)}</td>
																	<td>
																		<span class="[#if aftersales.status == "FAILED"]text-red[#elseif aftersales.status == "PENDING"]text-orange[#else]text-green[/#if]">${message("Aftersales.Status." + aftersales.status)}</span>
																	</td>
																	<td>
																		<a class="btn btn-default btn-icon" href="${base}/member/aftersales/view?aftersalesId=${aftersales.id}" title="${message("common.view")}">
																			<i class="iconfont icon-search"></i>
																		</a>
																	</td>
																</tr>
															[/#list]
														</tbody>
													</table>
												</div>
											</div>
										[/#if]
										<div class="panel panel-default">
											<div class="panel-heading">${message("member.aftersales.chooseReturnsSku")}</div>
											<div class="panel-body">
												<table class="table">
													<thead>
														<tr>
															<th>
																<div class="checkbox">
																	<input type="checkbox" value="true" data-toggle="checkAll" data-target="input.return-item:enabled">
																	<label></label>
																</div>
															</th>
															<th>${message("Aftersales.store")}</th>
															<th>${message("member.aftersalesItem.sku")}</th>
															<th>${message("member.aftersalesItem.name")}</th>
															<th>${message("AftersalesItem.quantity")}</th>
															<th>${message("member.aftersalesItem.price")}</th>
														</tr>
													</thead>
													<tbody>
														[#list order.orderItems as orderItem]
															[#if orderItem.type == "GENERAL"]
																<tr>
																	<td>
																		<div class="checkbox">
																			<input name="aftersalesItems[${orderItem_index}].orderItem.id" class="return-item" type="checkbox" value="${orderItem.id}"[#if orderItem.allowApplyAftersalesQuantity <= 0] disabled[/#if]>
																			<label></label>
																		</div>
																	</td>
																	<td>${order.store.name}</td>
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
																	</td>
																	<td>
																		<div class="spinner input-group input-group-sm" data-trigger="spinner">
																			<input name="aftersalesItems[${orderItem_index}].quantity" class="form-control" type="text" maxlength="5" data-rule="quantity" data-min="1" data-max="[#if orderItem.allowApplyAftersalesQuantity > 0]${orderItem.allowApplyAftersalesQuantity}[#else]1[/#if]">
																			<span class="input-group-addon">
																				<a class="spin-up" href="javascript:;" data-spin="up">
																					<i class="fa fa-caret-up"></i>
																				</a>
																				<a class="spin-down" href="javascript:;" data-spin="down">
																					<i class="fa fa-caret-down"></i>
																				</a>
																			</span>
																		</div>
																	</td>
																	<td>${currency(orderItem.price, true)}</td>
																</tr>
															[/#if]
														[/#list]
													</tbody>
												</table>
											</div>
										</div>
										<div class="gift panel panel-default">
											<div class="panel-heading">${message("member.aftersales.returnGift")}</div>
											<div class="panel-body">
												<ul class="clearfix">
													[#list order.orderItems as orderItem]
														[#if orderItem.type == "GIFT"]
															<li>
																[#if orderItem.sku??]
																	<a href="${base}${orderItem.sku.path}" target="_blank">${orderItem.name}</a>
																[#else]
																	${orderItem.name}
																[/#if]
																<span class="text-red">[${message("Product.Type." + orderItem.type)}]</span>
																<span>&times;${orderItem.quantity}[#if orderItem_has_next] ,[/#if]</span>
															</li>
														[/#if]
													[/#list]
												</ul>
											</div>
										</div>
										<div class="panel panel-default">
											<div class="panel-heading">${message("member.aftersales.reason")}</div>
											<div class="panel-body">
												<div class="form-group">
													<label class="col-xs-3 col-sm-2 control-label item-required" for="returnReason">${message("Aftersales.reason")}:</label>
													<div class="col-xs-9 col-sm-4">
														<textarea id="returnReason" name="reason" class="form-control" rows="5"></textarea>
													</div>
												</div>
											</div>
										</div>
										<div class="panel panel-default">
											<div class="panel-heading">${message("AftersalesReturns.method")}</div>
											<div class="panel-body">
												<div class="form-group">
													<label class="col-xs-3 col-sm-2 control-label item-required">${message("member.aftersales.chooseMethod")}:</label>
													<div class="col-xs-9 col-sm-4">
														<select id="method" name="method" class="selectpicker form-control">
															[#list methods as method]
																[#noautoesc]
																	<option value="${method}">${message("AftersalesReturns.Method." + method)}</option>
																[/#noautoesc]
															[/#list]
														</select>
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-3 col-sm-2 control-label item-required" for="bank">${message("AftersalesReturns.bank")}:</label>
													<div class="col-xs-9 col-sm-4">
														<input id="bank" name="bank" class="form-control" type="text" maxlength="200">
													</div>
												</div>
												<div class="form-group">
													<label class="col-xs-3 col-sm-2 control-label item-required" for="account">${message("AftersalesReturns.account")}:</label>
													<div class="col-xs-9 col-sm-4">
														<input id="account" name="account" class="form-control" type="text" maxlength="200">
													</div>
												</div>
											</div>
										</div>
										<div class="panel panel-default">
											<div class="panel-footer">
												<div class="row">
													<div class="col-xs-9 col-sm-10 col-xs-offset-3 col-sm-offset-2">
														<button class="submit btn btn-primary" type="submit" disabled>${message("member.aftersales.submit")}</button>
														<a class="btn btn-default" href="${base}/member/order/list">${message("common.back")}</a>
													</div>
												</div>
											</div>
										</div>
									</form>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</main>
	[#include "/shop/include/main_footer.ftl" /]
</body>
</html>