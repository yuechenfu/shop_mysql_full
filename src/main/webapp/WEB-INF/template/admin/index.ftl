<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("admin.index.title")} - Powered By SHOP++</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/admin/css/base.css" rel="stylesheet">
	<link href="${base}/resources/admin/css/index.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/bootstrap-growl.js"></script>
	<script src="${base}/resources/common/js/moment.js"></script>
	<script src="${base}/resources/common/js/jquery.nicescroll.js"></script>
	<script src="${base}/resources/common/js/jquery.validate.js"></script>
	<script src="${base}/resources/common/js/jquery.validate.additional.js"></script>
	<script src="${base}/resources/common/js/jquery.form.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/jquery.animateNumber.js"></script>
	<script src="${base}/resources/common/js/g2.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/admin/js/base.js"></script>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
			
				var $todayAddedMemberCount = $("#todayAddedMemberCount");
				var $todayAddedBusinessCount = $("#todayAddedBusinessCount");
				var $todayAddedPlatformCommission = $("#todayAddedPlatformCommission");
				var $todayAddedDistributionCommission = $("#todayAddedDistributionCommission");
				var $todayAddedMember = $("#todayAddedMember");
				var $yesterdayAddedCount = $("#yesterdayAddedMemberCount");
				var $currentMonthAddedCount = $("#currentMonthAddedMemberCount");
				var $todayAddedBusiness = $("#todayAddedBusiness");
				var $yesterdayAddedBusinessCount = $("#yesterdayAddedBusinessCount");
				var $currentMonthAddedBusinessCount = $("#currentMonthAddedBusinessCount");
				
				// 今日新增会员数
				$todayAddedMemberCount.animateNumber({
					number: ${todayAddedMemberCount},
					numberStep: function(now, tween) {
						$(tween.elem).add($todayAddedMember).text(Math.floor(now));
					}
				}, 1000);
				
				// 今日新增商家数
				$todayAddedBusinessCount.animateNumber({
					number: ${todayAddedBusinessCount},
					numberStep: function(now, tween) {
						$(tween.elem).add($todayAddedBusiness).text(Math.floor(now));
					}
				}, 1000);
				
				// 今日新增平台佣金
				$todayAddedPlatformCommission.animateNumber({
					number: ${todayAddedPlatformCommission},
					numberStep: function(now, tween) {
						$(tween.elem).text($.currency(now, true, true));
					}
				}, 1000);
				
				// 今日新增分销佣金
				$todayAddedDistributionCommission.animateNumber({
					number: ${todayAddedDistributionCommission},
					numberStep: function(now, tween) {
						$(tween.elem).text($.currency(now, true, true));
					}
				}, 1000);
				
				// 昨日新增会员数
				$yesterdayAddedCount.animateNumber({
					number: ${yesterdayAddedMemberCount}
				}, 1000);
				
				// 本月新增会员数
				$currentMonthAddedCount.animateNumber({
					number: ${currentMonthAddedMemberCount}
				}, 1000);
				
				// 昨日新增商家数
				$yesterdayAddedBusinessCount.animateNumber({
					number: ${yesterdayAddedBusinessCount}
				}, 1000);
				
				// 本月新增商家数
				$currentMonthAddedBusinessCount.animateNumber({
					number: ${currentMonthAddedBusinessCount}
				}, 1000);
				
				// 订单统计图表
				var orderStatisticChart = new G2.Chart({
					id: "orderStatisticChart",
					height: 200,
					forceFit: true,
					plotCfg: {
						margin: [20, 20, 30, 80]
					}
				});
				
				orderStatisticChart.source([], {
					date: {
						type: "time",
						tickCount: 10,
						formatter: function(value) {
							return moment(value).format("YYYY-MM-DD");
						}
					},
					value: {
						alias: "${message("Statistic.Type.CREATE_ORDER_COUNT")}"
					}
				});
				orderStatisticChart.axis("date", {
					title: null,
					formatter: function(value) {
						return moment(value).format("MM-DD");
					}
				});
				orderStatisticChart.axis("value", {
					title: null
				});
				orderStatisticChart.line().position("date*value").color("#66baff");
				orderStatisticChart.render();
				
				$.ajax({
					url: "${base}/admin/order_statistic/data",
					type: "get",
					data: {
						type: "CREATE_ORDER_COUNT"
					},
					dataType: "json",
					success: function(data) {
						orderStatisticChart.changeData(data);
					}
				});
				
				// 资金统计图表
				var amountStatisticChart = new G2.Chart({
					id: "amountStatisticChart",
					height: 200,
					forceFit: true,
					plotCfg: {
						margin: [20, 20, 30, 80]
					}
				});
				
				amountStatisticChart.source([], {
					date: {
						type: "time",
						tickCount: 10,
						formatter: function(value) {
							return moment(value).format("YYYY-MM-DD");
						}
					},
					value: {
						alias: "${message("Statistic.Type.PLATFORM_COMMISSION")}"
					}
				});
				amountStatisticChart.axis("date", {
					title: null,
					formatter: function(value) {
						return moment(value).format("MM-DD");
					}
				});
				amountStatisticChart.axis("value", {
					title: null
				});
				amountStatisticChart.line().position("date*value").color("#66baff");
				amountStatisticChart.render();
				
				$.ajax({
					url: "${base}/admin/fund_statistic/data",
					type: "get",
					data: {
						type: "PLATFORM_COMMISSION"
					},
					dataType: "json",
					success: function(data) {
						amountStatisticChart.changeData(data);
					}
				});
			
			});
			</script>
		[/#escape]
	[/#noautoesc]
</head>
<body class="admin index">
	[#include "/admin/include/main_header.ftl" /]
	[#include "/admin/include/main_sidebar.ftl" /]
	<main>
		<div class="container-fluid">
			<ol class="breadcrumb">
				<li class="active">${message("admin.index.title")}</li>
			</ol>
			<div class="row">
				<div class="col-xs-12 col-sm-3">
					<div class="section-info bg-blue-light">
						<i class="iconfont icon-people"></i>
						<h1 id="todayAddedMemberCount"></h1>
						<p>${message("admin.index.todayAddedMemberCount")}</p>
						<a href="${base}/admin/member/list">
							${message("admin.index.viewAllMember")}
							<i class="iconfont icon-pullright"></i>
						</a>
					</div>
				</div>
				<div class="col-xs-12 col-sm-3">
					<div class="section-info bg-red-light">
						<i class="iconfont icon-crown"></i>
						<h1 id="todayAddedBusinessCount"></h1>
						<p>${message("admin.index.todayAddedBusinessCount")}</p>
						<a href="${base}/admin/business/list">
							${message("admin.index.viewAllBusiness")}
							<i class="iconfont icon-pullright"></i>
						</a>
					</div>
				</div>
				<div class="col-xs-12 col-sm-3">
					<div class="section-info bg-green-light">
						<i class="iconfont icon-cart"></i>
						<h1 id="todayAddedPlatformCommission"></h1>
						<p>${message("admin.index.todayAddedPlatformCommission")}</p>
						<a href="${base}/admin/order/list">
							${message("admin.index.viewAllOrder")}
							<i class="iconfont icon-pullright"></i>
						</a>
					</div>
				</div>
				<div class="col-xs-12 col-sm-3">
					<div class="section-info bg-purple-light">
						<i class="iconfont icon-global"></i>
						<h1 id="todayAddedDistributionCommission"></h1>
						<p>${message("admin.index.todayAddedDistributionCommission")}</p>
						<a href="${base}/admin/distributor/list">
							${message("admin.index.viewAllDistributor")}
							<i class="iconfont icon-pullright"></i>
						</a>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-xs-12 col-sm-6">
					<div class="review-info panel panel-default">
						<div class="panel-heading">
							<h5>${message("admin.index.orderInfo")}</h5>
						</div>
						<div class="panel-body">
							<div class="row">
								<div class="col-xs-3">
									<a href="${base}/admin/store/list?status=PENDING">
										<div class="media">
											<div class="media-left hidden-xs hidden-sm hidden-md">
												<i class="bg-blue-light iconfont icon-shop"></i>
											</div>
											<div class="media-body media-middle">
												<h2 class="text-blue-light media-heading">
													${storeReviewCount}
													<small>${message("admin.index.countUnit")}</small>
												</h2>
												<p>${message("admin.index.storeReview")}</p>
											</div>
										</div>
									</a>
								</div>
								<div class="col-xs-3">
									<a href="${base}/admin/business_cash/list?status=PENDING">
										<div class="media">
											<div class="media-left hidden-xs hidden-sm hidden-md">
												<i class="bg-orange-light iconfont icon-moneybag"></i>
											</div>
											<div class="media-body media-middle">
												<h2 class="text-orange-light media-heading">
													${businessCashReviewCount}
													<small>${message("admin.index.countUnit")}</small>
												</h2>
												<p>${message("admin.index.businessCashReview")}</p>
											</div>
										</div>
									</a>
								</div>
								<div class="col-xs-3">
									<a href="${base}/admin/category_application/list?status=PENDING">
										<div class="media">
											<div class="media-left hidden-xs hidden-sm hidden-md">
												<i class="bg-yellow-light iconfont icon-cascades"></i>
											</div>
											<div class="media-body media-middle">
												<h2 class="text-yellow-light media-heading">
													${categoryApplicationReviewCount}
													<small>${message("admin.index.countUnit")}</small>
												</h2>
												<p>${message("admin.index.categoryApplicationReview")}</p>
											</div>
										</div>
									</a>
								</div>
								<div class="col-xs-3">
									<a href="${base}/admin/distribution_cash/list?status=PENDING">
										<div class="media">
											<div class="media-left hidden-xs hidden-sm hidden-md">
												<i class="bg-purple-light iconfont icon-sponsor"></i>
											</div>
											<div class="media-body media-middle">
												<h2 class="text-purple-light media-heading">
													${distributionCashReviewCount}
													<small>${message("admin.index.countUnit")}</small>
												</h2>
												<p>${message("admin.index.distributionCashReview")}</p>
											</div>
										</div>
									</a>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="col-xs-12 col-sm-6">
					<div class="sales-chart panel panel-default">
						<div class="panel-heading">
							<h5>${message("admin.index.salesChart")}</h5>
						</div>
						<div class="panel-body">
							<div class="row">
								<div class="col-xs-12 col-sm-6">
									<h3>${message("admin.index.weeksSales")}</h3>
									[#list weekSalesList as product]
										<div class="pull-left">
											[#if product_index == 0]
												<h2 class="text-orange-light">${message("admin.index.one")}</h2>
											[#elseif product_index == 1]
												<h2 class="text-yellow-light">${message("admin.index.two")}</h2>
											[/#if]
											<a href="${base}${product.path}" target="_blank">${product.name}</a>
											<span>${product.weekSales}</span>
										</div>
									[/#list]
								</div>
								<div class="col-xs-12 col-sm-6">
									<h3>${message("admin.index.monthSales")}</h3>
									[#list monthSalesList as product]
										<div class="pull-left">
											[#if product_index == 0]
												<h2 class="text-orange-light">${message("admin.index.one")}</h2>
											[#elseif product_index == 1]
												<h2 class="text-yellow-light">${message("admin.index.two")}</h2>
											[/#if]
											<a href="${base}${product.path}" target="_blank">${product.name}</a>
											<span>${product.monthSales}</span>
										</div>
									[/#list]
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-xs-12 col-sm-6">
					<div class="panel panel-default">
						<div class="panel-heading">
							<h5>${message("admin.index.orderStatistic")}</h5>
						</div>
						<div class="panel-body">
							<div id="orderStatisticChart"></div>
						</div>
					</div>
				</div>
				<div class="col-xs-12 col-sm-6">
					<div class="panel panel-default">
						<div class="panel-heading">
							<h5>${message("admin.index.amountStatistic")}</h5>
						</div>
						<div class="panel-body">
							<div id="amountStatisticChart"></div>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-xs-12 col-sm-6">
					<div class="member-info panel panel-default">
						<div class="panel-heading">
							<h5>${message("admin.index.memberInfo")}</h5>
						</div>
						<div class="panel-body">
							<div class="row">
								<div class="col-xs-3">
									<h2 class="text-blue-light">
										<span id="todayAddedMember"></span>
										<small>${message("admin.index.countUnit")}</small>
									</h2>
									<p>${message("admin.index.todayAdded")}</p>
								</div>
								<div class="col-xs-3">
									<h2 class="text-red-light">
										<span id="yesterdayAddedMemberCount"></span>
										<small>${message("admin.index.countUnit")}</small>
									</h2>
									<p>${message("admin.index.yesterdayAdded")}</p>
								</div>
								<div class="col-xs-3">
									<h2 class="text-green-light">
										<span id="currentMonthAddedMemberCount"></span>
										<small>${message("admin.index.countUnit")}</small>
									</h2>
									<p>${message("admin.index.currentMonthAdded")}</p>
								</div>
								<div class="last col-xs-3">
									<h2 class="text-purple-light">
										${memberTotal}
										<small>${message("admin.index.countUnit")}</small>
									</h2>
									<p>${message("admin.index.memberTotal")}</p>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="col-xs-12 col-sm-6">
					<div class="business-info panel panel-default">
						<div class="panel-heading">
							<h5>${message("admin.index.businessInfo")}</h5>
						</div>
						<div class="panel-body">
							<div class="row">
								<div class="col-xs-3">
									<h2 class="text-blue-light">
										<span id="todayAddedBusiness"></span>
										<small>${message("admin.index.countUnit")}</small>
									</h2>
									<p>${message("admin.index.todayAdded")}</p>
								</div>
								<div class="col-xs-3">
									<h2 class="text-red-light">
										<span id="yesterdayAddedBusinessCount"></span>
										<small>${message("admin.index.countUnit")}</small>
									</h2>
									<p>${message("admin.index.yesterdayAdded")}</p>
								</div>
								<div class="col-xs-3">
									<h2 class="text-green-light">
										<span id="currentMonthAddedBusinessCount"></span>
										<small>${message("admin.index.countUnit")}</small>
									</h2>
									<p>${message("admin.index.currentMonthAdded")}</p>
								</div>
								<div class="last col-xs-3">
									<h2 class="text-purple-light">
										${businessTotal}
										<small>${message("admin.index.countUnit")}</small>
									</h2>
									<p>${message("admin.index.businessTotal")}</p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="table-responsive">
				<table class="table table-bordered">
					<tr>
						<th>${message("admin.index.systemName")}</th>
						<td>
							${systemName}
							<a class="text-gray" href="http://www.shopxx.net" target="_blank">[${message("admin.index.license")}]</a>
						</td>
						<th>${message("admin.index.systemVersion")}</th>
						<td>${systemVersion}</td>
					</tr>
					<tr>
						<th>${message("admin.index.javaVersion")}</th>
						<td>${javaVersion}</td>
						<th>${message("admin.index.javaHome")}</th>
						<td>${javaHome}</td>
					</tr>
					<tr>
						<th>${message("admin.index.osArch")}</th>
						<td>${osArch}</td>
						<th>${message("admin.index.osName")}</th>
						<td>${osName}</td>
					</tr>
					<tr>
						<th>${message("admin.index.serverInfo")}</th>
						<td>
							<span title="${serverInfo}" data-toggle="tooltip">${abbreviate(serverInfo, 30, "...")}</span>
						</td>
						<th>${message("admin.index.servletVersion")}</th>
						<td>${servletVersion}</td>
					</tr>
				</table>
			</div>
		</div>
	</main>
</body>
</html>