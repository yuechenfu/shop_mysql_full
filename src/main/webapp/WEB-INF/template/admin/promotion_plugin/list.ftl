<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("admin.promotionPlugin.list")} - Powered By SHOP++</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/awesome-bootstrap-checkbox.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/admin/css/base.css" rel="stylesheet">
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
	<script src="${base}/resources/admin/js/base.js"></script>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
			
				var $install = $("a.install");
				var $uninstall = $("a.uninstall");
				
				// 安装/卸载
				$install.add($uninstall).click(function() {
					var $element = $(this);
					var message = $element.hasClass("install") ? "${message("admin.promotionPlugin.installConfirm")}" : "${message("admin.promotionPlugin.uninstallConfirm")}";
					
					bootbox.confirm(message, function(result) {
						if (result == null || !result) {
							return;
						}
						
						$.ajax({
							url: $element.data("url"),
							type: "POST",
							dataType: "json",
							cache: false,
							success: function() {
								setTimeout(function() {
									location.reload(true);
								}, 1000);
							}
						});
					});
				});
			
			});
			</script>
		[/#escape]
	[/#noautoesc]
</head>
<body class="admin">
	[#include "/admin/include/main_header.ftl" /]
	[#include "/admin/include/main_sidebar.ftl" /]
	<main>
		<div class="container-fluid">
			<ol class="breadcrumb">
				<li>
					<a href="${base}/admin/index">
						<i class="iconfont icon-homefill"></i>
						${message("common.breadcrumb.index")}
					</a>
				</li>
				<li class="active">${message("admin.promotionPlugin.list")}</li>
			</ol>
			<form action="${base}/admin/promotion_plugin/list" method="get">
				<div class="panel panel-default">
					<div class="panel-heading">
						<div class="btn-group">
							<button class="btn btn-default" type="button" data-action="refresh">
								<i class="iconfont icon-refresh"></i>
								${message("common.refresh")}
							</button>
						</div>
					</div>
					<div class="panel-body">
						<div class="table-responsive">
							<table class="table table-hover">
								<thead>
									<tr>
										<th>${message("PromotionPlugin.name")}</th>
										<th>${message("PromotionPlugin.version")}</th>
										<th>${message("PromotionPlugin.author")}</th>
										<th>${message("PromotionPlugin.serviceCharge")}</th>
										<th>${message("PromotionPlugin.isEnabled")}</th>
										<th>${message("common.order")}</th>
										<th>${message("common.action")}</th>
									</tr>
								</thead>
								<tbody>
									[#list promotionPlugins as promotionPlugin]
										<tr>
											<td>${promotionPlugin.name}</td>
											<td>${promotionPlugin.version!'-'}</td>
											<td>${promotionPlugin.author!'-'}</td>
											<td>
												[#if promotionPlugin.serviceCharge??]
													${currency(promotionPlugin.serviceCharge, true)}
												[/#if]
											</td>
											<td>
												[#if promotionPlugin.isEnabled]
													<i class="text-green iconfont icon-check"></i>
												[#else]
													<i class="text-red iconfont icon-close"></i>
												[/#if]
											</td>
											<td>${promotionPlugin.order}</td>
											<td>
												[#if promotionPlugin.isInstalled]
													[#if promotionPlugin.settingUrl??]
														<a class="btn btn-default btn-xs btn-icon" href="${base}${promotionPlugin.settingUrl}" title="${message("admin.promotionPlugin.setting")}" data-toggle="tooltip" data-redirect-url>
															<i class="iconfont icon-settings"></i>
														</a>
													[/#if]
													[#if promotionPlugin.uninstallUrl??]
														<a class="uninstall btn btn-default btn-xs btn-icon" href="javascript:;" title="${message("admin.promotionPlugin.uninstall")}" data-toggle="tooltip" data-url="${base}${promotionPlugin.uninstallUrl}">
															<i class="iconfont icon-delete"></i>
														</a>
													[/#if]
												[#else]
													[#if promotionPlugin.installUrl??]
														<a class="install btn btn-default btn-xs btn-icon" href="javascript:;" title="${message("admin.promotionPlugin.install")}" data-toggle="tooltip" data-url="${base}${promotionPlugin.installUrl}">
															<i class="iconfont icon-repair"></i>
														</a>
													[/#if]
												[/#if]
											</td>
										</tr>
									[/#list]
								</tbody>
							</table>
							[#if !promotionPlugins?has_content]
								<p class="no-result">${message("common.noResult")}</p>
							[/#if]
						</div>
					</div>
				</div>
			</form>
		</div>
	</main>
</body>
</html>