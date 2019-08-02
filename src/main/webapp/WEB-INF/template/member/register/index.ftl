<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.register.title")} - Powered By SHOP++</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/awesome-bootstrap-checkbox.css" rel="stylesheet">
	<link href="${base}/resources/common/css/bootstrap-datetimepicker.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/member/css/register.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/bootstrap-growl.js"></script>
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
	<script src="${base}/resources/common/js/velocity.js"></script>
	<script src="${base}/resources/common/js/velocity.ui.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/member/js/base.js"></script>
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
				var $agree = $("#agree");
				var $submit = $("#registerForm button:submit");
				
				// 推广用户
				var spreadUser = $.getSpreadUser();
				if (spreadUser != null) {
					$spreadMemberUsername.val(spreadUser.username);
				}
				
				// 地区选择
				$areaId.lSelect({
					url: "${base}/common/area"
				});
				
				// 同意注册协议
				$agree.change(function() {
					$submit.prop("disabled", !$agree.prop("checked"));
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
<body class="register">
	[#include "/shop/include/main_header.ftl" /]
	<main>
		<div class="container">
			<form id="registerForm" class="form-horizontal" action="${base}/member/register/submit" method="post">
				<input name="socialUserId" type="hidden" value="${socialUserId}">
				<input name="uniqueId" type="hidden" value="${uniqueId}">
				<input name="spreadMemberUsername" type="hidden">
				<div class="panel panel-default">
					<div class="panel-heading">
						<div class="panel-title">
							<h1 class="text-red">
								[#if socialUserId?has_content && uniqueId?has_content]
									${message("member.register.bind")}
									<small>REGISTER BIND</small>
								[#else]
									${message("member.register.title")}
									<small>USER REGISTER</small>
								[/#if]
							</h1>
						</div>
					</div>
					<div class="panel-body">
						<div class="row">
							<div class="col-xs-8">
								<div class="form-group">
									<label class="col-xs-3 control-label item-required" for="username">${message("member.register.username")}:</label>
									<div class="col-xs-8">
										<input id="username" name="username" class="form-control" type="text" maxlength="20" autocomplete="off">
									</div>
								</div>
								<div class="form-group">
									<label class="col-xs-3 control-label item-required" for="password">${message("member.register.password")}:</label>
									<div class="col-xs-8">
										<input id="password" name="password" class="form-control" type="password" maxlength="20" autocomplete="off">
									</div>
								</div>
								<div class="form-group">
									<label class="col-xs-3 control-label item-required" for="rePassword">${message("member.register.rePassword")}:</label>
									<div class="col-xs-8">
										<input id="rePassword" name="rePassword" class="form-control" type="password" maxlength="20" autocomplete="off">
									</div>
								</div>
								<div class="form-group">
									<label class="col-xs-3 control-label item-required" for="email">${message("member.register.email")}:</label>
									<div class="col-xs-8">
										<input id="email" name="email" class="form-control" type="text" maxlength="200">
									</div>
								</div>
								<div class="form-group">
									<label class="col-xs-3 control-label item-required" for="mobile">${message("member.register.mobile")}:</label>
									<div class="col-xs-8">
										<input id="mobile" name="mobile" class="form-control" type="text" maxlength="200">
									</div>
								</div>
								[@member_attribute_list]
									[#list memberAttributes as memberAttribute]
										<div class="form-group">
											<label class="col-xs-3 control-label[#if memberAttribute.isRequired] item-required[/#if]" for="memberAttribute_${memberAttribute.id}">${memberAttribute.name}:</label>
											[#if memberAttribute.type == "NAME" || memberAttribute.type == "ADDRESS" || memberAttribute.type == "ZIP_CODE" || memberAttribute.type == "PHONE" || memberAttribute.type == "TEXT"]
												<div class="col-xs-8">
													<input id="memberAttribute_${memberAttribute.id}" name="memberAttribute_${memberAttribute.id}" class="form-control" type="text" maxlength="200">
												</div>
											[#elseif memberAttribute.type == "GENDER"]
												<div class="col-xs-8">
													[#list genders as gender]
														<div class="radio radio-inline">
															<input id="${gender}" name="memberAttribute_${memberAttribute.id}" type="radio" value="${gender}">
															<label for="${gender}">${message("Member.Gender." + gender)}</label>
														</div>
													[/#list]
												</div>
											[#elseif memberAttribute.type == "BIRTH"]
												<div class="col-xs-8">
													<div class="input-group">
														<input name="memberAttribute_${memberAttribute.id}" class="form-control" type="text" data-provide="datetimepicker">
														<span class="input-group-addon">
															<i class="iconfont icon-calendar"></i>
														</span>
													</div>
												</div>
											[#elseif memberAttribute.type == "AREA"]
												<div class="col-xs-8">
													<div class="input-group">
														<input id="areaId" name="memberAttribute_${memberAttribute.id}" type="hidden">
													</div>
												</div>
											[#elseif memberAttribute.type == "SELECT"]
												<div class="col-xs-8">
													<select name="memberAttribute_${memberAttribute.id}" class="form-control">
														<option value="">${message("common.choose")}</option>
														[#list memberAttribute.options as option]
															<option value="${option}">${option}</option>
														[/#list]
													</select>
												</div>
											[#elseif memberAttribute.type == "CHECKBOX"]
												<div class="col-xs-8">
													[#list memberAttribute.options as option]
														<div class="checkbox checkbox-inline">
															<input id="${option}_${memberAttribute.id}" name="memberAttribute_${memberAttribute.id}" type="checkbox" value="${option}">
															<label for="${option}_${memberAttribute.id}">${option}</label>
														</div>
													[/#list]
												</div>
											[/#if]
										</div>
									[/#list]
								[/@member_attribute_list]
								[#if setting.captchaTypes?? && setting.captchaTypes?seq_contains("MEMBER_REGISTER")]
									<div class="form-group">
										<label class="col-xs-3 control-label item-required" for="captcha">${message("common.captcha.name")}:</label>
										<div class="col-xs-8">
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
							<div class="col-xs-3">
								<div class="login">
									<h2>${message("member.register.loginTitle")}</h2>
									<a class="btn btn-default btn-lg btn-block" href="${base}/member/login">${message("member.register.login")}</a>
									[#if loginPlugins?has_content && !socialUserId?has_content && !uniqueId?has_content]
										<ul class="clearfix">
											[#list loginPlugins as loginPlugin]
												<li>
													<a href="${base}/social_user_login?loginPluginId=${loginPlugin.id}"[#if loginPlugin.description??] title="${loginPlugin.description}"[/#if]>
														[#if loginPlugin.logo?has_content]
															<img src="${loginPlugin.logo}" alt="${loginPlugin.displayName}">
														[#else]
															${loginPlugin.displayName}
														[/#if]
													</a>
												</li>
											[/#list]
										</ul>
									[/#if]
								</div>
							</div>
						</div>
					</div>
					<div class="panel-footer">
						<div class="row">
							<div class="col-xs-8">
								<div class="form-group">
									<div class="col-xs-8 col-xs-offset-3">
										<div class="checkbox">
											<input id="agree" name="agree" type="checkbox" value="true" checked>
											<label for="agree">${message("member.register.agree")}</label>
											<a class="text-red" href="${base}/article/detail/14_1" target="_blank">${message("member.register.agreement")}</a>
										</div>
									</div>
								</div>
								<div class="form-group">
									<div class="col-xs-8 col-xs-offset-3">
										<button class="btn btn-primary btn-lg btn-block" type="submit">${message("member.register.submit")}</button>
									</div>
								</div>
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