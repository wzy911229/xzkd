//
//  NSHTTPCookie+xzkd.h
//  xzkd
//
//  Created by 小咸鱼 on 2019/3/5.
//  Copyright © 2019 xxy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSHTTPCookie (xzkd)
- (void)saveToUserDefaults;
+ (instancetype)getCookieFromUserDefaults;
@end

NS_ASSUME_NONNULL_END
