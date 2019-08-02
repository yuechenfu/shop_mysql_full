<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.aftersales.view")} - Powered By SHOP++</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
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
	<script src="${base}/resources/common/js/bootbox.js"></script>
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
				
				var $aftersalesViewForm = $("#aftersalesViewForm");
				var $cancel = $("#cancel");
				var $transitStep = $("a.transit-step");
				var $transitStepModal = $("#transitStepModal");
				var $transitStepModalBody = $("#transitStepModal div.modal-body");
				var transitStepTemplate = _.template($("#transitStepTemplate").html());
				
				// 取消
				$cancel.click(function() {
					bootbox.confirm("${message("member.aftersales.cancelConfirm")}", function(result) {
						if (result == null || !result) {
							return;
						}
						
						$.ajax({
							url: "${base}/member/aftersales/cancel?aftersalesId=${aftersales.id}",
							type: "POST",
							dataType: "json",
							cache: false,
							success: function(data) {
								location.reload(true);
							}
						});
					});
				});
				
				// 物流动态
				$transitStep.click(function() {
					var $element = $(this);
					
					$.ajax({
						url: "${base}/member/aftersales/transit_step",
						type: "GET",
						data: {
							aftersalesId: $element.data("aftersales-id")
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
				
				// 表单验证
				$aftersalesViewForm.validate({
					rules: {
						trackingNo: "required",
						deliveryCorpId: "required"
					},
					submitHandler: function(form) {
						$(form).ajaxSubmit({
							successRedirectUrl: "${base}/member/aftersales/view?aftersalesId=${aftersales.id}"
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
			<div id="transitStepModal" class="modal fade" tabindex="-1">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<button class="close" type="button" data-dismiss="modal">&times;</button>
							<h5 class="modal-title">${message("member.aftersales.transitStep")}</h5>
						</div>
						<div class="modal-body"></div>
						<div class="modal-footer">
							<button class="btn btn-default" type="button" data-dismiss="modal">${message("common.close")}</button>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-xs-2">
					[#include "/member/include/main_menu.ftl" /]
				</div>
				<div class="col-xs-10">
					<form id="aftersalesViewForm" class="ajax-form form-horizontal" action="${base}/member/aftersales/transit_tabs" method="post">
						<div class="aftersales-detail panel panel-default">
							<div class="panel-heading">${message("member.aftersales.detail")}</div>
							<div class="panel-body">
								<div class="list-group">
									<div class="list-group-item clearfix">
										<div class="row">
											<div class="col-xs-2">${message("member.aftersales.type")}: ${message("Aftersales.Type." + aftersales.type)}</div>
											<div class="col-xs-2">
												${message("Aftersales.status")}:
												<span class="[#if aftersales.status == "FAILED"]text-red[#elseif aftersales.status == "PENDING"]text-orange[#elseif aftersales.status == "CANCELED"]text-gray-dark[#else]text-green[/#if]">${message("Aftersales.Status." + aftersales.status)}</span>
											</div>
											[#if aftersales.status == "PENDING" || aftersales.status == "APPROVED"]
												<div class="col-xs-8">
													<a id="cancel" class="btn btn-default pull-right" href="javascript:;">${message("member.aftersales.cancel")}</a>
												</div>
											[/#if]
										</div>
									</div>
									<div class="list-group-item">
										<dl class="clearfix">
											<dt>${message("member.aftersales.reason")}</dt>
											<dd>${aftersales.reason}</dd>
										</dl>
									</div>
									[#if aftersales.type == "AFTERSALES_REPAIR" || aftersales.type == "AFTERSALES_REPLACEMENT"]
										<div class="list-group-item">
											<dl class="clearfix">
												<dt>${message("member.aftersales.receiveMethod")}</dt>
												<dd>
													${message("AftersalesRepair.consignee")}:
													<span class="text-gray-darker">${aftersales.consignee}</span>
												</dd>
												<dd>
													${message("AftersalesRepair.address")}:
													<span class="text-gray-darker">${aftersales.area}${aftersales.address}</span>
												</dd>
												<dd>
													${message("AftersalesRepair.phone")}:
													<span class="text-gray-darker">${aftersales.phone}</span>
												</dd>
											</dl>
										</div>
									[#else]
									<div class="list-group-item">
										<dl class="clearfix">
											<dt>${message("AftersalesReturns.method")}</dt>
											<dd>
												${message("AftersalesReturns.method")}:
												<span class="text-gray-darker">[#if aftersales.method?has_content]${message("AftersalesReturns.Method." + aftersales.method)}[#else]-[/#if]</span>
											</dd>
											<dd>
												${message("AftersalesReturns.bank")}:
												<span class="text-gray-darker">${aftersales.bank!"-"}</span>
											</d>
											<dd>
												${message("AftersalesReturns.account")}:
												<span class="text-gray-darker">${aftersales.account!"-"}</span>
											</dd>
										</dl>
									</div>
									[/#if]
									[#if aftersales.status == "APPROVED" && !aftersales.trackingNo??]
										<input name="aftersalesId" type="hidden" value="${aftersales.id}">
										<div class="list-group-item">
											<dl class="aftersales-transit clearfix">
												<dt>${message("member.aftersales.transitStep")}</dt>
												<dd>
													<div class="form-group">
														<label class="col-xs-3 col-sm-2 control-label item-required" for="trackingNo">${message("member.aftersales.trackingNo")}:</label>
														<div class="col-xs-9 col-sm-4">
															<input id="trackingNo" name="trackingNo" class="form-control" type="text" maxlength="200">
														</div>
													</div>
												</dd>
												<dd>
													<div class="form-group">
														<label class="col-xs-3 col-sm-2 control-label item-required">${message("member.aftersales.deliveryCorp")}:</label>
														<div class="col-xs-9 col-sm-4">
															<select name="deliveryCorpId" class="selectpicker form-control">
																[#list deliveryCorps as deliveryCorp]
																	<option value="${deliveryCorp.id}">${deliveryCorp.name}</option>
																[/#list]
															</select>
														</div>
													</div>
												</dd>
												<dd>
													<div class="form-group">
														<div class="col-xs-9 col-sm-10 col-xs-offset-3 col-sm-offset-2">
															<button class="submit btn btn-primary" type="submit">${message("member.aftersales.submitInfo")}</button>
															<a class="btn btn-default" href="${base}/member/aftersales/list">${message("common.back")}</a>
														</div>
													</div>
												</dd>
											</dl>
										</div>
									[#elseif aftersales.trackingNo?has_content && aftersales.deliveryCorp?has_content]
										<div class="list-group-item">
											<dl class="clearfix">
												<input name="aftersalesId" type="hidden" value="${aftersales.id}">
												<dt>${message("member.aftersales.transitStep")}</dt>
												<dd>
													${message("member.aftersales.trackingNo")}:
													<span class="text-gray-darker">
														${aftersales.trackingNo}
														[#if isKuaidi100Enabled]
															<a class="transit-step text-orange" href="javascript:;" data-aftersales-id="${aftersales.id}">[${message("member.aftersales.viewTransitStep")}]</a>
														[/#if]
													</span>
												</dd>
												<dd>${message("member.aftersales.deliveryCorp")}:
													<span class="text-gray-darker">${aftersales.deliveryCorp}</span>
												</dd>
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
											<th>${message("Aftersales.store")}</th>
											<th>${message("member.aftersalesItem.sku")}</th>
											<th>${message("member.aftersalesItem.name")}</th>
											<th>${message("AftersalesItem.quantity")}</th>
										</tr>
									</thead>
									<tbody>
										[#list aftersales.aftersalesItems as aftersalesItem]
											<tr>
												<td>${aftersales.store.name}</td>
												<td>
													[#if aftersalesItem.orderItem.sku??]
														<a href="${base}${aftersalesItem.orderItem.sku.path}" title="${aftersalesItem.orderItem.name}" target="_blank">
															<img class="img-thumbnail" src="${aftersalesItem.orderItem.thumbnail!setting.defaultThumbnailProductImage}" alt="${aftersalesItem.orderItem.name}">
														</a>
													[#else]
														<img class="img-thumbnail" src="${aftersalesItem.orderItem.thumbnail!setting.defaultThumbnailProductImage}" alt="${aftersalesItem.orderItem.name}">
													[/#if]
												</td>
												<td>
													[#if aftersalesItem.orderItem.sku??]
														<a href="${base}${aftersalesItem.orderItem.sku.path}" target="_blank">${aftersalesItem.orderItem.name}</a>
													[#else]
														${aftersalesItem.orderItem.name}
													[/#if]
												</td>
												<td>&times;${aftersalesItem.quantity}</td>
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