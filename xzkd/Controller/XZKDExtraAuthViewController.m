//
//  XZKDExtraAuthViewController.m
//  xzkd
//
//  Created by zhiyu on 2019/6/18.
//  Copyright © 2019 xxy. All rights reserved.
//

#import "XZKDExtraAuthViewController.h"
#import "XZExtraAuthView.h"
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBookDefines.h>
#import <AddressBook/ABRecord.h>
#import "XZAddressBookViewController.h"
#import "XZUDIDService.h"
@interface XZKDExtraAuthViewController ()<XZExtraAuthViewEventDelegate,XZAddressBookViewControllerDelegate>
@property (nonatomic, strong) NSMutableArray *addressBookArray;

@end

@implementation XZKDExtraAuthViewController {
    UIButton *_linkManBtn;
    NSArray *_linkMans;

}

- (void)loadView{
    [super loadView];
    XZExtraAuthView * authView = [[XZExtraAuthView alloc] init];
    authView.delegate = self;
    [self.view addSubview:authView];
    [authView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"附加认证";
    self.navigationController.navigationBar.topItem.title = @"";

    // Do any additional setup after loading the view.
}


- (void)addressBookViewControllerFinishSelectLinkMans:(NSArray *)LinkMans {
    _linkManBtn.hidden = YES;
    _linkMans = LinkMans;
}


- (void)extraAuthViewOnPressAddressBook:(UIButton *)btn {
    _linkManBtn = btn;
    [self requestContactAuthorAfterSystemVersion];
}

- (void)extraAuthViewOnPressSure:(NSDictionary *)addressInfo {
    
    if (!_linkMans || _linkMans.count<=0) {
        [SVProgressHUD showInfoWithStatus:@"请添加紧急联系人"];
        return;
    }
    
    NSError *error;
    NSData *jsonDAta = [NSJSONSerialization dataWithJSONObject:_linkMans options:NSJSONWritingPrettyPrinted error:&error];
    if (!jsonDAta) {
        [SVProgressHUD showErrorWithStatus:@"数据设置失败，请退出重新认证"];
        return;
    }
    NSString * jsonString = [[NSString alloc]initWithData:jsonDAta encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:addressInfo];
    
    [params setObject:jsonString forKey:@"e_contacts"];
    
    __weak typeof(self) weakSelf = self;
    [XZUDIDService submiteExtraInfo:params result:^(BOOL success, id data, NSError *responseError) {
        if (success) {
            [SVProgressHUD showSuccessWithStatus:@"附加认证成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            if (self.delegate && [self.delegate respondsToSelector:@selector(extraAuthSuccess)]) {
                [self.delegate extraAuthSuccess];
            }

        }else{
            [SVProgressHUD showSuccessWithStatus:@"附加认证失败，请重试"];
        }
    }];
    
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
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
    
    [self.addressBookArray removeAllObjects];
    
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
            if ([nameStr isEqualToString:@""]) {
                [tongxunDic setObject:@"未知联系人" forKey:@"name"];
            }else{
                [tongxunDic setObject:nameStr forKey:@"name"];
            }
            [tongxunDic setObject:[NSArray arrayWithObject:string] forKey:@"phoneList"];
            [self.addressBookArray addObject:tongxunDic];
        }
        
        
    }];
    
    XZAddressBookViewController * addressBookVc = [XZAddressBookViewController new];
    addressBookVc.addressBooks = self.addressBookArray;
    addressBookVc.delegate =self;
    [addressBookVc.view setFrame:self.view.bounds];
    [self addChildViewController:addressBookVc];
    [self.navigationController pushViewController:addressBookVc animated:YES];
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




- (NSMutableArray *)addressBookArray {
    if (!_addressBookArray) {
        _addressBookArray = [[NSMutableArray alloc] init];
    }
    return _addressBookArray;
}
@end
