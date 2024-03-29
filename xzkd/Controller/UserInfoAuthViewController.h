//
//  UserInfoAuthViewController.h
//  xzkd
//
//  Created by 刘琛 on 2019/2/28.
//  Copyright © 2019年 xxy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoAuthViewController : BaseViewController

@property (nonatomic, assign) BOOL hiddenHeader;

@property (nonatomic, strong) AuthStatusModel *authModel;

@end

NS_ASSUME_NONNULL_END
