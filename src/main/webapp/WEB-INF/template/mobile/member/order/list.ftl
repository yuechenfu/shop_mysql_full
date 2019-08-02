<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.order.list")}[#if showPowered] - Powered By SHOP++[/#if]</title>
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
	<script src="${base}/resources/common/js/moment.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/scrollload.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/mobile/member/js/base.js"></script>
	<script id="scrollLoadTemplate" type="text/template">
		<%
			function statusText(status) {
				switch (status) {
					case "PENDING_PAYMENT":
						return "${message("Order.Status.PENDING_PAYMENT")}";
					case "PENDING_REVIEW":
						return "${message("Order.Status.PENDING_REVIEW")}";
					case "PENDING_SHIPMENT":
						return "${message("Order.Status.PENDING_SHIPMENT")}";
					case "SHIPPED":
						return "${message("Order.Status.SHIPPED")}";
					case "RECEIVED":
						return "${message("Order.Status.RECEIVED")}";
					case "COMPLETED":
						return "${message("Order.Status.COMPLETED")}";
					case "FAILED":
						return "${message("Order.Status.FAILED")}";
					case "CANCELED":
						return "${message("Order.Status.CANCELED")}";
					case "DENIED":
						return "${message("Order.Status.DENIED")}";
				}
			}
			
			function productType(type) {
				switch (type) {
					case "EXCHANGE":
						return "${message("Product.Type.EXCHANGE")}";
					case "GIFT":
						return "${message("Product.Type.GIFT")}";
				}
			}
		%>
		<%_.each(data, function(order, i) {%>
			<div class="panel panel-default">
				<div class="panel-heading">
					<span><%-order.store.name%></span>
					<%if (order.store.type == "SELF") {%>
						<span class="label label-primary">${message("member.order.self")}</span>
					<%}%>
					<span title="<%-moment(new Date(order.createdDate)).format("YYYY-MM-DD HH:mm:ss")%>"><%-moment(new Date(order.createdDate)).format("YYYY-MM-DD")%></span>
					<%if (order.hasExpired) {%>
						<span class="pull-right text-gray-dark">${message("member.order.hasExpired")}</span>
					<%} else {%>
						<span class="pull-right">
							<% if ( order.status == "PENDING_SHIPMENT" || order.status == "PENDING_REVIEW" || order.status == "PENDING_PAYMENT") {%>
								<span class="text-orange"><%-statusText(order.status)%></span>
							<%} else if (order.status == "FAILED" || order.status == "DENIED") {%>
								<span class="text-red"><%-statusText(order.status)%></span>
							<%} else if (order.status == "CANCELED") {%>
								<span class="text-gray-dark"><%-statusText(order.status)%></span>
							<%} else {%>
								<span class="text-green"><%-statusText(order.status)%></span>
							<%}%>
						</span>
					<%}%>
				</div>
				<div class="panel-body">
					<div class="list-group">
						<%_.each(order.orderItems, function(orderItem, i) {%>
							<div class="list-group-item">
								<div class="media">
									<div class="media-left media-middle">
										<a href="view?orderSn=<%-order.sn%>">
											<img class="media-object img-thumbnail" src="<%-orderItem.thumbnail != null ? orderItem.thumbnail : "${setting.defaultThumbnailProductImage}"%>" alt="<%-orderItem.name%>">
										</a>
									</div>
									<div class="media-body media-middle">
										<h5 class="media-heading">
											<a href="view?orderSn=<%-order.sn%>" title="<%-orderItem.name%>"><%-orderItem.name%></a>
										</h5>
										<%if (orderItem.specifications.length > 0) {%>
											<span class="small text-gray">[<%-orderItem.specifications.join(", ")%>]</span>
										<%}%>
										<%if (orderItem.type != "GENERAL") {%>
											<strong class="small text-red">[<%-productType(orderItem.type)%>]</strong>
										<%}%>
									</div>
								</div>
							</div>
						<%});%>
					</div>
				</div>
				<div class="panel-footer text-right">
					[#if isKuaidi100Enabled]
						<%var orderShipping = !_.isEmpty(order.orderShippings) ? order.orderShippings[0] : null;%>
						<%if (orderShipping != null && orderShipping.deliveryCorp != null && orderShipping.trackingNo != null) {%>
							<button class="transit-step btn btn-default btn-sm" type="button" data-order-shipping-sn="<%-orderShipping.sn%>">${message("member.order.transitStep")}</button>
						<%}%>
					[/#if]
					<a class="btn btn-default btn-sm" href="view?orderSn=<%-order.sn%>">${message("member.order.view")}</a>
					[#if setting.isReviewEnabled]
						<%if (!order.isReviewed && (order.status == "RECEIVED" || order.status == "COMPLETED")) {%>
							<a class="btn btn-default btn-sm" href="${base}/member/review/add?orderId=<%-order.id%>">${message("member.order.review")}</a>
						<%}%>
					[/#if]
					<%if (order.isReviewed && (order.status == "RECEIVED" || order.status == "COMPLETED")) {%>
						<a class="btn btn-default btn-sm" href="${base}/member/review/list">${message("member.order.viewReview")}</a>
					<%}%>
					<%if (order.type == "GENERAL" && (order.status == "RECEIVED" || order.status == "COMPLETED")) {%>
						<a class="btn btn-default btn-sm" href="${base}/member/aftersales/apply?orderId=<%-order.id%>">${message("member.order.aftersalesApply")}</a>
					<%}%>
				</div>
			</div>
		<%});%>
	</script>
	<script id="transitStepTemplate" type="text/template">
		<%if (_.isEmpty(data.transitSteps)) {%>
			<p class="text-gray">${message("common.noResult")}</p>
		<%} else {%>
			<div class="list-group">
				<%_.each(data.transitSteps, function(transitStep, i) {%>
					<div class="list-group-item">
						<p class="small text-gray"><%-transitStep.time%></p>
						<p class="small"><%-transitStep.context%></p>
					</div>
				<%});%>
			</div>
		<%}%>
	</script>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
				
				var $transitStepModal = $("#transitStepModal");
				var $transitStepModalBody = $("#transitStepModal div.modal-body");
				var $scrollLoad = $("#scrollLoad");
				var transitStepTemplate = _.template($("#transitStepTemplate").html());
				
				// 物流动态
				$scrollLoad.on("click", "button.transit-step", function() {
					var $element = $(this);
					$.ajax({
						url: "${base}/member/order/transit_step",
						type: "GET",
						data: {
							orderShippingSn: $element.data("order-shipping-sn")
						},
						dataType: "json",
						beforeSend: function() {
							$transitStepModalBody.empty();
							$transitStepModal.modal();
						},
						success: function(data) {
							$transitStepModalBody.html(transitStepTemplate({
								data: data
							}));
						}
					});
					return false;
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
					<a href="${base}/member/index">
						<i class="iconfont icon-back"></i>
					</a>
				</div>
				<div class="col-xs-10">
					<h5>${message("member.order.list")}</h5>
				</div>
			</div>
		</div>
	</header>
	<main>
		<div class="container-fluid">
			<div id="transitStepModal" class="transit-step-modal modal fade" tabindex="-1">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<button class="close" type="button" data-dismiss="modal">&times;</button>
							<h5 class="modal-title">${message("member.order.transitStep")}</h5>
						</div>
						<div class="modal-body"></div>
						<div class="modal-footer">
							<button class="btn btn-default btn-sm" type="button" data-dismiss="modal">${message("member.order.close")}</button>
						</div>
					</div>
				</div>
			</div>
			<div id="scrollLoad" data-spy="scrollLoad" data-url="${base}/member/order/list?pageNumber=<%-pageNumber%>&status=${status}&hasExpired=${(hasExpired?string("true", "false"))!}">
				<div id="scrollLoadContent"></div>
			</div>
		</div>
	</main>
</body>
</html>