//
//  AuthViewTableCell.m
//  xzkd
//
//  Created by 刘琛 on 2019/3/2.
//  Copyright © 2019年 xxy. All rights reserved.
//

#import "AuthViewTableCell.h"

@implementation AuthViewTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
//活体认证(0-未认证，1-已认证，2-认证失败，3-认证中)
- (void)setStateType:(NSNumber *)stateType {
    _stateType = stateType;
    
    switch ([_stateType integerValue]) {
        case 0:
            _stateLabel.text = @"未认证";
            break;
        case 1:
            _stateLabel.text = @"已认证";
            break;
        case 2:
            _stateLabel.text = @"认证失败";
            break;
        case 3:
            _stateLabel.text = @"认证中";
            break;
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
