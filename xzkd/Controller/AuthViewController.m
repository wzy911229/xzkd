//
//  AuthViewController.m
//  xzkd
//
//  Created by 刘琛 on 2019/2/28.
//  Copyright © 2019年 xxy. All rights reserved.
//

#import "AuthViewController.h"
#import "AuthViewTableCell.h"
#import "UserInfoAuthViewController.h"
#import "PhoneAuthViewController.h"
#import "BankCardAuthViewController.h"
#import "UserInfoModel.h"
#import "AuthStatusModel.h"
#import "AuthResultViewController.h"
#import "XZUDIDManager.h"
#import "XZUDIDService.h"
#import "XZKDExtraAuthViewController.h"
#import "LoanViewController.h"

static NSString * const KSESSIONID_KEY = @"session_id";


@interface AuthViewController ()<UITableViewDelegate,UITableViewDataSource, XZUDIDManagerDelegate, XZKDExtraAuthViewControllerDelegate,BankCardAuthViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, strong) AuthStatusModel *model;

@property (nonatomic, strong) AFHTTPSessionManager *afSessionManager;
@property (nonatomic, strong) XZUDIDManager *ocrManager;


//保持用户信息认证
@property (nonatomic, strong) NSDictionary *userInfo;

@property (nonatomic, strong)  NSDictionary *liveness;

@property (nonatomic, strong)  NSDictionary *userCompareInfo;



@end

@implementation AuthViewController

static NSString *authViewTableCellIdentify = @"AuthViewTableCellIdentify";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"认证";
    
    _titleArray = @[@"个人信息",@"人脸识别",@"紧急联系人",@"运营商认证",@"银行认证"];
    _imageArray = @[@"grxx", @"htrz" ,@"excess_deal_icon",@"yys",@"bdyhk"];
    
    _table.delegate = self;
    _table.dataSource = self;
    [_table registerNib:[UINib nibWithNibName:@"AuthViewTableCell" bundle:nil] forCellReuseIdentifier:authViewTableCellIdentify];
    _table.scrollEnabled = NO;
    
    if (@available(iOS 11.0, *)) {
        self.table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _afSessionManager = [AFHTTPSessionManager manager];
    _ocrManager = [[XZUDIDManager alloc] initWithDelegate:self];
    [SVProgressHUD  setMinimumDismissTimeInterval:0.5];
    
    self.view.backgroundColor = kBaseViewColor;
    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getUserAuthStatus];

}


#pragma mark table
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AuthViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:authViewTableCellIdentify forIndexPath:indexPath];
    cell.image.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    cell.titleLabel.text = _titleArray[indexPath.row];
    
    switch (indexPath.row) {
        case 0:
            cell.stateType = _model.userInfoAuth;
            break;
        case 1:
            cell.stateType = _model.liveAuth;
            break;
        case 2:
            //todo: 附加认证
            cell.stateType = _model.OtherAuth;
            break;
        case 3:
        {
            if ([_model.operatorAuth integerValue] == 1 && [_model.mailAuth integerValue] == 1) {
                cell.stateType = @1;
            }else if([_model.operatorAuth integerValue] == 3 || [_model.mailAuth integerValue] == 3){
                cell.stateType = @3;
            }else{
                cell.stateType = @0;
            }
        }
            
            break;
        case 4:
            cell.stateType = _model.bankAuth;
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            [self startOCROauth];
            break;
        case 1:
            [self startLivenessFlow];;
            break;
        case 2:
            [self startExtraAuth];
            break;
        case 3:
            [self startPhoneAuth];
            
            break;
        case 4:
            [self startBankCardAuth];
            break;
        default:
            break;
    }
    
}

#pragma mark - taps


//身份认证
- (void)startOCROauth{
    if ([_model.userInfoAuth integerValue] != 1 && [_model.userInfoAuth integerValue] != 3 ) {
        [_ocrManager startOCR:self];
    }else {
        [SVProgressHUD showInfoWithStatus:  [_model.userInfoAuth integerValue] == 1  ? @"已认证" : @"认证中"];
    }
}

//活体
- (void)startLivenessFlow{
    
    if([_model.userInfoAuth integerValue] != 1){
        [SVProgressHUD showInfoWithStatus: @"请先进行个人信息认证"];
        return;
    }
   
    
    if ([_model.liveAuth integerValue] != 1  && [_model.liveAuth integerValue] != 3) {
        
        if (!_userCompareInfo) {
            [_ocrManager startOCR:self];
            return;
        }
        [_ocrManager startLivenessFlow:self];
        
    }else{
        [SVProgressHUD showInfoWithStatus:  [_model.liveAuth integerValue] == 1  ? @"已认证" : @"认证中"];
    }
    
}

//附加
- (void)startExtraAuth {
    if ([_model.OtherAuth integerValue] != 1 && [_model.OtherAuth integerValue] != 3 ) {
        XZKDExtraAuthViewController *extraVc = [XZKDExtraAuthViewController new];
        extraVc.delegate = self;
        [self.navigationController pushViewController:extraVc animated:YES];
    }else {
        [SVProgressHUD showInfoWithStatus:  [_model.OtherAuth integerValue] == 1  ? @"已认证" : @"认证中"];
    }
}


//银行卡
- (void)startBankCardAuth {
    if ([_model.bankAuth integerValue] != 1 && [_model.bankAuth integerValue] != 3 ) {
        BankCardAuthViewController *bank = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BankCardAuthViewController"];
        bank.hiddenHeader = YES;
        bank.authModel = self.model;
        [self.navigationController pushViewController:bank animated:YES];
    }else {
        [SVProgressHUD showInfoWithStatus:  [_model.bankAuth integerValue] == 1  ? @"已认证" : @"认证中"];
    }
}

//运营商认证
- (void)startPhoneAuth{
    if ([_model.operatorAuth integerValue] != 1 || [_model.mailAuth integerValue] != 1) {
        PhoneAuthViewController *phone = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PhoneAuthViewController"];
        phone.hiddenHeader = YES;
        phone.authModel = self.model;
        [self.navigationController pushViewController:phone animated:YES];
    }else {
        [SVProgressHUD showInfoWithStatus: @"已认证" ];
    }
}




#pragma mark - Delegate

// 身份证
- (void)ocrFinishedResult:(UDIDEngineResult)result UserInfo:(NSDictionary *)userInfo {
    _userInfo = userInfo;
    //处理身份结果
    if( !_userInfo || ([_userInfo.allKeys containsObject:@"success"] && !_userInfo[@"success"]) ){
        [self resumeUserCompareWithMessage:0 error:KOCR_FAILURE];
        return;
    }else if(_userInfo &&  [_userInfo.allKeys containsObject:@"validity_period_expired"] && [_userInfo[@"validity_period_expired"] isEqualToString:@"1"] ){
        [self resumeUserCompareWithMessage:0 error:KOCR_FAILURE_EXPIRED];
        return;
    }
    
    [_ocrManager startUserCompare:_userInfo[@"id_name"]
                  compareIDNumber:_userInfo[@"id_number"]
                        sessionId:_userInfo[@"session_id"]
                   viewController:self];
    
    
}

//活体
-(void)livenessFlowFinishedResult:(UDIDEngineResult)result UserInfo:(NSDictionary *)userInfo {
    _liveness = userInfo;
    //处理活体结果
    if( !_liveness || ([_liveness.allKeys containsObject:@"success"] && !_liveness[@"success"]) ){
        [self resumeUserCompareWithMessage:1 error:KLIVE_FAILURE];
        return;
    }
    
    
    __weak typeof(self) weakSelf = self;
    [XZUDIDService submiteLivingInfo:_userCompareInfo result:^(BOOL success, id data, NSError *responseError) {
        if(success){
            weakSelf.model.liveAuth =@1;
            [weakSelf.table reloadData];
            [SVProgressHUD showSuccessWithStatus:KLIVE_SUCCESS];
        }else{
            [SVProgressHUD showErrorWithStatus:KLIVE_FAILURE];
        }
        
    }];
}




- (void)userCompareFinishedResult:(UDIDEngineResult)result UserInfo:(NSDictionary *)userInfo{
    
    
}

- (void)faceCompareFinishedResult:(UDIDEngineResult)result UserInfo:(NSDictionary*)userInfo {
    //处理对比结果
    if( !userInfo || ([userInfo.allKeys containsObject:@"success"] && !userInfo[@"success"]) ){
        [self resumeUserCompareWithMessage:0 error:KFACECOMPARE_FAILURE];
        return;
    }else if ([userInfo.allKeys containsObject:@"verify_status"] && [userInfo[@"verify_status"] isEqualToString:@"2"]){
        [self resumeUserCompareWithMessage:0 error:KFACECOMPARE_VERIFY_FAILURE_02];
        return;
    }else if ([userInfo.allKeys containsObject:@"verify_status"] && [userInfo[@"verify_status"] isEqualToString:@"3"]){
        [self resumeUserCompareWithMessage:0 error:KFACECOMPARE_VERIFY_FAILURE_03];
        return;
    }else if ([userInfo.allKeys containsObject:@"result_status"] && [userInfo[@"result_status"] isEqualToString:@"02"]){
        [self resumeUserCompareWithMessage:0 error:KFACECOMPARE_RESULT_FAILURE_02];
        return;
    }else if ([userInfo.allKeys containsObject:@"result_status"] && [userInfo[@"result_status"] isEqualToString:@"03"]){
        [self resumeUserCompareWithMessage:0 error:KFACECOMPARE_RESULT_FAILURE_03];
        
        return;
    }else if ([userInfo.allKeys containsObject:@"result_status"] && [userInfo[@"result_status"] isEqualToString:@"04"]){
        [self resumeUserCompareWithMessage:0 error:KFACECOMPARE_RESULT_FAILURE_04];
        return;
    }else if ([userInfo.allKeys containsObject:@"result_status"] && [userInfo[@"result_status"] isEqualToString:@"05"]){
        [self resumeUserCompareWithMessage:0 error:KFACECOMPARE_RESULT_FAILURE_05];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    _userCompareInfo = userInfo;
    [XZUDIDService submiteUserInfo:_userInfo result:^(BOOL success, id data, NSError *responseError) {
        if (success) {
            weakSelf.model.userInfoAuth = @1;
            [weakSelf.table reloadData];
            [weakSelf startLivenessFlow];
        }else{
            [SVProgressHUD showSuccessWithStatus:KOCR_SUCCESS];
        }
    }];
    
}




- (void)extraAuthSuccess{
    _model.OtherAuth = @1;
    [_table reloadData];
    
}

- (void)bankCardAuthSuccess{
    _model.bankAuth = @1;
    [_table reloadData];
}


- (void)resumeUserCompareWithMessage:(NSInteger)type error:(NSString*)errorMsg{
    if (errorMsg) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
    }
    switch (type) {
        case 0:
            [self startOCROauth];
            break;
        case 1:
            [self startLivenessFlow];
            break;
        default:
            break;
    }
    
}

#pragma mark - event
- (IBAction)submitButtonAction:(id)sender {
    [SVProgressHUD show];
    [iSeeNetworkRequest postWithHeaderUrl:[MainUrl stringByAppendingPathComponent:@"api/User/GetAuthScore"] params:@{} success:^(id object) {
        [SVProgressHUD dismiss];
        AuthResultViewController *vc = (AuthResultViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AuthResultViewController"];
        vc.userStuatus = [self.model.userStuatus integerValue];
        vc.loanType = 0;
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        AuthResultViewController *vc = (AuthResultViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AuthResultViewController"];
        vc.userStuatus = 1;
        vc.loanType = 0;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)getUserAuthStatus {
    
    [iSeeNetworkRequest postWithHeaderUrl:kFormat(@"%@%@", MainUrl, kGetUserAuthStatus) params:[NSDictionary dictionary] success:^(id object) {
        
        self.model = [AuthStatusModel mj_objectWithKeyValues:object[@"data"]];
        [self.table reloadData];
        self.submitButton.enabled = self.model.allAuthSuccess;
        self.submitButton.backgroundColor = self.model.allAuthSuccess ? [UIColor colorWithHex:0xFE4606] : [UIColor colorWithHex:0xd0d0d0];

        
        if ([self.model.repayStatus integerValue] == 1) {
            LoanViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"LoanViewController"];
            [self.navigationController pushViewController:vc animated:YES];
            return ;
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}


@end
