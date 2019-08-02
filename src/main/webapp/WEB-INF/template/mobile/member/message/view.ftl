<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.message.view")}[#if showPowered] - Powered By SHOP++[/#if]</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/base.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/message.css" rel="stylesheet">
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
						content: {
							required: true,
							maxlength: 4000
						}
					},
					submitHandler: function(form) {
						$(form).ajaxSubmit({
							successRedirectUrl: "${base}/member/message/view?messageGroupId=${messageGroupId}"
						});
					}
				});
			
			});
			</script>
		[/#escape]
	[/#noautoesc]
</head>
<body class="member message">
	<header class="header-default" data-spy="scrollToFixed">
		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-1">
					<a href="${base}/member/message_group/list">
						<i class="iconfont icon-back"></i>
					</a>
				</div>
				<div class="col-xs-10">
					<h5>${message("member.message.view")}</h5>
				</div>
			</div>
		</div>
	</header>
	<main>
		<div class="container-fluid">
			<form id="inputForm" class="ajax-form" action="${base}/member/message/reply" method="post">
				<input name="messageGroupId" type="hidden" value="${messageGroupId}">
				<div class="panel panel-default">
					<div class="panel-body">
						<div class="list-group">
							[#if messages?has_content]
								<div class="list-group-item">
									[#list messages as memberMessage]
										<div class="message-item clearfix">
											<div class="popover[#if memberMessage.fromUser == currentUser] left pull-right[#else] right pull-left[/#if]">
												<div class="arrow"></div>
												<div class="popover-content clearfix">
													<p>${memberMessage.content}</p>
													[#if memberMessage.fromUser == currentUser]
														<div class="status">
															[#if memberMessage.toUserMessageStatus.isRead == false]
																<span class="text-red">${message("member.message.unread")}</span>
															[#else]
																<span class="text-gray">${message("member.message.read")}</span>
															[/#if]
														</div>
													[/#if]
													<span class="small text-gray">
														[${memberMessage.fromUser.getDisplayName()}]
														${memberMessage.createdDate?string("yyyy-MM-dd HH:mm:ss")}
													</span>
												</div>
											</div>
										</div>
									[/#list]
								</div>
							[/#if]
							<div class="list-group-item">
								<div class="form-group">
									<label class="item-required" for="content">${message("member.message.reply")}</label>
									<textarea id="content" name="content" class="form-control" rows="5">${(draftMessage.content)!}</textarea>
								</div>
							</div>
						</div>
					</div>
					<div class="panel-footer text-center">
						<button class="btn btn-primary" type="submit">${message("member.message.send")}</button>
						<a class="btn btn-default" href="${base}/member/message_group/list">${message("common.back")}</a>
					</div>
				</div>
			</form>
		</div>
	</main>
</body>
</html>