//
//  LoanAlertView.m
//  xzkd
//
//  Created by 小咸鱼 on 2019/3/2.
//  Copyright © 2019 xxy. All rights reserved.
//

#import "LoanAlertView.h"
#import "AppDelegate.h"
@interface LoanAlertView ()
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIView *alertView;
@end
@implementation LoanAlertView

- (instancetype)init {
    self = [[NSBundle mainBundle] loadNibNamed:@"LoanAlertView" owner:self options:nil].lastObject;
    return self;
}

- (void)show {
    self.alertView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    self.amountLabel.text = kFormat(@"%.2f元", self.serviceMoney);
    [kApplicationDelegate.window addSubview:self];
    self.frame = kApplicationDelegate.window.bounds;
    [UIView animateWithDuration:0.3 animations:^{
        self.alertView.transform = CGAffineTransformIdentity;
    }];
}

- (void)hidden {
    [UIView animateWithDuration:0.3 animations:^{
       self.alertView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (IBAction)cancelAction:(id)sender {
    [self hidden];
}

- (IBAction)agreementAction:(id)sender {
    if (self.delegate) {
        [self.delegate loanAlertViewAction];
    }
    [self hidden];
}

@end
