<div class="store-summary">
	<div class="store-summary-heading">
		<a href="${base}${store.path}" target="_blank">
			<img class="img-responsive center-block" src="${store.logo!setting.defaultStoreLogo}" alt="${store.name}">
		</a>
		<h5>
			<a href="${base}${store.path}" target="_blank">${abbreviate(store.name, 50, "...")}</a>
			[#if store.type == "SELF"]
				<span class="label label-primary">${message("Store.Type.SELF")}</span>
			[/#if]
		</h5>
	</div>
	<div class="store-summary-body">
		[#if store.address?has_content || store.phone?has_content]
			<dl class="dl-horizontal clearfix">
				[#if store.address?has_content]
					<dt>${message("Store.address")}:</dt>
					<dd>${store.address}</dd>
				[/#if]
				[#if store.phone?has_content]
					<dt>${message("Store.phone")}:</dt>
					<dd>${store.phone}</dd>
				[/#if]
			</dl>
		[/#if]
		[@instant_message_list storeId = store.id]
			[#if instantMessages?has_content]
				<p>
					[#list instantMessages as instantMessage]
						[#if instantMessage.type == "QQ"]
							<a href="http://wpa.qq.com/msgrd?v=3&uin=${instantMessage.account}&menu=yes" title="${instantMessage.name}" target="_blank">
								<img src="${base}/resources/shop/images/instant_message_qq.png" alt="${instantMessage.name}">
							</a>
						[#elseif instantMessage.type == "ALI_TALK"]
							<a href="http://amos.alicdn.com/getcid.aw?v=2&uid=${instantMessage.account}&site=cntaobao&s=2&groupid=0&charset=utf-8" title="${instantMessage.name}" target="_blank">
								<img src="${base}/resources/shop/images/instant_message_wangwang.png" alt="${instantMessage.name}">
							</a>
						[/#if]
					[/#list]
				</p>
			[/#if]
		[/@instant_message_list]
	</div>
	<div class="store-summary-footer">
		<a class="btn btn-default" href="${base}${store.path}" target="_blank">${message("shop.store.viewStore")}</a>
		<a class="btn btn-default" href="javascript:;" data-action="addStoreFavorite" data-store-id="${store.id}">${message("shop.store.addStoreFavorite")}</a>
	</div>
</div>