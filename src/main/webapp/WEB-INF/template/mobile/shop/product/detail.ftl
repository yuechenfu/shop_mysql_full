[#assign defaultSku = product.defaultSku /]
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
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/jquery.bxslider.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/mobile/shop/css/product.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/bootstrap-growl.js"></script>
	<script src="${base}/resources/common/js/jquery.scrolltofixed.js"></script>
	<script src="${base}/resources/common/js/moment.js"></script>
	<script src="${base}/resources/common/js/jquery.bxslider.js"></script>
	<script src="${base}/resources/common/js/jquery.fly.js"></script>
	<script src="${base}/resources/common/js/jquery.spinner.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/jquery.base64.js"></script>
	<script src="${base}/resources/common/js/scrollload.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/iscroll-probe.js"></script>
	<script src="${base}/resources/common/js/velocity.js"></script>
	<script src="${base}/resources/common/js/velocity.ui.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/mobile/shop/js/base.js"></script>
	<script id="reviewTemplate" type="text/template">
		<ul>
			<%_.each(data, function(review, i) {%>
				<li>
					<p>
						<strong><%-review.member.username%></strong>
						<span class="pull-right small text-orange">${message("shop.product.scoreDescTitle")}: <%-review.score%></span>
					</p>
					<p>
						<%if (review.content != null) {%>
							<%-review.content%>
						<%} else {%>
							${message("shop.product.noReview")}
						<%}%>
					</p>
					<%if (review.replyReviews != null) {%>
						<%_.each(review.replyReviews, function(replyReview, i) {%>
							<p>
								<span class="label label-primary">${message("Review.replyReviews")}</span>
								<span class="content"><%-replyReview.content%></span>
							</p>
						<%});%>
					<%}%>
					<span class="small text-gray"><%-moment(new Date(review.createdDate)).format("YYYY-MM-DD HH:mm:ss")%></span>
				</li>
			<%});%>
		</ul>
	</script>
	<script id="consultationTemplate" type="text/template">
		<ul>
			<%_.each(data, function(consultation, i) {%>
				<li>
					<p>
						<strong><%-consultation.member.username%></strong>
						<span class="pull-right small text-gray"><%-moment(new Date(consultation.createdDate)).format("YYYY-MM-DD HH:mm:ss")%></span>
					</p>
					<p>
						<span class="label label-success">Q</span>
						<%-consultation.content%>
					</p>
					<%if (consultation.replyConsultations != null) {%>
						<%_.each(consultation.replyConsultations, function(replyConsultation, i) {%>
							<p class="content">
								<span class="label label-primary">A</span>
								<%-replyConsultation.content%>
							</p>
						<%});%>
					<%}%>
				</li>
			<%});%>
		</ul>
	</script>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			var parameterScroll;
			var specificationScroll;
			var tabContentScroll;
			
			function loaded() {
				
				var $window = $(window);
				var $document = $(document);
				var $tabContentWrapper = $("#tabContentWrapper");
				var $pullDownTips = $("#pullDownTips");
				var $pullUpTips = $("#pullUpTips");
				var $tabPane = $("#tabContent div.tab-pane");
				var $nav = $("#nav");
				var $review = $("#review");
				var $reviewScrollLoad = $("#reviewScrollLoad");
				var $consultation = $("#consultation");
				var $consultationScrollLoad = $("#consultationScrollLoad");
				var $nextNavElement;
				
				$tabPane.each(function() {
					$(this).css("min-height", $tabContentWrapper.height() + 1);
				});
				
				$window.resize(_.debounce(function() {
					$tabPane.each(function() {
						$(this).css("min-height", $tabContentWrapper.height() + 1);
					});
				}, 50));
				
				[#if product.parameterValues?has_content]
					parameterScroll = new IScroll("#parameterBodyWrapper", {
						scrollbars: true,
						fadeScrollbars: true
					});
				[/#if]
				
				[#if product.hasSpecification()]
					specificationScroll = new IScroll("#specificationBodyWrapper", {
						scrollbars: true,
						fadeScrollbars: true,
						tap: true
					});
				[/#if]
				
				tabContentScroll = new IScroll("#tabContentWrapper", {
					tap: true,
					probeType: 2,
					deceleration: 0.001
				});
				
				// 加载评论
				$reviewScrollLoad.scrollLoad({
					url: "${base}/review/list?pageNumber=<%-pageNumber%>",
					data: {
						productId: ${product.id}
					},
					contentTarget: "#reviewScrollLoadContent",
					templateTarget: "#reviewTemplate"
				});
				
				// 加载咨询
				$consultationScrollLoad.scrollLoad({
					url: "${base}/consultation/list?pageNumber=<%-pageNumber%>",
					data: {
						productId: ${product.id}
					},
					contentTarget: "#consultationScrollLoadContent",
					templateTarget: "#consultationTemplate"
				});
				
				tabContentScroll.on("scroll", function() {
					if (this.y > 0) {
						if (!$nav.find("li:first").hasClass("active")) {
							$pullDownTips.show();
						}
					} else if (this.y < this.maxScrollY) {
						if (!$nav.find("li:last").hasClass("active")) {
							$pullUpTips.show();
						}
					}
					
					if (this.y <= this.maxScrollY && $review.hasClass("active")) {
						$("#reviewScrollLoad").scrollLoad();
					}
					
					if (this.y <= this.maxScrollY && $consultation.hasClass("active")) {
						$("#consultationScrollLoad").scrollLoad();
					}
				});
				
				tabContentScroll.on("scrollEnd", function() {
					if (this.y <= 0 && this.y >= this.maxScrollY) {
						$pullDownTips.hide();
						$pullUpTips.hide();
					}
					if ($nextNavElement != null && $nextNavElement.length > 0) {
						$nav.removeClass("disabled");
						$nextNavElement.tab("show");
						$nextNavElement = null;
					}
				});
				
				$document.on("touchend", function() {
					if (tabContentScroll.y >= 50) {
						$nextNavElement = $nav.find("li.active").prev("li").find("a");
					} else if (tabContentScroll.y <= tabContentScroll.maxScrollY - 50) {
						$nextNavElement = $nav.find("li.active").next("li").find("a");
					}
					if ($nextNavElement != null && $nextNavElement.length > 0) {
						var $nextTabPane = $($nextNavElement.attr("href"));
						if ($nextTabPane.length > 0) {
							$nav.addClass("disabled");
							$nextTabPane.addClass("active");
							setTimeout(function() {
								tabContentScroll.refresh();
								tabContentScroll.scrollToElement($nav.find("li.active a").attr("href"), 0);
								tabContentScroll.scrollToElement($nextTabPane[0], 1000);
							}, 0);
						}
					}
				});
			}
			
			function preventDefault(event) {
				event.preventDefault();
			}
			
			document.addEventListener("touchmove", preventDefault, false);
			
			$().ready(function() {
			
				var $nav = $("#nav");
				var $share = $("#share");
				var $shareMore = $("#shareMore");
				var $shareDialogClose = $(".bdshare_dialog_close");
				var $addConsultation = $("#addConsultation");
				var $parameter = $("#parameter");
				var $parameterBody = $("#parameterBody");
				var $specification = $("#specification");
				var $specificationTips = $("#specificationTips");
				var $specificationBody = $("#specificationBody");
				var $specificationItem = $("#specificationBody dl");
				var $specificationValue = $("#specificationBody a");
				var $price = $("#specification strong.price, #summary strong.price");
				var $marketPrice = $("#specification del.market-price, #summary del.market-price");
				var $exchangePoint = $("#specification strong.exchange-point, #summary strong.exchange-point");
				var $quantity = $("#quantity");
				var $addCart = $("#addCart");
				var $exchange = $("#exchange");
				var $productImage = $("#productImage");
				var $viewParameter = $("#viewParameter");
				var $closeParameter = $("#parameter button.close");
				var $viewSpecification = $("#viewSpecification");
				var $closeSpecification = $("#specification button.close");
				var $willAddCart = $("#willAddCart");
				var $willExchange = $("#willExchange");
				var skuId = ${defaultSku.id};
				var skuData = {};
				
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
				
				// 导航
				$nav.find("a").click(function() {
					if ($nav.hasClass("disabled")) {
						return false;
					}
				}).on("shown.bs.tab", function(event) {
					var $target = $(event.target);
					
					if ($target.attr("href") == "#summary") {
						$addConsultation.hide();
						if ($share.is(":hidden")) {
							$share.velocity("fadeIn");
						}
					} else if ($target.attr("href") == "#consultation") {
						$share.hide();
						if ($addConsultation.is(":hidden")) {
							$addConsultation.velocity("fadeIn");
						}
					} else {
						if ($share.is(":visible")) {
							$share.velocity("fadeOut");
						}
						if ($addConsultation.is(":visible")) {
							$addConsultation.velocity("fadeOut");
						}
					}
					tabContentScroll.refresh();
					tabContentScroll.scrollTo(0, 0);
				});
				
				// 分享模态框滑动处理
				$shareMore.click(function() {
					document.removeEventListener("touchmove", preventDefault, false);
				});
				
				$shareDialogClose.click(function() {
					document.addEventListener("touchmove", preventDefault, false);
				});
				
				// 商品图片轮播
				$productImage.bxSlider({
					controls: false,
					infiniteLoop: false
				});
				
				// 查看参数
				$viewParameter.on("tap", function() {
					$parameter.show().height($parameterBody.outerHeight() + 40).velocity("transition.slideUpBigIn");
					if (parameterScroll != null) {
						parameterScroll.refresh();
					}
					return false;
				});
				
				// 关闭参数
				$closeParameter.click(function() {
					$parameter.velocity("transition.slideDownBigOut");
					return false;
				});
				
				// 查看规格
				$viewSpecification.on("tap", function() {
					$specification.show().height($specificationBody.outerHeight() + 190).velocity("transition.slideUpBigIn");
					if (specificationScroll != null) {
						specificationScroll.refresh();
					}
					return false;
				});
				
				// 关闭规格
				$closeSpecification.click(function() {
					$specification.velocity("transition.slideDownBigOut");
					return false;
				});
				
				// 规格值选择
				$specificationValue.on("tap", function() {
					var $element = $(this);
					
					if ($element.hasClass("disabled")) {
						return false;
					}
					$element.toggleClass("active").parent().siblings().children("a").removeClass("active");
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
					skuId = sku != null ? sku.id : null;
					if (skuId == null) {
						$specificationTips.text("${message("shop.product.specificationRequired")}").velocity("fadeIn", {
							display: "block"
						});
						$addCart.add($exchange).prop("disabled", true);
						return;
					}
					$price.text($.currency(sku.price, true));
					$marketPrice.text($.currency(sku.marketPrice, true));
					$exchangePoint.text(sku.exchangePoint);
					if (sku.isOutOfStock) {
						$specificationTips.text("${message("shop.product.skuLowStock")}").velocity("fadeIn", {
							display: "block"
						});
						$addCart.add($exchange).prop("disabled", true);
						return;
					}
					$specificationTips.velocity("fadeOut");
					$addCart.add($exchange).prop("disabled", false);
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
				
				// 加入购物车
				$addCart.addCart({
					skuId: function() {
						return skuId;
					},
					quantity: function() {
						return $quantity.val();
					},
					cartTarget: "#footerCart",
					productImageTarget: "#specification .specification-header img"
				}).on("success.shopxx.addCart", function() {
					$closeSpecification.trigger("click");
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
				
				// 将要加入购物车
				$willAddCart.click(function() {
					if ($specification.is(":hidden")) {
						$viewSpecification.trigger("tap");
						return false;
					}
				});
				
				// 将要积分兑换
				$willExchange.click(function() {
					if ($specification.is(":hidden")) {
						$viewSpecification.trigger("tap");
						return false;
					}
				});
				
				// 点击数
				$.get("${base}/product/hits/${product.id}");
				
			});
			</script>
		[/#escape]
	[/#noautoesc]
</head>
<body class="shop product-detail" onload="loaded();">
	<header>
		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-1">
					<a href="javascript:;" data-action="back">
						<i class="iconfont icon-back"></i>
					</a>
				</div>
				<div class="col-xs-10">
					<ul id="nav" class="nav nav-pills">
						<li class="active">
							<a href="#summary" data-toggle="pill">${message("shop.product.summaryNav")}</a>
						</li>
						<li>
							<a href="#detail" data-toggle="pill">${message("shop.product.detailNav")}</a>
						</li>
						<li>
							<a href="#review" data-toggle="pill">${message("shop.product.reviewNav")}</a>
						</li>
						<li>
							<a href="#consultation" data-toggle="pill">${message("shop.product.consultationNav")}</a>
						</li>
					</ul>
				</div>
				<div class="col-xs-1">
					<a id="share" href="#shareModal" data-toggle="modal">
						<i class="iconfont icon-share"></i>
					</a>
					[#if setting.isConsultationEnabled]
						<a id="addConsultation" class="hidden-element" href="${base}/consultation/add/${product.id}">
							<i class="iconfont icon-edit"></i>
						</a>
					[/#if]
				</div>
			</div>
		</div>
	</header>
	<main>
		[#if product.parameterValues?has_content]
			<div id="parameter" class="parameter">
				<div class="parameter-header">
					${message("shop.product.parameter")}
					<button class="close" type="button">
						<span>&times;</span>
					</button>
				</div>
				<div id="parameterBodyWrapper" class="parameter-body-wrapper">
					<div id="parameterBody" class="parameter-body">
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
			</div>
		[/#if]
		[#assign defaultSpecificationValueIds = defaultSku.specificationValueIds /]
		<div id="specification" class="specification">
			<div class="specification-header">
				<img src="${product.thumbnail!setting.defaultThumbnailProductImage}" alt="${product.name}">
				<button class="close" type="button">
					<span>&times;</span>
				</button>
				[#if product.type == "GENERAL"]
					<strong class="price text-red">${currency(defaultSku.price, true)}</strong>
					[#if setting.isShowMarketPrice]
						<del class="market-price text-gray">${currency(defaultSku.marketPrice, true)}</del>
					[/#if]
				[#elseif product.type == "EXCHANGE"]
					${message("Sku.exchangePoint")}:
					<strong class="exchange-point text-red">${defaultSku.exchangePoint}</strong>
				[#elseif product.type == "GIFT"]
					<p class="text-red">${message("shop.product.giftNoBuy")}</p>
				[/#if]
				<span id="specificationTips" class="specification-tips text-red-dark"></span>
			</div>
			[#if product.hasSpecification()]
				<div id="specificationBodyWrapper" class="specification-body-wrapper">
					<div id="specificationBody" class="specification-body">
						[#list product.specificationItems as specificationItem]
							<dl class="clearfix">
								<dt>
									<span title="${specificationItem.name}">${abbreviate(specificationItem.name, 8, "...")}:</span>
								</dt>
								[#list specificationItem.entries as entry]
									[#if entry.isSelected]
										<dd>
											<a[#if defaultSpecificationValueIds[specificationItem_index] == entry.id] class="active"[/#if] href="javascript:;" data-specification-item-entry-id="${entry.id}">${entry.value}</a>
										</dd>
									[/#if]
								[/#list]
							</dl>
						[/#list]
					</div>
				</div>
			[/#if]
			[#if product.type == "GENERAL" || product.type == "EXCHANGE"]
				<div class="specification-footer">
					<div class="container-fluid">
						<div class="row">
							<div class="col-xs-8">${message("shop.product.quantity")}</div>
							<div class="col-xs-4 text-right">
								<div class="spinner input-group input-group-sm" data-trigger="spinner">
									<span class="input-group-addon" data-spin="down">-</span>
									<input id="quantity" class="form-control" type="text" value="1" maxlength="5" data-rule="quantity" data-min="1" data-max="10000">
									<span class="input-group-addon" data-spin="up">+</span>
								</div>
							</div>
						</div>
						[#if product.type == "GENERAL"]
							<button id="addCart" class="btn btn-primary btn-lg btn-block" type="button">${message("shop.product.addCart")}</button>
						[#elseif product.type == "EXCHANGE"]
							<button id="exchange" class="btn btn-primary btn-lg btn-block" type="button">${message("shop.product.exchange")}</button>
						[/#if]
					</div>
				</div>
			[/#if]
		</div>
		<div class="container-fluid">
			<div id="shareModal" class="modal fade" tabindex="-1">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-body clearfix">
							<div class="bdsharebuttonbox">
								<a class="bds_qzone" data-cmd="qzone" href="#"></a>
								<a class="bds_tsina" data-cmd="tsina"></a>
								<a class="bds_tqq" data-cmd="tqq"></a>
								<a class="bds_weixin" data-cmd="weixin"></a>
								<a class="bds_renren" data-cmd="renren"></a>
								<a id="shareMore" class="bds_more" data-cmd="more"></a>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div id="tabContentWrapper" class="tab-content-wrapper">
				<div id="tabContent" class="tab-content">
					<div id="pullDownTips" class="pull-down-tips">${message("shop.product.pullDownTips")}</div>
					<div id="pullUpTips" class="pull-up-tips">${message("shop.product.pullUpTips")}</div>
					<div id="summary" class="summary tab-pane active">
						<ul id="productImage" class="product-image">
							[#if product.productImages?has_content]
								[#list product.productImages as productImage]
									<li>
										<img class="img-responsive center-block" src="${productImage.medium}" alt="${product.name}">
									</li>
								[/#list]
							[#else]
								<li>
									<img class="img-responsive center-block" src="${setting.defaultMediumProductImage}" alt="${product.name}">
								</li>
							[/#if]
						</ul>
						<section>
							<h4>
								[#if product.store.type == "SELF"]
									<span class="label label-primary">${message("Store.Type.SELF")}</span>
								[/#if]
								${product.name}
								[#if product.caption?has_content]
									<span class="text-orange">${product.caption}</span>
								[/#if]
							</h4>
						</section>
						<section>
							[#if product.type == "GENERAL"]
								<strong class="price text-red">${currency(defaultSku.price, true)}</strong>
								[#if setting.isShowMarketPrice]
									<del class="market-price text-gray">${currency(defaultSku.marketPrice, true)}</del>
								[/#if]
							[#elseif product.type == "EXCHANGE"]
								${message("Sku.exchangePoint")}:
								<strong class="exchange-point text-red">${defaultSku.exchangePoint}</strong>
							[#elseif product.type == "GIFT"]
								<p class="text-red">${message("shop.product.giftNoBuy")}</p>
							[/#if]
						</section>
						[#if product.parameterValues?has_content]
							<section>
								<a id="viewParameter" href="javascript:;">
									${message("shop.product.parameter")}
									<i class="iconfont icon-more text-gray"></i>
								</a>
							</section>
						[/#if]
						<section>
							<a id="viewSpecification" href="javascript:;">
								${message("shop.product.specification")}
								<i class="iconfont icon-more text-gray"></i>
							</a>
						</section>
					</div>
					<div id="detail" class="detail tab-pane">
						[#noautoesc]
							${product.introduction}
						[/#noautoesc]
					</div>
					<div id="review" class="review tab-pane">
						<div id="reviewScrollLoad">
							<div id="reviewScrollLoadContent"></div>
						</div>
					</div>
					<div id="consultation" class="consultation tab-pane">
						<div id="consultationScrollLoad">
							<div id="consultationScrollLoadContent"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</main>
	<footer class="footer-default" data-spy="scrollToFixed" data-bottom="0">
		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-2">
					<a href="${base}/">
						<i class="iconfont icon-home center-block"></i>
						<span class="center-block">${message("shop.footer.home")}</span>
					</a>
				</div>
				<div class="col-xs-2">
					<a href="${base}${product.store.path}">
						<i class="iconfont icon-shop center-block"></i>
						<span class="center-block">${message("shop.product.store")}</span>
					</a>
				</div>
				<div class="col-xs-2">
					<a class="center-block" href="javascript:;" data-action="addProductFavorite" data-product-id="${product.id}">
						<i class="iconfont icon-like center-block"></i>
						<span class="center-block">${message("shop.product.addProductFavorite")}</span>
					</a>
				</div>
				<div class="col-xs-2">
					<a id="footerCart" href="${base}/cart/list">
						<i class="iconfont icon-cart center-block"></i>
						<span class="center-block">${message("shop.footer.cart")}</span>
					</a>
				</div>
				<div class="col-xs-4">
					[#if product.type == "GENERAL"]
						<button id="willAddCart" class="btn btn-primary btn-lg btn-block" type="button">${message("shop.product.addCart")}</button>
					[#elseif product.type == "EXCHANGE"]
						<button id="willExchange" class="btn btn-primary btn-lg btn-block" type="button">${message("shop.product.exchange")}</button>
					[#elseif product.type == "GIFT"]
						<button class="btn btn-primary btn-lg btn-block disabled" type="button">${message("shop.product.addCart")}</button>
					[/#if]
				</div>
			</div>
		</div>
	</footer>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
				window._bd_share_config = {
					common: {
						bdUrl: $.generateSpreadUrl()
					},
					share: [
						{
							bdSize: 24
						}
					]
				}
				with(document)0[(getElementsByTagName("head")[0]||body).appendChild(createElement("script")).src="http://bdimg.share.baidu.com/static/api/js/share.js?cdnversion="+~(-new Date()/36e5)];
			</script>
		[/#escape]
	[/#noautoesc]
</body>
</html>