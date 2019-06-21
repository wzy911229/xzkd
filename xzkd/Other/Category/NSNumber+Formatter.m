//
//  NSNumber+Formatter.m
//  qudaiba
//
//  Created by 小咸鱼 on 2019/2/23.
//  Copyright © 2019 刘琛. All rights reserved.
//

#import "NSNumber+Formatter.h"

@implementation NSNumber (Formatter)
- (NSString *)stringWithCurrrncyStyleFormatter {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterCurrencyStyle;
    NSString *string = [formatter stringFromNumber:self];
    if ([string characterAtIndex:0] > '9' || [string characterAtIndex:0] < '0') {
        return [string substringFromIndex:1];
    }
    return string;
}
@end
