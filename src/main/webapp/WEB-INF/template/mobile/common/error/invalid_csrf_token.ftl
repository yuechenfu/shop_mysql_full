<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("common.error.invalidCsrfToken")}[#if showPowered] - Powered By SHOP++[/#if]</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/common/css/error.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/jquery.animateNumber.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
</head>
<body class="mobile error">
	<main>
		<div class="error-wrapper">
			<img src="${base}/resources/common/images/error_icon.png" alt="${message("common.error.invalidCsrfToken")}">
			<h3>${message("common.error.title")}</h3>
			<p class="text-red-light">${errorMessage!message("common.error.invalidCsrfToken")}</p>
			[#noautoesc]
				<p class="text-gray-dark">${message("common.error.delayMessage")}</p>
			[/#noautoesc]
		</div>
	</main>
</body>
</html>