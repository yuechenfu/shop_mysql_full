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
	<link href="${base}/resources/mobile/member/css/base.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/aftersales.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/bootstrap-growl.js"></script>
	<script src="${base}/resources/common/js/jquery.scrolltofixed.js"></script>
	<script src="${base}/resources/common/js/bootstrap-select.js"></script>
	<script src="${base}/resources/common/js/bootbox.js"></script>
	<script src="${base}/resources/common/js/moment.js"></script>
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
	<header class="header-default" data-spy="scrollToFixed">
		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-1">
					<a href="${base}/member/aftersales/list">
						<i class="iconfont icon-back"></i>
					</a>
				</div>
				<div class="col-xs-10">
					<h5>${message("member.aftersales.detail")}</h5>
				</div>
			</div>
		</div>
	</header>
	<main>
		<div class="container-fluid">
			<div id="transitStepModal" class="transit-step-modal modal fade" tabindex="-1">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<button class="close" type="button" data-dismiss="modal">&times;</button>
							<h5 class="modal-title">${message("member.aftersales.transitStep")}</h5>
						</div>
						<div class="modal-body"></div>
						<div class="modal-footer">
							<button class="btn btn-default btn-sm" type="button" data-dismiss="modal">${message("common.close")}</button>
						</div>
					</div>
				</div>
			</div>
			<form id="aftersalesViewForm" class="ajax-form form-horizontal" action="${base}/member/aftersales/transit_tabs" method="post">
				<div class="list-group">
					<div class="list-group-item clearfix">
						<h5>${message("member.aftersales.info")}</h5>
						<span class="pull-left">${message("member.aftersales.type")}: ${message("Aftersales.Type." + aftersales.type)}</span>
						<span class="pull-left">
							${message("Aftersales.status")}:
							<span class="[#if aftersales.status == "PENDING"]text-orange[#elseif aftersales.status == "FAILED"]text-red[#elseif aftersales.status == "CANCELED"]text-gray-dark[#else]text-green[/#if]">${message("Aftersales.Status." + aftersales.status)}</span>
						</span>
						[#if aftersales.status == "PENDING" || aftersales.status == "APPROVED"]
							<span class="pull-right">
								<a id="cancel" class="btn btn-default btn-sm" href="javascript:;">${message("member.aftersales.cancel")}</a>
							</span>
						[/#if]
					</div>
					<div class="list-group-item">
						<h5>${message("member.aftersales.sku")}</h5>
						<table class="table">
							<thead>
								<tr>
									<th>${message("member.aftersalesItem.sku")}</th>
									<th>${message("member.aftersalesItem.name")}</th>
									<th>${message("AftersalesItem.quantity")}</th>
								</tr>
							</thead>
							<tbody>
								[#list aftersales.aftersalesItems as aftersalesItem]
									<tr>
										<td>
											[#if aftersalesItem.orderItem.sku??]
												<a href="${base}${aftersalesItem.orderItem.sku.path}" title="${aftersalesItem.orderItem.name}">
													<img src="${aftersalesItem.orderItem.thumbnail!setting.defaultThumbnailProductImage}" alt="${aftersalesItem.orderItem.name}">
												</a>
											[#else]
												<img src="${aftersalesItem.orderItem.thumbnail!setting.defaultThumbnailProductImage}" alt="${aftersalesItem.orderItem.name}">
											[/#if]
										</td>
										<td>
											<a href="${base}${aftersalesItem.orderItem.sku.path}">${aftersalesItem.orderItem.name}</a>
										</td>
										<td>&times;${aftersalesItem.quantity}</td>
									</tr>
								[/#list]
							</tbody>
						</table>
					</div>
					<div class="list-group-item">
						<h5>${message("member.aftersales.reason")}</h5>
						<p>${aftersales.reason}</p>
					</div>
					[#if aftersales.type == "AFTERSALES_REPAIR" || aftersales.type == "AFTERSALES_REPLACEMENT"]
						<div class="list-group-item">
							<h5>${message("member.aftersales.receiveMethod")}</h5>
							<div class="form-group">
								<label class="col-xs-3 control-label">${message("AftersalesRepair.consignee")}:</label>
								<div class="col-xs-9">
									<p>${aftersales.consignee}</p>
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-3 control-label">${message("AftersalesRepair.address")}:</label>
								<div class="col-xs-9">
									<p>${aftersales.area}${aftersales.address}</p>
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-3 control-label">${message("AftersalesRepair.phone")}:</label>
								<div class="col-xs-9">
									<p>${aftersales.phone}</p>
								</div>
							</div>
						</div>
					[#else]
					<div class="list-group-item">
						<h5>${message("AftersalesReturns.method")}</h5>
						<div class="form-group">
							<label class="col-xs-3 control-label">${message("AftersalesReturns.method")}:</label>
							<div class="col-xs-9">
								<p>${message("AftersalesReturns.Method." + aftersales.method)}</p>
							</div>
						</div>
						<div class="form-group">
							<label class="col-xs-3 control-label">${message("AftersalesReturns.bank")}:</label>
							<div class="col-xs-9">
								<p>${aftersales.bank!"-"}</p>
							</div>
						</div>
						<div class="form-group">
							<label class="col-xs-3 control-label">${message("AftersalesReturns.account")}:</label>
							<div class="col-xs-9">
								<p>${aftersales.account!"-"}</p>
							</div>
						</div>
					</div>
					[/#if]
					[#if aftersales.status == "APPROVED" && !aftersales.trackingNo??]
						<div class="list-group-item">
							<input name="aftersalesId" type="hidden" value="${aftersales.id}">
							<h5>${message("member.aftersales.transitStep")}</h5>
							<div class="form-group">
								<label class="item-required" for="trackingNo">${message("member.aftersales.trackingNo")}:</label>
								<input id="trackingNo" name="trackingNo" class="form-control" type="text" maxlength="200">
							</div>
							<div class="form-group">
								<label class="item-required">${message("member.aftersales.deliveryCorp")}:</label>
								<select name="deliveryCorpId" class="selectpicker form-control">
									[#list deliveryCorps as deliveryCorp]
										<option value="${deliveryCorp.id}">${deliveryCorp.name}</option>
									[/#list]
								</select>
							</div>
							<div class="form-group">
								<div class="text-center">
									<button class="submit btn btn-primary btn-sm" type="submit">${message("member.aftersales.submitInfo")}</button>
									<a class="btn btn-default btn-sm" href="${base}/member/aftersales/list">${message("common.back")}</a>
								</div>
							</div>
						</div>
					[#elseif aftersales.trackingNo?has_content && aftersales.deliveryCorp?has_content]
						<div class="list-group-item">
							<input name="aftersalesId" type="hidden" value="${aftersales.id}">
							<h5>${message("member.aftersales.transitStep")}</h5>
							<div class="form-group">
								<label class="col-xs-3 control-label">${message("member.aftersales.trackingNo")}:</label>
								<div class="col-xs-9">
									${aftersales.trackingNo}
									[#if isKuaidi100Enabled]
										<a class="transit-step text-orange" href="javascript:;" data-aftersales-id="${aftersales.id}">[${message("member.aftersales.viewTransitStep")}]</a>
									[/#if]
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-3 control-label">${message("member.aftersales.deliveryCorp")}:</label>
								<div class="col-xs-9">${aftersales.deliveryCorp}</div>
							</div>
						</div>
					[/#if]
				</div>
			</form>
		</div>
	</main>
</body>
</html>