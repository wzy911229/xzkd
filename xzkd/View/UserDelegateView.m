//
//  UserDelegateView.m
//  xzkd
//
//  Created by 刘琛 on 2019/3/26.
//  Copyright © 2019年 xxy. All rights reserved.
//

#import "UserDelegateView.h"

@implementation UserDelegateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self removeFromSuperview];
}

@end
