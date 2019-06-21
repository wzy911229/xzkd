//
//  UIFont+EX.m
//  ArthasBaseAppStructure
//
//  Created by Andrew Shen on 16/2/26.
//  Copyright © 2016年 Andrew Shen. All rights reserved.
//

#import "UIFont+EX.h"

@implementation UIFont (EX)

#pragma mark - Private

+ (UIFont *)p_boldFontWithSize:(CGFloat)size {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
        return [UIFont fontWithName:@"PingFangSC-Medium" size:SCALE(size)];
    }
    else {
        return [UIFont fontWithName:@"PingFangSC-Regular" size:SCALE(size)];
    }

}

+ (UIFont *)p_fontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Regular" size:SCALE(size)];
}

+ (UIFont *)p_numberFontSize:(CGFloat)size {
    return [UIFont fontWithName:@"Helvetica" size:SCALE(size)];
}

+ (UIFont *)p_numberLightFontSize:(CGFloat)size {
    return [UIFont fontWithName:@"Helvetica-Light" size:SCALE(size)];
}

+ (UIFont *)p_numberBoldFontSize:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Semibold" size:SCALE(size)];
}

@end
