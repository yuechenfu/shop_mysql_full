[#assign defaultSku = product.defaultSku /]
[#assign productCategory = product.productCategory /]
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	[@seo type = "PRODUCT_DETAIL"]
		[#if seo.resolveKeywords()?has_content]
			<meta name="keywords" content="${seo.resolveKeywords()}">
		[/#if]
		[#if seo.resolveDescription()?has_content]
			<meta name="description" content="${seo.resolveDescription()}">
		[/#if]
		<title>${seo.resolveTitle()}[#if showPowered] - Powered By SHOP++[/#if]</title>
	[/@seo]
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/bootstrap-spinner.css" rel="stylesheet">
	<link href="${base}/resources/common/css/jquery.jqzoom.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/product.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/jquery.migrate.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/bootstrap-growl.js"></script>
	<script src="${base}/resources/common/js/jquery.lazyload.js"></script>
	<script src="${base}/resources/common/js/jquery.fly.js"></script>
	<script src="${base}/resources/common/js/jquery.qrcode.js"></script>
	<script src="${base}/resources/common/js/jquery.jqzoom.js"></script>
	<script src="${base}/resources/common/js/jquery.spinner.js"></script>
	<script src="${base}/resources/common/js/jquery.validate.js"></script>
	<script src="${base}/resources/common/js/jquery.validate.additional.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/jquery.base64.js"></script>
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
				
				var $productNotifyForm = $("#productNotifyForm");
				var $productNotifyModal = $("#productNotifyModal");
				var $productNotifyEmail = $("#productNotifyForm input[name='email']");
				var $zoom = $("#zoom");
				var $thumbnailProductImageItem = $("#productImage .thumbnail-product-image .item a");
				var $price = $("#price");
				var $marketPrice = $("#marketPrice");
				var $rewardPoint = $("#rewardPoint");
				var $exchangePoint = $("#exchangePoint");
				var $specification = $("#specification");
				var $specificationItem = $("#specification dd");
				var $specificationValue = $("#specification dd a");
				var $quantity = $("#quantity");
				var $buy = $("#buy");
				var $addCart = $("#addCart");
				var $exchange = $("#exchange");
				var $addProductNotify = $("#addProductNotify");
				var $actionTips = $("#actionTips");
				var $topbar = $("#topbar");
				var skuId = ${defaultSku.id};
				var skuData = {};
				var historyProductIdsLocalStorageKey = "historyProductIds";
				
				[#if product.hasSpecification()]
					[#list product.skus as sku]
						skuData["${sku.specificationValueIds?join(",")}"] = {
							id: ${sku.id},
							price: ${sku.price},
							marketPrice: ${sku.marketPrice},
							rewardPoint: ${sku.rewardPoint},
							exchangePoint: ${sku.exchangePoint},
							isOutOfStock: ${sku.isOutOfStock?string("true", "false")}
						};
					[/#list]
					
					// 锁定规格值
					lockSpecificationValue();
				[/#if]
				
				// 浏览记录
				var historyProductIdsLocalStorage = localStorage.getItem(historyProductIdsLocalStorageKey);
				var historyProductIds = historyProductIdsLocalStorage != null ? JSON.parse(historyProductIdsLocalStorage) : [];
				
				historyProductIds = $.grep(historyProductIds, function(historyProductId, i) {
					return historyProductId != ${product.id};
				});
				historyProductIds.unshift(${product.id});
				historyProductIds = historyProductIds.slice(0, 10);
				localStorage.setItem(historyProductIdsLocalStorageKey, JSON.stringify(historyProductIds));
				
				// 到货通知
				$productNotifyModal.on("show.bs.modal", function(event) {
					if ($.trim($productNotifyEmail.val()) == "") {
						$.ajax({
							url: "${base}/product_notify/email",
							type: "GET",
							dataType: "json",
							cache: false,
							success: function(data) {
								$productNotifyEmail.val(data.email);
							}
						});
					}
				});
				
				// 商品图片放大镜
				$zoom.jqzoom({
					zoomWidth: 378,
					zoomHeight: 378,
					title: false,
					preloadText: null,
					preloadImages: false
				});
				
				// 商品缩略图
				$thumbnailProductImageItem.hover(function() {
					$(this).click();
				});
				
				// 规格值选择
				$specificationValue.click(function() {
					var $element = $(this);
					
					if ($element.hasClass("disabled")) {
						return false;
					}
					$element.toggleClass("active").siblings().removeClass("active");
					lockSpecificationValue();
					return false;
				});
				
				// 锁定规格值
				function lockSpecificationValue() {
					var activeSpecificationValueIds = $specificationItem.map(function() {
						var $active = $(this).find("a.active");
						return $active.length > 0 ? $active.data("specification-item-entry-id") : [null];
					}).get();
					$specificationItem.each(function(i) {
						$(this).find("a").each(function(j) {
							var $element = $(this);
							var specificationValueIds = activeSpecificationValueIds.slice(0);
							specificationValueIds[i] = $element.data("specification-item-entry-id");
							if (isValid(specificationValueIds)) {
								$element.removeClass("disabled");
							} else {
								$element.addClass("disabled");
							}
						});
					});
					var sku = skuData[activeSpecificationValueIds.join(",")];
					if (sku != null) {
						skuId = sku.id;
						$specification.removeClass("warning");
						$price.text($.currency(sku.price, true));
						$marketPrice.text($.currency(sku.marketPrice, true));
						$rewardPoint.text(sku.rewardPoint);
						$exchangePoint.text(sku.exchangePoint);
						if (sku.isOutOfStock) {
							$buy.add($addCart).add($exchange).prop("disabled", true);
							$addProductNotify.show();
							$actionTips.text("${message("shop.product.skuLowStock")}").fadeIn();
						} else {
							$buy.add($addCart).add($exchange).prop("disabled", false);
							$addProductNotify.hide();
							$actionTips.empty().fadeOut();
						}
					} else {
						skuId = null;
						$specification.addClass("warning");
						$buy.add($addCart).add($exchange).prop("disabled", true);
						$addProductNotify.hide();
						$actionTips.text("${message("shop.product.specificationRequired")}").fadeIn();
					}
				}
				
				// 判断规格值ID是否有效
				function isValid(specificationValueIds) {
					for (var key in skuData) {
						var ids = key.split(",");
						if (match(specificationValueIds, ids)) {
							return true;
						}
					}
					return false;
				}
				
				// 判断数组是否配比
				function match(array1, array2) {
					if (array1.length != array2.length) {
						return false;
					}
					for (var i = 0; i < array1.length; i ++) {
						if (array1[i] != null && array2[i] != null && array1[i] != array2[i]) {
							return false;
						}
					}
					return true;
				}
				
				// 立即购买
				$buy.checkout({
					skuId: function() {
						return skuId;
					},
					quantity: function() {
						return $quantity.val();
					}
				});
				
				// 加入购物车
				$addCart.addCart({
					skuId: function() {
						return skuId;
					},
					quantity: function() {
						return $quantity.val();
					},
					cartTarget: "#mainSidebarCart",
					productImageTarget: "#productImage .medium-product-image img"
				});
				
				// 积分兑换
				$exchange.checkout({
					skuId: function() {
						return skuId;
					},
					quantity: function() {
						return $quantity.val();
					}
				});
				
				// 顶部栏
				$topbar.affix({
					offset: {
						top: function() {
							return $topbar.parent().offset().top;
						}
					}
				});
				
				// 到货通知表单验证
				$productNotifyForm.validate({
					rules: {
						email: {
							required: true,
							email: true
						}
					},
					submitHandler: function(form) {
						$.ajax({
							url: $productNotifyForm.attr("action"),
							type: $productNotifyForm.attr("method"),
							data: {
								skuId: skuId,
								email: $productNotifyEmail.val()
							},
							dataType: "json",
							cache: false,
							success: function(data) {
								$.bootstrapGrowl(data.message);
								$productNotifyModal.modal("hide");
							}
						});
					}
				});
				
				// 点击数
				$.get("${base}/product/hits/${product.id}");
				
			});
			</script>
		[/#escape]
	[/#noautoesc]
</head>
<body class="shop product-detail" data-spy="scroll" data-target="#topbar">
	[#include "/shop/include/main_header.ftl" /]
	[#include "/shop/include/main_sidebar.ftl" /]
	<main>
		<div class="container">
			<form id="productNotifyForm" class="form-horizontal" action="${base}/product_notify/save" method="post">
				<div id="productNotifyModal" class="product-notify-modal modal fade" tabindex="-1">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button class="close" type="button" data-dismiss="modal">&times;</button>
								<h5 class="modal-title">${message("shop.product.addProductNotify")}</h5>
							</div>
							<div class="modal-body">
								<div class="form-group">
									<label class="col-xs-3 control-label item-required">${message("shop.product.productNotifyEmail")}:</label>
									<div class="col-xs-8">
										<input name="email" class="form-control" type="text" maxlength="200">
									</div>
								</div>
							</div>
							<div class="modal-footer">
								<button class="btn btn-primary" type="submit">${message("common.ok")}</button>
								<button class="btn btn-default" type="button" data-dismiss="modal">${message("common.cancel")}</button>
							</div>
						</div>
					</div>
				</div>
			</form>
			<ol class="breadcrumb">
				<li>
					<a href="${base}/">
						<i class="iconfont icon-homefill"></i>
						${message("common.breadcrumb.index")}
					</a>
				</li>
				[@product_category_parent_list productCategoryId = productCategory.id]
					[#list productCategories as productCategory]
						<li>
							<a href="${base}${productCategory.path}">${productCategory.name}</a>
						</li>
					[/#list]
				[/@product_category_parent_list]
				<li class="active">
					<a href="${base}${productCategory.path}">${productCategory.name}</a>
				</li>
			</ol>
			<div class="row">
				<div class="col-xs-3">
					<div id="productImage" class="product-image">
						<div class="medium-product-image">
							[#if product.productImages?has_content]
								<a id="zoom" href="${product.productImages[0].large}" rel="gallery">
									<img src="${product.productImages[0].medium}" alt="${product.name}">
								</a>
							[#else]
								<a id="zoom" href="${setting.defaultLargeProductImage}" rel="gallery">
									<img src="${setting.defaultMediumProductImage}" alt="${product.name}">
								</a>
							[/#if]
						</div>
						<div class="thumbnail-product-image carousel slide" data-ride="carousel" data-interval="false" data-wrap="false">
							<ul class="carousel-inner">
								[#if product.productImages?has_content]
									[#list product.productImages?chunk(5) as row]
										<li class="item[#if row_index == 0] active[/#if]">
											[#list row as productImage]
												<a[#if row_index == 0 && productImage_index == 0] class="zoomThumbActive"[/#if] href="javascript:;" rel="{gallery: 'gallery', smallimage: '${productImage.medium}', largeimage: '${productImage.large}'}">
													<img src="${productImage.thumbnail}" alt="${product.name}">
												</a>
											[/#list]
										</li>
									[/#list]
								[#else]
									<li class="item active">
										<a class="zoomThumbActive" href="javascript:;" rel="{gallery: 'gallery', smallimage: '${setting.defaultMediumProductImage}', largeimage: '${setting.defaultLargeProductImage}'}">
											<img src="${setting.defaultThumbnailProductImage}" alt="${product.name}">
										</a>
									</li>
								[/#if]
							</ul>
							<a class="carousel-control left" href="#productImage .carousel" data-slide="prev">
								<i class="iconfont icon-back"></i>
							</a>
							<a class="carousel-control right" href="#productImage .carousel" data-slide="next">
								<i class="iconfont icon-right"></i>
							</a>
						</div>
					</div>
					<div class="product-action clearfix">
						<div class="bdsharebuttonbox">
							<a class="bds_qzone" data-cmd="qzone" href="#"></a>
							<a class="bds_tsina" data-cmd="tsina"></a>
							<a class="bds_tqq" data-cmd="tqq"></a>
							<a class="bds_weixin" data-cmd="weixin"></a>
							<a class="bds_renren" data-cmd="renren"></a>
							<a class="bds_more" data-cmd="more"></a>
						</div>
						<a class="add-product-favorite" href="javascript:;" data-action="addProductFavorite" data-product-id="${product.id}">
							<i class="iconfont icon-like"></i>
							${message("shop.product.addProductFavorite")}
						</a>
					</div>
				</div>
				<div class="col-xs-7">
					<div class="name">
						<h4>${product.name}</h4>
						[#if product.caption?has_content]
							<strong>${product.caption}</strong>
						[/#if]
					</div>
					<div class="summary">
						<dl class="dl-horizontal clearfix">
							<dt>${message("Product.sn")}:</dt>
							<dd>${product.sn}</dd>
							[#if product.type != "GENERAL"]
								<dt>${message("Product.type")}:</dt>
								<dd>${message("Product.Type." + product.type)}</dd>
							[/#if]
							[#if product.type == "GENERAL"]
								<dt>${message("Sku.price")}:</dt>
								<dd>
									<strong id="price">${currency(defaultSku.price, true)}</strong>
								</dd>
								[#if setting.isShowMarketPrice]
									<dt>${message("Sku.marketPrice")}:</dt>
									<dd>
										<del id="marketPrice">${currency(defaultSku.marketPrice, true)}</del>
									</dd>
								[/#if]
								[#if product.validPromotions?has_content]
									<dt>${message("Product.promotions")}:</dt>
									<dd>
										[#list product.validPromotions as promotion]
											<a class="label label-default" href="${base}${promotion.path}" target="_blank">${promotion.name}</a>
										[/#list]
									</dd>
								[/#if]
								[#if defaultSku.rewardPoint > 0]
									<dt>${message("Sku.rewardPoint")}:</dt>
									<dd id="rewardPoint">${defaultSku.rewardPoint}</dd>
								[/#if]
							[#else]
								[#if product.type == "EXCHANGE"]
									<dt>${message("Sku.exchangePoint")}:</dt>
									<dd>
										<strong id="exchangePoint">${defaultSku.exchangePoint}</strong>
									</dd>
								[/#if]
								[#if setting.isShowMarketPrice]
									<dt>${message("Sku.marketPrice")}:</dt>
									<dd id="marketPrice">${currency(defaultSku.marketPrice, true)}</dd>
								[/#if]
							[/#if]
						</dl>
						<ul class="clearfix">
							<li>
								${message("Product.monthSales")}:
								<strong>${product.monthSales}</strong>
							</li>
							<li>
								${message("Product.scoreCount")}:
								<strong>${product.scoreCount}</strong>
							</li>
							<li>
								${message("Product.score")}:
								<strong>${product.score?string("0.0")}</strong>
							</li>
						</ul>
					</div>
					[#if product.type == "GENERAL" || product.type == "EXCHANGE"]
						[#if product.hasSpecification()]
							[#assign defaultSpecificationValueIds = defaultSku.specificationValueIds /]
							<div id="specification" class="specification">
								<dl class="dl-horizontal clearfix">
									[#list product.specificationItems as specificationItem]
										<dt>
											<span title="${specificationItem.name}">${abbreviate(specificationItem.name, 8)}:</span>
										</dt>
										<dd>
											[#list specificationItem.entries as entry]
												[#if entry.isSelected]
													<a[#if defaultSpecificationValueIds[specificationItem_index] == entry.id] class="active"[/#if] href="javascript:;" data-specification-item-entry-id="${entry.id}">${entry.value}</a>
												[/#if]
											[/#list]
										</dd>
									[/#list]
								</dl>
							</div>
						[/#if]
						<div class="quantity">
							<dl class="dl-horizontal clearfix">
								<dt>${message("shop.product.quantity")}:</dt>
								<dd>
									<div class="spinner input-group input-group-sm" data-trigger="spinner">
										<input id="quantity" class="form-control" type="text" maxlength="5" data-rule="quantity" data-min="1" data-max="10000">
										<span class="input-group-addon">
											<a class="spin-up" href="javascript:;" data-spin="up">
												<i class="fa fa-caret-up"></i>
											</a>
											<a class="spin-down" href="javascript:;" data-spin="down">
												<i class="fa fa-caret-down"></i>
											</a>
										</span>
									</div>
									<span class="unit">${product.unit!message("shop.product.defaultUnit")}</span>
								</dd>
							</dl>
						</div>
						<div class="action">
							[#if product.type == "GENERAL"]
								<button id="buy" class="btn btn-default btn-lg" type="button"[#if defaultSku.isOutOfStock] disabled[/#if]>${message("shop.product.buy")}</button>
								<button id="addCart" class="btn btn-primary btn-lg" type="button"[#if defaultSku.isOutOfStock] disabled[/#if]>
									<i class="iconfont icon-cart"></i>
									${message("shop.product.addCart")}
								</button>
							[#elseif product.type == "EXCHANGE"]
								<button id="exchange" class="btn btn-primary btn-lg" type="button"[#if defaultSku.isOutOfStock] disabled[/#if]>
									<i class="iconfont icon-present"></i>
									${message("shop.product.exchange")}
								</button>
							[/#if]
							<button id="addProductNotify" class="btn btn-primary btn-lg[#if !defaultSku.isOutOfStock] hidden-element[/#if]" type="button" data-toggle="modal" data-target="#productNotifyModal">
								<i class="iconfont icon-mail"></i>
								${message("shop.product.addProductNotify")}
							</button>
							[#if defaultSku.isOutOfStock]
								<span id="actionTips" class="text-orange">${message("shop.product.skuLowStock")}</span>
							[#else]
								<span id="actionTips" class="text-orange hidden-element"></span>
							[/#if]
						</div>
					[/#if]
				</div>
				<div class="col-xs-2">
					<div class="store">
						<div class="store-heading">
							<a href="${base}${product.store.path}" target="_blank">
								<img class="img-responsive center-block" src="${product.store.logo!setting.defaultStoreLogo}" alt="${product.store.name}">
							</a>
							<h5>
								<a href="${base}${product.store.path}" target="_blank">${abbreviate(product.store.name, 50, "...")}</a>
								[#if product.store.type == "SELF"]
									<span class="label label-primary">${message("Store.Type.SELF")}</span>
								[/#if]
							</h5>
						</div>
						[@instant_message_list storeId = product.store.id]
							[#if product.store.address?has_content || product.store.phone?has_content || instantMessages?has_content]
								<div class="store-body">
									[#if product.store.address?has_content || product.store.phone?has_content]
										<dl class="dl-horizontal clearfix">
											[#if product.store.address?has_content]
												<dt>${message("Store.address")}:</dt>
												<dd>${product.store.address}</dd>
											[/#if]
											[#if product.store.phone?has_content]
												<dt>${message("Store.phone")}:</dt>
												<dd>${product.store.phone}</dd>
											[/#if]
										</dl>
									[/#if]
									[#if instantMessages?has_content]
										<p>
											[#list instantMessages as instantMessage]
												[#if instantMessage.type == "QQ"]
													<a href="http://wpa.qq.com/msgrd?v=3&uin=${instantMessage.account}&menu=yes" title="${instantMessage.name}" target="_blank">
														<img src="${base}/resources/shop/images/instant_message_qq.png" alt="${instantMessage.name}">
													</a>
												[#elseif instantMessage.type == "ALI_TALK"]
													<a href="http://amos.alicdn.com/getcid.aw?v=2&uid=${instantMessage.account}&site=cntaobao&s=2&groupid=0&charset=utf-8" title="${instantMessage.name}" target="_blank">
														<img src="${base}/resources/shop/images/instant_message_wangwang.png" alt="${instantMessage.name}">
													</a>
												[/#if]
											[/#list]
										</p>
									[/#if]
								</div>
							[/#if]
						[/@instant_message_list]
						<div class="store-footer">
							<a class="btn btn-default" href="${base}${product.store.path}" target="_blank">${message("shop.product.viewStore")}</a>
							<a class="btn btn-default" href="javascript:;" data-action="addStoreFavorite" data-store-id="${product.store.id}">${message("shop.product.addStoreFavorite")}</a>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-xs-2">
					[#include "/shop/include/featured_product.ftl" /]
				</div>
				<div class="col-xs-10">
					[#if product.introduction?has_content || product.parameterValues?has_content || setting.isReviewEnabled || setting.isConsultationEnabled]
						<div class="topbar-wrapper">
							<div id="topbar" class="topbar">
								<ul class="nav">
									[#if product.introduction?has_content]
										<li>
											<a href="#introductionAnchor">${message("shop.product.introduction")}</a>
										</li>
									[/#if]
									[#if product.parameterValues?has_content]
										<li>
											<a href="#parameterAnchor">${message("shop.product.parameter")}</a>
										</li>
									[/#if]
									[#if setting.isReviewEnabled]
										<li>
											<a href="#reviewAnchor">${message("shop.product.review")}</a>
										</li>
									[/#if]
									[#if setting.isConsultationEnabled]
										<li>
											<a href="#consultationAnchor">${message("shop.product.consultation")}</a>
										</li>
									[/#if]
								</ul>
							</div>
						</div>
					[/#if]
					[#if product.introduction?has_content]
						<div class="introduction">
							<span id="introductionAnchor" class="introduction-anchor"></span>
							<div class="introduction-heading">
								<h4>${message("shop.product.introduction")}</h4>
							</div>
							<div class="introduction-body">
								[#noautoesc]
									${product.introduction}
								[/#noautoesc]
							</div>
						</div>
					[/#if]
					[#if product.parameterValues?has_content]
						<div class="parameter">
							<span id="parameterAnchor" class="parameter-anchor"></span>
							<div class="parameter-heading">
								<h4>${message("shop.product.parameter")}</h4>
							</div>
							<div class="parameter-body">
								<table>
									[#list product.parameterValues as parameterValue]
										<tr>
											<th class="group" colspan="2">${parameterValue.group}</th>
										</tr>
										[#list parameterValue.entries as entry]
											<tr>
												<th>${entry.name}</th>
												<td>${entry.value}</td>
											</tr>
										[/#list]
									[/#list]
								</table>
							</div>
						</div>
					[/#if]
					[#if setting.isReviewEnabled]
						<div class="review">
							<span id="reviewAnchor" class="review-anchor"></span>
							<div class="review-heading">
								<h4>${message("shop.product.review")}</h4>
							</div>
							<div class="review-body">
								[#if product.scoreCount > 0]
									<div class="score media">
										<div class="media-left media-middle">
											<h5>${message("Product.score")}</h5>
											<strong>${product.score?string("0.0")}</strong>
											<p>
												[#list 1..5 as score]
													<i class="iconfont[#if score <= product.score] icon-favorfill[#else] icon-favor[/#if]"></i>
												[/#list]
											</p>
										</div>
										<div class="media-body media-middle">
											<div class="graph">
												<div class="graph-scroller">
													<em style="left: ${(product.score * 20)?string("0.0")}%;">
														${product.score?string("0.0")}
														<span class="caret"></span>
													</em>
												</div>
												<ul class="graph-description">
													<li>${message("shop.product.graph1")}</li>
													<li>${message("shop.product.graph2")}</li>
													<li>${message("shop.product.graph3")}</li>
													<li>${message("shop.product.graph4")}</li>
													<li>${message("shop.product.graph5")}</li>
												</ul>
											</div>
										</div>
										<div class="media-right media-middle">
											<p>${message("Product.scoreCount")}: ${product.scoreCount}</p>
											<a href="${base}/review/detail/${product.id}">[${message("shop.product.viewReview")}]</a>
										</div>
									</div>
									[@review_list productId = product.id count = 5]
										[#if reviews?has_content]
											<ul class="review-list media-list">
												[#list reviews as review]
													<li class="media">
														<div class="media-left">
															<strong>${review.member.username}</strong>
															<span title="${review.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${review.createdDate?string("yyyy-MM-dd")}</span>
															[#if review.specifications?has_content]
																<span>[${review.specifications?join(", ")}]</span>
															[/#if]
														</div>
														<div class="media-body">
															<p>
																[#list 1..(review.score?number)!0 as i]
																	<i class="iconfont icon-favorfill"></i>
																[/#list]
																[#list 0..(5 - review.score) as d]
																	[#if d != 0]
																		<i class="iconfont icon-favor"></i>
																	[#else]
																		
																	[/#if]
																[/#list]
															</p>
															<p>${review.content}</p>
															[#if review.replyReviews?has_content]
																<ul class="reply-list">
																	[#list review.replyReviews as replyReview]
																		<li>
																			<strong>${replyReview.store.name}:</strong>
																			<p>${replyReview.content}</p>
																			<span title="${replyReview.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${replyReview.createdDate?string("yyyy-MM-dd")}</span>
																		</li>
																	[/#list]
																</ul>
															[/#if]
														</div>
													</li>
												[/#list]
											</ul>
										[/#if]
									[/@review_list]
								[#else]
									<p class="no-result">${message("shop.product.noReview")}</p>
								[/#if]
							</div>
						</div>
					[/#if]
					[#if setting.isConsultationEnabled]
						<div class="consultation">
							<span id="consultationAnchor" class="consultation-anchor"></span>
							<div class="consultation-heading">
								<h4>${message("shop.product.consultation")}</h4>
							</div>
							<div class="consultation-body">
								[@consultation_list productId = product.id count = 5]
									[#if consultations?has_content]
										<ul class="consultation-list media-list">
											[#list consultations as consultation]
												<li class="media">
													<div class="media-left">
														<strong>${consultation.member.username}</strong>
														<span title="${consultation.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${consultation.createdDate?string("yyyy-MM-dd")}</span>
													</div>
													<div class="media-body media-middle">
														<p>${consultation.content}</p>
														[#if consultation.replyConsultations?has_content]
															<ul class="reply-list">
																[#list consultation.replyConsultations as replyConsultation]
																	<li>
																		<strong>${replyConsultation.store.name}:</strong>
																		<p>${replyConsultation.content}</p>
																		<span title="${replyConsultation.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${replyConsultation.createdDate?string("yyyy-MM-dd")}</span>
																	</li>
																[/#list]
															</ul>
														[/#if]
													</div>
												</li>
											[/#list]
										</ul>
									[#else]
										<p class="no-result">${message("shop.product.noConsultation")}</p>
									[/#if]
								[/@consultation_list]
							</div>
							<div class="consultation-footer">
								<a href="${base}/consultation/add/${product.id}">[${message("shop.product.addConsultation")}]</a>
								<a href="${base}/consultation/detail/${product.id}">[${message("shop.product.viewConsultation")}]</a>
							</div>
						</div>
					[/#if]
				</div>
			</div>
		</div>
	</main>
	[#include "/shop/include/main_footer.ftl" /]
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
				window._bd_share_config = {
					common: {
						bdUrl: $.generateSpreadUrl()
					},
					share: [
						{
							bdSize: 16
						}
					]
				}
				with(document)0[(getElementsByTagName("head")[0]||body).appendChild(createElement("script")).src="http://bdimg.share.baidu.com/static/api/js/share.js?cdnversion="+~(-new Date()/36e5)];
			</script>
		[/#escape]
	[/#noautoesc]
</body>
</html>