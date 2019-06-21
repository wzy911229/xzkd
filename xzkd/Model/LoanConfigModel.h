//
//  LoanConfigModel.h
//  xzkd
//
//  Created by 小咸鱼 on 2019/3/8.
//  Copyright © 2019 xxy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoanConfigModel : NSObject
/*
 loanMoney = 2000;
 overdueRate = 5;
 repayDate = "2019-03-14T00:00:00+08:00";
 repayDay = 7;
 serviceMoney = 600;
 yearRate = 24;
 */
@property (nonatomic, assign) NSInteger loanMoney;      //借款额
@property (nonatomic, assign) NSInteger serviceMoney;   //服务费
@property (nonatomic, assign) CGFloat   yearRate;       //年利率
@property (nonatomic, assign) CGFloat   overdueRate;    //逾期后日利率
@property (nonatomic, assign) NSInteger repayDay;       //借款天数
@property (nonatomic, strong) NSDate *repayDate;     //还款日期
@end

NS_ASSUME_NONNULL_END
