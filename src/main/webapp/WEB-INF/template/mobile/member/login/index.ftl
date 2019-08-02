<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.login.title")}[#if showPowered] - Powered By SHOP++[/#if]</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/awesome-bootstrap-checkbox.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/base.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/login.css" rel="stylesheet">
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
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
				
				var $document = $(document);
				var $loginForm = $("#loginForm");
				var $input = $("#loginForm input");
				var $username = $("#username");
				var $password = $("#password");
				var $captcha = $("#captcha");
				var $captchaImage = $("[data-toggle='captchaImage']");
				var $rememberUsername = $("#rememberUsername");
				var rememberedUsernameLocalStorageKey = "rememberedMemberUsername";
				var loginSuccessUrl = "${base}${memberLoginSuccessUrl}";
				var $footer = $("footer");
				
				// 记住用户名
				if (localStorage.getItem(rememberedUsernameLocalStorageKey) != null) {
					$username.val(localStorage.getItem(rememberedUsernameLocalStorageKey));
					$password.focus();
					$rememberUsername.prop("checked", true);
				} else {
					$username.focus();
					$rememberUsername.prop("checked", false);
				}
				
				// 输入框
				$input.focus(function() {
					$footer.css("position", "static");
				}).blur(function() {
					$footer.css("position", "fixed");
				});
				
				// 底部
				$footer.velocity("transition.slideUpBigIn");
				
				// 表单验证
				$loginForm.validate({
					rules: {
						username: "required",
						password: {
							required: true,
							normalizer: function(value) {
								return value;
							}
						},
						captcha: "required"
					},
					messages: {
						username: {
							required: "${message("member.login.usernameRequired")}"
						},
						password: {
							required: "${message("member.login.passwordRequired")}"
						},
						captcha: {
							required: "${message("member.login.captchaRequired")}"
						}
					},
					submitHandler: function(form) {
						$(form).ajaxSubmit({
							successMessage: false,
							successRedirectUrl: function(redirectUrlParameterName) {
								var redirectUrl = Url.queryString(redirectUrlParameterName);
								
								return $.trim(redirectUrl) != "" ? redirectUrl : loginSuccessUrl;
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
				
				// 用户登录成功、记住用户名
				$loginForm.on("success.shopxx.ajaxSubmit", function() {
					$document.trigger("loggedIn.shopxx.user", [{
						type: "member",
						username: $username.val()
					}]);
					
					if ($rememberUsername.prop("checked")) {
						localStorage.setItem(rememberedUsernameLocalStorageKey, $username.val());
					} else {
						localStorage.removeItem(rememberedUsernameLocalStorageKey);
					}
				});
				
				// 验证码图片
				$loginForm.on("error.shopxx.ajaxSubmit", function() {
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
<body class="member login">
	<header class="header-default" data-spy="scrollToFixed">
		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-1">
					<a href="javascript:;" data-action="back">
						<i class="iconfont icon-back"></i>
					</a>
				</div>
				<div class="col-xs-10">
					<h5>
						[#if socialUserId?has_content && uniqueId?has_content]
							${message("member.login.bind")}
						[#else]
							${message("member.login.title")}
						[/#if]
					</h5>
				</div>
			</div>
		</div>
	</header>
	<main>
		<div class="container-fluid">
			<form id="loginForm" action="${base}/member/login" method="post">
				<input name="socialUserId" type="hidden" value="${socialUserId}">
				<input name="uniqueId" type="hidden" value="${uniqueId}">
				<div class="form-group">
					<div class="input-group">
						<span class="input-group-addon">
							<i class="iconfont icon-people"></i>
						</span>
						<input id="username" name="username" class="form-control" type="text" maxlength="200" placeholder="${message("member.login.usernamePlaceholder")}" autocomplete="off">
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<span class="input-group-addon">
							<i class="iconfont icon-lock"></i>
						</span>
						<input id="password" name="password" class="form-control" type="password" maxlength="200" placeholder="${message("member.login.passwordPlaceholder")}" autocomplete="off">
					</div>
				</div>
				[#if setting.captchaTypes?? && setting.captchaTypes?seq_contains("MEMBER_LOGIN")]
					<div class="form-group">
						<div class="input-group">
							<span class="input-group-addon">
								<i class="iconfont icon-pic"></i>
							</span>
							<input id="captcha" name="captcha" class="captcha form-control" type="text" maxlength="4" placeholder="${message("common.captcha.name")}" autocomplete="off">
							<div class="input-group-btn">
								<img class="captcha-image" src="${base}/resources/common/images/transparent.png" title="${message("common.captcha.imageTitle")}" data-toggle="captchaImage">
							</div>
						</div>
					</div>
				[/#if]
				<div class="checkbox">
					<input id="rememberUsername" name="rememberUsername" type="checkbox" value="true">
					<label for="rememberUsername">${message("member.login.rememberUsername")}</label>
				</div>
				[#if socialUserId?has_content && uniqueId?has_content]
					<button class="btn btn-primary btn-lg btn-block" type="submit">${message("member.login.bind")}</button>
				[#else]
					<button class="btn btn-primary btn-lg btn-block" type="submit">${message("member.login.submit")}</button>
				[/#if]
			</form>
			<div class="row">
				<div class="col-xs-6 text-left">
				[#if socialUserId?has_content && uniqueId?has_content]
					<a href="${base}/member/register?socialUserId=${socialUserId}&uniqueId=${uniqueId}">${message("member.login.registerBind")}</a>
				[#else]
					<a href="${base}/member/register">${message("member.login.register")}</a>
				[/#if]
				</div>
				<div class="col-xs-6 text-right">
					<a href="${base}/password/forgot?type=MEMBER">${message("member.login.forgotPassword")}</a>
				</div>
			</div>
		</div>
	</main>
	<footer class="text-center">
		[#if loginPlugins?has_content && !socialUserId?has_content && !uniqueId?has_content]
			[#list loginPlugins as loginPlugin]
				<a href="${base}/social_user_login?loginPluginId=${loginPlugin.id}"[#if loginPlugin.description??] title="${loginPlugin.description}"[/#if]>
					[#if loginPlugin.logo?has_content]
						<img src="${loginPlugin.logo}" alt="${loginPlugin.displayName}">
					[#else]
						${loginPlugin.displayName}
					[/#if]
				</a>
			[/#list]
		[/#if]
	</footer>
</body>
</html>