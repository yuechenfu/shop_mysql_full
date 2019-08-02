<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.message.send")}[#if showPowered] - Powered By SHOP++[/#if]</title>
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
				
				// 表单验证
				$inputForm.validate({
					rules: {
						type: "required",
						username: {
							required: true,
							notEquals: {
								param: {
									value: "${currentUser.username}",
									ignoreCase: true
								},
								depends: function() {
									return $("input[name='type']:checked").val() === "MEMBER";
								}
							},
							remote: {
								url: "${base}/member/message/check_username",
								cache: false,
								data: {
									type: function() {
										return $("input[name='type']:checked").val();
									}
								}
							}
						},
						content: {
							required: true,
							maxlength: 4000
						}
					},
					messages: {
						username: {
							notEquals: "${message("member.message.notAllowSelf")}",
							remote: "${message("member.message.userNotExist")}"
						}
					},
					submitHandler: function(form) {
						$(form).ajaxSubmit({
							successRedirectUrl: "${base}/member/message_group/list"
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
					<a href="${base}/member/index">
						<i class="iconfont icon-back"></i>
					</a>
				</div>
				<div class="col-xs-10">
					<h5>${message("member.message.send")}</h5>
				</div>
			</div>
		</div>
	</header>
	<main>
		<div class="container-fluid">
			<form id="inputForm" action="${base}/member/message/send" method="post">
				<div class="panel panel-default">
					<div class="panel-body">
						<div class="form-group">
							<label class="item-required">${message("member.message.toUser")}</label>
							<p>
								<div class="radio radio-inline">
									<input id="member" name="type" type="radio" value="MEMBER" checked>
									<label for="member">${message("member.message.otherMember")}</label>
								</div>
								<div class="radio radio-inline">
									<input id="business" name="type" type="radio" value="BUSINESS">
									<label for="business">${message("member.message.business")}</label>
								</div>
							</p>
						</div>
						<div class="form-group">
							<label class="item-required" for="username">${message("member.message.toUsername")}</label>
							<input id="username" name="username" class="form-control" type="text" maxlength="200">
						</div>
						<div class="form-group">
							<label class="item-required" for="content">${message("Message.content")}</label>
							<textarea id="content" name="content" class="form-control" rows="5"></textarea>
						</div>
					</div>
					<div class="panel-footer text-center">
						<button id="send" class="btn btn-primary" type="submit">${message("member.message.sendNow")}</button>
					</div>
				</div>
			</form>
		</div>
	</main>
</body>
</html>