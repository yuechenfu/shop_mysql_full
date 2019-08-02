<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.distributionCash.list")} - Powered By SHOP++</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/shop/css/base.css" rel="stylesheet">
	<link href="${base}/resources/member/css/base.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/bootstrap-growl.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/member/js/base.js"></script>
</head>
<body class="member">
	[#include "/shop/include/main_header.ftl" /]
	<main>
		<div class="container">
			<div class="row">
				<div class="col-xs-2">
					[#include "/member/include/main_menu.ftl" /]
				</div>
				<div class="col-xs-10">
					<form action="${base}/member/distribution_cash/list" method="get">
						<input name="pageNumber" type="hidden" value="${page.pageNumber}">
						<div class="panel panel-default">
							<div class="panel-heading">${message("member.distributionCash.list")}</div>
							<div class="panel-body">
								<div class="form-group">
									<a class="btn btn-default" href="${base}/member/distribution_cash/application">
										<i class="iconfont icon-add"></i>
										${message("member.distributionCash.application")}
									</a>
								</div>
								[#if page.content?has_content]
									<table class="table">
										<thead>
											<tr>
												<th>${message("DistributionCash.amount")}</th>
												<th>${message("DistributionCash.bank")}</th>
												<th>${message("DistributionCash.account")}</th>
												<th>${message("DistributionCash.accountHolder")}</th>
												<th>${message("DistributionCash.status")}</th>
												<th>${message("common.createdDate")}</th>
											</tr>
										</thead>
										<tbody>
											[#list page.content as distributionCash]
												<tr>
													<td>${currency(distributionCash.amount, true)}</td>
													<td>${distributionCash.bank}</td>
													<td>${distributionCash.account}</td>
													<td>${distributionCash.accountHolder}</td>
													<td>
														<span class="[#if distributionCash.status == "PENDING"]text-orange[#elseif distributionCash.status == "FAILED"]text-red[#else]text-green[/#if]">${message("DistributionCash.Status." + distributionCash.status)}</span>
													</td>
													<td>
														<span title="${distributionCash.createdDate?string("yyyy-MM-dd HH:mm:ss")}">${distributionCash.createdDate}</span>
													</td>
												</tr>
											[/#list]
										</tbody>
									</table>
								[/#if]
							</div>
							[@pagination pageNumber = page.pageNumber totalPages = page.totalPages]
								[#if totalPages > 1]
									<div class="panel-footer text-right clearfix">
										[#include "/member/include/pagination.ftl" /]
									</div>
								[/#if]
							[/@pagination]
						</div>
					</form>
				</div>
			</div>
		</div>
	</main>
	[#include "/shop/include/main_footer.ftl" /]
</body>
</html>