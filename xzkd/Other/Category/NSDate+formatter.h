//
//  NSDate+formatter.h
//  xzkd
//
//  Created by 小咸鱼 on 2019/3/8.
//  Copyright © 2019 xxy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (formatter)
+ (instancetype)dateFromString:(NSString *)string format:(NSString *)format;
- (NSString *)dateStringWithFormat:(NSString *)format;
@end

NS_ASSUME_NONNULL_END
