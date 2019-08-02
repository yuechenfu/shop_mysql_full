<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.aftersales.list")} - Powered By SHOP++</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/member/css/base.css" rel="stylesheet">
	<link href="${base}/resources/member/css/aftersales.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/bootstrap-growl.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/velocity.js"></script>
	<script src="${base}/resources/common/js/velocity.ui.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/member/js/base.js"></script>
</head>
<body class="member aftersales">
	[#include "/shop/include/main_header.ftl" /]
	<main>
		<div class="container">
			<div class="row">
				<div class="col-xs-2">
					[#include "/member/include/main_menu.ftl" /]
				</div>
				<div class="col-xs-10">
					<form action="${base}/member/aftersales/list" method="get">
						<input name="pageNumber" type="hidden" value="${page.pageNumber}">
						<div class="aftersales-list panel panel-default">
							<div class="panel-heading">${message("member.aftersales.list")}</div>
							<div class="panel-body">
								[#if page.content?has_content]
									<ul class="media-list">
										[#list page.content as aftersales]
											<li class="media">
												<div class="media-left media-middle">
													<ul class="media-list">
														[#list aftersales.aftersalesItems as aftersalesItem]
															<li class="media">
																<div class="media-left media-middle">
																	[#if aftersalesItem.orderItem.sku??]
																		<a href="${base}${aftersalesItem.orderItem.sku.path}" target="_blank" title="${aftersalesItem.orderItem.name}">
																			<img class="media-object img-thumbnail" src="${aftersalesItem.orderItem.thumbnail!setting.defaultThumbnailProductImage}" alt="${aftersalesItem.orderItem.name}">
																		</a>
																	[#else]
																		<img class="media-object img-thumbnail" src="${aftersalesItem.orderItem.thumbnail!setting.defaultThumbnailProductImage}" alt="${aftersalesItem.orderItem.name}" title="${aftersalesItem.orderItem.name}">
																	[/#if]
																</div>
																<div class="media-body media-middle">
																	<h5 class="media-heading">
																		[#if aftersalesItem.orderItem.sku??]
																			<a href="${base}${aftersalesItem.orderItem.sku.path}" title="${aftersalesItem.orderItem.name}" target="_blank">${aftersalesItem.orderItem.name}</a>
																		[#else]
																			${aftersalesItem.orderItem.name}
																		[/#if]
																	</h5>
																	[#if aftersalesItem.orderItem.specifications?has_content]
																		<span class="text-gray">[${aftersalesItem.orderItem.specifications?join(", ")}]</span>
																	[/#if]
																	<p class="text-gray-dark">&times; ${aftersalesItem.quantity}</p>
																</div>
															</li>
															[#if aftersalesItem_index == 2]
																[#break /]
															[/#if]
														[/#list]
													</ul>
												</div>
												<div class="media-body media-middle">
													<ul>
														<li>
															<h5 class="text-gray-dark">${message("Aftersales.Type." + aftersales.type)}</h5>
														</li>
														<li>
															<strong class="[#if aftersales.status == "PENDING"]text-orange[#elseif aftersales.status == "FAILED"]text-red[#elseif aftersales.status == "CANCELED"]text-gray-dark[#else]text-green[/#if]">${message("Aftersales.Status." + aftersales.status)}</strong>
														</li>
														<li>
															<span class="text-gray-dark">
																<i class="iconfont icon-shop"></i>
																${aftersales.store.name}
															</span>
															<span class="text-gray" title="${aftersales.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${aftersales.createdDate}</span>
														</li>
													</ul>
												</div>
												<div class="media-right media-middle">
													<strong class="text-red pull-left">${currency(aftersales.amount, true)}</strong>
													<a class="btn btn-default btn-icon pull-right" href="${base}/member/aftersales/view?aftersalesId=${aftersales.id}" title="${message("common.view")}">
														<i class="iconfont icon-search"></i>
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