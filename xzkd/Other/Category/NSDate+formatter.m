//
//  NSDate+formatter.m
//  xzkd
//
//  Created by 小咸鱼 on 2019/3/8.
//  Copyright © 2019 xxy. All rights reserved.
//

#import "NSDate+formatter.h"

@implementation NSDate (formatter)
+ (instancetype)dateFromString:(NSString *)string format:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter dateFromString:string];
}
- (NSString *)dateStringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter stringFromDate:self];
}
@end
