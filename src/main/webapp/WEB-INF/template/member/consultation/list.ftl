<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.consultation.list")} - Powered By SHOP++</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/member/css/base.css" rel="stylesheet">
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
<body class="member">
	[#include "/shop/include/main_header.ftl" /]
	<main>
		<div class="container">
			<div class="row">
				<div class="col-xs-2">
					[#include "/member/include/main_menu.ftl" /]
				</div>
				<div class="col-xs-10">
					<form action="${base}/member/consultation/list" method="get">
						<input name="pageNumber" type="hidden" value="${page.pageNumber}">
						<div class="panel panel-default">
							<div class="panel-heading">${message("member.consultation.list")}</div>
							<div class="panel-body">
								[#if page.content?has_content]
									<ul class="media-list">
										[#list page.content as consultation]
											<li class="media">
												<div class="media-left media-middle">
													<div class="media">
														<div class="media-left media-middle">
															<a href="${base}${consultation.product.path}" target="_blank">
																<img class="media-object img-thumbnail" src="${consultation.product.thumbnail!setting.defaultThumbnailProductImage}" alt="${consultation.product.name}">
															</a>
														</div>
														<div class="media-body media-middle">
															<h5 class="media-heading">
																<a href="${base}${consultation.product.path}#consultationAnchor" title="${consultation.product.name}" target="_blank">${consultation.product.name}</a>
															</h5>
															<p class="text-gray-dark small" title="${consultation.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${consultation.createdDate}</p>
														</div>
													</div>
												</div>
												<div class="media-body media-middle">
													<p>
														<span class="bg-orange-light badge">${message("member.consultation.question")}</span>
														${consultation.content}
													</p>
												</div>
												<div class="media-right media-middle">
													<a class="btn btn-default btn-icon pull-right" href="${base}${consultation.product.path}#consultationAnchor" title="${message("common.view")}">
														<i class="iconfont icon-search"></i>
													</a>
													<a class="btn btn-default btn-icon pull-right" href="javascript:;" title="${message("common.delete")}" data-action="delete" data-url="${base}/member/consultation/delete?consultationId=${consultation.id}">
														<i class="iconfont icon-close"></i>
													</a>
												</div>
											</li>
										[/#list]
									</ul>
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