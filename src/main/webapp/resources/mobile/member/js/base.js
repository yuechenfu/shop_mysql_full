/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * 
 * JavaScript - Base
 * Version: 6.1
 */

$().ready(function() {

	var $window = $(window);
	var $document = $(document);
	var $backTop = $('<div class="back-top"><i class="iconfont icon-top"><\/i><\/div>').appendTo("body");
	var $footer = $("footer");
	
	// 回到顶部
	$window.scroll(_.throttle(function() {
		if ($window.scrollTop() > 500) {
			$backTop.fadeIn();
			if ($footer.length > 0) {
				if ($footer.offset().top <= $backTop.offset().top + $backTop.outerHeight()) {
					$backTop.animate({
						bottom: $footer.outerHeight() + 10
					});
				} else if ($footer.offset().top >= $backTop.offset().top + $backTop.outerHeight() + 15) {
					$backTop.animate({
						bottom: 10
					});
				}
			}
		} else {
			$backTop.fadeOut();
		}
	}, 500));
	
	// 回到顶部
	$backTop.click(function() {
		$("body, html").animate({
			scrollTop: 0
		});
	});
	
	// 删除
	$document.on("success.shopxx.delete", function(event) {
		var $element = $(event.target);
		
		if ($.fn.velocity == null) {
			throw new Error("Delete requires velocity.js");
		}
		
		$element.closest(".panel").velocity("slideUp", {
			complete: function() {
				$(this).remove();
				if ($("[data-action='delete']").length < 1) {
					location.reload(true);
				}
			}
		});
	});
	
});