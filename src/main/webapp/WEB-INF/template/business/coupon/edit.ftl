<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.coupon.edit")} - Powered By SHOP++</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/awesome-bootstrap-checkbox.css" rel="stylesheet">
	<link href="${base}/resources/common/css/bootstrap-datetimepicker.css" rel="stylesheet">
	<link href="${base}/resources/common/css/summernote.css" rel="stylesheet">
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
	<script src="${base}/resources/common/js/bootstrap-datetimepicker.js"></script>
	<script src="${base}/resources/common/js/summernote.js"></script>
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
			
				var $couponForm = $("#couponForm");
				var $isExchange = $("#isExchange");
				var $point = $("#point");
				
				// 是否允许积分兑换
				$isExchange.change(function() {
					var checked = $(this).prop("checked");
					
					$point.prop("disabled", !checked).closest(".form-group").velocity(checked ? "slideDown" : "slideUp");
				});
				
				// 表单验证
				$couponForm.validate({
					rules: {
						name: "required",
						prefix: "required",
						minimumPrice: {
							number: true,
							min: 0,
							decimal: {
								integer: 12,
								fraction: ${setting.priceScale}
							}
						},
						maximumPrice: {
							number: true,
							min: 0,
							decimal: {
								integer: 12,
								fraction: ${setting.priceScale}
							},
							greaterThanEqual: "#minimumPrice"
						},
						minimumQuantity: "digits",
						maximumQuantity: {
							digits: true,
							greaterThanEqual: "#minimumQuantity"
						},
						priceExpression: {
							remote: {
								url: "${base}/business/coupon/check_price_expression",
								cache: false
							}
						},
						point: {
							required: true,
							digits: true
						}
					}
				});
			
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
			<ol class="breadcrumb">
				<li>
					<a href="${base}/business/index">
						<i class="iconfont icon-homefill"></i>
						${message("common.breadcrumb.index")}
					</a>
				</li>
				<li class="active">${message("business.coupon.edit")}</li>
			</ol>
			<form id="couponForm" class="ajax-form form-horizontal" action="${base}/business/coupon/update" method="post">
				<input name="couponId" type="hidden" value="${coupon.id}">
				<div class="panel panel-default">
					<div class="panel-body">
						<ul class="nav nav-tabs">
							<li class="active">
								<a href="#base" data-toggle="tab">${message("business.coupon.base")}</a>
							</li>
							<li>
								<a href="#introduction" data-toggle="tab">${message("Coupon.introduction")}</a>
							</li>
						</ul>
						<div class="tab-content">
							<div id="base" class="tab-pane active">
								<div class="form-group">
									<label class="col-xs-3 col-sm-2 control-label item-required" for="name">${message("Coupon.name")}:</label>
									<div class="col-xs-9 col-sm-4">
										<input id="name" name="name" class="form-control" type="text" value="${coupon.name}" maxlength="200">
									</div>
								</div>
								<div class="form-group">
									<label class="col-xs-3 col-sm-2 control-label item-required" for="prefix">${message("Coupon.prefix")}:</label>
									<div class="col-xs-9 col-sm-4">
										<input id="prefix" name="prefix" class="form-control" type="text" value="${coupon.prefix}" maxlength="200">
									</div>
								</div>
								<div class="form-group">
									<label class="col-xs-3 col-sm-2 control-label" for="beginDate">${message("common.dateRange")}:</label>
									<div class="col-xs-9 col-sm-4">
										<div class="input-group" data-provide="datetimerangepicker" data-date-format="YYYY-MM-DD HH:mm:ss">
											<input id="beginDate" name="beginDate" class="form-control" type="text" value="[#if coupon.beginDate??]${coupon.beginDate?string("yyyy-MM-dd HH:mm:ss")}[/#if]">
											<span class="input-group-addon">-</span>
											<input name="endDate" class="form-control" type="text" value="[#if coupon.endDate??]${coupon.endDate?string("yyyy-MM-dd HH:mm:ss")}[/#if]">
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col-xs-3 col-sm-2 control-label" for="minimumPrice">${message("common.priceRange")}:</label>
									<div class="col-xs-9 col-sm-4">
										<div class="input-group">
											<input id="minimumPrice" name="minimumPrice" class="form-control" type="text" value="${coupon.minimumPrice}" maxlength="16">
											<span class="input-group-addon">-</span>
											<input name="maximumPrice" class="form-control" type="text" value="${coupon.maximumPrice}" maxlength="16">
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col-xs-3 col-sm-2 control-label" for="minimumQuantity">${message("common.quantityRange")}:</label>
									<div class="col-xs-9 col-sm-4">
										<div class="input-group">
											<input id="minimumQuantity" name="minimumQuantity" class="form-control" type="text" value="${coupon.minimumQuantity}" maxlength="9">
											<span class="input-group-addon">-</span>
											<input name="maximumQuantity" class="form-control" type="text" value="${coupon.maximumQuantity}" maxlength="9">
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col-xs-3 col-sm-2 control-label" for="priceExpression">${message("Coupon.priceExpression")}:</label>
									<div class="col-xs-9 col-sm-4" title="${message("business.coupon.priceExpressionTitle")}" data-toggle="tooltip">
										<input id="priceExpression" name="priceExpression" class="form-control" type="text" value="${coupon.priceExpression}" maxlength="200">
									</div>
								</div>
								<div class="form-group">
									<label class="col-xs-3 col-sm-2 control-label">${message("common.setting")}:</label>
									<div class="col-xs-9 col-sm-4">
										<div class="checkbox checkbox-inline">
											<input name="_isEnabled" type="hidden" value="false">
											<input id="isEnabled" name="isEnabled" type="checkbox" value="true"[#if coupon.isEnabled] checked[/#if]>
											<label for="isEnabled">${message("Coupon.isEnabled")}</label>
										</div>
										<div class="checkbox checkbox-inline">
											<input name="_isExchange" type="hidden" value="false">
											<input id="isExchange" name="isExchange" type="checkbox" value="true"[#if coupon.isExchange] checked[/#if]>
											<label for="isExchange">${message("Coupon.isExchange")}</label>
										</div>
									</div>
								</div>
								<div class="form-group[#if !coupon.isExchange] hidden-element[/#if]">
									<label class="col-xs-3 col-sm-2 control-label item-required" for="point">${message("Coupon.point")}:</label>
									<div class="col-xs-9 col-sm-4">
										<input id="point" name="point" class="form-control" type="text" value="${coupon.point}" maxlength="9"[#if !coupon.isExchange] disabled[/#if]>
									</div>
								</div>
							</div>
							<div id="introduction" class="tab-pane">
								<textarea name="introduction" data-provide="editor">${coupon.introduction}</textarea>
							</div>
						</div>
					</div>
					<div class="panel-footer">
						<div class="row">
							<div class="col-xs-9 col-sm-10 col-xs-offset-3 col-sm-offset-2">
								<button class="btn btn-primary" type="submit">${message("common.submit")}</button>
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