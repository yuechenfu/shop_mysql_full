<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	[#if productCategory??]
		[@seo type = "PRODUCT_LIST"]
			[#if productCategory.seoKeywords?has_content]
				<meta name="keywords" content="${productCategory.seoKeywords}">
			[#elseif seo.resolveKeywords()?has_content]
				<meta name="keywords" content="${seo.resolveKeywords()}">
			[/#if]
			[#if productCategory.seoDescription?has_content]
				<meta name="description" content="${productCategory.seoDescription}">
			[#elseif seo.resolveDescription()?has_content]
				<meta name="description" content="${seo.resolveDescription()}">
			[/#if]
			<title>
				[#if productCategory.seoTitle?has_content]
					${productCategory.seoTitle}
				[#else]
					${seo.resolveTitle()}
				[/#if]
				[#if showPowered] - Powered By SHOP++[/#if]
			</title>
		[/@seo]
	[#else]
		<title>${message("shop.product.list")}[#if showPowered] - Powered By SHOP++[/#if]</title>
	[/#if]
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/awesome-bootstrap-checkbox.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/store.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/product.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/bootstrap-growl.js"></script>
	<script src="${base}/resources/common/js/jquery.lazyload.js"></script>
	<script src="${base}/resources/common/js/jquery.fly.js"></script>
	<script src="${base}/resources/common/js/jquery.qrcode.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/velocity.js"></script>
	<script src="${base}/resources/common/js/velocity.ui.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/shop/js/base.js"></script>
	<script id="compareProductItemTemplate" type="text/template">
		<li>
			<input name="productIds" type="hidden" value="<%-compareProduct.id%>">
			<div class="media">
				<div class="media-left media-middle">
					<a href="${base}<%-compareProduct.path%>" target="_blank">
						<img class="media-object img-thumbnail" src="<%-compareProduct.thumbnail != null ? compareProduct.thumbnail : "${setting.defaultThumbnailProductImage}"%>" alt="<%-compareProduct.name%>">
					</a>
				</div>
				<div class="media-body media-middle">
					<h5 class="media-heading text-overflow">
						<a href="${base}<%-compareProduct.path%>" title="<%-compareProduct.name%>" target="_blank"><%-compareProduct.name%></a>
					</h5>
					<strong class="text-red"><%-$.currency(compareProduct.price, true)%></strong>
					<a class="delete-compare btn btn-default btn-xs btn-icon" href="javascript:;" title="${message("common.delete")}" data-product-id="<%-compareProduct.id%>">
						<i class="iconfont icon-close"></i>
					</a>
				</div>
			</div>
		</li>
	</script>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
				
				var $compareForm = $("#compareForm");
				var $compareBar = $("#compareBar");
				var $compareBody = $("#compareBar .compare-bar-body ul");
				var $compare = $("#compareBar a.compare");
				var $clearCompareBar = $("#compareBar a.clear-compare-bar");
				var $productForm = $("#productForm");
				var $brandId = $("[name='brandId']");
				var $orderType = $("[name='orderType']");
				var $storeType = $("[name='storeType']");
				var $isOutOfStock = $("[name='isOutOfStock']");
				var $filter = $("#filter");
				var $brandFilterItem = $("[data-brand-id]");
				var $attributeFilterItem = $("[data-attribute-id]");
				var $filterGroupCollapse = $("#filter a.filter-group-collapse");
				var $filterCollapse = $("#filter a.filter-collapse");
				var $orderTypeItem = $("[data-order-type]");
				var $startPrice = $("[name='startPrice']");
				var $endPrice = $("[name='endPrice']");
				var $addCompare = $("a.add-compare");
				var compareProductItemTemplate = _.template($("#compareProductItemTemplate").html());
				var compareProductIdsLocalStorageKey = "compareProductIds";
				
				// 对比栏
				var compareProductIdsLocalStorage = localStorage.getItem(compareProductIdsLocalStorageKey);
				var compareProductIds = compareProductIdsLocalStorage != null ? JSON.parse(compareProductIdsLocalStorage) : [];
				
				if (compareProductIds.length > 0) {
					$.ajax({
						url: "${base}/product/compare_bar",
						type: "GET",
						data: {
							productIds: compareProductIds
						},
						dataType: "json",
						cache: true,
						success: function(data) {
							$.each(data, function(i, item) {
								$compareBody.append(compareProductItemTemplate({
									compareProduct: item
								}));
							});
							$compareBar.velocity("fadeIn");
						}
					});
				}
				
				// 添加对比项
				$addCompare.click(function() {
					var $element = $(this);
					var productId = $element.data("product-id");
					
					if ($.inArray(productId, compareProductIds) >= 0) {
						$.bootstrapGrowl("${message("shop.product.alreadyAddCompare")}", {
							type: "warning"
						});
						return false;
					}
					if (compareProductIds.length >= 4) {
						$.bootstrapGrowl("${message("shop.product.addCompareNotAllowed")}", {
							type: "warning"
						});
						return false;
					}
					$.ajax({
						url: "${base}/product/add_compare",
						type: "GET",
						data: {
							productId: productId
						},
						dataType: "json",
						cache: false,
						success: function(data) {
							if ($compareBar.is(":hidden")) {
								$compareBar.velocity("fadeIn");
							}
							$compareBody.append(compareProductItemTemplate({
								compareProduct: data
							}));
							compareProductIds.push(productId);
							localStorage.setItem(compareProductIdsLocalStorageKey, JSON.stringify(compareProductIds));
						}
					});
					return false;
				});
				
				// 删除对比项
				$compareBar.on("click", "a.delete-compare", function() {
					var $element = $(this);
					var productId = $element.data("product-id");
					
					$element.closest("li").velocity("fadeOut").remove();
					compareProductIds = $.grep(compareProductIds, function(compareProductId, i) {
						return compareProductId != productId;
					});
					if (compareProductIds.length === 0) {
						$compareBar.velocity("fadeOut");
						localStorage.removeItem(compareProductIdsLocalStorageKey);
					} else {
						localStorage.setItem(compareProductIdsLocalStorageKey, JSON.stringify(compareProductIds));
					}
					return false;
				});
				
				// 开始对比
				$compare.click(function() {
					if (compareProductIds.length < 2) {
						$.bootstrapGrowl("${message("shop.product.compareNotAllowed")}", {
							type: "warning"
						});
						return false;
					}
					$compareForm.submit();
					return false;
				});
				
				// 清空对比栏
				$clearCompareBar.click(function() {
					compareProductIds = [];
					localStorage.removeItem(compareProductIdsLocalStorageKey);
					$compareBar.find("li:not(.action)").remove().end().velocity("fadeOut");
					return false;
				});
				
				// 品牌筛选
				$brandFilterItem.click(function() {
					var $element = $(this);
					var brandId = $element.data("brand-id");
					
					if ($element.closest("li").hasClass("active")) {
						$brandId.prop("disabled", true);
					} else {
						$brandId.val(brandId);
					}
					$productForm.submit();
					return false;
				});
				
				// 属性筛选
				$attributeFilterItem.click(function() {
					var $element = $(this);
					var attributeId = $element.data("attribute-id");
					var attributeOption = $element.data("attribute-option");
					var $attribute = $("[name='attribute_" + attributeId + "']");
					
					if ($element.closest("li").hasClass("active")) {
						$attribute.prop("disabled", true);
					} else {
						$attribute.prop("disabled", false).val(attributeOption);
					}
					$productForm.submit();
					return false;
				});
				
				// 刷新筛选组折叠
				function refreshFilterGroupCollapse() {
					$filterGroupCollapse.each(function() {
						var $element = $(this);
						var $filterGroup = $element.prev("ul");
						
						if ($filterGroup.outerHeight() < $filterGroup[0].scrollHeight) {
							$element.show();
						}
					});
				}
				
				// 刷新筛选折叠
				function refreshFilterCollapse() {
					if ($filter.find("dd").length > 3) {
						$filterCollapse.show();
					}
				}
				
				refreshFilterGroupCollapse();
				refreshFilterCollapse();
				
				// 筛选组折叠
				$filterGroupCollapse.click(function() {
					var $element = $(this);
					var $filterGroup = $element.prev("ul");
					
					$filterGroup.scrollTop(0).toggleClass("expanded");
				});
				
				// 筛选折叠
				$filterCollapse.click(function() {
					$filter.toggleClass("expanded");
					$filterCollapse.find("span").text($filter.hasClass("expanded") ? "${message("shop.product.collapse")}": "${message("shop.product.expand")}");
					refreshFilterGroupCollapse();
				});
				
				// 价格
				$startPrice.add($endPrice).keypress(function(event) {
					return (event.which >= 48 && event.which <= 57) || (event.which == 46 && $(this).val().indexOf(".") < 0) || event.which == 8 || event.which == 13;
				});
				
				// 排序类型
				$orderTypeItem.click(function() {
					var $element = $(this);
					var orderType = $element.data("order-type");
					
					$orderType.val(orderType);
					$productForm.submit();
					return false;
				});
				
				// 是否自营筛选
				$storeType.change(function() {
					$productForm.submit();
					return false;
				});
				
				// 是否有货筛选
				$isOutOfStock.change(function() {
					$productForm.submit();
					return false;
				});
			
			});
			</script>
		[/#escape]
	[/#noautoesc]
</head>
<body class="shop product-list">
	[#include "/shop/include/main_header.ftl" /]
	[#include "/shop/include/main_sidebar.ftl" /]
	<main>
		<div class="container">
			<form id="compareForm" action="${base}/product/compare" method="get">
				<div id="compareBar" class="compare-bar">
					<div class="compare-bar-heading">
						<h5>${message("shop.product.compareBar")}</h5>
					</div>
					<div class="compare-bar-body clearfix">
						<ul class="pull-left clearfix"></ul>
						<div class="action">
							<a class="compare btn btn-primary" href="javascript:;">${message("shop.product.beginCompare")}</a>
							<a class="clear-compare-bar" href="javascript:;">${message("shop.product.clearCompareBar")}</a>
						</div>
					</div>
				</div>
			</form>
			<div class="row">
				<div class="col-xs-2">
					[#if storeProductCategory??]
						[#assign store = storeProductCategory.store /]
						[#include "/shop/include/store_summary.ftl" /]
						[#include "/shop/include/store_product_search.ftl" /]
						[#include "/shop/include/store_product_category.ftl" /]
					[#else]
						[#include "/shop/include/featured_product.ftl" /]
					[/#if]
				</div>
				<div class="col-xs-10">
					<ol class="breadcrumb">
						<li>
							<a href="${base}/">
								<i class="iconfont icon-homefill"></i>
								${message("common.breadcrumb.index")}
							</a>
						</li>
						[#if productCategory??]
							[@product_category_parent_list productCategoryId = productCategory.id]
								[#list productCategories as productCategory]
									<li>
										<a href="${base}${productCategory.path}">${productCategory.name}</a>
									</li>
								[/#list]
							[/@product_category_parent_list]
							<li class="active">${productCategory.name}</li>
						[#else]
							<li class="active">${message("shop.product.list")}</li>
						[/#if]
					</ol>
					<form id="productForm" action="${base}${(productCategory.path)!"/product/list"}" method="get">
						[#if type??]
							<input name="type" type="hidden" value="${type}">
						[/#if]
						[#if storeProductCategory??]
							<input name="storeProductCategoryId" type="hidden" value="${storeProductCategory.id}">
						[/#if]
						<input name="brandId" type="hidden" value="${(brand.id)!}">
						<input name="promotionId" type="hidden" value="${(promotion.id)!}">
						<input name="orderType" type="hidden" value="${orderType}">
						[#if productCategory??]
							[@product_category_children_list productCategoryId = productCategory.id recursive = false]
								[#assign filterProductCategories = productCategories /]
							[/@product_category_children_list]
							[@brand_list productCategoryId = productCategory.id]
								[#assign filterBrands = brands /]
							[/@brand_list]
							[@attribute_list productCategoryId = productCategory.id]
								[#assign filterAttributes = attributes /]
							[/@attribute_list]
							[#list filterAttributes as filterAttribute]
								<input name="attribute_${filterAttribute.id}" type="hidden"[#if attributeValueMap?keys?seq_contains(filterAttribute)] value="${attributeValueMap.get(filterAttribute)}"[#else] disabled[/#if]>
							[/#list]
							[#if filterProductCategories?has_content || filterBrands?has_content || filterAttributes?has_content]
								<div id="filter" class="filter[#if attributeValueMap?has_content] expanded[/#if]">
									<div class="filter-body">
										<dl class="dl-horizontal">
											[#if filterProductCategories?has_content]
												<dt>${message("shop.product.productCategory")}:</dt>
												<dd>
													<ul class="text-filter-group clearfix">
														[#list filterProductCategories as filterProductCategory]
															<li>
																<a href="${base}${filterProductCategory.path}">${filterProductCategory.name}</a>
															</li>
														[/#list]
													</ul>
													<a class="filter-group-collapse" href="javascript:;">
														<i class="iconfont icon-unfold"></i>
													</a>
												</dd>
											[/#if]
											[#if filterBrands?has_content]
												<dt>${message("shop.product.brand")}:</dt>
												<dd>
													<ul class="image-filter-group clearfix">
														[#list filterBrands as filterBrand]
															<li[#if filterBrand == brand] class="active" title="${message("shop.product.cancel")}"[/#if]>
																<a href="javascript:;" data-brand-id="${filterBrand.id}">
																	[#if filterBrand.type == "IMAGE"]
																		<img class="img-responsive center-block" src="${filterBrand.logo}" alt="${filterBrand.name}">
																	[/#if]
																	<strong>${filterBrand.name}</strong>
																</a>
															</li>
														[/#list]
													</ul>
													<a class="filter-group-collapse" href="javascript:;">
														<i class="iconfont icon-unfold"></i>
													</a>
												</dd>
											[/#if]
											[#list filterAttributes as filterAttribute]
												<dt title="${filterAttribute.name}">${filterAttribute.name}:</dt>
												<dd>
													<ul class="text-filter-group clearfix">
														[#list filterAttribute.options as option]
															<li[#if attributeValueMap.get(filterAttribute) == option] class="active" title="${message("shop.product.cancel")}"[/#if]>
																<a href="javascript:;" data-attribute-id="${filterAttribute.id}" data-attribute-option="${option}">${option}</a>
															</li>
														[/#list]
													</ul>
													<a class="filter-group-collapse" href="javascript:;">
														<i class="iconfont icon-unfold"></i>
													</a>
												</dd>
											[/#list]
										</dl>
									</div>
									<div class="filter-footer">
										<a class="filter-collapse" href="javascript:;">
											<i class="iconfont icon-unfold"></i>
											[#if attributeValueMap?has_content]
												<span>${message("shop.product.collapse")}</span>
											[#else]
												<span>${message("shop.product.expand")}</span>
											[/#if]
										</a>
									</div>
								</div>
							[/#if]
						[/#if]
						<div class="bar clearfix">
							<a class="bar-item[#if !orderType?? || orderType == "TOP_DESC"] active[/#if]" href="javascript:;" data-order-type="TOP_DESC">
								${message("shop.product.topDesc")}
								<i class="iconfont icon-unfold"></i>
							</a>
							<a class="bar-item[#if orderType == "SALES_DESC"] active[/#if]" href="javascript:;" data-order-type="SALES_DESC">
								${message("shop.product.salesDesc")}
								<i class="iconfont icon-unfold"></i>
							</a>
							<a class="bar-item[#if orderType == "SCORE_DESC"] active[/#if]" href="javascript:;" data-order-type="SCORE_DESC">
								${message("shop.product.scoreDesc")}
								<i class="iconfont icon-unfold"></i>
							</a>
							<a class="bar-item[#if orderType == "PRICE_ASC"] active[/#if]" href="javascript:;" data-order-type="PRICE_ASC">
								${message("shop.product.priceAsc")}
								<i class="iconfont icon-fold"></i>
							</a>
							<div class="bar-item bg-white">
								<div class="checkbox checkbox-inline">
									<input name="storeType" type="checkbox" value="SELF"[#if storeType == "SELF"] checked[/#if]>
									<label>${message("shop.product.self")}</label>
								</div>
								<div class="checkbox checkbox-inline">
									<input name="isOutOfStock" type="checkbox" value="false"[#if isOutOfStock?? && !isOutOfStock] checked[/#if]>
									<label>${message("shop.product.inStock")}</label>
								</div>
							</div>
							<div class="bar-item bg-white">
								<input name="startPrice" type="text" value="${startPrice}" maxlength="16" placeholder="${message("shop.product.startPricePlaceholder")}" onpaste="return false;">
								-
								<input name="endPrice" type="text" value="${endPrice}" maxlength="16" placeholder="${message("shop.product.endPricePlaceholder")}" onpaste="return false;">
								<button type="submit">${message("shop.product.submit")}</button>
							</div>
							<div class="bar-item bg-white pull-right">
								[@pagination pageNumber = page.pageNumber totalPages = page.totalPages]
									[#if hasPrevious]
										<a href="javascript:;" data-page-number="${previousPageNumber}">
											<i class="iconfont icon-back"></i>
										</a>
									[#else]
										<i class="text-gray iconfont icon-back"></i>
									[/#if]
									[#if hasNext]
										<a href="javascript:;" data-page-number="${nextPageNumber}">
											<i class="iconfont icon-right"></i>
										</a>
									[#else]
										<i class="text-gray iconfont icon-right"></i>
									[/#if]
								[/@pagination]
							</div>
						</div>
						[#if page.content?has_content]
							<div class="list">
								<ul class="clearfix">
									[#list page.content as product]
										[#assign defaultSku = product.defaultSku /]
										<li class="list-item">
											<div class="list-item-body">
												<a href="${base}${product.path}" target="_blank">
													<img id="productImage${product.id}" class="lazy-load img-responsive center-block" src="${base}/resources/common/images/transparent.png" alt="${product.name}" data-original="${product.thumbnail!setting.defaultThumbnailProductImage}">
												</a>
												<strong>
													[#if product.type == "GENERAL"]
														${currency(defaultSku.price, true)}
														[#if setting.isShowMarketPrice]
															<del>${currency(defaultSku.marketPrice, true)}</del>
														[/#if]
													[#elseif product.type == "EXCHANGE"]
														${message("Sku.exchangePoint")}: ${defaultSku.exchangePoint}
													[/#if]
												</strong>
												<a href="${base}${product.path}" target="_blank">
													<h5 class="text-overflow" title="${product.name}">${product.name}</h5>
													[#if product.caption?has_content]
														<h6 class="text-overflow" title="${product.caption}">${product.caption}</h6>
													[/#if]
												</a>
												<p class="text-center">
													<a href="${base}${product.store.path}" title="${product.store.name}" target="_blank">${abbreviate(product.store.name, 15)}</a>
													[#if product.store.type == "SELF"]
														<span class="label label-primary">${message("Store.Type.SELF")}</span>
													[/#if]
												</p>
											</div>
											<div class="list-item-footer clearfix">
												[#if product.type == "GENERAL"]
													<a href="javascript:;" data-action="addCart" data-sku-id="${defaultSku.id}" data-cart-target="#mainSidebarCart" data-product-image-target="#productImage${product.id}">
														<i class="iconfont icon-cart"></i>
														${message("shop.product.addCart")}
													</a>
												[#elseif product.type == "EXCHANGE"]
													<a href="javascript:;" data-action="checkout" data-sku-id="${defaultSku.id}">
														<i class="iconfont icon-present"></i>
														${message("shop.product.exchange")}
													</a>
												[/#if]
												<a class="add-product-favorite" href="javascript:;" title="${message("shop.product.addProductFavorite")}" data-action="addProductFavorite" data-product-id="${product.id}">
													<i class="iconfont icon-like"></i>
												</a>
												<a class="add-compare" href="javascript:;" title="${message("shop.product.addCompare")}" data-product-id="${product.id}">
													<i class="iconfont icon-list"></i>
												</a>
											</div>
										</li>
									[/#list]
								</ul>
							</div>
							[@pagination pageNumber = page.pageNumber totalPages = page.totalPages]
								[#if totalPages > 1]
									<div class="text-right">
										[#include "/shop/include/pagination.ftl" /]
									</div>
								[/#if]
							[/@pagination]
						[#else]
							[#noautoesc]
								<div class="no-result">${message("shop.product.noResult")}</div>
							[/#noautoesc]
						[/#if]
					</form>
				</div>
			</div>
		</div>
	</main>
	[#include "/shop/include/main_footer.ftl" /]
</body>
</html>