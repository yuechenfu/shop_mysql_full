<div class="main-menu">
	<div class="main-menu-heading">
		<i class="iconfont icon-people"></i>
		<a href="${base}/member/index">${message("member.mainMenu.title")}</a>
	</div>
	<div class="main-menu-body">
		<dl>
			<dt>
				<i class="iconfont icon-form"></i>
				${message("member.mainMenu.order")}
			</dt>
			<dd[#if .main_template_name?matches(".*/order/.*")] class="active"[/#if]>
				<a href="${base}/member/order/list">${message("member.mainMenu.orderList")}</a>
			</dd>
			<dd[#if .main_template_name?matches(".*/coupon_code/list.*")] class="active"[/#if]>
				<a href="${base}/member/coupon_code/list">${message("member.mainMenu.couponCodeList")}</a>
			</dd>
			<dd[#if .main_template_name?matches(".*/coupon_code/exchange.*")] class="active"[/#if]>
				<a href="${base}/member/coupon_code/exchange">${message("member.mainMenu.couponCodeExchange")}</a>
			</dd>
			<dd[#if .main_template_name?matches(".*/point_log/.*")] class="active"[/#if]>
				<a href="${base}/member/point_log/list">${message("member.mainMenu.pointLogList")}</a>
			</dd>
		</dl>
		<dl>
			<dt>
				<i class="iconfont icon-favor"></i>
				${message("member.mainMenu.favorite")}
			</dt>
			<dd[#if .main_template_name?matches(".*/product_favorite/.*")] class="active"[/#if]>
				<a href="${base}/member/product_favorite/list">${message("member.mainMenu.productFavoriteList")}</a>
			</dd>
			<dd[#if .main_template_name?matches(".*/store_favorite/.*")] class="active"[/#if]>
				<a href="${base}/member/store_favorite/list">${message("member.mainMenu.storeFavoriteList")}</a>
			</dd>
			<dd[#if .main_template_name?matches(".*/product_notify/.*")] class="active"[/#if]>
				<a href="${base}/member/product_notify/list">${message("member.mainMenu.productNotifyList")}</a>
			</dd>
			<dd[#if .main_template_name?matches(".*/review/.*")] class="active"[/#if]>
				<a href="${base}/member/review/list">${message("member.mainMenu.reviewList")}</a>
			</dd>
			<dd[#if .main_template_name?matches(".*/consultation/.*")] class="active"[/#if]>
				<a href="${base}/member/consultation/list">${message("member.mainMenu.consultationList")}</a>
			</dd>
		</dl>
		<dl>
			<dt>
				<i class="iconfont icon-message"></i>
				${message("member.mainMenu.message")}
			</dt>
			<dd[#if .main_template_name?matches(".*/message/.*")] class="active"[/#if]>
				<a href="${base}/member/message/send">${message("member.mainMenu.messageSend")}</a>
			</dd>
			<dd[#if .main_template_name?matches(".*/message_group/.*")] class="active"[/#if]>
				<a href="${base}/member/message_group/list">${message("member.mainMenu.messageGroupList")}</a>
			</dd>
		</dl>
		<dl>
			<dt>
				<i class="iconfont icon-profile"></i>
				${message("member.mainMenu.profile")}
			</dt>
			<dd[#if .main_template_name?matches(".*/profile/.*")] class="active"[/#if]>
				<a href="${base}/member/profile/edit">${message("member.mainMenu.profileEdit")}</a>
			</dd>
			<dd[#if .main_template_name?matches(".*/password/.*")] class="active"[/#if]>
				<a href="${base}/member/password/edit">${message("member.mainMenu.passwordEdit")}</a>
			</dd>
			<dd[#if .main_template_name?matches(".*/receiver/.*")] class="active"[/#if]>
				<a href="${base}/member/receiver/list">${message("member.mainMenu.receiverList")}</a>
			</dd>
			<dd[#if .main_template_name?matches(".*/social_user/.*")] class="active"[/#if]>
				<a href="${base}/member/social_user/list">${message("member.mainMenu.socialUserList")}</a>
			</dd>
		</dl>
		<dl>
			<dt>
				<i class="iconfont icon-recharge"></i>
				${message("member.mainMenu.memberDeposit")}
			</dt>
			<dd[#if .main_template_name?matches(".*/member_deposit/recharge.*")] class="active"[/#if]>
				<a href="${base}/member/member_deposit/recharge">${message("member.mainMenu.memberDepositRecharge")}</a>
			</dd>
			<dd[#if .main_template_name?matches(".*/member_deposit/log.*")] class="active"[/#if]>
				<a href="${base}/member/member_deposit/log">${message("member.mainMenu.memberDepositLog")}</a>
			</dd>
		</dl>
		<dl>
			<dt>
				<i class="iconfont icon-text"></i>
				${message("member.mainMenu.aftersales")}
			</dt>
			<dd[#if .main_template_name?matches(".*/aftersales/.*")] class="active"[/#if]>
				<a href="${base}/member/aftersales/list">${message("member.mainMenu.aftersalesList")}</a>
			</dd>
		</dl>
		[#if currentUser.isDistributor]
			<dl>
				<dt>
					<i class="iconfont icon-friend"></i>
					${message("member.mainMenu.distribution")}
				</dt>
				<dd[#if .main_template_name?matches(".*/distribution_cash/.*")] class="active"[/#if]>
					<a href="${base}/member/distribution_cash/list">${message("member.mainMenu.distributionCashList")}</a>
				</dd>
				<dd[#if .main_template_name?matches(".*/distribution_commission/.*")] class="active"[/#if]>
					<a href="${base}/member/distribution_commission/list">${message("member.mainMenu.distributionCommissionList")}</a>
				</dd>
			</dl>
		[/#if]
	</div>
</div>