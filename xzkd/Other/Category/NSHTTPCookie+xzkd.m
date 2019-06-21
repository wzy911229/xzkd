//
//  NSHTTPCookie+xzkd.m
//  xzkd
//
//  Created by 小咸鱼 on 2019/3/5.
//  Copyright © 2019 xxy. All rights reserved.
//

#import "NSHTTPCookie+xzkd.h"

@implementation NSHTTPCookie (xzkd)
- (void)saveToUserDefaults {
    [kUserDefaults setObject:self.properties forKey:kLoginCookie];
    [kUserDefaults synchronize];
}
+ (instancetype)getCookieFromUserDefaults {
    NSDictionary *dic = [kUserDefaults objectForKey:kLoginCookie];
    if (dic) {
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:dic];
        return cookie;
    }
    return nil;
}
@end
