//
//  BaseViewController.m
//  BitKe
//
//  Created by ZhuJiaCong on 2018/7/4.
//  Copyright © 2018年 ZhuJiaCong. All rights reserved.
//

#import "BaseViewController.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [MobClick beginLogPageView:self.title];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [MobClick endLogPageView:self.title];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

//是否旋转
-(BOOL)shouldAutorotate{
    return NO;
}
//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


- (void)didBack {
    if (self.navigationController && self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)initBackButton{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"]
                                                style:UIBarButtonItemStylePlain
                                                 target:self
                                                 action:@selector(didBack)];
}




- (UIBarButtonItem *)createRightBarButtonRightTitle:(NSString *)rightTitle
                                             action:(SEL)selector{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    if (kSystemVersion.doubleValue < 11.0f) {
        btn.frame = [rightTitle boundingRectWithSize:CGSizeMake(80, 44) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont p_fontWithSize:16]} context:nil];
    }
    [btn setTitle:rightTitle forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont p_fontWithSize:16];
    [btn setTitleColor:[UIColor colorWithHex:0x33B87C] forState:UIControlStateNormal];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return barBtnItem;
}



@end
