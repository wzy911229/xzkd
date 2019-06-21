//
//  UIImage+EX.m
//  ArthasBaseAppStructure
//
//  Created by Andrew Shen on 16/2/26.
//  Copyright © 2016年 Andrew Shen. All rights reserved.
//

#import "UIImage+EX.h"

@implementation UIImage (EX)

/**
 *  裁剪图片
 *
 *  @param image 要裁剪的图片
 *  @param size  将要裁剪的大小
 *
 *  @return 裁剪好的图片
 */
+ (UIImage *)at_imageScaleFromImage:(UIImage *)image toSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 * 创建纯色的图片，用来做背景
 */
+ (UIImage *)at_imageWithColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *ColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return ColorImg;
}

/**
 * 屏幕截图
 */
+ (UIImage *)at_imageScreenshotFromView:(UIView *)view {
    // Draw a view’s contents into an image context
    UIGraphicsBeginImageContext(view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[view layer] renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;

}

/**
 *  想图片添加水印
 *
 *  @param sourceImage 需要加水印的图片
 *  @param maskImage   水印图片
 *
 *  @return 添加好的图片
 */
+ (UIImage *)at_imageAddWatermarkToImage:(UIImage *)sourceImage maskImage:(UIImage *)maskImage maskPosition:(CGPoint)position {
    UIGraphicsBeginImageContext(sourceImage.size);
    [sourceImage drawInRect:CGRectMake(0, 0, sourceImage.size.width, sourceImage.size.height)];
    [maskImage drawInRect:CGRectMake(position.x,position.y,maskImage.size.width,maskImage.size.height)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

+ (UIImage *)at_imageWithColor:(UIColor *)color {
    
    return [self at_imageWithColor:color size:CGSizeMake(1, 1)];
}

- (UIImage *)at_imageClipWithArrowXOffset:(CGFloat)offset arrowSize:(CGSize)arrowSize cornerRadius:(CGFloat)cornerRadius {
    CGFloat bubbleWidth = [UIScreen mainScreen].bounds.size.width;
    //1.创建图片上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(bubbleWidth, self.size.height), 0, [UIScreen mainScreen].scale);
    //2.获取图片上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    
    CGFloat halfArrowW = arrowSize.width * 0.5;
    CGFloat arrrowH = arrowSize.height;

    //3.创建路径
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(6, arrrowH, bubbleWidth - 12, self.size.height - arrrowH) cornerRadius:cornerRadius];
    
    [path moveToPoint:CGPointMake(offset - halfArrowW, arrrowH)];
    [path addLineToPoint:CGPointMake(offset, 0)];
    [path addLineToPoint:CGPointMake(offset + halfArrowW, arrrowH)];
    [path closePath];
    //4.把路径添加到上下文中
    CGContextAddPath(contextRef, path.CGPath);
    
    //5.裁剪上下文
    CGContextEOClip(contextRef);
    
    //6.把图片画到上下文中
    [self drawInRect:CGRectMake(0, 0, bubbleWidth, self.size.height)];
    
    //7.从上下文中取出图片
    UIImage *arrowImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //8.卸磨杀驴
    UIGraphicsEndImageContext();
    
    return arrowImage;
}
@end
