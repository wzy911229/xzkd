//
//  XMTabBarButton.h
//  WorkerNews
//
//  Created by JiaCong Zhu on 2019/1/21.
//  Copyright © 2019 XiMu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMTabBarButton : UIButton
@property (nonatomic, strong, readonly) UIImageView   *iconView;
@property (nonatomic, strong, readonly) UILabel       *textLabel;


- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon selectedIcon:(UIImage *)selectedIcon;
- (instancetype)initWithTitle:(NSString *)title iconURL:(NSURL *)iconURL selectedIconURL:(NSURL *)selectedIconURL;

@end

NS_ASSUME_NONNULL_END
