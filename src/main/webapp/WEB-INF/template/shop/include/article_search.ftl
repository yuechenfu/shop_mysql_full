[#noautoesc]
	[#escape x as x?js_string]
		<script>
		$().ready(function() {
		
			var $articleSearchForm = $("#articleSearchForm");
			var $keyword = $("#articleSearchForm [name='keyword']");
			
			// 搜索
			$articleSearchForm.submit(function() {
				if ($.trim($keyword.val()) == "") {
					return false;
				}
			});
		
		});
		</script>
	[/#escape]
[/#noautoesc]
<div class="article-search">
	<form id="articleSearchForm" action="${base}/article/search" method="get">
		<div class="article-search">
			<div class="article-search-heading">
				<h4>${message("shop.article.search")}</h4>
			</div>
			<div class="article-search-body clearfix">
				<input name="keyword" type="text" value="${articleKeyword}" placeholder="${message("shop.article.aritcleSearchSubmit")}" x-webkit-speech="x-webkit-speech" x-webkit-grammar="builtin:search">
				<button type="submit">
					<i class="iconfont icon-search"></i>
				</button>
			</div>
		</div>
	</form>
</div>