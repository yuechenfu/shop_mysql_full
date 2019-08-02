<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("shop.product.compare")} - Powered By SHOP++</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/product.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/bootstrap-growl.js"></script>
	<script src="${base}/resources/common/js/jquery.lazyload.js"></script>
	<script src="${base}/resources/common/js/jquery.qrcode.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
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
				
				var $parameterTr = $("table.parameter tr");
				
				$parameterTr.hover(function() {
					var $element = $(this);
					var parameterValueGroup = $element.data("parameter-value-group");
					var parameterValueEntryName = $element.data("parameter-value-entry-name");
					
					$parameterTr.filter("[data-parameter-value-group='" + parameterValueGroup + "'][data-parameter-value-entry-name='" + parameterValueEntryName + "']").addClass("current");
				}, function() {
					$parameterTr.removeClass("current");
				});
				
			});
			</script>
		[/#escape]
	[/#noautoesc]
</head>
<body class="shop product-compare">
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
						<li class="active">${message("shop.product.compare")}</li>
					</ol>
					<div class="compare-list">
						<ul class="clearfix">
							[#list products as product]
								<li class="compare-list-item">
									<div class="thumbnail">
										<a href="${base}${product.path}" target="_blank">
											<img class="img-responsive center-block" src="${product.thumbnail!setting.defaultThumbnailProductImage}" title="${product.name}" alt="${product.name}">
										</a>
										<div class="caption">
											<p class="text-overflow">
												<a href="${base}${product.path}" titile="${product.name}" target="_blank">${product.name}</a>
											</p>
											<strong class="text-red">${currency(product.price, true)}</strong>
											<p>
												<a href="${base}${product.store.path}" title="${product.store.name}" target="_blank">${abbreviate(product.store.name, 15)}</a>
												[#if product.store.type == "SELF"]
													<span class="label label-primary">${message("Store.Type.SELF")}</span>
												[/#if]
											</p>
										</div>
									</div>
									[#if product.parameterValues?has_content]
										<table class="parameter table table-bordered">
											[#list product.parameterValues as parameterValue]
												<tr>
													<th class="parameter-value-group" colspan="2">${parameterValue.group}</th>
												</tr>
												[#list parameterValue.entries as entry]
													<tr data-parameter-value-group="${parameterValue.group}" data-parameter-value-entry-name="${entry.name}">
														<th>${entry.name}</th>
														<td>${entry.value}</td>
													</tr>
												[/#list]
											[/#list]
										</table>
									[/#if]
								</li>
							[/#list]
						</ul>
					</div>
				</div>
			</div>
		</div>
	</main>
	[#include "/shop/include/main_footer.ftl" /]
</body>
</html>