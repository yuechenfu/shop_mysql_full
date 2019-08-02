<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.messageGroup.list")} - Powered By SHOP++</title>
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
	<script src="${base}/resources/common/js/bootbox.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/velocity.js"></script>
	<script src="${base}/resources/common/js/velocity.ui.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/member/js/base.js"></script>
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
					<form action="${base}/member/message_group/list" method="get">
						<input name="pageNumber" type="hidden" value="${page.pageNumber}">
						<div class="message-list panel panel-default">
							<div class="panel-heading">${message("member.messageGroup.list")}</div>
							<div class="panel-body">
								[#if page.content?has_content]
									<table class="table">
										<thead>
											<tr>
												<th>${message("member.messageGroup.opposite")}</th>
												<th>${message("member.messageGroup.new")}</th>
												<th>${message("common.lastModifiedDate")}</th>
												<th width="240">${message("common.action")}</th>
											</tr>
										</thead>
										<tbody>
											[#list page.content as messageGroup]
												<tr>
													<td>
														[#if messageGroup.user1 == currentUser]
															${messageGroup.user2.getDisplayName()}
														[#else]
															${messageGroup.user1.getDisplayName()}
														[/#if]
													</td>
													<td class="new-message">
														[#if messageGroup.user1 == currentUser]
															[#if messageGroup.user1MessageStatus.isRead]-[#else]${message("member.messageGroup.new")}[/#if]
														[#else]
															[#if messageGroup.user2MessageStatus.isRead]-[#else]${message("member.messageGroup.new")}[/#if]
														[/#if]
													</td>
													<td>
														<span title="${messageGroup.lastModifiedDate?string("yyyy-MM-dd HH:mm:ss")}">${messageGroup.lastModifiedDate}</span>
													</td>
													<td>
														<a class="btn btn-default btn-icon" href="${base}/member/message/view?messageGroupId=${messageGroup.id}" title="${message("common.view")}">
															<i class="iconfont icon-search"></i>
														</a>
														<a class="btn btn-default btn-icon" href="javascript:;" title="${message("common.delete")}" data-action="delete" data-url="${base}/member/message_group/delete?messageGroupId=${messageGroup.id}">
															<i class="iconfont icon-close"></i>
														</a>
													</td>
												</tr>
											[/#list]
										</tbody>
									</table>
								[#else]
									<p class="text-gray">${message("common.noResult")}</p>
								[/#if]
							</div>
							[@pagination pageNumber = page.pageNumber totalPages = page.totalPages]
								[#if totalPages > 1]
									<div class="panel-footer text-right clearfix">
										[#include "/member/include/pagination.ftl" /]
									</div>
								[/#if]
							[/@pagination]
						</div>
					</form>
				</div>
			</div>
		</div>
	</main>
	[#include "/shop/include/main_footer.ftl" /]
</body>
</html>