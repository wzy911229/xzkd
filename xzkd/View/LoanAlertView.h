//
//  LoanAlertView.h
//  xzkd
//
//  Created by 小咸鱼 on 2019/3/2.
//  Copyright © 2019 xxy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol LoanAlertViewDelegate <NSObject>

- (void)loanAlertViewAction;

@end
@interface LoanAlertView : UIView
@property (nonatomic, assign) CGFloat serviceMoney;
@property (nonatomic, weak)   id<LoanAlertViewDelegate> delegate;
- (void)show;
- (void)hidden;
@end

NS_ASSUME_NONNULL_END
