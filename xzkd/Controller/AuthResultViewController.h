//
//  AuthResultViewController.h
//  xzkd
//
//  Created by 刘琛 on 2019/2/28.
//  Copyright © 2019年 xxy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AuthResultViewController : BaseViewController
@property (nonatomic, assign) NSInteger userStuatus;
// 0 正常 1 展期
@property (nonatomic, assign) NSInteger loanType;

@end

NS_ASSUME_NONNULL_END
