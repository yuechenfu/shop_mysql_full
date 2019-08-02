<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.message.view")} - Powered By SHOP++</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/member/css/base.css" rel="stylesheet">
	<link href="${base}/resources/member/css/message.css" rel="stylesheet">
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
			
				var $messageForm = $("#messageForm");
				
				// 表单验证
				$messageForm.validate({
					rules: {
						content: {
							required: true,
							maxlength: 4000
						}
					},
					submitHandler: function(form) {
						$(form).ajaxSubmit({
							successRedirectUrl: "${base}/member/message/view?messageGroupId=${messageGroup.id}"
						});
					}
				});
			
			});
			</script>
		[/#escape]
	[/#noautoesc]
</head>
<body class="member message">
	[#include "/shop/include/main_header.ftl" /]
	<main>
		<div class="container">
			<div class="row">
				<div class="col-xs-2">
					[#include "/member/include/main_menu.ftl" /]
				</div>
				<div class="col-xs-10">
					<form id="messageForm" class="ajax-form form-horizontal" action="${base}/member/message/reply" method="post">
						<input name="messageGroupId" type="hidden" value="${messageGroupId}">
						<div class="message-detail panel panel-default">
							<div class="panel-heading">${message("member.message.view")}</div>
							<div class="panel-body">
								<div class="list-group">
									[#if messages?has_content]
										<div class="list-group-item">
											[#list messages as memberMessage]
												<div class="message-item clearfix">
													<div class="popover[#if memberMessage.fromUser == currentUser] pull-right[#else] pull-left[/#if]">
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
															<span class="small text-gray pull-right">
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
											<label class="col-xs-3 col-sm-2 col-xs-offset-1 item-required" for="content">${message("member.message.reply")}:</label>
										</div>
										<div class="form-group">
											<div class="col-xs-9 col-sm-4 col-xs-offset-1">
												<textarea id="content" name="content" class="form-control" rows="5"></textarea>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="panel-footer">
								<div class="row">
									<div class="col-xs-9 col-sm-10 col-xs-offset-3 col-sm-offset-2">
										<button class="btn btn-primary" type="submit">${message("member.message.send")}</button>
										<a class="btn btn-default" href="${base}/member/message_group/list">${message("common.back")}</a>
									</div>
								</div>
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