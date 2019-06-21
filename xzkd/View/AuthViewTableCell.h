//
//  AuthViewTableCell.h
//  xzkd
//
//  Created by 刘琛 on 2019/3/2.
//  Copyright © 2019年 xxy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AuthViewTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (nonatomic, strong) NSNumber *stateType;

@end

NS_ASSUME_NONNULL_END
