<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${product.name} ${message("shop.consultation.title")} - Powered By SHOP++</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/bootstrap-star-rating.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/product.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/consultation.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/bootstrap-growl.js"></script>
	<script src="${base}/resources/common/js/bootstrap-star-rating.js"></script>
	<script src="${base}/resources/common/js/jquery.lazyload.js"></script>
	<script src="${base}/resources/common/js/jquery.validate.js"></script>
	<script src="${base}/resources/common/js/jquery.validate.additional.js"></script>
	<script src="${base}/resources/common/js/jquery.form.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/jquery.qrcode.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/velocity.js"></script>
	<script src="${base}/resources/common/js/velocity.ui.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/shop/js/base.js"></script>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
			
				var $addConsultation = $("#addConsultation");
				
				$addConsultation.click(function() {
					if ($.checkLogin()) {
						return true;
					} else {
						$.redirectLogin("${base}/consultation/add/${product.id}", "${message("shop.consultation.accessDenied")}");
						return false;
					}
				});
			
			});
			</script>
		[/#escape]
	[/#noautoesc]
</head>
<body class="shop consultation">
	[#include "/shop/include/main_header.ftl" /]
	[#include "/shop/include/main_sidebar.ftl" /]
	<main>
		<div class="container">
			<div class="row">
				<div class="col-xs-2">
					[#include "/shop/include/featured_product.ftl" /]
				</div>
				<div class="col-xs-10">
					<ol class="breadcrumb">
						<li>
							<a href="${base}/">
								<i class="iconfont icon-homefill"></i>
								${message("common.breadcrumb.index")}
							</a>
						</li>
						<li>
							<a href="${base}${product.path}">${abbreviate(product.name, 30)}</a>
						</li>
						<li class="active">${message("shop.consultation.title")}</li>
					</ol>
					<div class="consultation-product">
						<div class="media">
							<div class="media-left media-middle">
								<a href="${base}${product.path}" title="${product.name}" target="_blank">
									<img class="media-object img-thumbnail" src="${product.thumbnail!setting.defaultThumbnailProductImage}" alt="${product.name}">
								</a>
							</div>
							<div class="media-body media-middle">
								<h5>
									<a href="${base}${product.path}" title="${product.name}">${product.name}</a>
								</h5>
								<span>
									${message("Product.price")}:
									<strong class="text-orange">${currency(product.price, true, true)}</strong>
								</span>
								${message("Product.score")}:
								[#if product.score > 0]
									[#list 1..(product.score?number)!0 as i]
										<i class="iconfont icon-favorfill"></i>
									[/#list]
								[/#if]
								[#list 0..(5 - product.score) as d]
									[#if d != 0]
										<i class="iconfont icon-favor"></i>
									[#else]
										
									[/#if]
								[/#list]
							</div>
							<div class="media-right media-middle">
								<a id="addConsultation" class="btn btn-default" href="${base}/consultation/add/${product.id}">
									<i class="iconfont icon-question"></i>
									${message("shop.consultation.add")}
								</a>
							</div>
						</div>
					</div>
					[#if page.content?has_content]
						<div class="panel panel-default">
							<div class="panel-body">
								[#list page.content as consultation]
									<div class="list-group-item">
										<div class="row">
											<div class="col-xs-10">
												<span class="bg-yellow badge">${message("shop.consultation.ask")}</span>
												<strong>${consultation.content}</strong>
											</div>
											<div class="col-xs-2 text-right text-gray-dark">
												[#if consultation.member??]
													<span>${consultation.member.username}</span>
												[#else]
													<span>${message("shop.consultation.anonymous")}</span>
												[/#if]
												<span title="${consultation.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${consultation.createdDate?string("yyyy-MM-dd")}</span>
											</div>
										</div>
										[#if consultation.replyConsultations?has_content]
											[#list consultation.replyConsultations as replyConsultation]
												<div class="row">
													<div class="col-xs-10 text-gray-darker">
														<span class="bg-green-light badge">${message("shop.consultation.answer")}</span>
														<span>${replyConsultation.content}</span>
													</div>
													<div class="col-xs-2 text-right text-gray-dark">
														<span title="${replyConsultation.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${replyConsultation.createdDate?string("yyyy-MM-dd")}</span>
													</div>
												</div>
											[/#list]
										[/#if]
									</div>
								[/#list]
							</div>
							[@pagination pageNumber = page.pageNumber totalPages = page.totalPages pattern = "${base}/consultation/detail/" + product.id + "[#if {pageNumber} > 1]?pageNumber={pageNumber}[/#if]"]
								[#if totalPages > 1]
									<div class="panel-footer text-right">
										[#include "/shop/include/pagination.ftl" /]
									</div>
								[/#if]
							[/@pagination]
						</div>
					[#else]
						<div class="list-group-item">
							<p class="text-gray-dark">${message("shop.consultation.noResult")}</p>
						</div>
					[/#if]
				</div>
			</div>
		</div>
	</main>
	[#include "/shop/include/main_footer.ftl" /]
</body>
</html>