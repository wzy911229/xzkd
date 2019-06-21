//
//  XZOCRManager.m
//  xzkd
//
//  Created by zhiyu on 2019/6/4.
//  Copyright © 2019 xxy. All rights reserved.
//

#import "XZUDIDManager.h"
#import "UDIDFaceCompareFactory.h"
#import "Md5.h"
#import "UDIDSafeDataDefine.h"

@interface XZUDIDManager ()<UDIDEngineDelegate>

@end
@implementation XZUDIDManager

- (id)initWithDelegate:(id<XZUDIDManagerDelegate>)delegate{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return  self;
}

// 身份证
- (void)startOCR:(UIViewController*)Vc{
    
    UDIDEngine *ocrEngine = [[UDIDEngine alloc] init];
    ocrEngine.actions = @[@0];
    ocrEngine.showInfo = YES;
    //    ocrEngine.mosaicIdName = NO;
    ocrEngine.mosaicIdNumber = NO;
    ocrEngine.showConfirmIdNumber = NO;
    [self startManager:ocrEngine viewController:Vc];

}

// 银行卡
- (void)startBankOcrFlow:(UIViewController*)Vc {
    UDIDEngine *bankEngine = [[UDIDEngine alloc] init];
    bankEngine.actions = @[@10];
    
    [self startManager:bankEngine viewController:Vc];

}

// 活体检测
- (void)startLivenessFlow:(UIViewController*)Vc {
    UDIDEngine *livenessEngine = [[UDIDEngine alloc] init];
    livenessEngine.actions = @[@1];
    // 或者下面的 actions 传入方式
//     livenessEngine.actions = @[[NSNumber numberWithUnsignedInteger:UDIDAuthFlowLiving]];
    
    /* 活体检测相关参数 */
    livenessEngine.livingMode = UDIDLivingCommandMode;
  
    livenessEngine.closeRemindVoice = NO;
    
    [self startManager:livenessEngine viewController:Vc];

}




/** */
- (void)startUserCompare:(NSString *)compareIDName compareIDNumber:(NSString *)compareIDNumber sessionId:(NSString*)sessionId viewController:(UIViewController *)Vc {
    UDIDEngine *engine = [[UDIDEngine alloc] init];

    engine.actions = @[@7];

    engine.compareIDName = compareIDName;
    
    engine.compareIDNumber = compareIDNumber;
    
//    /** 添加 身份证ocr识别相关设置 */
//    engine.showConfirmIdNumber = YES;
//
//    /** 添加 活体检测相关设置 */
//    engine.livingMode = UDIDAuthFlowRecommand;


    /** 设置人脸照片为 OCR 证件照 */
    engine.compareItemA = [UDIDFaceCompareFactory getBySessionID:sessionId type:UDIDSafePhotoTypeNormal];
    
    [self startManager:engine viewController:Vc];

}


- (void)startFaceCompare:(NSString *)ocrSessionId liveSessionId:(NSString *)liveSessionId viewController:(UIViewController *)Vc {
    
    UDIDEngine *engine = [[UDIDEngine alloc] init];
    engine.actions = @[@6];
    engine.compareItemA =  [UDIDFaceCompareFactory getBySessionID:ocrSessionId type:UDIDSafePhotoTypeLiving];
    engine.compareItemB =  [UDIDFaceCompareFactory getBySessionID:liveSessionId type:UDIDSafePhotoTypeLiving];

    [self startManager:engine viewController:Vc];
}



- (void)idSafeEngineFinishedResult:(UDIDEngineResult)result UserInfo:(id)userInfo {
    
    switch (result) {
            case UDIDEngineResult_OCR: {
                // TODO: 身份证OCR识别 回调
                if (self.delegate && [self.delegate respondsToSelector:@selector(ocrFinishedResult:UserInfo:)]) {
                    [self.delegate ocrFinishedResult:result UserInfo:userInfo];
                }
            
                break;
            } case UDIDEngineResult_Liveness: {
                // TODO: 活体检测 回调
                if (self.delegate && [self.delegate respondsToSelector:@selector(livenessFlowFinishedResult:UserInfo:)]) {
                    [self.delegate livenessFlowFinishedResult:result UserInfo:userInfo];
                }
                break;
            } case UDIDEngineResult_IDAuth: {
                // TODO: 实名验证 回调
                if (self.delegate && [self.delegate respondsToSelector:@selector(userCompareFinishedResult:UserInfo:)]) {
                    [self.delegate userCompareFinishedResult:result UserInfo:userInfo];
                }
                break;
            } case UDIDEngineResult_FaceCompare: {
                // TODO: 人脸比对 回调
                if (self.delegate && [self.delegate respondsToSelector:@selector(faceCompareFinishedResult:UserInfo:)]) {
                    [self.delegate faceCompareFinishedResult:result UserInfo:userInfo];
                }
                break;
            } case UDIDEngineResult_BankOCR: {
                if (self.delegate && [self.delegate respondsToSelector:@selector(bankOcrFinishedResult:UserInfo:)]) {
                    [self.delegate bankOcrFinishedResult:result UserInfo:userInfo];
                }
                break;
            }
        default:
            break;
    }
}



//通用配置
- (void)startManager:(UDIDEngine *)engine viewController:(UIViewController*)Vc {
    
    // 通用设置
    engine.pubKey = KUDPUBKEY;
    engine.signTime =  [Md5 timeSp];
    engine.partnerOrderId = [NSString stringWithFormat:@"%@", [self getTimeSp]];
    engine.sign = [self getSignatureByMd5];
    engine.delegate = self;
    [engine startIdSafeAuthInViewController:Vc];
}



// 签名方法
- (NSString*)getSignatureByMd5 {
    NSString *timeSp = [self getTimeSp];
    NSString *resultString = nil;
    NSString* signature = [NSString stringWithFormat:@"pub_key=%@|partner_order_id=%@|sign_time=%@|security_key=%@",KUDPUBKEY,[NSString stringWithFormat:@"%@", timeSp], timeSp , KUDSECURITYKEY];
    resultString = [Md5 encodeToLowerCase:signature];
    return resultString;
}

// 签名时间方法
- (NSString *)getTimeSp {
    NSString *resultString = nil;
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] ;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyyMMddHHMMss"];
    NSDate *datenow = [NSDate dateWithTimeIntervalSince1970:time];
    resultString = [formatter stringFromDate:datenow];
    return resultString;
}


@end
