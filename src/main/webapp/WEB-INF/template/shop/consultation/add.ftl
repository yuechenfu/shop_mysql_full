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
			
				var $consultationForm = $("#consultationForm");
				var $captcha = $("#captcha");
				var $captchaImage = $("[data-toggle='captchaImage']");
				
				// 表单验证
				$consultationForm.validate({
					rules: {
						content: {
							required: true,
							maxlength: 200
						},
						captcha: "required"
					},
					submitHandler: function(form) {
						$(form).ajaxSubmit({
							successRedirectUrl: "${base}/consultation/detail/${product.id}"
						});
					}
				});
				
				// 验证码图片
				$consultationForm.on("error.shopxx.ajaxSubmit", function() {
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
					<form id="consultationForm" class="ajax-form" action="${base}/consultation/save" method="post">
						<input name="productId" type="hidden" value="${product.id}">
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
							</div>
						</div>
						<div class="row">
							<div class="col-xs-5">
								<div class="form-group">
									<label class="control-label item-required" for="content">${message("Consultation.content")}</label>
									<textarea id="content" name="content" class="form-control" rows="5"></textarea>
								</div>
								[#if setting.captchaTypes?? && setting.captchaTypes?seq_contains("CONSULTATION")]
									<div class="form-group">
										<label class="control-label item-required" for="captcha">${message("common.captcha.name")}</label>
										<div class="input-group">
											<input id="captcha" name="captcha" class="captcha form-control" type="text" maxlength="4" autocomplete="off">
											<div class="input-group-btn">
												<img class="captcha-image" src="${base}/resources/common/images/transparent.png" title="${message("common.captcha.imageTitle")}" data-toggle="captchaImage">
											</div>
										</div>
									</div>
								[/#if]
								<div class="form-group text-center">
									<button class="btn btn-primary" type="submit">${message("common.submit")}</button>
									<button class="btn btn-default" type="button" data-action="back">${message("common.back")}</button>
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