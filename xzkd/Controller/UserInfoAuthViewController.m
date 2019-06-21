//
//  UserInfoAuthViewController.m
//  xzkd
//
//  Created by 刘琛 on 2019/2/28.
//  Copyright © 2019年 xxy. All rights reserved.
//

#import "UserInfoAuthViewController.h"
#import "AuthScheduleView.h"
#import <UIView+BlocksKit.h>
//#import <MXOCR/MXOCR.h>
//#import <MXLiveness/MXLiveness.h>
#import "UserInfoModel.h"
#import "PhoneAuthViewController.h"
#import "UDIDEngine.h"
#import "UDIDFaceCompareFactory.h"
#import "Md5.h"




@interface UserInfoAuthViewController ()<UDIDEngineDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *faceImage;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@property (nonatomic, strong) AuthScheduleView *header;
@property (weak, nonatomic) IBOutlet UIView *headBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headBackViewHeight;

@property (nonatomic, strong) NSString *cardForInfoUrl;

@property (nonatomic, strong) NSString *cardForNationalUrl;
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;

@property (weak, nonatomic) IBOutlet UITextField *identifyCard;

@property (nonatomic, strong) AFHTTPSessionManager *afSessionManager;

@end

@implementation UserInfoAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"个人信息认证";
    [self initBackButton];
    [self.faceImage bk_whenTapped:^{
        [self startSearchOCR:0];
    }];
    
    [self.backImage bk_whenTapped:^{
        [self startSearchOCR:1];
    }];
    
    if (_hiddenHeader) {
        
        _headBackView.hidden = YES;
        _headBackViewHeight.constant = 0;
        
    }else {
        
        _header = [[NSBundle mainBundle] loadNibNamed:@"AuthScheduleView" owner:self options:nil].lastObject;
        _header.statusType = 0;
        [_headBackView addSubview:_header];
    }
    
    _afSessionManager = [AFHTTPSessionManager manager];
}


#pragma mark ORC识别
//1证明 2反面
- (void)startSearchOCR:(NSInteger) type {
    
    UDIDEngine *ocrEngine = [[UDIDEngine alloc] init];
    /* 身份证 OCR 扫描相关参数 */
//    ocrEngine.actions = @[@0];
     ocrEngine.actions = @[[NSNumber numberWithUnsignedInteger:UDIDAuthFlowOCR]];
    ocrEngine.showInfo = YES;
    //    ocrEngine.mosaicIdName = NO;
    ocrEngine.mosaicIdNumber = NO;
    ocrEngine.showConfirmIdNumber = NO;
    
    /* 通用参数 */
    ocrEngine.pubKey = KUDPUBKEY;
    ocrEngine.signTime = [Md5 timeSp];
//    self.signTime = ocrEngine.signTime;
    ocrEngine.partnerOrderId = [NSString stringWithFormat:@"%@",  [Md5 timeSp]];
//    self.partnerOrderId = ocrEngine.partnerOrderId;
    //    ocrEngine.notifyUrl = @"你的异步通知地址，请填规范的 URL";
    ocrEngine.sign = [Md5 signatureByMd5];
    ocrEngine.delegate = self;
    [ocrEngine startIdSafeAuthInViewController:self];
}

- (void)receiveOcrResult:(id)userInfo {
//    NSLog(@"识别成功 ----> 方向:%ld",(long)idcard.side);
//
//    if (idcard.side == mxIDCardSideFront) {
//        //正面
////        self.faceImage.image = idcard.imgCardDetected;
//        [self upLoadImageFile:idcard.imgCardDetected Type:1];
//    }else {
//        //背面
////        self.backImage.image = idcard.imgCardDetected;
//        [self upLoadImageFile:idcard.imgCardDetected Type:2];
//    }

}


// 识别出错
- (void)receiveOcrError:(id)errorCode {
//    switch (errorCode) {
//        case mxIDCardIdentifyFailed:
//            NSLog(@"识别出错 --- 单图识别失败");
//            break;
//        case mxIDCardHandleInitFailed:
//            NSLog(@"识别出错 --- 初始化失败");
//            break;
//        case mxIDCardCameraAuthorizationFailed:
//            NSLog(@"识别出错 --- 获取相机权限失败");
//            break;
//        case mxIDCardHandleParameterFaild:
//
//            break;
//        case mxIDCardHandleError:
//
//            break;
//        case mxIDCardFILENOTFOUND:
//
//            break;
//        case mxIDCardModelError:
//
//            break;
//        case mxIDCardModelExpire:
//
//            break;
//        case mxIDCardLicenseError:
//
//            break;
//        case mxIDCardAppIDError:
//
//            break;
//        case mxIDCardSDKExpire:
//
//            break;
//    }
}


//取消识别
- (void)receiveOcrCancel {
    NSLog(@"取消识别");
}
//超时自动取消
- (void)receiveOcrTimerOut {
    NSLog(@"超时自动取消");
}


#pragma mark 活体识别

- (void)startLiveness {
//    NSLog(@"活体识别");
//    MXLivenessParams* params = [[MXLivenessParams alloc] init];
//    params.outPutType = MX_LIVE_OUTPUT_HIGH_QUALITY_VIDEO;//设置输出方案
//    MXLiveness* livObj = [MXLiveness shared];
//    [livObj start:self params:params delegate:self];//启动SDK
}

//活体识别成功的回调
- (void)receiveLivenessResult:(NSArray *)arrMXImage mxVideoData:(NSData *)mxVideoData {
    NSLog(@"活体检测成功");
//    MXLivenessResult *result = arrMXImage.firstObject;
//    [self upLoadImageFile:result.image Type:3];
}
//
////活体识别失败的回调
//- (void)receiveLivenessErrorWithType:(MXMultipleLivenessError)iErrorType
//                       DetectionType:(MXDetectionType)iDetectionType
//                      DetectionIndex:(NSInteger)iIndex
//                            mxImages:(NSArray *)arrMXImage
//                         mxVideoData:(NSData *)mxVideoData {
//    NSString* errorMsg = @"";
//    switch (iErrorType) {
//            case MXMultipleLivenessInitFaild:
//            errorMsg = @"算法SDK初始化失败";
//            break;
//            case MXMultipleLivenessCameraError:
//            errorMsg = @"相机权限获取失败";
//            break;
//            case MXMultipleLivenessFaceChanged:
//            errorMsg = @"人脸变更";
//            break;
//            case MXMultipleLivenessTimeOut:
//            errorMsg = @"超时";
//            break;
//            case MXMultipleLivenessWillResignActive:
//            errorMsg = @"应用即将被挂起";
//            break;
//            case MXMultipleLivenessInternalError:
//            errorMsg = @"内部错误";
//            break;
//            case MXMultipleLivenessBadJson:
//            errorMsg = @"解析Json指令失败";
//            break;
//        default:
//            break;
//    }
//    NSLog(@"活体检测失败 ---- %@",errorMsg);
//}
// 取消活体检测指令回调方法.
- (void)receiveLivenessCancel {
    NSLog(@"活体检测取消");
}



#pragma mark <UDIDEngineDelegate>

- (void)idSafeEngineFinishedResult:(UDIDEngineResult)result UserInfo:(id)userInfo{
    switch (result) {
            case UDIDEngineResult_OCR: {
                //身份证OCR识别 回调
                [self receiveOcrResult:userInfo];
                break;
            } case UDIDEngineResult_Liveness: {
                // TODO: 活体检测 回调
                NSLog(@"demo:活体检测回调: %@", userInfo);
                break;
            } case UDIDEngineResult_IDAuth: {
                // TODO: 实名验证 回调
                NSLog(@"demo:实名验证回调: %@", userInfo);
                break;
            } case UDIDEngineResult_FaceCompare: {
                // TODO: 人脸比对 回调
                NSLog(@"demo:人脸比对回调: %@", userInfo);
                break;
            } case UDIDEngineResult_Video: {
                // TODO: 视频存证 回调
                NSLog(@"demo:视频存证回调: %@", userInfo);
                break;
            } case UDIDEngineResult_DriverLicense: {
                NSLog(@"demo:驾驶证OCR回调: %@", userInfo);
                break;
            } case UDIDEngineResult_VehicleLicense: {
                NSLog(@"demo:行驶证OCR回调: %@", userInfo);
                break;
            }case UDIDEngineResult_BankOCR: {
                NSLog(@"demo:银行卡OCR回调: %@", userInfo);
                break;
            }
            
        default:
            NSLog(@"userInfo = %@", userInfo);
            break;
    }
}



#pragma mark upLoadImageFile

- (void)upLoadImageFile:(UIImage *)image Type:(NSInteger ) type {
    
    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
    
    
    
    NSString *urlStr = kFormat(@"%@%@", MainUrl, kUploadImageFlie);
    
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UserInfoModel *userInfo = [UserInfoModel mj_objectWithKeyValues: [[[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKey] mj_JSONObject]];
    if (userInfo) {
        if (userInfo.userId.length) {
            [_afSessionManager.requestSerializer setValue:userInfo.userId forHTTPHeaderField:@"userId"];
        }else {
            [_afSessionManager.requestSerializer setValue:@"" forHTTPHeaderField:@"userId"];
        }
        if (userInfo.userName.length) {
            [_afSessionManager.requestSerializer setValue:userInfo.userName forHTTPHeaderField:@"userName"];
        }else {
            [_afSessionManager.requestSerializer setValue:@"" forHTTPHeaderField:@"userName"];
        }
    }else {
        [_afSessionManager.requestSerializer setValue:@"" forHTTPHeaderField:@"userId"];
        [_afSessionManager.requestSerializer setValue:@"" forHTTPHeaderField:@"userName"];
    }
    
    [_afSessionManager.requestSerializer setValue:kFormat(@"%ld", (long)type) forHTTPHeaderField:@"filetype"];
    
    
    [SVProgressHUD showWithStatus:@"数据上传中"];
    
    [_afSessionManager POST:urlStr parameters:parmas constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
        if (image) {
            NSData *data = UIImageJPEGRepresentation(image, .8);
            [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"photos%ld",(long)type] fileName:[NSString stringWithFormat:@"image%ld.png",(long)type] mimeType:@"image/png"];
        }
        
        
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [SVProgressHUD dismiss];
        
        if ([responseObject[@"code"] integerValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"数据上传成功"];
            NSArray *array = responseObject[@"data"];
            if (type == 1) {
                self.cardForInfoUrl = @"正面";
                self.faceImage.image = image;
                if (self.cardForNationalUrl.length) {
                    self.authModel.userInfoAuth = @(1);
                }
            }else if (type == 2) {
                self.cardForNationalUrl = @"反面";
                self.backImage.image = image;
                if (self.cardForInfoUrl.length) {
                    self.authModel.userInfoAuth = @(1);
                }
            }else if (type == 3) {
                self.authModel.liveAuth = @(1);
                [self pushNext];
            }
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"图片上传失败"];
        NSLog(@"%@",error);
    }];
}

#pragma mark Action

- (IBAction)submitButtonAction:(id)sender {
    if (_cardForInfoUrl.length) {
        if (_cardForNationalUrl.length) {
            
            [self startLiveness];
            
        }else {
            [SVProgressHUD showErrorWithStatus:@"请扫描身份证反面"];
            return;
        }
    }else {
        [SVProgressHUD showErrorWithStatus:@"请扫描身份证正面"];
        return;
    }
}

- (void)pushNext {
    PhoneAuthViewController *phone = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PhoneAuthViewController"];
    phone.hiddenHeader = NO;
    phone.authModel = self.authModel;
    [self.navigationController pushViewController:phone animated:YES];
}




@end
