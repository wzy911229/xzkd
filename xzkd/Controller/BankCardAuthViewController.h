//
//  BankCardAuthViewController.h
//  xzkd
//
//  Created by 刘琛 on 2019/2/28.
//  Copyright © 2019年 xxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BankCardAuthViewControllerDelegate <NSObject>

@optional

- (void)bankCardAuthSuccess;

@end
NS_ASSUME_NONNULL_BEGIN

@interface BankCardAuthViewController : BaseViewController

@property (nonatomic, assign) BOOL hiddenHeader;

@property (nonatomic, strong) AuthStatusModel *authModel;
@property(nonatomic, weak) id <BankCardAuthViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
