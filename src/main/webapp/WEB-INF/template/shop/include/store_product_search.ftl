[#noautoesc]
	[#escape x as x?js_string]
		<script>
		$().ready(function() {
		
			var $storeProductSearchForm = $("#storeProductSearchForm");
			var $keyword = $("#storeProductSearchForm [name='keyword']");
			
			// 搜索
			$storeProductSearchForm.submit(function() {
				if ($.trim($keyword.val()) == "") {
					return false;
				}
			});
		
		});
		</script>
	[/#escape]
[/#noautoesc]
<div class="store-product-search">
	<form id="storeProductSearchForm" action="${base}/product/search" method="get">
		<input name="storeId" type="hidden" value="${store.id}">
		<div class="input-group">
			<input name="keyword" class="form-control" type="text" value="${productKeyword}" placeholder="${message("shop.store.search")}" x-webkit-speech="x-webkit-speech" x-webkit-grammar="builtin:search">
			<div class="input-group-btn">
				<button class="btn btn-default" type="submit">
					<i class="iconfont icon-search"></i>
				</button>
			</div>
		</div>
	</form>
</div>