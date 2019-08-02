<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${product.name} ${message("shop.review.title")} - Powered By SHOP++</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/bootstrap-star-rating.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/product.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/review.css" rel="stylesheet">
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
	<script src="${base}/resources/common/js/g2.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/shop/js/base.js"></script>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
			
				var $reviewForm = $("#reviewForm");
				var $type = $("#type");
				var $typeItem = $("ul.type li");
				
				// 评论类型
				$typeItem.click(function() {
					var $element = $(this);
					
					$type.val($element.attr("val"));
					$element.addClass("current").siblings().removeClass("current");
					$reviewForm.submit();
				});
				
			});
			</script>
		[/#escape]
	[/#noautoesc]
</head>
<body class="shop review">
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
							<a href="${base}${product.path}" title="${product.name}">${abbreviate(product.name, 30, "...")}</a>
						</li>
						<li class="active">${message("shop.review.title")}</li>
					</ol>
					<form id="reviewForm" action="${base}/review/detail/${product.id}" method="get">
						<input id="type" name="type" type="hidden" value="${type}">
						<div class="review-product">
							<div class="media">
								<div class="media-left">
									<a href="${base}${product.path}" title="${product.name}" target="_blank">
										<img class="media-object img-thumbnail" src="${product.thumbnail!setting.defaultThumbnailProductImage}" alt="${product.name}">
									</a>
								</div>
								<div class="media-body">
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
							</div>
						</div>
						[#if page.content?has_content]
							<div class="panel panel-default">
								<div class="panel-heading">
									<ul class="type clearfix">
										[@review_count productId = product.id]
											<li[#if type == null] class="current"[/#if]>${message("shop.review.allType")}(${count})</li>
										[/@review_count]
										[#assign currentType = type /]
										[#list types as type]
											[@review_count productId = product.id type = type]
												<li[#if type == currentType] class="current"[/#if] val="${type}">${message("Review.Type." + type)}(${count})</li>
											[/@review_count]
										[/#list]
									</ul>
								</div>
								<div class="panel-body">
									[#list page.content as review]
										<div class="media">
											<div class="media-left">
												[#if review.member??]
													<span class="text-red">${review.member.username}</span>
												[#else]
													${message("shop.review.anonymous")}
												[/#if]
												<p class="text-gray-dark">${review.member.memberRank.name}</p>
											</div>
											<div class="media-body">
												[#list 1..(review.score?number)!0 as i]
													<i class="iconfont icon-favorfill"></i>
												[/#list]
												[#list 0..(5 - review.score) as d]
													[#if d != 0]
														<i class="iconfont icon-favor"></i>
													[#else]
														
													[/#if]
												[/#list]
												<p>
													[#if review.content?has_content]
														${review.content}
													[#else]
														${message("shop.review.noReview")}
													[/#if]
												</p>
												[#if review.replyReviews?has_content]
													[#list review.replyReviews as replyReview]
														<p class="review-reply">${replyReview.store.name}: ${replyReview.content}</p>
													[/#list]
												[/#if]
												[#if review.specifications?has_content]
													<span class="text-gray-dark">[${review.specifications?join(", ")}]</span>
												[/#if]
												<span class="text-gray-dark" title="${review.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${review.createdDate?string("yyyy-MM-dd")}</span>
											</div>
										</div>
									[/#list]
								</div>
								[@pagination pageNumber = page.pageNumber totalPages = page.totalPages]
									[#if totalPages > 1]
										<div class="panel-footer text-right">
											[#include "/shop/include/pagination.ftl" /]
										</div>
									[/#if]
								[/@pagination]
							[#else]
								<div class="list-group-item">
									<p class="text-gray-dark">${message("shop.review.noResult")}</p>
								</div>
							[/#if]
						</div>
					</form>
				</div>
			</div>
		</div>
	</main>
	[#include "/shop/include/main_footer.ftl" /]
</body>
</html>