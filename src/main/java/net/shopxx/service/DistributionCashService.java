/*
 * Copyright 2008-2018 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 * FileId: NSleLTq4/+O1Gf5H8niF7ygZbvkYQSqs
 */
package net.shopxx.service;

import net.shopxx.Page;
import net.shopxx.Pageable;
import net.shopxx.entity.DistributionCash;
import net.shopxx.entity.Distributor;

/**
 * Service - 分销提现
 * 
 * @author SHOP++ Team
 * @version 6.1
 */
public interface DistributionCashService extends BaseService<DistributionCash, Long> {

	/**
	 * 申请分销提现
	 * 
	 * @param distributionCash
	 *            分销提现
	 * @param distributor
	 *            分销员
	 */
	void applyCash(DistributionCash distributionCash, Distributor distributor);

	/**
	 * 审核分销提现
	 * 
	 * @param distributionCash
	 *            分销提现
	 * @param isPassed
	 *            是否审核通过
	 */
	void review(DistributionCash distributionCash, Boolean isPassed);

	/**
	 * 查找分销提现记录分页
	 * 
	 * @param status
	 *            状态
	 * @param bank
	 *            收款银行
	 * @param account
	 *            收款账号
	 * @param accountHolder
	 *            开户人
	 * @param distributor
	 *            分销员
	 * @param pageable
	 *            分页信息
	 * @return 分销提现记录分页
	 */
	Page<DistributionCash> findPage(DistributionCash.Status status, String bank, String account, String accountHolder, Distributor distributor, Pageable pageable);

	/**
	 * 查找分销提现数量
	 * 
	 * @param status
	 *            状态
	 * @param bank
	 *            收款银行
	 * @param account
	 *            收款账号
	 * @param accountHolder
	 *            开户人
	 * @param distributor
	 *            分销员
	 * @return 分销提现数量
	 */
	Long count(DistributionCash.Status status, String bank, String account, String accountHolder, Distributor distributor);

	/**
	 * 查找分销提现数量
	 * 
	 * @param status
	 *            状态
	 * @param bank
	 *            收款银行
	 * @param account
	 *            收款账号
	 * @param accountHolder
	 *            开户人
	 * @param distributorId
	 *            分销员Id
	 * @return 分销提现数量
	 */
	Long count(DistributionCash.Status status, String bank, String account, String accountHolder, Long distributorId);

}