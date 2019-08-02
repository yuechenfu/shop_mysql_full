<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.index.title")}[#if showPowered] - Powered By SHOP++[/#if]</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/base.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/index.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/bootstrap-growl.js"></script>
	<script src="${base}/resources/common/js/jquery.scrolltofixed.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/mobile/member/js/base.js"></script>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
				
				var $document = $(document);
				var $logout = $("#logout");
				
				// 用户注销
				$logout.click(function() {
					$document.trigger("loggedOut.shopxx.user", $.getCurrentUser());
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
					<a href="javascript:;" data-action="back">
						<i class="iconfont icon-back"></i>
					</a>
				</div>
				<div class="col-xs-10">
					<h5>${message("member.index.title")}</h5>
				</div>
			</div>
		</div>
	</header>
	<main>
		<div class="container-fluid">
			<div class="panel panel-default">
				<div class="panel-heading">
					${message("member.index.welcome", currentUser.username)}
					<span class="pull-right">
						${message("member.index.memberRank")}:
						<span class="text-red">${currentUser.memberRank.name}</span>
					</span>
				</div>
				<div class="panel-body small">
					<div class="row">
						<div class="col-xs-3 text-center">
							<a class="icon" href="${base}/member/product_favorite/list">
								<i class="iconfont icon-like text-blue-light"></i>
								<span class="badge">${productFavoriteCount}</span>
								${message("member.index.productFavorite")}
							</a>
						</div>
						<div class="col-xs-3 text-center">
							<a class="icon" href="${base}/member/product_notify/list">
								<i class="iconfont icon-notice text-purple-light"></i>
								<span class="badge" title="${productNotifyCount}">[#if productNotifyCount > 99]99+[#else]${productNotifyCount}[/#if]</span>
								${message("member.index.productNotifyList")}
							</a>
						</div>
						<div class="col-xs-3 text-center">
							<a class="icon" href="${base}/member/review/list">
								<i class="iconfont icon-comment text-pink-light"></i>
								<span class="badge" title="${reviewCount}">[#if reviewCount > 99]99+[#else]${reviewCount}[/#if]</span>
								${message("member.index.reviewList")}
							</a>
						</div>
						<div class="col-xs-3 text-center">
							<a class="icon" href="${base}/member/consultation/list">
								<i class="iconfont icon-question text-green-light"></i>
								<span class="badge" title="${consultationCount}">[#if consultationCount > 99]99+[#else]${consultationCount}[/#if]</span>
								${message("member.index.consultationList")}
							</a>
						</div>
					</div>
				</div>
			</div>
			<div class="panel panel-default">
				<div class="panel-heading">
					${message("member.index.order")}
					<a class="pull-right text-gray" href="${base}/member/order/list">
						${message("member.index.more")}
						<i class="iconfont icon-right"></i>
					</a>
				</div>
				<div class="panel-body small">
					<div class="row">
						<div class="col-xs-4 text-center">
							<a class="icon" href="${base}/member/order/list?status=PENDING_PAYMENT&hasExpired=false">
								<i class="iconfont icon-pay text-orange-light"></i>
								<span class="badge" title="${pendingPaymentOrderCount}">[#if pendingPaymentOrderCount > 99]99+[#else]${pendingPaymentOrderCount}[/#if]</span>
								${message("member.index.pendingPaymentOrderList")}
							</a>
						</div>
						<div class="col-xs-4 text-center">
							<a class="icon" href="${base}/member/order/list?status=PENDING_SHIPMENT&hasExpired=false">
								<i class="iconfont icon-calendar text-orange-light"></i>
								<span class="badge" title="${pendingShipmentOrderCount}">[#if pendingShipmentOrderCount > 99]99+[#else]${pendingShipmentOrderCount}[/#if]</span>
								${message("member.index.pendingShipmentOrderList")}
							</a>
						</div>
						<div class="col-xs-4 text-center">
							<a class="icon" href="${base}/member/order/list?status=SHIPPED">
								<i class="iconfont icon-deliver text-orange-light"></i>
								<span class="badge" title="${shippedOrderCount}">[#if shippedOrderCount > 99]99+[#else]${shippedOrderCount}[/#if]</span>
								${message("member.index.shippedOrderList")}
							</a>
						</div>
					</div>
				</div>
			</div>
			<div class="panel panel-default">
				<div class="panel-heading">${message("member.index.message")}</div>
				<div class="panel-body small">
					<div class="row">
						<div class="col-xs-6 text-center">
							<a class="icon" href="${base}/member/message_group/list">
								<i class="iconfont icon-message text-blue"></i>
								${message("member.index.messageList")}
							</a>
						</div>
						<div class="col-xs-6 text-center">
							<a class="icon" href="${base}/member/message/send">
								<i class="iconfont icon-forward text-green-light"></i>
								${message("member.index.messageSend")}
							</a>
						</div>
					</div>
				</div>
			</div>
			<div class="panel panel-default">
				<div class="panel-heading">${message("member.index.other")}</div>
				<div class="panel-body small">
					<div class="list-group">
						<div class="list-group-item">
							<div class="row">
								<div class="col-xs-3 text-center">
									<a class="icon" href="${base}/member/store_favorite/list">
										<i class="iconfont icon-favor text-yellow"></i>
										${message("member.index.storeFavoriteList")}
									</a>
								</div>
								<div class="col-xs-3 text-center">
									<a class="icon" href="${base}/member/coupon_code/list">
										<i class="iconfont icon-ticket text-orange"></i>
										${message("member.index.couponCodeList")}
									</a>
								</div>
								<div class="col-xs-3 text-center">
									<a class="icon" href="${base}/member/coupon_code/exchange">
										<i class="iconfont icon-order text-green-light"></i>
										${message("member.index.couponCodeExchange")}
									</a>
								</div>
								<div class="col-xs-3 text-center">
									<a class="icon" href="${base}/member/point_log/list">
										<i class="iconfont icon-present text-purple-dark"></i>
										${message("member.index.pointLogList")}
									</a>
								</div>
							</div>
						</div>
						<div class="list-group-item">
							<div class="row">
								<div class="col-xs-3 text-center">
									<a class="icon" href="${base}/member/member_deposit/log">
										<i class="iconfont icon-recharge text-blue"></i>
										${message("member.index.depositLog")}
									</a>
								</div>
								<div class="col-xs-3 text-center">
									<a class="icon" href="${base}/member/member_deposit/recharge">
										<i class="iconfont icon-refund text-pink"></i>
										${message("member.index.depositRecharge")}
									</a>
								</div>
								<div class="col-xs-3 text-center">
									<a class="icon" href="${base}/member/social_user/list">
										<i class="iconfont icon-friendadd text-blue-light"></i>
										${message("member.index.socialUserList")}
									</a>
								</div>
								<div class="col-xs-3 text-center">
									<a class="icon" href="${base}/member/aftersales/list">
										<i class="iconfont icon-text text-yellow-light"></i>
										${message("member.index.aftersales")}
									</a>
								</div>
							</div>
						</div>
						[#if currentUser.isDistributor]
							<div class="list-group-item">
								<div class="row">
									<div class="col-xs-3 text-center">
										<a class="icon" href="${base}/member/distribution_cash/list">
											<i class="iconfont icon-moneybag text-green-light"></i>
											${message("member.index.distributionCashList")}
										</a>
									</div>
									<div class="col-xs-3 text-center">
										<a class="icon" href="${base}/member/distribution_commission/list">
											<i class="iconfont icon-redpacket text-red-light"></i>
											${message("member.index.distributionCommissionList")}
										</a>
									</div>
								</div>
							</div>
						[/#if]
					</div>
				</div>
			</div>
			<div class="list-group">
				<div class="list-group-item">
					${message("member.index.receiverList")}
					<a class="pull-right text-gray" href="${base}/member/receiver/list">
						${message("member.index.receiverList")}
						<i class="iconfont icon-right"></i>
					</a>
				</div>
			</div>
			<div class="list-group">
				<div class="list-group-item">
					${message("member.index.profileEdit")}
					<a class="pull-right text-gray" href="${base}/member/profile/edit">
						${message("member.index.profileEdit")}
						<i class="iconfont icon-right"></i>
					</a>
				</div>
			</div>
			<div class="list-group">
				<div class="list-group-item">
					${message("member.index.passwordEdit")}
					<a class="pull-right text-gray" href="${base}/member/password/edit">
						${message("member.index.passwordEdit")}
						<i class="iconfont icon-right"></i>
					</a>
				</div>
			</div>
			<div class="list-group">
				<div class="list-group-item">
					<a id="logout" class="btn btn-primary btn-lg btn-flat btn-block" href="${base}/member/logout">${message("member.index.logout")}</a>
				</div>
			</div>
		</div>
	</main>
	<footer class="footer-default" data-spy="scrollToFixed" data-bottom="0">
		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-3">
					<a href="${base}/">
						<i class="iconfont icon-home center-block"></i>
						<span class="center-block">${message("member.index.home")}</span>
					</a>
				</div>
				<div class="col-xs-3">
					<a href="${base}/product_category">
						<i class="iconfont icon-sort center-block"></i>
						<span class="center-block">${message("member.index.productCategory")}</span>
					</a>
				</div>
				<div class="col-xs-3">
					<a href="${base}/cart/list">
						<i class="iconfont icon-cart center-block"></i>
						<span class="center-block">${message("member.index.cart")}</span>
					</a>
				</div>
				<div class="col-xs-3">
					<a class="active" href="${base}/member/index">
						<i class="iconfont icon-people center-block"></i>
						<span class="center-block">${message("member.index.member")}</span>
					</a>
				</div>
			</div>
		</div>
	</footer>
</body>
</html>