<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	<meta name="author" content="SHOP++ Team">
	<meta name="copyright" content="SHOP++">
	<title>${message("member.profile.edit")}[#if showPowered] - Powered By SHOP++[/#if]</title>
	<link href="${base}/favicon.ico" rel="icon">
	<link href="${base}/resources/common/css/bootstrap.css" rel="stylesheet">
	<link href="${base}/resources/common/css/font-awesome.css" rel="stylesheet">
	<link href="${base}/resources/common/css/iconfont.css" rel="stylesheet">
	<link href="${base}/resources/common/css/awesome-bootstrap-checkbox.css" rel="stylesheet">
	<link href="${base}/resources/common/css/bootstrap-datetimepicker.css" rel="stylesheet">
	<link href="${base}/resources/common/css/base.css" rel="stylesheet">
	<link href="${base}/resources/mobile/member/css/base.css" rel="stylesheet">
	<!--[if lt IE 9]>
		<script src="${base}/resources/common/js/html5shiv.js"></script>
		<script src="${base}/resources/common/js/respond.js"></script>
	<![endif]-->
	<script src="${base}/resources/common/js/jquery.js"></script>
	<script src="${base}/resources/common/js/bootstrap.js"></script>
	<script src="${base}/resources/common/js/bootstrap-growl.js"></script>
	<script src="${base}/resources/common/js/jquery.scrolltofixed.js"></script>
	<script src="${base}/resources/common/js/moment.js"></script>
	<script src="${base}/resources/common/js/bootstrap-datetimepicker.js"></script>
	<script src="${base}/resources/common/js/jquery.lSelect.js"></script>
	<script src="${base}/resources/common/js/jquery.validate.js"></script>
	<script src="${base}/resources/common/js/jquery.validate.additional.js"></script>
	<script src="${base}/resources/common/js/jquery.form.js"></script>
	<script src="${base}/resources/common/js/jquery.cookie.js"></script>
	<script src="${base}/resources/common/js/underscore.js"></script>
	<script src="${base}/resources/common/js/url.js"></script>
	<script src="${base}/resources/common/js/base.js"></script>
	<script src="${base}/resources/mobile/member/js/base.js"></script>
	[#noautoesc]
		[#escape x as x?js_string]
			<script>
			$().ready(function() {
				
				var $inputForm = $("#inputForm");
				var $areaId = $("#areaId");
				
				// 地区选择
				$areaId.lSelect({
					url: "${base}/common/area"
				});
				
				// 表单验证
				$inputForm.validate({
					rules: {
						email: {
							required: true,
							email: true,
							remote: {
								url: "${base}/member/profile/check_email",
								cache: false
							}
						},
						mobile: {
							required: true,
							mobile: true,
							remote: {
								url: "${base}/member/profile/check_mobile",
								cache: false
							}
						}
						[@member_attribute_list]
							[#list memberAttributes as memberAttribute]
								[#if memberAttribute.isRequired || memberAttribute.pattern?has_content]
									,"memberAttribute_${memberAttribute.id}": {
										[#if memberAttribute.isRequired]
											required: true
											[#if memberAttribute.pattern?has_content],[/#if]
										[/#if]
										[#if memberAttribute.pattern?has_content]
											pattern: new RegExp("${memberAttribute.pattern}")
										[/#if]
									}
								[/#if]
							[/#list]
						[/@member_attribute_list]
					},
					submitHandler: function(form) {
						$(form).ajaxSubmit({
							successRedirectUrl: "${base}/member/profile/edit"
						});
					},
					messages: {
						email: {
							remote: "${message("common.validator.exist")}"
						},
						mobile: {
							remote: "${message("common.validator.exist")}"
						}
					}
				});
			
			});
			</script>
		[/#escape]
	[/#noautoesc]
</head>
<body class="member">
	<header class="header-default" data-spy="scrollToFixed">
		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-1">
					<a href="${base}/member/index">
						<i class="iconfont icon-back"></i>
					</a>
				</div>
				<div class="col-xs-10">
					<h5>${message("member.profile.edit")}</h5>
				</div>
			</div>
		</div>
	</header>
	<main>
		<div class="container-fluid">
			<form id="inputForm" class="ajax-form" action="${base}/member/profile/update" method="post">
				<input name="id" type="hidden" value="${receiver.id}">
				<div class="panel panel-default">
					<div class="panel-body">
						<div class="form-group">
							<label class="item-required" for="email">${message("Member.email")}</label>
							<input id="email" name="email" class="form-control" type="text" value="${currentUser.email}" maxlength="200">
						</div>
						<div class="form-group">
							<label class="item-required" for="mobile">${message("Member.mobile")}</label>
							<input id="mobile" name="mobile" class="form-control" type="text" value="${currentUser.mobile}" maxlength="200">
						</div>
						[@member_attribute_list]
							[#list memberAttributes as memberAttribute]
								<div class="form-group">
									<label[#if memberAttribute.isRequired] class="item-required"[/#if][#if memberAttribute.type != "GENDER" && memberAttribute.type != "AREA" && memberAttribute.type != "CHECKBOX"] for="memberAttribute_${memberAttribute.id}"[/#if]>${memberAttribute.name}</label>
									[#if memberAttribute.type == "NAME"]
										<input id="memberAttribute_${memberAttribute.id}" name="memberAttribute_${memberAttribute.id}" class="form-control" type="text" value="${currentUser.name}" maxlength="200">
									[#elseif memberAttribute.type == "GENDER"]
										<p>
											[#list genders as gender]
												<div class="radio radio-inline">
													<input id="${gender}" name="memberAttribute_${memberAttribute.id}" type="radio" value="${gender}"[#if gender == currentUser.gender] checked[/#if]>
													<label for="${gender}">${message("Member.Gender." + gender)}</label>
												</div>
											[/#list]
										</p>
									[#elseif memberAttribute.type == "BIRTH"]
										<div class="input-group">
											<input id="memberAttribute_${memberAttribute.id}" name="memberAttribute_${memberAttribute.id}" class="form-control" type="text" value="${currentUser.birth}" data-provide="datetimepicker">
											<span class="input-group-addon">
												<i class="iconfont icon-calendar"></i>
											</span>
										</div>
									[#elseif memberAttribute.type == "AREA"]
										<div class="input-group">
											<input id="areaId" name="memberAttribute_${memberAttribute.id}" type="hidden" value="${(currentUser.area.id)!}" treePath="${(currentUser.area.treePath)!}">
										</div>
									[#elseif memberAttribute.type == "ADDRESS"]
										<input id="memberAttribute_${memberAttribute.id}" name="memberAttribute_${memberAttribute.id}" class="form-control" type="text" value="${currentUser.address}" maxlength="200">
									[#elseif memberAttribute.type == "ZIP_CODE"]
										<input id="memberAttribute_${memberAttribute.id}" name="memberAttribute_${memberAttribute.id}" class="form-control" type="text" value="${currentUser.zipCode}" maxlength="200">
									[#elseif memberAttribute.type == "PHONE"]
										<input id="memberAttribute_${memberAttribute.id}" name="memberAttribute_${memberAttribute.id}" class="form-control" type="text" value="${currentUser.phone}" maxlength="200">
									[#elseif memberAttribute.type == "TEXT"]
										<input id="memberAttribute_${memberAttribute.id}" name="memberAttribute_${memberAttribute.id}" class="form-control" type="text" value="${currentUser.getAttributeValue(memberAttribute)}" maxlength="200">
									[#elseif memberAttribute.type == "SELECT"]
										<select id="memberAttribute_${memberAttribute.id}" name="memberAttribute_${memberAttribute.id}" class="form-control">
											<option value="">${message("common.choose")}</option>
											[#list memberAttribute.options as option]
												<option value="${option}"[#if option == currentUser.getAttributeValue(memberAttribute)] selected[/#if]>${option}</option>
											[/#list]
										</select>
									[#elseif memberAttribute.type == "CHECKBOX"]
										<p>
											[#list memberAttribute.options as option]
												<div class="checkbox checkbox-inline">
													<input id="${option}_${memberAttribute.id}" name="memberAttribute_${memberAttribute.id}" type="checkbox" value="${option}"[#if (currentUser.getAttributeValue(memberAttribute)?seq_contains(option))!] checked[/#if]>
													<label for="${option}_${memberAttribute.id}">${option}</label>
												</div>
											[/#list]
										</p>
									[/#if]
								</div>
							[/#list]
						[/@member_attribute_list]
					</div>
					<div class="panel-footer text-center">
						<button class="btn btn-primary" type="submit">${message("common.submit")}</button>
						<a class="btn btn-default" href="${base}/member/index">${message("common.back")}</a>
					</div>
				</div>
			</form>
		</div>
	</main>
</body>
</html>