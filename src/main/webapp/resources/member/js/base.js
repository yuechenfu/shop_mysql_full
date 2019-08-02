/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * 
 * JavaScript - Base
 * Version: 6.1
 */

$().ready(function() {

	var $pageNumber = $("input[name='pageNumber']");
	var $button = $(".btn");
	var $deleteAction = $("[data-action='delete']");
	var $pageNumberItem = $("[data-page-number]");
	
	// 按钮
	$button.click(function() {
		var $element = $(this);
		
		if ($.support.transition) {
			$element.addClass("btn-clicked").one("bsTransitionEnd", function() {
				$(this).removeClass("btn-clicked");
			}).emulateTransitionEnd(300);
		}
	});
	
	// 删除
	$deleteAction.on("success.shopxx.delete", function(event) {
		var $element = $(event.target);
		
		if ($.fn.velocity == null) {
			throw new Error("Delete requires velocity.js");
		}
		
		$element.closest("li, tr, .media, [class^='col-']").velocity("slideUp", {
			complete: function() {
				$(this).remove();
				if ($("[data-action='delete']").length < 1) {
					location.reload(true);
				}
			}
		});
	});
	
	// 页码
	$pageNumberItem.click(function() {
		var $element = $(this);
		
		$pageNumber.val($element.data("page-number")).closest("form").submit();
		return false;
	});

});