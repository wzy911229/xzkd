//
//  LoanViewController.m
//  xzkd
//
//  Created by 刘琛 on 2019/2/28.
//  Copyright © 2019年 xxy. All rights reserved.
//

#import "LoanViewController.h"
#import "LoanAlertView.h"
#import "LoanResultModel.h"
#import <FUMobilePay/FUMobilePay.h>
#import <FUMobilePay/NSString+Extension.h>
#import "RepayMentViewController.h"
#import <UIBarButtonItem+BlocksKit.h>
#import "BankCardAuthViewController.h"
#import "AuthResultViewController.h"
@interface LoanViewController () <LoanAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIButton *loanButton;
@property (weak, nonatomic) IBOutlet UIButton *repaymentButton;
@property (nonatomic, strong) LoanResultModel   *model;
@property (nonatomic, assign) NSInteger payType;
@property (nonatomic, strong) LoanAlertView *alertView;
@property (nonatomic, strong) NSDictionary  *payDic;
@property (nonatomic, assign) BOOL  isRenew;
@end

@implementation LoanViewController{
    NSInteger _userStuatus;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBackButton];
    self.title = @"借款成功";
    self.repaymentButton.layer.borderColor = [UIColor colorWithHex:0xFE4606].CGColor;
    self.repaymentButton.layer.borderWidth = 1;
    //    [self p_setText:@"借款金额：2000元 \n年利率：24% \n还款时间：2019年5月6日 \n到期还款：2009.3元" lineHeight:23 alignment:NSTextAlignmentLeft label:self.contentLabel];
    [self loadData];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"切换银行卡" style:UIBarButtonItemStylePlain handler:^(id sender) {
//        BankCardAuthViewController *bank = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BankCardAuthViewController"];
//        bank.hiddenHeader = YES;
//        [self.navigationController pushViewController:bank animated:YES];
//    }];
    
    
    NSMutableArray * array =[[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    
    if (array.count > 3) {
        [array removeObjectAtIndex:array.count-2];
        [self.navigationController setViewControllers:array animated:YES];
    }
}


- (void)loadData {
    [iSeeNetworkRequest postWithHeaderUrl:kFormat(@"%@%@", MainUrl, kGetLoanInfo) params:@{} success:^(id object) {
        self.model = [LoanResultModel mj_objectWithKeyValues:object[@"data"]];
        [self p_setText:kFormat(@"借款金额：%.0f元 \n年利率：%@%% \n还款时间：%@ \n到期还款：%.2f元", self.model.loanMoney, self.model.yearRate, self.model.repayTime, self.model.repayMoney) lineHeight:23 alignment:NSTextAlignmentLeft label:self.contentLabel];
    } failure:^(NSError *error) {
        [error showInSVProgressHUD];
    }];
}
- (void)p_setText:(NSString *)text
       lineHeight:(CGFloat)lineHeight
        alignment:(NSTextAlignment)aliment
            label:(UILabel *)label {
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = aliment;
    paragraphStyle.maximumLineHeight = lineHeight;
    paragraphStyle.minimumLineHeight = lineHeight;
    label.attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
}

- (IBAction)loanAction:(id)sender {
    self.payType = 2;
    [SVProgressHUD show];
    self.isRenew = YES;
 [iSeeNetworkRequest postWithHeaderUrl:kFormat(@"%@%@", MainUrl, kRenewPayment) params:nil success:^(id object) {
        [SVProgressHUD dismiss];
        self.payDic = object[@"data"];
        self.alertView.serviceMoney = [self.payDic[@"amt"] doubleValue];
        [self.alertView show];
    } failure:^(NSError *error) {
        [error showInSVProgressHUD];
    }];
}
- (IBAction)repaymentButtonAction:(id)sender {
    self.payType = 1;
    self.isRenew = false;
    [SVProgressHUD show];
    __weak typeof(self) weakSelf = self;
    [iSeeNetworkRequest postWithHeaderUrl:kFormat(@"%@%@", MainUrl, kPayment) params:nil success:^(id object) {
        [SVProgressHUD dismiss];
        [weakSelf showPayAler];
    } failure:^(NSError *error) {
        [error showInSVProgressHUD];
    }];
}



- (void)paySmsConfirm:(NSString*)VerifyCode{
    NSDictionary*parama = @{ @"VerifyCode":VerifyCode };
    [SVProgressHUD show];
    [iSeeNetworkRequest postWithHeaderUrl:kFormat(@"%@%@", MainUrl, KQuickPaySmsConfirm) params:parama success:^(id object) {
        [SVProgressHUD dismiss];
        RepayMentViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RepayMentViewController"];
        if ( self.isRenew) {
            vc.navTitle = @"展期成功";
        }
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSError *error) {
        [error showInSVProgressHUD];
    }];
}


- (LoanAlertView *)alertView {
    if (!_alertView) {
        _alertView = [[LoanAlertView alloc] init];
        _alertView.delegate = self;
    }
    return _alertView;
}

- (void)loanAlertViewAction {
    
    
    [self showPayAler];

    
//    AuthResultViewController *vc = (AuthResultViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AuthResultViewController"];
////    vc.userStuatus = 1;
//    vc.loanType = 1;
//    [self.navigationController pushViewController:vc animated:YES];
    
}



- (void)showPayAler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入验证码" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"验证码";
    }];
    
    __weak typeof(self) weakSelf = self;
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *envirnmentNameTextField = alertController.textFields.firstObject;
        [weakSelf paySmsConfirm:envirnmentNameTextField.text];
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
                    
        
    }]] ;
    
    [self presentViewController:alertController animated:true completion:nil];
    
}

@end

