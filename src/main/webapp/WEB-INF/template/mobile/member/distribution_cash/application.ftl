<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.distributionCash.application")}[#if showPowered] - Powered By SHOP++[/#if]</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/base.css" rel="stylesheet">
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
	<script src="${base}/resources/mobile/member/js/base.js"></script>
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
	<header class="header-default" data-spy="scrollToFixed">
		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-1">
					<a href="${base}/member/distribution_cash/list">
						<i class="iconfont icon-back"></i>
					</a>
				</div>
				<div class="col-xs-10">
					<h5>${message("member.distributionCash.application")}</h5>
				</div>
			</div>
		</div>
	</header>
	<main>
		<div class="container-fluid">
			<form id="distributionCashForm" action="${base}/member/distribution_cash/save" method="post">
				<div class="panel panel-default">
					<div class="panel-body">
						<div class="form-group">
							${message("Member.availableBalance")}:
							<span class="text-red">${currency(currentUser.availableBalance, true, true)}</span>
						</div>
						[#if currentUser.frozenAmount > 0]
							<div class="form-group">
								${message("Member.frozenAmount")}:
								<span class="text-gray">${currency(currentUser.frozenAmount, true, true)}</span>
							</div>
						[/#if]
						<div class="form-group">
							<label class="item-required" for="amount">${message("DistributionCash.amount")}:</label>
							<input id="amount" name="amount" class="form-control" type="text" maxlength="16">
						</div>
						<div class="form-group">
							<label class="item-required" for="bank">${message("DistributionCash.bank")}:</label>
							<input id="bank" name="bank" class="form-control" type="text" maxlength="200">
						</div>
						<div class="form-group">
							<label class="item-required" for="account">${message("DistributionCash.account")}:</label>
							<input id="account" name="account" class="form-control" type="text" maxlength="200">
						</div>
						<div class="form-group">
							<label class="item-required" for="accountHolder">${message("DistributionCash.accountHolder")}:</label>
							<input id="accountHolder" name="accountHolder" class="form-control" type="text" maxlength="200">
						</div>
					</div>
					<div class="panel-footer text-center">
						<button class="btn btn-primary" type="submit">${message("common.submit")}</button>
						<button class="btn btn-default" type="button" data-action="back">${message("common.back")}</button>
					</div>
				</div>
			</form>
		</div>
	</main>
</body>
</html>