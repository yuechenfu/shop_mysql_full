[@article_category_root_list count = 10]
	[#if articleCategories?has_content]
		<div class="hot-article-category">
			<div class="hot-article-category-heading">
				<h4>${message("shop.article.hotArticleCategory")}</h4>
			</div>
			<div class="hot-article-category-body">
				<ul>
					[#list articleCategories as articleCategory]
						<li>
							<a href="${base}${articleCategory.path}">${articleCategory.name}</a>
						</li>
					[/#list]
				</ul>
			</div>
		</div>
	[/#if]
[/@article_category_root_list]