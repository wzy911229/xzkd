//
//  NSError+SVProgress.m
//  xzkd
//
//  Created by 小咸鱼 on 2019/3/8.
//  Copyright © 2019 xxy. All rights reserved.
//

#import "NSError+SVProgress.h"

@implementation NSError (SVProgress)
- (void)showInSVProgressHUD {
    NSString *msg = self.userInfo[@"msg"];
    if (!kStringIsEmpty(msg)) {
        [SVProgressHUD showErrorWithStatus:msg];
    } else {
        [SVProgressHUD showErrorWithStatus:@"系统错误，请稍后再试"];
    }

}
@end
