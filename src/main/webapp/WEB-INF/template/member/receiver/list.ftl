<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.receiver.list")} - Powered By SHOP++</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/member/css/base.css" rel="stylesheet">
	<link href="${base}/resources/member/css/receiver.css" rel="stylesheet">
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
<body class="member receiver">
	[#include "/shop/include/main_header.ftl" /]
	<main>
		<div class="container">
			<div class="row">
				<div class="col-xs-2">
					[#include "/member/include/main_menu.ftl" /]
				</div>
				<div class="col-xs-10">
					<form action="${base}/member/receiver/list" method="get">
						<input name="pageNumber" type="hidden" value="${page.pageNumber}">
						<div class="panel panel-default">
							<div class="panel-heading">${message("member.receiver.list")}</div>
							<div class="panel-body">
								<a class="add" href="${base}/member/receiver/add">
									<i class="iconfont icon-add"></i>
									${message("member.receiver.add")}
								</a>
								[#if page.content?has_content]
									<ul class="receiver-list">
										[#list page.content as receiver]
											<li>
												<h5 class="text-overflow" title="${receiver.consignee}">
													${receiver.consignee}
													[#if receiver.isDefault]
														<span class="label label-primary">${message("member.receiver.default")}</span>
													[/#if]
												</h5>
												<p class="text-gray-dark">${receiver.phone}</p>
												<p class="text-overflow" title="${receiver.areaName}${receiver.address}">${receiver.areaName}${receiver.address}</p>
												<p class="text-gray-dark">${receiver.zipCode}</p>
												<div class="action">
													<a class="btn btn-default btn-xs btn-icon" href="${base}/member/receiver/edit?receiverId=${receiver.id}" title="${message("common.edit")}">
														<i class="iconfont icon-write"></i>
													</a>
													<a class="btn btn-default btn-xs btn-icon" href="javascript:;" title="${message("common.delete")}" data-action="delete" data-url="${base}/member/receiver/delete?receiverId=${receiver.id}">
														<i class="iconfont icon-close"></i>
													</a>
												</div>
											</li>
										[/#list]
									</ul>
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