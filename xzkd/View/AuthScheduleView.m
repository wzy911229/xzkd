//
//  AuthScheduleView.m
//  xzkd
//
//  Created by 刘琛 on 2019/3/2.
//  Copyright © 2019年 xxy. All rights reserved.
//

#import "AuthScheduleView.h"

@interface AuthScheduleView()



@end

@implementation AuthScheduleView


- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    for (int i = 0; i < 4; i++) {
        UIView *view = [self viewWithTag:100 + i];
        view.layer.cornerRadius = view.bounds.size.width / 2;
        view.layer.masksToBounds = YES;
    }
    
}

- (void)setStatusType:(NSInteger )statusType {
    _statusType = statusType;
    for (NSInteger i = 0; i < 4; i++) {
        UIView *backView = [self viewWithTag:100 + i];
        UIView *connectView = [self viewWithTag:200 + i];
        UILabel *label = (UILabel *)[self viewWithTag:300 + i];
        if (i <= statusType) {
            backView.backgroundColor = kOriginColor;
            if (i != 0) {
                connectView.backgroundColor = kOriginColor;
            }
            label.textColor = kOriginColor;
        }else {
            backView.backgroundColor = kGrayColor;
            if (i != 0) {
                connectView.backgroundColor = kGrayColor;
            }
            label.textColor = kGrayColor;
        }
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
