//
//  BaseNavigationController.h
//  BitKe
//
//  Created by ZhuJiaCong on 2018/7/9.
//  Copyright © 2018年 ZhuJiaCong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavigationController : UINavigationController
@property (nonatomic,unsafe_unretained) BOOL closedInteractivePopGestureRecognizer;
@end
