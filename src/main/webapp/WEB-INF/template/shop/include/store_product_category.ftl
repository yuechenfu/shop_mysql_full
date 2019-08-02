[@store_product_category_root_list storeId = store.id]
	[#if storeProductCategories?has_content]
		<div class="store-product-category">
			[#list storeProductCategories as storeProductCategory]
				<dl class="clearfix">
					<dt>
						<a href="${base}${storeProductCategory.path}" title="${storeProductCategory.name}">${abbreviate(storeProductCategory.name, 15, "...")}</a>
					</dt>
					[@store_product_category_children_list storeProductCategoryId = storeProductCategory.id storeId = store.id recursive = false]
						[#list storeProductCategories as storeProductCategory]
							<dd>
								<a class="text-overflow" href="${base}${storeProductCategory.path}" title="${storeProductCategory.name}">${storeProductCategory.name}</a>
							</dd>
						[/#list]
					[/@store_product_category_children_list]
				</dl>
			[/#list]
		</div>
	[/#if]
[/@store_product_category_root_list]