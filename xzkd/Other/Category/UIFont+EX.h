//
//  UIFont+EX.h
//  ArthasBaseAppStructure
//
//  Created by Andrew Shen on 16/2/26.
//  Copyright © 2016年 Andrew Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (EX)

+ (UIFont *)p_boldFontWithSize:(CGFloat)size;
+ (UIFont *)p_fontWithSize:(CGFloat)size;
+ (UIFont *)p_numberFontSize:(CGFloat)size;
+ (UIFont *)p_numberBoldFontSize:(CGFloat)size;

+ (UIFont *)p_numberLightFontSize:(CGFloat)size;

@end
