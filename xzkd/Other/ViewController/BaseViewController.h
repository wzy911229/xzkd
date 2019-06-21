//
//  BaseViewController.h
//  BitKe
//
//  Created by ZhuJiaCong on 2018/7/4.
//  Copyright © 2018年 ZhuJiaCong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)didBack;
- (void)initBackButton;
- (UIBarButtonItem *)createRightBarButtonRightTitle:(NSString *)rightTitle
                                             action:(SEL)selector;


@end
