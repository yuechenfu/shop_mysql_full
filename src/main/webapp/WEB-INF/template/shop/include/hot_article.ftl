[@article_list articleCategoryId = articleCategory.id count = 10 orderBy = "hits DESC"]
	[#if articles?has_content]
		<div class="hot-article">
			<div class="hot-article-heading">
				<h4>${message("shop.article.hotArticle")}</h4>
			</div>
			<div class="hot-article-body">
				<ul>
					[#list articles as article]
						<li class="text-overflow">
							<a href="${base}${article.path}" title="${article.title}">${article.title}</a>
						</li>
					[/#list]
				</ul>
			</div>
		</div>
	[/#if]
[/@article_list]