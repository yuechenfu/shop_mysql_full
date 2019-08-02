/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: CR5FbOmEEM2qB0hoFKw+i2Uwzxr1mY9m
 */
package net.shopxx.service.impl;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.ConnectException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.crypto.spec.SecretKeySpec;
import javax.inject.Inject;

import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateFormatUtils;
import org.apache.http.Header;
import org.apache.http.entity.ByteArrayEntity;
import org.apache.http.message.BasicHeader;
import org.springframework.core.task.TaskExecutor;
import org.springframework.stereotype.Service;
import org.springframework.ui.freemarker.FreeMarkerTemplateUtils;
import org.springframework.util.Assert;
import org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer;

import com.fasterxml.jackson.core.type.TypeReference;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import net.shopxx.Setting;
import net.shopxx.TemplateConfig;
import net.shopxx.entity.Business;
import net.shopxx.entity.Member;
import net.shopxx.entity.MessageConfig;
import net.shopxx.entity.Order;
import net.shopxx.entity.Store;
import net.shopxx.service.MessageConfigService;
import net.shopxx.service.SmsService;
import net.shopxx.util.JsonUtils;
import net.shopxx.util.SecurityUtils;
import net.shopxx.util.SystemUtils;
import net.shopxx.util.WebUtils;

/**
 * Service - 短信
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
@Service
public class SmsServiceImpl implements SmsService {

	@Inject
	private FreeMarkerConfigurer freeMarkerConfigurer;
	@Inject
	private TaskExecutor taskExecutor;
	@Inject
	private MessageConfigService messageConfigService;

	/**
	 * 添加短信发送任务
	 * 
	 * @param mobiles
	 *            手机号码
	 * @param content
	 *            内容
	 * @param sendTime
	 *            发送时间
	 */
	private void addSendTask(final String[] mobiles, final String content, final Date sendTime) {
		taskExecutor.execute(new Runnable() {
			public void run() {
				send(mobiles, content, sendTime);
			}
		});
	}

	/**
	 * 发送短信
	 * 
	 * @param mobiles
	 *            手机号码
	 * @param content
	 *            内容
	 * @param sendTime
	 *            发送时间
	 */
	private void send(String[] mobiles, String content, Date sendTime) {
		Assert.notEmpty(mobiles, "[Assertion failed] - mobiles must not be empty: it must contain at least 1 element");
		Assert.hasText(content, "[Assertion failed] - content must have text; it must not be null, empty, or blank");

		Setting setting = SystemUtils.getSetting();
		String smsAppId = setting.getSmsAppId();
		String smsSecretKey = setting.getSmsSecretKey();
		if (StringUtils.isEmpty(smsAppId) || StringUtils.isEmpty(smsSecretKey)) {
			return;
		}

		try {
			SecretKeySpec secretKeySpec = new SecretKeySpec(smsSecretKey.getBytes(), SecurityUtils.AES_KEY_ALGORITHM);
			Map<String, Object> parameterMap = new HashMap<>();
			parameterMap.put("mobiles", mobiles);
			parameterMap.put("content", content);
			parameterMap.put("requestTime", new Date().getTime());
			parameterMap.put("requestValidPeriod", 60);
			if (sendTime != null) {
				parameterMap.put("timerTime", DateFormatUtils.format(sendTime, "yyyy-MM-dd HH:mm:ss"));
			}
			byte[] encodedParameter = SecurityUtils.encrypt(secretKeySpec, JsonUtils.toJson(parameterMap).getBytes("UTF-8"), SecurityUtils.AES_TRANSFORMATION);
			Header header = new BasicHeader("appId", smsAppId);
			WebUtils.post("http://shmtn.b2m.cn/inter/sendBatchOnlySMS", header, new ByteArrayEntity(encodedParameter));
		} catch (UnsupportedEncodingException e) {
			throw new RuntimeException(e.getMessage(), e);
		}
	}

	@Override
	public void send(String[] mobiles, String content, Date sendTime, boolean async) {
		Assert.notEmpty(mobiles, "[Assertion failed] - mobiles must not be empty: it must contain at least 1 element");
		Assert.hasText(content, "[Assertion failed] - content must have text; it must not be null, empty, or blank");

		if (async) {
			addSendTask(mobiles, content, sendTime);
		} else {
			send(mobiles, content, sendTime);
		}
	}

	@Override
	public void send(String[] mobiles, String templatePath, Map<String, Object> model, Date sendTime, boolean async) {
		Assert.notEmpty(mobiles, "[Assertion failed] - mobiles must not be empty: it must contain at least 1 element");
		Assert.hasText(templatePath, "[Assertion failed] - templatePath must have text; it must not be null, empty, or blank");

		try {
			Configuration configuration = freeMarkerConfigurer.getConfiguration();
			Template template = configuration.getTemplate(templatePath);
			String content = FreeMarkerTemplateUtils.processTemplateIntoString(template, model);
			send(mobiles, content, sendTime, async);
		} catch (TemplateException e) {
			throw new RuntimeException(e.getMessage(), e);
		} catch (IOException e) {
			throw new RuntimeException(e.getMessage(), e);
		}
	}

	@Override
	public void send(String mobile, String content) {
		Assert.hasText(mobile, "[Assertion failed] - mobile must have text; it must not be null, empty, or blank");
		Assert.hasText(content, "[Assertion failed] - content must have text; it must not be null, empty, or blank");

		send(new String[] { mobile }, content, null, true);
	}

	@Override
	public void send(String mobile, String templatePath, Map<String, Object> model) {
		Assert.hasText(mobile, "[Assertion failed] - mobile must have text; it must not be null, empty, or blank");
		Assert.hasText(templatePath, "[Assertion failed] - templatePath must have text; it must not be null, empty, or blank");

		send(new String[] { mobile }, templatePath, model, null, true);
	}

	@Override
	public void sendRegisterMemberSms(Member member) {
		if (member == null || StringUtils.isEmpty(member.getMobile())) {
			return;
		}
		MessageConfig messageConfig = messageConfigService.find(MessageConfig.Type.REGISTER_MEMBER);
		if (messageConfig == null || !messageConfig.getIsSmsEnabled()) {
			return;
		}
		Map<String, Object> model = new HashMap<>();
		model.put("member", member);
		TemplateConfig templateConfig = SystemUtils.getTemplateConfig("registerMemberSms");
		send(member.getMobile(), templateConfig.getTemplatePath(), model);
	}

	@Override
	public void sendCreateOrderSms(Order order) {
		if (order == null || order.getMember() == null || StringUtils.isEmpty(order.getMember().getMobile())) {
			return;
		}
		MessageConfig messageConfig = messageConfigService.find(MessageConfig.Type.CREATE_ORDER);
		if (messageConfig == null || !messageConfig.getIsSmsEnabled()) {
			return;
		}
		Map<String, Object> model = new HashMap<>();
		model.put("order", order);
		TemplateConfig templateConfig = SystemUtils.getTemplateConfig("createOrderSms");
		send(order.getMember().getMobile(), templateConfig.getTemplatePath(), model);
	}

	@Override
	public void sendUpdateOrderSms(Order order) {
		if (order == null || order.getMember() == null || StringUtils.isEmpty(order.getMember().getMobile())) {
			return;
		}
		MessageConfig messageConfig = messageConfigService.find(MessageConfig.Type.UPDATE_ORDER);
		if (messageConfig == null || !messageConfig.getIsSmsEnabled()) {
			return;
		}
		Map<String, Object> model = new HashMap<>();
		model.put("order", order);
		TemplateConfig templateConfig = SystemUtils.getTemplateConfig("updateOrderSms");
		send(order.getMember().getMobile(), templateConfig.getTemplatePath(), model);
	}

	@Override
	public void sendCancelOrderSms(Order order) {
		if (order == null || order.getMember() == null || StringUtils.isEmpty(order.getMember().getMobile())) {
			return;
		}
		MessageConfig messageConfig = messageConfigService.find(MessageConfig.Type.CANCEL_ORDER);
		if (messageConfig == null || !messageConfig.getIsSmsEnabled()) {
			return;
		}
		Map<String, Object> model = new HashMap<>();
		model.put("order", order);
		TemplateConfig templateConfig = SystemUtils.getTemplateConfig("cancelOrderSms");
		send(order.getMember().getMobile(), templateConfig.getTemplatePath(), model);
	}

	@Override
	public void sendReviewOrderSms(Order order) {
		if (order == null || order.getMember() == null || StringUtils.isEmpty(order.getMember().getMobile())) {
			return;
		}
		MessageConfig messageConfig = messageConfigService.find(MessageConfig.Type.REVIEW_ORDER);
		if (messageConfig == null || !messageConfig.getIsSmsEnabled()) {
			return;
		}
		Map<String, Object> model = new HashMap<>();
		model.put("order", order);
		TemplateConfig templateConfig = SystemUtils.getTemplateConfig("reviewOrderSms");
		send(order.getMember().getMobile(), templateConfig.getTemplatePath(), model);
	}

	@Override
	public void sendPaymentOrderSms(Order order) {
		if (order == null || order.getMember() == null || StringUtils.isEmpty(order.getMember().getMobile())) {
			return;
		}
		MessageConfig messageConfig = messageConfigService.find(MessageConfig.Type.PAYMENT_ORDER);
		if (messageConfig == null || !messageConfig.getIsSmsEnabled()) {
			return;
		}
		Map<String, Object> model = new HashMap<>();
		model.put("order", order);
		TemplateConfig templateConfig = SystemUtils.getTemplateConfig("paymentOrderSms");
		send(order.getMember().getMobile(), templateConfig.getTemplatePath(), model);
	}

	@Override
	public void sendRefundsOrderSms(Order order) {
		if (order == null || order.getMember() == null || StringUtils.isEmpty(order.getMember().getMobile())) {
			return;
		}
		MessageConfig messageConfig = messageConfigService.find(MessageConfig.Type.REFUNDS_ORDER);
		if (messageConfig == null || !messageConfig.getIsSmsEnabled()) {
			return;
		}
		Map<String, Object> model = new HashMap<>();
		model.put("order", order);
		TemplateConfig templateConfig = SystemUtils.getTemplateConfig("refundsOrderSms");
		send(order.getMember().getMobile(), templateConfig.getTemplatePath(), model);
	}

	@Override
	public void sendShippingOrderSms(Order order) {
		if (order == null || order.getMember() == null || StringUtils.isEmpty(order.getMember().getMobile())) {
			return;
		}
		MessageConfig messageConfig = messageConfigService.find(MessageConfig.Type.SHIPPING_ORDER);
		if (messageConfig == null || !messageConfig.getIsSmsEnabled()) {
			return;
		}
		Map<String, Object> model = new HashMap<>();
		model.put("order", order);
		TemplateConfig templateConfig = SystemUtils.getTemplateConfig("shippingOrderSms");
		send(order.getMember().getMobile(), templateConfig.getTemplatePath(), model);
	}

	@Override
	public void sendReturnsOrderSms(Order order) {
		if (order == null || order.getMember() == null || StringUtils.isEmpty(order.getMember().getMobile())) {
			return;
		}
		MessageConfig messageConfig = messageConfigService.find(MessageConfig.Type.RETURNS_ORDER);
		if (messageConfig == null || !messageConfig.getIsSmsEnabled()) {
			return;
		}
		Map<String, Object> model = new HashMap<>();
		model.put("order", order);
		TemplateConfig templateConfig = SystemUtils.getTemplateConfig("returnsOrderSms");
		send(order.getMember().getMobile(), templateConfig.getTemplatePath(), model);
	}

	@Override
	public void sendReceiveOrderSms(Order order) {
		if (order == null || order.getMember() == null || StringUtils.isEmpty(order.getMember().getMobile())) {
			return;
		}
		MessageConfig messageConfig = messageConfigService.find(MessageConfig.Type.RECEIVE_ORDER);
		if (messageConfig == null || !messageConfig.getIsSmsEnabled()) {
			return;
		}
		Map<String, Object> model = new HashMap<>();
		model.put("order", order);
		TemplateConfig templateConfig = SystemUtils.getTemplateConfig("receiveOrderSms");
		send(order.getMember().getMobile(), templateConfig.getTemplatePath(), model);
	}

	@Override
	public void sendCompleteOrderSms(Order order) {
		if (order == null || order.getMember() == null || StringUtils.isEmpty(order.getMember().getMobile())) {
			return;
		}
		MessageConfig messageConfig = messageConfigService.find(MessageConfig.Type.COMPLETE_ORDER);
		if (messageConfig == null || !messageConfig.getIsSmsEnabled()) {
			return;
		}
		Map<String, Object> model = new HashMap<>();
		model.put("order", order);
		TemplateConfig templateConfig = SystemUtils.getTemplateConfig("completeOrderSms");
		send(order.getMember().getMobile(), templateConfig.getTemplatePath(), model);
	}

	@Override
	public void sendFailOrderSms(Order order) {
		if (order == null || order.getMember() == null || StringUtils.isEmpty(order.getMember().getMobile())) {
			return;
		}
		MessageConfig messageConfig = messageConfigService.find(MessageConfig.Type.FAIL_ORDER);
		if (messageConfig == null || !messageConfig.getIsSmsEnabled()) {
			return;
		}
		Map<String, Object> model = new HashMap<>();
		model.put("order", order);
		TemplateConfig templateConfig = SystemUtils.getTemplateConfig("failOrderSms");
		send(order.getMember().getMobile(), templateConfig.getTemplatePath(), model);
	}

	@Override
	public void sendRegisterBusinessSms(Business business) {
		if (business == null || StringUtils.isEmpty(business.getMobile())) {
			return;
		}
		MessageConfig messageConfig = messageConfigService.find(MessageConfig.Type.REGISTER_BUSINESS);
		if (messageConfig == null || !messageConfig.getIsSmsEnabled()) {
			return;
		}
		Map<String, Object> model = new HashMap<>();
		model.put("business", business);
		TemplateConfig templateConfig = SystemUtils.getTemplateConfig("registerBusinessSms");
		send(business.getMobile(), templateConfig.getTemplatePath(), model);
	}

	@Override
	public void sendApprovalStoreSms(Store store) {
		if (store == null || StringUtils.isEmpty(store.getMobile())) {
			return;
		}
		MessageConfig messageConfig = messageConfigService.find(MessageConfig.Type.APPROVAL_STORE);
		if (messageConfig == null || !messageConfig.getIsSmsEnabled()) {
			return;
		}
		Map<String, Object> model = new HashMap<>();
		model.put("store", store);
		TemplateConfig templateConfig = SystemUtils.getTemplateConfig("approvalStoreSms");
		send(store.getMobile(), templateConfig.getTemplatePath(), model);
	}

	@Override
	public void sendFailStoreSms(Store store, String content) {
		if (store == null || StringUtils.isEmpty(store.getMobile()) || StringUtils.isEmpty(content)) {
			return;
		}
		MessageConfig messageConfig = messageConfigService.find(MessageConfig.Type.FAIL_STORE);
		if (messageConfig == null || !messageConfig.getIsSmsEnabled()) {
			return;
		}
		Map<String, Object> model = new HashMap<>();
		model.put("store", store);
		model.put("content", content);
		TemplateConfig templateConfig = SystemUtils.getTemplateConfig("failStoreSms");
		send(store.getMobile(), templateConfig.getTemplatePath(), model);
	}

	@Override
	public long getBalance() {
		Setting setting = SystemUtils.getSetting();
		String smsAppId = setting.getSmsAppId();
		String smsSecretKey = setting.getSmsSecretKey();

		Assert.hasText(smsAppId, "[Assertion failed] - smsAppId must have text; it must not be null, empty, or blank");
		Assert.hasText(smsSecretKey, "[Assertion failed] - smsSecretKey must have text; it must not be null, empty, or blank");

		try {
			SecretKeySpec secretKeySpec = new SecretKeySpec(smsSecretKey.getBytes(), SecurityUtils.AES_KEY_ALGORITHM);
			Map<String, Object> parameterMap = new HashMap<>();
			parameterMap.put("requestTime", new Date().getTime());
			parameterMap.put("requestValidPeriod", 60);
			byte[] encodedParameter = SecurityUtils.encrypt(secretKeySpec, JsonUtils.toJson(parameterMap).getBytes("UTF-8"), SecurityUtils.AES_TRANSFORMATION);
			Header header = new BasicHeader("appId", smsAppId);
			byte[] byteArrayResult = WebUtils.post("http://bjmtn.b2m.cn/inter/getBalance", header, new ByteArrayEntity(encodedParameter), byte[].class);
			if (ArrayUtils.isEmpty(byteArrayResult)) {
				throw new ConnectException();
			}

			String result = new String(SecurityUtils.decrypt(secretKeySpec, byteArrayResult, SecurityUtils.AES_TRANSFORMATION));
			Map<String, Object> data = JsonUtils.toObject(result, new TypeReference<Map<String, Object>>() {
			});
			return Long.parseLong(data.get("balance").toString());
		} catch (Exception e) {
			throw new RuntimeException(e.getMessage(), e);
		}
	}

}