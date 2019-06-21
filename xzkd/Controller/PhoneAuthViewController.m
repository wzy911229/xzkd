//
//  PhoneAuthViewController.m
//  xzkd
//
//  Created by 刘琛 on 2019/2/28.
//  Copyright © 2019年 xxy. All rights reserved.
//

#import "PhoneAuthViewController.h"
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBookDefines.h>
#import <AddressBook/ABRecord.h>
#import "AuthScheduleView.h"
#import "BankCardAuthViewController.h"
#import "XZUDIDService.h"
#import "XZWebviewController.h"
#import "Md5.h"

static NSString *const XYBaseURL = @"https://qz.xinyan.com/h5";
static NSString *const XYApiUser = @"8150735681";
static NSString *const XYApiName = @"carrier";
static NSString *const XYApiKey = @"6IZa38b97662d299";
static NSString *const XYheadVisible = @"0";


@interface PhoneAuthViewController ()
@property (weak, nonatomic) IBOutlet UIButton *detailListButton;
@property (weak, nonatomic) IBOutlet UIButton *getPhoneList;
@property (nonatomic, strong) NSMutableArray *tongxunArray;
@property (nonatomic, strong) AuthScheduleView *header;
@property (weak, nonatomic) IBOutlet UIView *headBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headBackViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (nonatomic, assign) BOOL flag1;
@property (nonatomic, assign) BOOL flag2;

@property (nonatomic, strong) NSString * taskId;
@property (nonatomic, strong) NSString * jumpUrl;

@end

@implementation PhoneAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.flag2 = NO;
    self.flag1 = NO;
    self.title = @"运营商验证";
    [self initBackButton];
    self.getPhoneList.layer.borderColor = [UIColor colorWithHex:0xFE4606].CGColor;
    self.getPhoneList.layer.borderWidth = 1;
    if (_hiddenHeader) {
        
        _headBackView.hidden = YES;
        _headBackViewHeight.constant = 0;
        
    }else {
        
        _header = [[NSBundle mainBundle] loadNibNamed:@"AuthScheduleView" owner:self options:nil].lastObject;
        _header.statusType = 1;
        [_headBackView addSubview:_header];
    }
    
    [self requestTaskInfo];
    
}

- (void)requestTaskInfo {
    __weak typeof(self) weakSelf = self;
    [XZUDIDService requestForTaskId:^(BOOL success, NSDictionary * data, NSError *responseError) {
        if (success && [data.allKeys containsObject:@"data"] ) {
            NSDictionary *taskInfo = data[@"data"];
            NSString *taskId = taskInfo[@"taskId"];
            NSString *jumpUrl = taskInfo[@"jumpUrl"];
            weakSelf.taskId = taskId;
            weakSelf.jumpUrl = jumpUrl;
        }
    }];
}


- (IBAction)nextAction:(id)sender {
    BankCardAuthViewController *bank = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BankCardAuthViewController"];
    bank.hiddenHeader = YES;
    bank.authModel = self.authModel;
    [self.navigationController pushViewController:bank animated:YES];
}

- (NSMutableArray *)tongxunArray {
    if (!_tongxunArray) {
        _tongxunArray = [[NSMutableArray alloc] init];
    }
    return _tongxunArray;
}
- (IBAction)getTXLAction:(id)sender {
    [self requestContactAuthorAfterSystemVersion];
}

- (void)setFlag1:(BOOL)flag1 {
    _flag1 = flag1;
    self.nextBtn.enabled = _flag1 && self.flag2;
}
- (void)setFlag2:(BOOL)flag2 {
    _flag2 = flag2;
    self.nextBtn.enabled = _flag2 && self.flag1;
}

//请求通讯录权限
#pragma mark 请求通讯录权限
- (void)requestContactAuthorAfterSystemVersion{
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined) {
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError*  _Nullable error) {
            if (error) {
                NSLog(@"授权失败");
            }else {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self openContact];
                });
            }
        }];
    }
    else if(status == CNAuthorizationStatusRestricted)
    {
        NSLog(@"用户拒绝");
        [self showAlertViewAboutNotAuthorAccessContact];
    }
    else if (status == CNAuthorizationStatusDenied)
    {
        NSLog(@"用户拒绝");
        [self showAlertViewAboutNotAuthorAccessContact];
    }
    else if (status == CNAuthorizationStatusAuthorized)//已经授权
    {
        //有通讯录权限-- 进行下一步操作
        [self openContact];
    }
    
}

//有通讯录权限-- 进行下一步操作
- (void)openContact{
    // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    
    [self.tongxunArray removeAllObjects];
    
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        NSString *nameStr = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
        NSArray *phoneNumbers = contact.phoneNumbers;
        for (CNLabeledValue *labelValue in phoneNumbers) {
            CNPhoneNumber *phoneNumber = labelValue.value;
            
            NSString * string = phoneNumber.stringValue;
            string = [string stringByReplacingOccurrencesOfString:@"+86" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSMutableDictionary *tongxunDic = [NSMutableDictionary dictionary];
            [tongxunDic setObject:nameStr forKey:@"name"];
            [tongxunDic setObject:[NSArray arrayWithObject:string] forKey:@"phoneList"];
            [self.tongxunArray addObject:tongxunDic];
        }
        
    }];
    
    NSString *str = [[self.tongxunArray mj_JSONString] mj_JSONString];
    [iSeeNetworkRequest postWithHeaderUrl:kFormat(@"%@%@", MainUrl, kUserMails) params:@{@"Mails" : str} success:^(id object) {
        [SVProgressHUD showSuccessWithStatus:@"获取成功"];
        self.flag2 = YES;
        self.authModel.mailAuth = @(1);
        self.getPhoneList.hidden = true;
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"上传失败"];
        self.authModel.mailAuth = @(2);
        self.flag1 = NO;
    }];
    
}




//提示没有通讯录权限
- (void)showAlertViewAboutNotAuthorAccessContact{
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"请授权通讯录权限"
                                          message:@"请在iPhone的\"设置-隐私-通讯录\"选项中,允许小猪时贷访问你的通讯录"
                                          preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:OKAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark jump to webview

- (IBAction)carrierImportClick:(id)sender {
    if (_taskId && _jumpUrl) {
        
        NSString *apiEnc = [NSString stringWithFormat:@"%@%@%@%@%@",XYApiUser, self.getTimeString, XYApiName, _taskId, XYApiKey];
        NSString * url = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@?headVisible=%@&jumpUrl=%@",XYBaseURL, XYApiUser, [Md5 encodeToLowerCase:apiEnc],[self getTimeString] ,XYApiName,_taskId, XYheadVisible, [self stringURLEecode:_jumpUrl]];
        
        XZWebviewController *webVc = [XZWebviewController new];
        webVc.stringUrl = url;
        self.flag1 = YES;
        [self.navigationController pushViewController:webVc animated:YES];
        return;
    }
    [SVProgressHUD showErrorWithStatus:@"运营商信息获取失败，请退出重试"];
}




- (NSString *)getTimeString{
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
    
    NSString* string=[dateFormat stringFromDate:[NSDate date]];
    
    return string;
    
}



- (NSString *)stringURLEecode:(NSString *)string{
    NSString *decoded = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)string, CFSTR(""), kCFStringEncodingUTF8);
    return decoded;
}

@end
