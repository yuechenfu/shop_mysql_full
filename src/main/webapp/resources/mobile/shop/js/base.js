/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * 
 * JavaScript - Base
 * Version: 6.1
 */

(function($) {

	// 解析推广Url
	var spreadUrlMatch = /SPREAD_([^&#]+)/.exec(location.href);
	if (spreadUrlMatch != null && spreadUrlMatch.length >= 2) {
		if ($.base64 == null) {
			throw new Error("spreadUrlMatch requires jquery.base64.js");
		}
		$.setSpreadUser({
			username: $.base64.decode(spreadUrlMatch[1])
		});
	}

})(jQuery);

$().ready(function() {

	var $window = $(window);
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

});