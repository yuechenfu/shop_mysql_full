<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.receiver.add")}[#if showPowered] - Powered By SHOP++[/#if]</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/awesome-bootstrap-checkbox.css" rel="stylesheet">
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
	<script src="${base}/resources/common/js/jquery.lSelect.js"></script>
	<script src="${base}/resources/common/js/jquery.validate.js"></script>
	<script src="${base}/resources/common/js/jquery.validate.additional.js"></script>
	<script src="${base}/resources/common/js/jquery.form.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/mobile/member/js/base.js"></script>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
				
				var $inputForm = $("#inputForm");
				var $areaId = $("#areaId");
				
				// 地区选择
				$areaId.lSelect({
					url: "${base}/common/area"
				});
				
				// 表单验证
				$inputForm.validate({
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
					},
					submitHandler: function(form) {
						$(form).ajaxSubmit({
							successRedirectUrl: "${base}/member/receiver/list"
						});
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
					<a href="${base}/member/receiver/list">
						<i class="iconfont icon-back"></i>
					</a>
				</div>
				<div class="col-xs-10">
					<h5>${message("member.receiver.add")}</h5>
				</div>
			</div>
		</div>
	</header>
	<main>
		<div class="container-fluid">
			<form id="inputForm" action="${base}/member/receiver/save" method="post">
				<div class="panel panel-default">
					<div class="panel-body">
						<div class="form-group">
							<label class="item-required" for="consignee">${message("Receiver.consignee")}</label>
							<input id="consignee" name="consignee" class="form-control" type="text" maxlength="20">
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
					</div>
					<div class="panel-footer text-center">
						<button class="btn btn-primary" type="submit">${message("common.submit")}</button>
						<a class="btn btn-default" href="${base}/member/receiver/list">${message("common.back")}</a>
					</div>
				</div>
			</form>
		</div>
	</main>
</body>
</html>