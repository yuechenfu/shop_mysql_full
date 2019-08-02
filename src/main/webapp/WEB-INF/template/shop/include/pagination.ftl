<ul class="pagination">
	[#if hasPrevious]
		<li>
			<a href="[@pattern?replace("{pageNumber}", "${previousPageNumber}")?interpret /]" data-page-number="${previousPageNumber}">&laquo;</a>
		</li>
	[#else]
		<li class="disabled">
			<a href="javascript:;">&laquo;</a>
		</li>
	[/#if]
	[#list segment as segmentPageNumber]
		<li[#if segmentPageNumber == pageNumber] class="active"[/#if]>
			<a href="[@pattern?replace("{pageNumber}", "${segmentPageNumber}")?interpret /]" data-page-number="${segmentPageNumber}">${segmentPageNumber}</a>
		</li>
	[/#list]
	[#if hasNext]
		<li>
			<a href="[@pattern?replace("{pageNumber}", "${nextPageNumber}")?interpret /]" data-page-number="${nextPageNumber}">&raquo;</a>
		</li>
	[#else]
		<li class="disabled">
			<a href="javascript:;">&raquo;</a>
		</li>
	[/#if]
</ul>