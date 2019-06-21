//
//  OverdueViewController.m
//  xzkd
//
//  Created by 刘琛 on 2019/2/28.
//  Copyright © 2019年 xxy. All rights reserved.
//

#import "OverdueViewController.h"
#import "LoanResultModel.h"
#import <FUMobilePay/FUMobilePay.h>
#import <FUMobilePay/NSString+Extension.h>
#import "RepayMentViewController.h"
@interface OverdueViewController () <FYPayDelegate>
@property (weak, nonatomic) IBOutlet UILabel *overdueLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel1;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel2;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel3;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel4;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel5;
@property (weak, nonatomic) IBOutlet UIButton *repayment;

@property (nonatomic, strong) LoanResultModel   *model;
@end

@implementation OverdueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"逾期";
    [self initBackButton];
    [self loadData];
    
}

- (void)loadData {
    [iSeeNetworkRequest postWithHeaderUrl:kFormat(@"%@%@", MainUrl, kGetLoanInfo) params:@{} success:^(id object) {
        self.model = [LoanResultModel mj_objectWithKeyValues:object[@"data"]];
        self.valueLabel1.text = self.model.repayTime;
        self.valueLabel2.text = kFormat(@"%.2f元", self.model.repayMoney);
        self.valueLabel3.text = kFormat(@"%.2f元", self.model.loanMoney);
        self.valueLabel4.text = kFormat(@"%.2f元", self.model.interestMoney);
        self.valueLabel5.text = kFormat(@"%.2f元", self.model.overdueMoney);
        self.overdueLabel.text = kFormat(@"%li天", self.model.overdueDay);
    } failure:^(NSError *error) {
        [error showInSVProgressHUD];
    }];
}
- (IBAction)repaymentButtonAction:(id)sender {
    [SVProgressHUD show];
    [iSeeNetworkRequest postWithHeaderUrl:kFormat(@"%@%@", MainUrl, kLoanPayment) params:@{@"loanType" : @(1)} success:^(id object) {
        [SVProgressHUD dismiss];
        [self pay:object[@"data"]];
    } failure:^(NSError *error) {
        [error showInSVProgressHUD];
    }];
}


- (void)pay:(NSDictionary *)dic {
    
    NSString * myVERSION = [NSString stringWithFormat:@"2.0"];
    NSString * myMCHNTCD = kFormat(@"%@", dic[@"mchntCd"]);
    NSString * myMCHNTORDERID = kFormat(@"%@", dic[@"orderId"]);
    NSString * myUSERID = kFormat(@"%@", dic[@"userId"]);
    NSString * myAMT = kFormat(@"%@", dic[@"amt"]);
    NSString * myBANKCARD = kFormat(@"%@", dic[@"cardNo"]);
    NSString * myBACKURL = kFormat(@"%@", dic[@"backUrl"]);
    NSString * myNAME = kFormat(@"%@", dic[@"userName"]);
    NSString * myIDNO = kFormat(@"%@", dic[@"idNo"]);
    NSString * myIDTYPE = kFormat(@"%@", dic[@"IDCardType"]);
    NSString * myTYPE = [NSString stringWithFormat:@"02"];
    NSString * mySIGNTP = [NSString stringWithFormat:@"MD5"];
    //商户号秘钥  必填
    NSString * myMCHNTCDKEY= kFormat(@"%@", dic[@"key"]);
    NSString * mySIGN = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@", myTYPE,myVERSION,myMCHNTCD,myMCHNTORDERID,myUSERID,myAMT,myBANKCARD,myBACKURL,myNAME,myIDNO,myIDTYPE,myMCHNTCDKEY];
    mySIGN = [mySIGN MD5String];
    
    //添加环境参数  BOOL 变量 @"TEST"   YES 是测试  NO 是生产
    BOOL test = NO;
    NSNumber * testNumber = [NSNumber numberWithBool:test];
    NSDictionary * dicD = @{@"TYPE":myTYPE,@"VERSION":myVERSION,@"MCHNTCD":myMCHNTCD,@"MCHNTORDERID":myMCHNTORDERID,@"USERID":myUSERID,@"AMT":myAMT,@"BANKCARD":myBANKCARD,@"BACKURL":myBACKURL,@"NAME":myNAME,@"IDNO":myIDNO,@"IDTYPE":myIDTYPE,@"SIGNTP":mySIGNTP,@"SIGN":mySIGN , @"TEST" : testNumber} ;
    NSLog(@"😄dicD =%@ " , dicD);
    
    FUMobilePay * pay = [FUMobilePay shareInstance];
    if([pay respondsToSelector:@selector(mobilePay:delegate:)])
        [pay performSelector:@selector(mobilePay:delegate:) withObject:dicD withObject:self];
}

-(void)payCallBack:(BOOL) success responseParams:(NSDictionary*) responseParams{
    NSInteger responseCode = [responseParams[@"RESPONSECODE"] integerValue];
    if (responseCode == 0) {
        //成功
        
        RepayMentViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RepayMentViewController"];
        vc.canReLoan = NO;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
        //失败
        [SVProgressHUD showErrorWithStatus:@"支付失败"];
    }
}
@end
