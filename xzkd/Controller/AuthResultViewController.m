//
//  AuthResultViewController.m
//  xzkd
//
//  Created by 刘琛 on 2019/2/28.
//  Copyright © 2019年 xxy. All rights reserved.
//

#import "AuthResultViewController.h"
#import "LoanConfigModel.h"
#import "LoanViewController.h"
#import "RepayMentViewController.h"
#import "AppDelegate.h"

@interface AuthResultViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation AuthResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"审核结果";
    [self initBackButton];
    [self loadData];
    
    NSMutableArray * array =[[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    if (array.count > 3) {
        [array removeObjectAtIndex:array.count-2];
        [self.navigationController setViewControllers:array animated:YES];
    }
}

- (void)loadData {
    if (self.userStuatus) {
        self.iconImageView.image = Image(@"icon_failure");
        [self p_setText:@"很遗憾， \n您的借款申请未获通过！" lineHeight:28 alignment:NSTextAlignmentCenter label:self.titleLabel];
        [self p_setText:@"" lineHeight:23 alignment:NSTextAlignmentLeft label:self.contentLabel];
        self.submitButton.hidden = YES;
        return;
    }
    [iSeeNetworkRequest postWithHeaderUrl:kFormat(@"%@%@", MainUrl, kGetLoanConfig) params:@{} success:^(id object) {
        
        LoanConfigModel *model = [LoanConfigModel mj_objectWithKeyValues:object[@"data"]];
        if (model.loanMoney) {
            self.iconImageView.image = Image(@"icon_success");
            [self p_setText:kFormat(@"恭喜！您的申请已通过，\n 借款额度%li元", model.loanMoney) lineHeight:28 alignment:NSTextAlignmentCenter label:self.titleLabel];
            NSString *contentString = kFormat(@"借款金额：%li元 \n年利率：%.1f%% \n服务费：%li元 \n到账金额：%li元 \n还款时间：%@", model.loanMoney, model.yearRate, model.serviceMoney, model.loanMoney - model.serviceMoney, [model.repayDate dateStringWithFormat:@"yyyy-MM-dd"]);
            [self p_setText:contentString lineHeight:23 alignment:NSTextAlignmentLeft label:self.contentLabel];
            self.submitButton.hidden = NO;
        } else {
            self.iconImageView.image = Image(@"icon_failure");
            [self p_setText:@"很遗憾， \n您的借款申请未获通过！" lineHeight:28 alignment:NSTextAlignmentCenter label:self.titleLabel];
            [self p_setText:@"" lineHeight:23 alignment:NSTextAlignmentLeft label:self.contentLabel];
            self.submitButton.hidden = YES;
        }
    } failure:^(NSError *error) {
        [error showInSVProgressHUD];
    }];
}


- (void)setUserStuatus:(NSInteger)userStuatus {
    _userStuatus = userStuatus;
    [self loadData];
}

- (IBAction)buttonAction:(UIButton *)sender {
    [SVProgressHUD show];
    self.loanType == 0 ? [self requestTOSubmitLoan] : [self requestTOLoadRenewPayment];
 
}



- (void)requestTOSubmitLoan {
    __weak typeof (self) weakSelf = self;
    [iSeeNetworkRequest postWithHeaderUrl:kFormat(@"%@%@", MainUrl, kSubmitLoan) params:@{} success:^(id object) {
        [SVProgressHUD dismiss];
        LoanViewController *vc = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"LoanViewController"];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSError *error) {
        [error showInSVProgressHUD];
    }];
    
}



- (void)requestTOLoadRenewPayment {
    __weak typeof (self) weakSelf = self;
    [iSeeNetworkRequest postWithHeaderUrl:kFormat(@"%@%@", MainUrl, kRenewPayment) params:nil success:^(id object) {
        [SVProgressHUD dismiss];
        [weakSelf showPayAler];
    } failure:^(NSError *error) {
        [error showInSVProgressHUD];
    }];
    
}



- (void)paySmsConfirm:(NSString*)VerifyCode {
    NSDictionary*parama = @{ @"VerifyCode":VerifyCode };
    [SVProgressHUD show];
    [iSeeNetworkRequest postWithHeaderUrl:kFormat(@"%@%@", MainUrl, KQuickPaySmsConfirm) params:parama success:^(id object) {
        [SVProgressHUD dismiss];
    
        [SVProgressHUD showSuccessWithStatus:@"展期成功"];
        [(AppDelegate *)kApplicationDelegate goAuth];
        
    } failure:^(NSError *error) {
        [error showInSVProgressHUD];
    }];
    
}




- (void)initBackButton{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(didBack)];
}


- (void)didBack {
    [self.navigationController popToRootViewControllerAnimated:YES];
    
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
