//
//  RegistAgreementView.m
//  qudaiba
//
//  Created by 刘琛 on 2019/5/11.
//  Copyright © 2019年 刘琛. All rights reserved.
//

#import "RegistAgreementView.h"

@interface RegistAgreementView()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation RegistAgreementView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    self.textView.attributedText = _str;
    
    self.textView.editable = NO;
    
}
- (IBAction)agrreAction:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RegistAgreement" object:nil];
    
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
