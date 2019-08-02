<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.review.add")} - Powered By SHOP++</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/bootstrap-star-rating.css" rel="stylesheet">
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
	<script src="${base}/resources/common/js/bootstrap-star-rating.js"></script>
	<script src="${base}/resources/common/js/jquery.validate.js"></script>
	<script src="${base}/resources/common/js/jquery.validate.additional.js"></script>
	<script src="${base}/resources/common/js/jquery.form.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/member/js/base.js"></script>
	<style>
		.media {
			margin-bottom: 15px;
			border-bottom: dotted 1px #e8e8e8;
		}
		
		.media:last-child {
			margin-bottom: 0px;
			border-bottom: 0px;
		}
		
		.media .media-left img {
			max-width: 95px;
		}
		
	</style>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
			
				var $reviewForm = $("#reviewForm");
				var $captcha = $("#captcha");
				var $captchaImage = $("[data-toggle='captchaImage']");
				
				$.validator.addClassRules({
					content: {
						maxlength: 200
					}
				});
				
				// 表单验证
				$reviewForm.validate({
					rules: {
						captcha: "required"
					},
					submitHandler: function(form) {
						$(form).ajaxSubmit({
							successRedirectUrl: "${base}/member/order/list"
						});
					}
				});
				
				// 验证码图片
				$reviewForm.on("error.shopxx.ajaxSubmit", function() {
					$captchaImage.captchaImage("refresh");
				});
				
				// 验证码图片
				$captchaImage.on("refreshed.shopxx.captchaImage", function() {
					$captcha.val("");
				});
			
			});
			</script>
		[/#escape]
	[/#noautoesc]
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
					<form id="reviewForm" class="form-horizontal" action="${base}/member/review/save" method="post">
						<input name="orderId" type="hidden" value="${order.id}">
						<div class="panel panel-default">
							<div class="panel-heading">${message("member.review.add")}</div>
							<div class="panel-body">
								[#list order.orderItems as orderItem]
									<div class="media">
										<div class="media-left text-center">
											[#if orderItem.sku?has_content]
												<a href="${base}${orderItem.sku.path}" target="_blank">
													<img class="media-object img-thumbnail" src="${orderItem.thumbnail!setting.defaultThumbnailProductImage}" alt="${orderItem.name}">
												</a>
											[#else]
												<img class="media-object img-thumbnail" src="${orderItem.thumbnail!setting.defaultThumbnailProductImage}" alt="${orderItem.name}">
											[/#if]
										</div>
										<div class="media-body">
											<input name="reviewEntryList[${orderItem_index}].orderItem.id" type="hidden" value="${orderItem.id}">
											<div class="form-group">
												<label class="col-xs-3 col-sm-2 control-label">${message("Review.product")}:</label>
												<div class="col-xs-9 col-sm-4">
													<p class="form-control-static">
														[#if orderItem.sku?has_content]
															<a href="${base}${orderItem.sku.path}" target="_blank">${orderItem.name}</a>
														[#else]
															${orderItem.name}
														[/#if]
														[#if orderItem.specifications?has_content]
															<span class="text-gray">[${orderItem.specifications?join(", ")}]</span>
														[/#if]
													</p>
												</div>
											</div>
											[#if !orderItem.sku?has_content]
												<div class="form-group">
													<div class="col-xs-offset-2 col-sm-4">
														<p class="form-control-static">${message("member.review.canNotReview")}</p>
													</div>
												</div>
											[/#if]
											<div class="[#if !orderItem.sku?has_content]hidden-element [/#if]form-group">
												<label class="col-xs-3 col-sm-2 control-label">${message("Product.RankingType.SCORE_COUNT")}:</label>
												<div class="col-xs-9 col-sm-4">
													<input name="reviewEntryList[${orderItem_index}].review.score" class="rating rating-loading" value="5" data-size="lg"[#if !orderItem.sku?has_content] disabled[/#if]>
												</div>
											</div>
											<div class="[#if !orderItem.sku?has_content]hidden-element [/#if]form-group">
												<label class="col-xs-3 col-sm-2 control-label" for="content[${orderItem_index}]">${message("Review.content")}:</label>
												<div class="col-xs-9 col-sm-4">
													<textarea id="content[${orderItem_index}]" name="reviewEntryList[${orderItem_index}].review.content" class="content form-control" rows="5"></textarea>
												</div>
											</div>
											[#if !orderItem?has_next && setting.captchaTypes?? && setting.captchaTypes?seq_contains("REVIEW")]
												<div class="form-group">
													<label class="col-xs-3 col-sm-2 control-label item-required">${message("common.captcha.name")}:</label>
													<div class="col-xs-6 col-sm-4">
														<div class="input-group">
															<input id="captcha" name="captcha" class="captcha form-control" type="text" maxlength="4" placeholder="${message("common.captcha.name")}" autocomplete="off">
															<div class="input-group-btn">
																<img class="captcha-image" src="${base}/resources/common/images/transparent.png" title="${message("common.captcha.imageTitle")}" data-toggle="captchaImage">
															</div>
														</div>
													</div>
												</div>
											[/#if]
										</div>
									</div>
								[/#list]
							</div>
							<div class="panel-footer">
								<div class="row">
									<div class="col-xs-8 col-sm-9 col-xs-offset-4 col-sm-offset-3">
										<button class="btn btn-primary" type="submit">${message("common.submit")}</button>
										<button class="btn btn-default" type="button" data-action="back">${message("common.back")}</button>
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