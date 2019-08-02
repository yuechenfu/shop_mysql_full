<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("shop.password.forgot")} - Powered By SHOP++</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/password.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/bootstrap-growl.js"></script>
	<script src="${base}/resources/common/js/jquery.validate.js"></script>
	<script src="${base}/resources/common/js/jquery.validate.additional.js"></script>
	<script src="${base}/resources/common/js/jquery.form.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/jquery.qrcode.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/velocity.js"></script>
	<script src="${base}/resources/common/js/velocity.ui.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/shop/js/base.js"></script>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
			
				var $passwordForm = $("#passwordForm");
				var $captcha = $("#captcha");
				var $captchaImage = $("[data-toggle='captchaImage']");
				
				// 表单验证
				$passwordForm.validate({
					rules: {
						username: "required",
						email: {
							required: true,
							email: true
						},
						captcha: "required"
					},
					submitHandler: function(form) {
						$(form).ajaxSubmit({
							successRedirectUrl: "${base}/"
						});
					}
				});
				
				// 验证码图片
				$passwordForm.on("error.shopxx.ajaxSubmit", function() {
					$captchaImage.captchaImage("refresh");
				});
				
				// 验证码图片
				$captchaImage.on("refreshed.shopxx.captchaImage", function() {
					$captcha.val("");
				});
			
			});
			</script>
		[/#escape]
	[/#noautoesc]
</head>
<body class="shop password">
	[#include "/shop/include/main_header.ftl" /]
	[#include "/shop/include/main_sidebar.ftl" /]
	<main>
		<div class="container">
			<form id="passwordForm" class="form-horizontal" action="${base}/password/forgot" method="post">
				<input name="type" type="hidden" value="${type}">
				<div class="panel panel-default">
					<div class="panel-heading">
						<div class="panel-title">
							<h1 class="text-red">
								${message("shop.password.forgot")}
								<small>FORGOT PASSWORD</small>
							</h1>
						</div>
					</div>
					<div class="panel-body">
						<div class="form-group">
							<label class="col-xs-3 control-label item-required" for="username">${message("shop.password.username")}:</label>
							<div class="col-xs-6">
								<input id="username" name="username" class="form-control" type="text" maxlength="20" autocomplete="off">
							</div>
						</div>
						<div class="form-group">
							<label class="col-xs-3 control-label item-required" for="email">${message("shop.password.email")}:</label>
							<div class="col-xs-6">
								<input id="email" name="email" class="form-control" type="text" maxlength="200">
							</div>
						</div>
						[#if setting.captchaTypes?? && setting.captchaTypes?seq_contains("FORGOT_PASSWORD")]
							<div class="form-group">
								<label class="col-xs-3 control-label item-required" for="captcha">${message("common.captcha.name")}:</label>
								<div class="col-xs-6">
									<div class="input-group">
										<input id="captcha" name="captcha" class="captcha form-control" type="text" maxlength="4" autocomplete="off">
										<div class="input-group-btn">
											<img class="captcha-image" src="${base}/resources/common/images/transparent.png" title="${message("common.captcha.imageTitle")}" data-toggle="captchaImage">
										</div>
									</div>
								</div>
							</div>
						[/#if]
					</div>
					<div class="panel-footer">
						<div class="row">
							<div class="col-xs-6 col-xs-offset-3">
								<button class="btn btn-primary btn-lg btn-block" type="submit">${message("shop.password.submit")}</button>
							</div>
						</div>
					</div>
				</div>
			</form>
		</div>
	</main>
	[#include "/shop/include/main_footer.ftl" /]
</body>
</html>