//
//  LoginViewController.m
//  xzkd
//
//  Created by 小咸鱼 on 2019/2/27.
//  Copyright © 2019 xxy. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginHeaderView.h"
#import "BaseConfigModel.h"
#import "UserInfoModel.h"
#import "AppDelegate.h"
#import "RegistAgreementView.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeInputTopConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginButtonHeightConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeightConstraints;
@property (weak, nonatomic) IBOutlet LoginHeaderView *headerView;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberInput;     
@property (weak, nonatomic) IBOutlet UITextField *imageVerifyCode;
@property (weak, nonatomic) IBOutlet UITextField *phoneVerifyCode;
@property (weak, nonatomic) IBOutlet UIButton *agreementButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *getVerifyCodeButton;    // 获取验证码
@property (weak, nonatomic) IBOutlet UIButton *imageVerifyCodeButton;  // 显示验证码

@property (nonatomic, strong) UIImage   *verifyImage;
@property (nonatomic, copy)   NSString  *safeKey;
@property (nonatomic, assign) NSInteger countDown;
@property (nonatomic, strong) NSTimer   *timer;
@property (nonatomic, assign) NSInteger maxSendSms;
@property (nonatomic, assign) NSInteger sendCount;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sendCount = 0;
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:252/255.0 green:54/255.0 blue:59/255.0 alpha:1];    
    self.loginButtonHeightConstraints.constant = SCALE(55.0);
    self.headerHeightConstraints.constant = SCALE(319);
    self.verifyImage = nil;
    self.agreementButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    [self.imageVerifyCodeButton addTarget:self action:@selector(getImageVerifyCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.getVerifyCodeButton addTarget:self action:@selector(getVerifyCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self loadData];
}


- (void)loadData {
    BaseConfigModel *base = [BaseConfigModel mj_objectWithKeyValues:[[kUserDefaults objectForKey:BaseInfoKey] mj_JSONObject]];
    [self.headerView configBackgroundImage:base.backgroundUrl title:@"授信额度" amount:kFormat(@"%@元", base.regLoanMoney) duration:base.regLoanTime];
    self.view.backgroundColor = [UIColor colorWithHexString:base.backgroundColor];
//    [self.agreementButton setAttributedTitle:contentText forState:UIControlStateNormal];
    self.maxSendSms = [base.maxSendSms integerValue];
    self.sendCount = self.sendCount;
}

- (void)setVerifyImage:(UIImage *)verifyImage {
    _verifyImage = verifyImage;
    [self.imageVerifyCodeButton setBackgroundImage:_verifyImage forState:UIControlStateNormal];
    self.codeInputTopConstraints.constant = _verifyImage ? 64 : 10;
}
- (void)setSendCount:(NSInteger)sendCount {
    _sendCount = sendCount;
    if (_sendCount > self.maxSendSms) {
        [self getImageVerifyCodeAction];
    }
}
#pragma mark - Action

- (IBAction)loginAction:(id)sender {

    if (!self.agreementButton.selected) {
        [SVProgressHUD showErrorWithStatus:@"请阅读用户协议!"];
        return;
    }
    if (self.phoneNumberInput.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }
    if (self.phoneVerifyCode.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    [SVProgressHUD show];
    [iSeeNetworkRequest postUrl:kFormat(@"%@%@", MainUrl, kLogin) params:@{@"UserMobile" : self.phoneNumberInput.text, @"VerifyCode" : self.phoneVerifyCode.text} success:^(id object) {
        
        UserInfoModel *userInfo = [UserInfoModel mj_objectWithKeyValues:object[@"data"]];
        
        [[NSUserDefaults standardUserDefaults] setObject:[userInfo mj_JSONString] forKey:UserInfoKey];
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        [app submitDeviceInfo];
        
        if ([userInfo.userStuatus integerValue] == 1) {
            
            [app goOverdue:[userInfo.userStuatus integerValue]];
            
        }else  {
            
            
            if ([userInfo.loanStatus integerValue] == 1) {
                
                [app goLoanView];
            }else if ([userInfo.loanStatus integerValue] == 3) {
                
                [app goOverdueView];
            }else {
                [app goAuth];
            }
        }
        
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)getImageVerifyCodeAction {
    self.imageVerifyCodeButton.enabled = NO;
    [iSeeNetworkRequest postUrl:kFormat(@"%@%@", MainUrl, kGetImageVerifyCode) params:nil success:^(id object) {
        NSDictionary *data = object[@"data"];
        NSString *base64String = data[@"imageBase"];
        if (base64String.length) {
            NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:base64String options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
            UIImage *decodedImage = [UIImage imageWithData: decodeData];
            if (decodedImage) {
                self.verifyImage = decodedImage;
                self.safeKey = data[@"safeKey"];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"获取图片验证码失败\n请检查网络后重试"];
        }
        self.imageVerifyCodeButton.enabled = YES;
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取图片验证码失败\n请检查网络后重试"];
        self.imageVerifyCodeButton.enabled = YES;
    }];
}
- (IBAction)getVerifyCodeAction:(id)sender {
    if (self.phoneNumberInput.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:self.phoneNumberInput.text forKey:@"UserMobile"];
    if (self.verifyImage && self.safeKey.length) {
        if (self.imageVerifyCode.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入图片验证码"];
            return;
        }
        [parm setObject:self.safeKey forKey:@"SafeKey"];
        [parm setObject:self.imageVerifyCode.text forKey:@"SafeCode"];
    }
    [iSeeNetworkRequest postUrl:kFormat(@"%@%@", MainUrl, kSendPhoneMessage) params:[parm copy] success:^(id object) {
        NSLog(@"%@", object);
        self.sendCount++;
        self.countDown = 60;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
        [SVProgressHUD showSuccessWithStatus:@"验证码已发送"];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.userInfo[@"msg"]];
    }];
}


- (void)countDownAction {
    if (self.countDown > 0) {
        self.getVerifyCodeButton.enabled = NO;
        [self.getVerifyCodeButton setTitle:kFormat(@"%lis", self.countDown) forState:UIControlStateDisabled];
        self.countDown--;
    } else {
        [self.timer invalidate];
        self.getVerifyCodeButton.enabled = YES;
    }
}
- (IBAction)agreementButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        
    }else {
        BaseConfigModel *base = [BaseConfigModel mj_objectWithKeyValues:[[kUserDefaults objectForKey:BaseInfoKey] mj_JSONObject]];
        
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[base.regAgreementConter dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];

        
        RegistAgreementView *view = [[NSBundle mainBundle] loadNibNamed:@"RegistAgreementView" owner:self options:nil].lastObject;
        view.str = attrStr;
        [self.view.window addSubview:view];
        
//        UserDelegateView *view = [[NSBundle mainBundle] loadNibNamed:@"UserDelegateView" owner:self options:nil].lastObject;
//        view.label.attributedText = attrStr;
//        [self.view.window addSubview:view];
    }
}
@end
