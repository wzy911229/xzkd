//
//  NetworkAddress.h
//  iSee
//
//  Created by 刘琛 on 2017/11/23.
//  Copyright © 2017年 刘琛. All rights reserved.
//

#ifndef NetworkAddress_h
#define NetworkAddress_h

//base
#import "iSeeNetworkRequest.h"

#define GetInitInfo                 @"api/System/Initialize"
#define kSendPhoneMessage           @"api/System/SendVerifyCode"
#define kGetImageVerifyCode         @"api/System/GetImgVerifyCode"
#define kLogin                      @"api/User/userLogin"
#define passwordLogin               @"MiMaDengLu"
#define resetPassword               @"ChongZhiMiMa"
#define registerUserInfo            @"ZhuCe"
#define homeBanner                  @"LunBoGuangGao"
#define getMarqueeList              @"GunDong"
#define getLoanCommitment           @"DaiKuanJinE"
#define kUserMails                  @"api/User/UserMails"
#define kPostContactTaskId          @"api/User/ContactTaskId"
#define kGetUserAuthStatus          @"api/User/GetUserAuthStatus"
#define kUploadImageFlie            @"api/System/OCRUpload"
#define kSubmitDeviceInfo           @"api/User/SubmitDeviceInfo"
#define kSubmitUserInfo             @"api/User/SubmitUserInfo"
#define kGetLoanConfig              @"api/System/GetLoanConfig"
#define kSubmitLoan                 @"api/User/SubmitLoan"
#define kGetLoanInfo                @"api/User/GetLoanInfo"
#define kLoanPayment                @"api/User/LoanPayment"


//ocr
#define kCardOCR                @"api/User/CardOCR"
#define kLivingOCR                @"api/User/LivingOCR"
#define kExtraOCR                @"api/User/OtherORC"
#define kPostBankInfo               @"api/User/BankORC"
#define kGetTaskID              @"api/User/GetTaskID"

//pay
#define kPayment                @"api/User/QuickPayment"
#define kRenewPayment           @"/api/User/LoanRenew"

#define KQuickPaySmsConfirm      @"api/User/QuickPaySmsConfirm"


#define KGetAuthScore   @"api/User/GetAuthScore"



#endif /* NetworkAddress_h */
