<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.register.title")}[#if showPowered] - Powered By SHOP++[/#if]</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/awesome-bootstrap-checkbox.css" rel="stylesheet">
	<link href="${base}/resources/common/css/bootstrap-datetimepicker.css" rel="stylesheet">
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
	<script src="${base}/resources/common/js/moment.js"></script>
	<script src="${base}/resources/common/js/bootstrap-datetimepicker.js"></script>
	<script src="${base}/resources/common/js/jquery.lSelect.js"></script>
	<script src="${base}/resources/common/js/jquery.validate.js"></script>
	<script src="${base}/resources/common/js/jquery.validate.additional.js"></script>
	<script src="${base}/resources/common/js/jquery.form.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/jquery.base64.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/mobile/member/js/base.js"></script>
	<style>
		.register main {
			padding: 10px;
			background-color: #ffffff;
		}
		
		.register main .btn-primary {
			margin-bottom: 10px;
		}
	</style>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
				
				var $document = $(document);
				var $registerForm = $("#registerForm");
				var $spreadMemberUsername = $("input[name='spreadMemberUsername']");
				var $username = $("#username");
				var $areaId = $("#areaId");
				var $captcha = $("#captcha");
				var $captchaImage = $("[data-toggle='captchaImage']");
				
				// 推广用户
				var spreadUser = $.getSpreadUser();
				if (spreadUser != null) {
					$spreadMemberUsername.val(spreadUser.username);
				}
				
				// 地区选择
				$areaId.lSelect({
					url: "${base}/common/area"
				});
				
				// 表单验证
				$registerForm.validate({
					rules: {
						username: {
							required: true,
							minlength: 4,
							username: true,
							notAllNumber: true,
							remote: {
								url: "${base}/member/register/check_username",
								cache: false
							}
						},
						password: {
							required: true,
							minlength: 4,
							normalizer: function(value) {
								return value;
							}
						},
						rePassword: {
							required: true,
							equalTo: "#password",
							normalizer: function(value) {
								return value;
							}
						},
						email: {
							required: true,
							email: true,
							remote: {
								url: "${base}/member/register/check_email",
								cache: false
							}
						},
						mobile: {
							required: true,
							mobile: true,
							remote: {
								url: "${base}/member/register/check_mobile",
								cache: false
							}
						},
						captcha: "required"
						[@member_attribute_list]
							[#list memberAttributes as memberAttribute]
								[#if memberAttribute.isRequired || memberAttribute.pattern?has_content]
									,"memberAttribute_${memberAttribute.id}": {
										[#if memberAttribute.isRequired]
											required: true
											[#if memberAttribute.pattern?has_content],[/#if]
										[/#if]
										[#if memberAttribute.pattern?has_content]
											pattern: new RegExp("${memberAttribute.pattern}")
										[/#if]
									}
								[/#if]
							[/#list]
						[/@member_attribute_list]
					},
					messages: {
						username: {
							remote: "${message("member.register.usernameExist")}"
						},
						email: {
							remote: "${message("member.register.emailExist")}"
						},
						mobile: {
							remote: "${message("member.register.mobileExist")}"
						}
					},
					submitHandler: function(form) {
						$(form).ajaxSubmit({
							successMessage: false,
							successRedirectUrl: "${base}/"
						});
					}
				});
				
				// 用户注册成功
				$registerForm.on("success.shopxx.ajaxSubmit", function() {
					$document.trigger("registered.shopxx.user", [{
						type: "member",
						username: $username.val()
					}]);
				});
				
				// 验证码图片
				$registerForm.on("error.shopxx.ajaxSubmit", function() {
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
<body class="member register">
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
							${message("member.register.bind")}
						[#else]
							${message("member.register.title")}
						[/#if]
					</h5>
				</div>
			</div>
		</div>
	</header>
	<main>
		<div class="container-fluid">
			<form id="registerForm" action="${base}/member/register/submit" method="post">
				<input name="socialUserId" type="hidden" value="${socialUserId}">
				<input name="uniqueId" type="hidden" value="${uniqueId}">
				<input name="spreadMemberUsername" type="hidden">
				<div class="form-group">
					<label class="item-required" for="username">${message("member.register.username")}</label>
					<input id="username" name="username" class="form-control" type="text" maxlength="20" autocomplete="off">
				</div>
				<div class="form-group">
					<label class="item-required" for="password">${message("member.register.password")}</label>
					<input id="password" name="password" class="form-control" type="password" maxlength="20" autocomplete="off">
				</div>
				<div class="form-group">
					<label class="item-required" for="rePassword">${message("member.register.rePassword")}</label>
					<input id="rePassword" name="rePassword" class="form-control" type="password" maxlength="20" autocomplete="off">
				</div>
				<div class="form-group">
					<label class="item-required" for="email">${message("member.register.email")}</label>
					<input id="email" name="email" class="form-control" type="text" maxlength="200">
				</div>
				<div class="form-group">
					<label class="item-required" for="mobile">${message("member.register.mobile")}</label>
					<input id="mobile" name="mobile" class="form-control" type="text" maxlength="200">
				</div>
				[@member_attribute_list]
					[#list memberAttributes as memberAttribute]
						<div class="form-group">
							<label[#if memberAttribute.isRequired] class="item-required"[/#if][#if memberAttribute.type != "GENDER" && memberAttribute.type != "AREA" && memberAttribute.type != "CHECKBOX"] for="memberAttribute_${memberAttribute.id}"[/#if]>${memberAttribute.name}</label>
							[#if memberAttribute.type == "NAME"]
								<input id="memberAttribute_${memberAttribute.id}" name="memberAttribute_${memberAttribute.id}" class="form-control" type="text" maxlength="200">
							[#elseif memberAttribute.type == "GENDER"]
								<p>
									[#list genders as gender]
										<div class="radio radio-inline">
											<input id="${gender}" name="memberAttribute_${memberAttribute.id}" type="radio" value="${gender}">
											<label for="${gender}">${message("Member.Gender." + gender)}</label>
										</div>
									[/#list]
								</p>
							[#elseif memberAttribute.type == "BIRTH"]
								<div class="input-group">
									<input id="memberAttribute_${memberAttribute.id}" name="memberAttribute_${memberAttribute.id}" class="form-control" type="text" data-provide="datetimepicker">
									<span class="input-group-addon">
										<i class="iconfont icon-calendar"></i>
									</span>
								</div>
							[#elseif memberAttribute.type == "AREA"]
								<div class="input-group">
									<input id="areaId" name="memberAttribute_${memberAttribute.id}" type="hidden">
								</div>
							[#elseif memberAttribute.type == "ADDRESS"]
								<input id="memberAttribute_${memberAttribute.id}" name="memberAttribute_${memberAttribute.id}" class="form-control" type="text" maxlength="200">
							[#elseif memberAttribute.type == "ZIP_CODE"]
								<input id="memberAttribute_${memberAttribute.id}" name="memberAttribute_${memberAttribute.id}" class="form-control" type="text" maxlength="200">
							[#elseif memberAttribute.type == "PHONE"]
								<input id="memberAttribute_${memberAttribute.id}" name="memberAttribute_${memberAttribute.id}" class="form-control" type="text" maxlength="200">
							[#elseif memberAttribute.type == "TEXT"]
								<input id="memberAttribute_${memberAttribute.id}" name="memberAttribute_${memberAttribute.id}" class="form-control" type="text" maxlength="200">
							[#elseif memberAttribute.type == "SELECT"]
								<select id="memberAttribute_${memberAttribute.id}" name="memberAttribute_${memberAttribute.id}" class="form-control">
									<option value="">${message("common.choose")}</option>
									[#list memberAttribute.options as option]
										<option value="${option}">${option}</option>
									[/#list]
								</select>
							[#elseif memberAttribute.type == "CHECKBOX"]
								<p>
									[#list memberAttribute.options as option]
										<div class="checkbox checkbox-inline">
											<input id="${option}_${memberAttribute.id}" name="memberAttribute_${memberAttribute.id}" type="checkbox" value="${option}">
											<label for="${option}_${memberAttribute.id}">${option}</label>
										</div>
									[/#list]
								</p>
							[/#if]
						</div>
					[/#list]
				[/@member_attribute_list]
				[#if setting.captchaTypes?? && setting.captchaTypes?seq_contains("MEMBER_REGISTER")]
					<div class="form-group">
						<label class="item-required" for="captcha">${message("common.captcha.name")}</label>
						<div class="input-group">
							<input id="captcha" name="captcha" class="captcha form-control" type="text" maxlength="4" autocomplete="off">
							<div class="input-group-btn">
								<img class="captcha-image" src="${base}/resources/common/images/transparent.png" title="${message("common.captcha.imageTitle")}" data-toggle="captchaImage">
							</div>
						</div>
					</div>
				[/#if]
				<button class="btn btn-primary btn-lg btn-block" type="submit">${message("member.register.submit")}</button>
			</form>
			<div class="row">
				<div class="col-xs-6 text-left">
					<a href="${base}/article/detail/1_1">${message("member.register.agreement")}</a>
				</div>
				<div class="col-xs-6 text-right">
					<a href="${base}/member/login">${message("member.register.login")}</a>
				</div>
			</div>
		</div>
	</main>
</body>
</html>