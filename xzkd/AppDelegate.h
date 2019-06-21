//
//  AppDelegate.h
//  xzkd
//
//  Created by 小咸鱼 on 2019/2/26.
//  Copyright © 2019 xxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)goAuth;

- (void)goOverdue:(NSInteger ) userStuatus;

- (void)goLoanView;

- (void)goOverdueView;

- (void)submitDeviceInfo;
@end

