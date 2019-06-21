//
//  BaseConfigModel.h
//  xzkd
//
//  Created by 刘琛 on 2019/3/3.
//  Copyright © 2019年 xxy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*baseConfig:{
regAgreementConter：'注册协议注册协议注册协议注册协议注册协议注册协议'，
regLoanMoney:'6000',
regLoanTime:'7天-14天',
maxSendSms：3,
backgroundColor：'#fff',
backgroundUrl:'',
btnColor:'#fff'
},
*/

@interface BaseConfigModel : NSObject

@property (nonatomic, strong) NSString *regAgreementConter;
@property (nonatomic, strong) NSString *regLoanMoney;
@property (nonatomic, strong) NSString *regLoanTime;
@property (nonatomic, strong) NSString *maxSendSms;
@property (nonatomic, strong) NSString *backgroundColor;
@property (nonatomic, strong) NSString *backgroundUrl;
@property (nonatomic, strong) NSString *btnColor;


@end

NS_ASSUME_NONNULL_END
