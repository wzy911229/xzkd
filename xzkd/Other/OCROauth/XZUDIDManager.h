//
//  XZOCRManager.h
//  xzkd
//
//  Created by zhiyu on 2019/6/4.
//  Copyright © 2019 xxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UDIDEngine.h"


//身份证
static NSString * const KOCR_SUCCESS = @"个人信息认证成功";
static NSString * const KOCR_FAILURE = @"个人信息认证失败,请重试";
static NSString * const KOCR_FAILURE_EXPIRED = @"身份证已过期";

//身份证
static NSString * const KLIVE_SUCCESS = @"活体认证成功";
static NSString * const KLIVE_FAILURE = @"活体认证失败,请重试";

//对比
static NSString * const KFACECOMPARE_SUCCESS = @"认证成功";
static NSString * const KFACECOMPARE_FAILURE = @"对比认证失败";

static NSString * const KFACECOMPARE_VERIFY_FAILURE_02 = @"姓名与号码不一致,请重试";
static NSString * const KFACECOMPARE_VERIFY_FAILURE_03 = @"查询无结果,请重试";

static NSString * const KFACECOMPARE_RESULT_FAILURE_02 = @"系统判断为不同人，实名人像比对失败，请重试";
static NSString * const KFACECOMPARE_RESULT_FAILURE_03 = @"系统比对失败，请重试";
static NSString * const KFACECOMPARE_RESULT_FAILURE_04 = @"系统比对失败，请重试";
static NSString * const KFACECOMPARE_RESULT_FAILURE_05 = @"库中无照片（公安库中没有网格照），联系所属公安局进行录入网格照";





NS_ASSUME_NONNULL_BEGIN
@protocol XZUDIDManagerDelegate <NSObject>
@optional
- (void)ocrFinishedResult:(UDIDEngineResult)result UserInfo:(id)userInfo;
- (void)bankOcrFinishedResult:(UDIDEngineResult)result UserInfo:(id)userInfo;
- (void)livenessFlowFinishedResult:(UDIDEngineResult)result UserInfo:(id)userInfo;
- (void)faceCompareFinishedResult:(UDIDEngineResult)result UserInfo:(id)userInfo;
- (void)userCompareFinishedResult:(UDIDEngineResult)result UserInfo:(id)userInfo;


@end

@interface XZUDIDManager : NSObject
@property (nonatomic, weak) id <XZUDIDManagerDelegate> delegate;

- (id)initWithDelegate:(id<XZUDIDManagerDelegate>)delegate;
//身份证ocr
- (void)startOCR:(UIViewController*)Vc;
//银行卡
- (void)startBankOcrFlow:(UIViewController*)Vc;
// 活体检测
- (void)startLivenessFlow:(UIViewController*)Vc;


/** 实名人像比对 */
- (void)startUserCompare:(NSString *)compareIDName
         compareIDNumber:(NSString *)compareIDNumber
               sessionId:(NSString*)sessionId
          viewController:(UIViewController *)Vc;


- (void)startFaceCompare:(NSString *)ocrSessionId
         liveSessionId:(NSString*)liveSessionId
     viewController:(UIViewController*)Vc;


@end

NS_ASSUME_NONNULL_END
