<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${product.name} ${message("shop.consultation.title")}[#if showPowered] - Powered By SHOP++[/#if]</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/consultation.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/bootstrap-growl.js"></script>
	<script src="${base}/resources/common/js/jquery.scrolltofixed.js"></script>
	<script src="${base}/resources/common/js/jquery.validate.js"></script>
	<script src="${base}/resources/common/js/jquery.validate.additional.js"></script>
	<script src="${base}/resources/common/js/jquery.form.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/mobile/shop/js/base.js"></script>
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
							successRedirectUrl: "${base}/product/detail/${product.id}#consultation"
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
<body class="shop add-consultation">
	<header class="header-default" data-spy="scrollToFixed">
		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-1">
					<a href="${base}/product/detail/${product.id}#consultation">
						<i class="iconfont icon-back"></i>
					</a>
				</div>
				<div class="col-xs-10">
					<h5>${message("shop.consultation.title")}</h5>
				</div>
			</div>
		</div>
	</header>
	<main>
		<div class="media">
			<div class="media-left">
				<a href="${base}${product.path}">
					<img class="media-object img-thumbnail" src="${product.thumbnail!setting.defaultThumbnailProductImage}" alt="${product.name}">
				</a>
			</div>
			<div class="media-body">
				<h5 class="media-heading">
					<a href="${base}${product.path}" title="${product.name}">${product.name}</a>
				</h5>
				<span>
					${message("Product.price")}:
					<strong class="text-red">${currency(product.price, true, true)}</strong>
				</span>
				[#if product.scoreCount > 0]
					<span>${message("Product.score")}: ${product.score?string("0.0")}</span>
				[#elseif setting.isShowMarketPrice]
					<span>
						${message("Product.marketPrice")}:
						<del class="text-gray">${currency(product.marketPrice, true, true)}</del>
					</span>
				[/#if]
			</div>
		</div>
		<form id="consultationForm" action="${base}/consultation/save" method="post">
			<input name="productId" type="hidden" value="${product.id}">
			<div class="form-group">
				<label class="item-required" for="content">${message("Consultation.content")}</label>
				<textarea id="content" name="content" class="form-control" rows="5"></textarea>
			</div>
			[#if setting.captchaTypes?? && setting.captchaTypes?seq_contains("CONSULTATION")]
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
			<button class="btn btn-primary btn-lg btn-block" type="submit">${message("shop.consultation.submit")}</button>
		</form>
	</main>
</body>
</html>