<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.productNotify.list")} - Powered By SHOP++</title>
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
					<form action="${base}/member/product_notify/list" method="get">
						<input name="pageNumber" type="hidden" value="${page.pageNumber}">
						<div class="panel panel-default">
							<div class="panel-heading">${message("member.productNotify.list")}</div>
							<div class="panel-body">
								[#if page.content?has_content]
									<ul class="media-list">
										[#list page.content as productNotify]
											<li class="media">
												<div class="media-left media-middle">
													<div class="media">
														<div class="media-left media-middle">
															<a href="${base}${productNotify.sku.path}" target="_blank">
																<img class="media-object img-thumbnail" src="${productNotify.sku.thumbnail!setting.defaultThumbnailProductImage}" alt="${productNotify.sku.name}">
															</a>
														</div>
														<div class="media-body media-middle">
															<h5 class="media-heading">
																<a href="${base}${productNotify.sku.path}" title="${productNotify.sku.name}" target="_blank">${productNotify.sku.name}</a>
															</h5>
															[#if productNotify.sku.specifications?has_content]
																<span class="text-gray">[${productNotify.sku.specifications?join(", ")}]</span>
															[/#if]
															<p class="text-gray-dark small">${currency(productNotify.sku.price, true)}</p>
														</div>
													</div>
												</div>
												<div class="media-body media-middle">
													<p>
														<i class="iconfont icon-mark text-orange-light"></i>
														<span class="text-gray-darker">${message("member.productNotify.email")}: ${productNotify.email}</span>
													</p>
												</div>
												<div class="media-right media-middle">
													<a class="btn btn-default btn-icon pull-right" href="${base}${productNotify.sku.path}" title="${message("common.view")}" target="_blank">
														<i class="iconfont icon-search"></i>
													</a>
													<a class="btn btn-default btn-icon pull-right" href="javascript:;" title="${message("common.delete")}" data-action="delete" data-url="${base}/member/product_notify/delete?productNotifyId=${productNotify.id}">
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