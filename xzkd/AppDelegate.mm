//
//  AppDelegate.m
//  xzkd
//
//  Created by 小咸鱼 on 2019/2/26.
//  Copyright © 2019 xxy. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "InitializeModel.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "AuthResultViewController.h"
@interface AppDelegate ()

@property (nonatomic, strong) AppVersionModel *versionModel;

@property (nonatomic, strong) AuthStatusModel *authModel;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setMaximumDismissTimeInterval:3];
    
    [self appInit];
    [self IQKeyboardInit];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)appInit {
    [iSeeNetworkRequest postWithHeaderUrl:[NSString stringWithFormat:@"%@%@", MainUrl, GetInitInfo] params:[NSDictionary dictionary] success:^(id object) {
        if ([object[@"code"] integerValue] == 1) {
            
            InitializeModel *model = [InitializeModel mj_objectWithKeyValues:object[@"data"]];
            if (model.userInfo.userId.length && model.userInfo.userName.length) {
                [[NSUserDefaults standardUserDefaults] setObject:[model.userInfo mj_JSONString] forKey:UserInfoKey];
                
                [self getUserAuthStatus];

            }else {
                UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"LoginViewController"];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                nav.navigationBar.translucent = NO;
                self.window.rootViewController = nav;
            }


            [[NSUserDefaults standardUserDefaults] setObject:[model.baseConfig mj_JSONString] forKey:BaseInfoKey];
            self.versionModel = model.appVersion;
        }
    } failure:^(NSError *error) {
        UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"LoginViewController"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.navigationBar.translucent = NO;
        self.window.rootViewController = nav;
    }];
}

- (void)goAuth {
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"AuthViewController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.translucent = NO;
    self.window.rootViewController = nav;
}

- (void)goOverdue:(NSInteger ) userStuatus {
    AuthResultViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"AuthResultViewController"];
    vc.userStuatus = userStuatus;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.translucent = NO;
    self.window.rootViewController = nav;
}

- (void)goLoanView {
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"LoanViewController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
}
- (void)goOverdueView {
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"OverdueViewController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.translucent = NO;
    self.window.rootViewController = nav;
}


- (void)submitDeviceInfo {
    NSDictionary *dic  = @{@"MobileId" : [UIDevice currentDevice].identifierForVendor.UUIDString,
                           @"MobileOsType"  : @(2),
                           @"MobileOsVersion" : [UIDevice currentDevice].systemVersion
                           };
    [iSeeNetworkRequest postWithHeaderUrl:kFormat(@"%@%@", MainUrl, kSubmitDeviceInfo) params:dic success:nil failure:nil];
}

- (void)IQKeyboardInit{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    keyboardManager.shouldResignOnTouchOutside = YES;
}

- (void)getUserAuthStatus {
    
    [iSeeNetworkRequest postWithHeaderUrl:kFormat(@"%@%@", MainUrl, kGetUserAuthStatus)
                                   params:[NSDictionary dictionary]
                                  success:^(id object) {
        
        
        self.authModel = [AuthStatusModel mj_objectWithKeyValues:object[@"data"]];

        if ([self.authModel.userStuatus integerValue] == 1) {
            
            [self goOverdue:[self.authModel.userStuatus integerValue]];
            
        }else {
            
            if ([self.authModel.loanStatus integerValue] == 1) {
                
                [self goLoanView];
                
            }else if ([self.authModel.loanStatus integerValue] == 3){
                [self goOverdueView];
            } else {
                [self goAuth];
            }
            
        }
        

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}


@end
