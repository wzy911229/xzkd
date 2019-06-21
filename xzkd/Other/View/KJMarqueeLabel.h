//  uilabel滚动效果
//  KJMarqueeLabel.h
//  HCNewGoldFinger
//
//  Created by 刘琛 on 2019/1/2.
//  Copyright © 2019年 zjhcsoftios. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, KJMarqueeLabelType) {
    KJMarqueeLabelTypeLeft = 0,//向左边滚动
    KJMarqueeLabelTypeLeftRight = 1,//先向左边，再向右边滚动
};

@interface KJMarqueeLabel : UILabel


@property(nonatomic,unsafe_unretained)KJMarqueeLabelType marqueeLabelType;
@property(nonatomic,unsafe_unretained)CGFloat speed;//速度
@property(nonatomic,unsafe_unretained)CGFloat secondLabelInterval;
@property(nonatomic,unsafe_unretained)NSTimeInterval stopTime;//滚到顶的停止时间


@end
