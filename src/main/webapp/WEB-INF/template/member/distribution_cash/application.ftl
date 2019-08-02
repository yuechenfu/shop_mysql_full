<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.distributionCash.application")} - Powered By SHOP++</title>
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
	<script src="${base}/resources/common/js/jquery.validate.js"></script>
	<script src="${base}/resources/common/js/jquery.validate.additional.js"></script>
	<script src="${base}/resources/common/js/jquery.form.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/member/js/base.js"></script>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
				
				var $distributionCashForm = $("#distributionCashForm");
				
				// 表单验证
				$distributionCashForm.validate({
					rules: {
						amount: {
							required: true,
							positive: true,
							number: true,
							min: parseFloat(${setting.memberMinimumCashAmount}),
							decimal: {
								integer: 12,
								fraction: ${setting.priceScale}
							},
							remote: {
								url: "${base}/member/distribution_cash/check_balance",
								cache: false
							}
						},
						bank: "required",
						account: "required",
						accountHolder: "required"
					},
					messages: {
						amount: {
							remote: "${message("member.distributionCash.notCurrentAccountBalance")}"
						}
					},
					submitHandler: function(form) {
						$(form).ajaxSubmit({
							successRedirectUrl: "${base}/member/distribution_cash/list"
						});
					}
				});
			
			});
			</script>
		[/#escape]
	[/#noautoesc]
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
					<form id="distributionCashForm" class="form-horizontal" action="${base}/member/distribution_cash/save" method="post">
						<div class="panel panel-default">
							<div class="panel-heading">${message("member.distributionCash.application")}</div>
							<div class="panel-body">
								<div class="form-group">
									<label class="col-xs-3 col-sm-2 control-label">${message("Member.availableBalance")}:</label>
									<div class="col-xs-9 col-sm-4">
										<p class="form-control-static text-red">${currency(currentUser.availableBalance, true, true)}</p>
									</div>
								</div>
								[#if currentUser.frozenAmount > 0]
									<div class="form-group">
										<label class="col-xs-3 col-sm-2 control-label">${message("Member.frozenAmount")}:</label>
										<div class="col-xs-9 col-sm-4">
											<p class="form-control-static text-gray">${currency(currentUser.frozenAmount, true, true)}</p>
										</div>
									</div>
								[/#if]
								<div class="form-group">
									<label class="col-xs-3 col-sm-2 control-label item-required">${message("DistributionCash.amount")}:</label>
									<div class="col-xs-9 col-sm-4">
										<input name="amount" class="form-control" type="text" maxlength="16">
									</div>
								</div>
								<div class="form-group">
									<label class="col-xs-3 col-sm-2 control-label item-required">${message("DistributionCash.bank")}:</label>
									<div class="col-xs-9 col-sm-4">
										<input name="bank" class="form-control" type="text" maxlength="200">
									</div>
								</div>
								<div class="form-group">
									<label class="col-xs-3 col-sm-2 control-label item-required">${message("DistributionCash.account")}:</label>
									<div class="col-xs-9 col-sm-4">
										<input name="account" class="form-control" type="text" maxlength="200">
									</div>
								</div>
								<div class="form-group">
									<label class="col-xs-3 col-sm-2 control-label item-required">${message("DistributionCash.accountHolder")}:</label>
									<div class="col-xs-9 col-sm-4">
										<input name="accountHolder" class="form-control" type="text" maxlength="200">
									</div>
								</div>
							</div>
							<div class="panel-footer">
								<div class="row">
									<div class="col-xs-9 col-sm-10 col-xs-offset-3 col-sm-offset-2">
										<button class="btn btn-primary" type="submit">${message("common.submit")}</button>
										<button class="btn btn-default" type="button" data-action="back">${message("common.back")}</button>
									</div>
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