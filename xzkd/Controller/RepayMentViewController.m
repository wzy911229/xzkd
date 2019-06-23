//
//  RepayMentViewController.m
//  xzkd
//
//  Created by 刘琛 on 2019/2/28.
//  Copyright © 2019年 xxy. All rights reserved.
//

#import "RepayMentViewController.h"
#import "AppDelegate.h"
@interface RepayMentViewController ()
@property (weak, nonatomic) IBOutlet UIButton *reLoanButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation RepayMentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBackButton];
    if (!_navTitle) {
        self.title = @"还款成功";
    }else{
      self.titleLabel.text = _navTitle;
    }
    self.reLoanButton.hidden = !self.canReLoan;
}

- (void)setCanReLoan:(BOOL)canReLoan {
    _canReLoan = canReLoan;
    self.reLoanButton.hidden = !_canReLoan;
}

- (void)setNavTitle:(NSString *)navTitle{
    _navTitle = navTitle;
    self.titleLabel.text = navTitle;
}


- (IBAction)reLoanAction:(id)sender {
    [self didBack];
}
- (void)didBack {
    [(AppDelegate *)kApplicationDelegate goAuth];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
