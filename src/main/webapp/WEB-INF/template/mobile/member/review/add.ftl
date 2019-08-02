<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.review.add")}[#if showPowered] - Powered By SHOP++[/#if]</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/bootstrap-star-rating.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/base.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/review.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/bootstrap-growl.js"></script>
	<script src="${base}/resources/common/js/jquery.scrolltofixed.js"></script>
	<script src="${base}/resources/common/js/bootstrap-star-rating.js"></script>
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
<body class="member review">
	<header class="header-default" data-spy="scrollToFixed">
		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-1">
					<a href="${base}/member/order/list">
						<i class="iconfont icon-back"></i>
					</a>
				</div>
				<div class="col-xs-10">
					<h5>${message("member.review.add")}</h5>
				</div>
			</div>
		</div>
	</header>
	<main>
		<form id="reviewForm" action="${base}/member/review/save" method="post">
			<input name="orderId" type="hidden" value="${order.id}">
			[#list order.orderItems as orderItem]
				<div class="review-add panel panel-default">
					<div class="panel-body">
						<div class="media">
							<div class="media-left text-center">
								[#if order.orderItem.sku?has_content]
									<a href="${base}${orderItem.sku.path}" title="${orderItem.name}">
										<img class="media-object img-thumbnail" src="${orderItem.thumbnail!setting.defaultThumbnailProductImage}" alt="${orderItem.name}">
									</a>
								[#else]
									<img class="media-object img-thumbnail" src="${orderItem.thumbnail!setting.defaultThumbnailProductImage}" alt="${orderItem.name}">
								[/#if]
							</div>
							<div class="media-body">
								<input name="reviewEntryList[${orderItem_index}].orderItem.id" type="hidden" value="${orderItem.id}">
								<h5>
									[#if orderItem.sku?has_content]
										<a href="${base}${orderItem.sku.path}">${orderItem.name}</a>
									[#else]
										${orderItem.name}
									[/#if]
								</h5>
								[#if orderItem.specifications?has_content]
									<p class="text-gray">[${orderItem.specifications?join(", ")}]</p>
								[/#if]
							</div>
						</div>
						[#if !orderItem.sku?has_content]
							<div class="form-group">${message("member.review.canNotReview")}</div>
						[/#if]
						<div class="[#if !orderItem.sku?has_content]hidden-element [/#if]form-group">
							<h5>${message("Product.RankingType.SCORE_COUNT")}</h5>
							<input name="reviewEntryList[${orderItem_index}].review.score" class="rating rating-loading" value="5" data-size="lg"[#if !orderItem.sku?has_content] disabled[/#if]>
						</div>
						<div class="[#if !orderItem.sku?has_content]hidden-element [/#if]form-group">
							<h5>${message("Review.content")}</h5>
							<textarea name="reviewEntryList[${orderItem_index}].review.content" class="content form-control" rows="5"></textarea>
						</div>
					</div>
				</div>
			[/#list]
			<div class="panel panel-default">
				<div class="panel-body">
					[#if setting.captchaTypes?? && setting.captchaTypes?seq_contains("REVIEW")]
						<div class="form-group">
							<label class="item-required" for="captcha">${message("common.captcha.name")}</label>
							<div class="input-group">
								<input id="captcha" name="captcha" class="captcha form-control" type="text" maxlength="4" autocomplete="off">
								<div class="input-group-btn">
									<img class="captcha-image" src="${base}/resources/common/images/transparent.png" title="${message("common.captcha.imageTitle")}" data-toggle="captchaImage">
								</div>
							</div>
						</div>
					[/#if]
					<button class="btn btn-primary btn-lg btn-block" type="submit">${message("common.submit")}</button>
				</div>
			</div>
		</form>
	</main>
</body>
</html>