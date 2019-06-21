//
//  LoanResultModel.h
//  xzkd
//
//  Created by 小咸鱼 on 2019/3/11.
//  Copyright © 2019 xxy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoanResultModel : NSObject
/*
 interestMoney = "9.2054794520547945205479458";
 loanMoney = 2000;
 loanStatus = 3;
 overdueDay = 0;
 overdueMoney = 0;
 repayMoney = "2009.2054794520547945205479458";
 repayTime = "2019-03-17 20:53:54";
 yearRate = 24;

 */

@property (nonatomic, assign) NSInteger loanStatus;     //借款状态
@property (nonatomic, assign) CGFloat loanMoney;        //借款额
@property (nonatomic, copy)   NSString  *yearRate;      //年利率
@property (nonatomic, copy)     NSString *repayTime;        //还款时间
@property (nonatomic, assign) CGFloat repayMoney;       //还款金额
@property (nonatomic, assign) NSInteger overdueDay;     //逾期天数
@property (nonatomic, assign) CGFloat interestMoney;    //利息额
@property (nonatomic, assign) CGFloat overdueMoney;     //逾期费用
@end

NS_ASSUME_NONNULL_END
