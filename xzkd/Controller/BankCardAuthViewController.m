//
//  BankCardAuthViewController.m
//  xzkd
//
//  Created by 刘琛 on 2019/2/28.
//  Copyright © 2019年 xxy. All rights reserved.
//

#import "BankCardAuthViewController.h"
#import "AuthScheduleView.h"
@interface BankCardAuthViewController ()


@property (nonatomic, strong) AuthScheduleView *header;
@property (weak, nonatomic) IBOutlet UIView *headBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headBackViewHeight;




@property (weak, nonatomic) IBOutlet UITextField *bankCardID;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *idCardNum;
@property (weak, nonatomic) IBOutlet UITextField *phone;

@end

@implementation BankCardAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"银行卡认证";
    [self initBackButton];
    if (_hiddenHeader) {
        
        _headBackView.hidden = YES;
        _headBackViewHeight.constant = 0;
        
    }else {
        
        _header = [[NSBundle mainBundle] loadNibNamed:@"AuthScheduleView" owner:self options:nil].lastObject;
        _header.statusType = 2;
        [_headBackView addSubview:_header];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)submitButtonAction:(UIButton *)sender {
    if (self.bankCardID.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入银行卡号"];
        return;
    }
    if (self.userName.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入持卡人姓名"];
        return;
    }
    if (self.idCardNum.text.length != 18 && self.idCardNum.text.length != 15) {
        [SVProgressHUD showErrorWithStatus:@"请检查身份证号"];
        return;
    }
    if (self.phone.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }
    [SVProgressHUD show];
    __weak typeof(self) weakSelf = self;
    [iSeeNetworkRequest postWithHeaderUrl:kFormat(@"%@%@", MainUrl, kPostBankInfo)
                                   params:@{
                                            @"BankAccountNo" : self.bankCardID.text,
                                            @"RealName" : self.userName.text,
                                            @"IDCardNo" : self.idCardNum.text,
                                            @"MobileNo" : self.phone.text
                                            }
                                  success:^(id object) {
                                      [SVProgressHUD showSuccessWithStatus:@"提交成功"];
                                      if (weakSelf.authModel) {
                                          weakSelf.authModel.bankAuth = @(3);
                                      }
                                      [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                                      if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(bankCardAuthSuccess)]) {
                                          [weakSelf.delegate bankCardAuthSuccess];
                                      }
                                  }
                                  failure:^(NSError *error) {
                                      [SVProgressHUD showErrorWithStatus:@"提交失败"];
                                      weakSelf.authModel.bankAuth = @(2);
                                  }];
}

@end
