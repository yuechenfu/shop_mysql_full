<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("business.promotionPlugin.index")} - Powered By SHOP++</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/awesome-bootstrap-checkbox.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/business/css/base.css" rel="stylesheet">
	<link href="${base}/resources/business/css/promotion_plugins.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/bootstrap-growl.js"></script>
	<script src="${base}/resources/common/js/bootbox.js"></script>
	<script src="${base}/resources/common/js/jquery.nicescroll.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/velocity.js"></script>
	<script src="${base}/resources/common/js/velocity.ui.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/business/js/base.js"></script>
</head>
<body class="business promotion-plugins">
	[#include "/business/include/main_header.ftl" /]
	[#include "/business/include/main_sidebar.ftl" /]
	<main>
		<div class="container-fluid">
			<ol class="breadcrumb">
				<li>
					<a href="${base}/business/index">
						<i class="iconfont icon-homefill"></i>
						${message("common.breadcrumb.index")}
					</a>
				</li>
				<li class="active">${message("business.promotionPlugin.index")}</li>
			</ol>
			<ul class="promotion-plugins-list clearfix">
				[#list promotionPlugins as promotionPlugin]
					<li>
						<a href="${base}/business/promotion_plugin/list?promotionPluginId=${promotionPlugin.id}">
							<h4>${promotionPlugin.displayName}</h4>
							<p>${promotionPlugin.description}</p>
							<div class="clearfix" style="line-height: 30px;">
								[#if currentStore.type == "GENERAL" ]
									<strong class="pull-left">${message("PromotionPlugin.serviceCharge")}:${currency(promotionPlugin.serviceCharge, true, true)}</strong>
									[#if currentStore.isPromotionPluginActive(promotionPlugin.id)]
										<span class="pull-right">${message("StorePluginStatus.endDate")}:
											<span title="${currentStore.getPromotionPluginEndDate(promotionPlugin.id)?string("yyyy-MM-dd HH:mm:ss")}" data-toggle="tooltip">${currentStore.getPromotionPluginEndDate(promotionPlugin.id)}</span>	
										</span>
									[#else]
										<a class="btn btn-primary pull-right" href="${base}/business/promotion_plugin/buy?promotionPluginId=${promotionPlugin.id}">${message("business.promotionPlugin.buy")}</a>
									[/#if]
								[/#if]
							</div>
						</a>
					</li>
				[/#list]
			</ul>
		</div>
	</main>
</body>
</html>