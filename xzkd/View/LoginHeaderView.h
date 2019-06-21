//
//  LoginHeaderView.h
//  xzkd
//
//  Created by 小咸鱼 on 2019/3/2.
//  Copyright © 2019 xxy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginHeaderView : UIView
- (void)configBackgroundImage:(NSString *)bgImage
                        title:(NSString *)title
                       amount:(NSString *)amount
                     duration:(NSString *)duration;
@end

NS_ASSUME_NONNULL_END
