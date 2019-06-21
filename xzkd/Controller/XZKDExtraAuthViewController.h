//
//  XZKDExtraAuthViewController.h
//  xzkd
//
//  Created by zhiyu on 2019/6/18.
//  Copyright © 2019 xxy. All rights reserved.
//

#import "ViewController.h"
@protocol XZKDExtraAuthViewControllerDelegate <NSObject>

@optional

- (void)extraAuthSuccess;

@end
NS_ASSUME_NONNULL_BEGIN

@interface XZKDExtraAuthViewController : BaseViewController
@property(nonatomic, weak) id <XZKDExtraAuthViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
