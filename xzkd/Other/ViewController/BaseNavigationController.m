//
//  BaseNavigationController.m
//  BitKe
//
//  Created by ZhuJiaCong on 2018/7/9.
//  Copyright © 2018年 ZhuJiaCong. All rights reserved.
//

#import "BaseNavigationController.h"
#import "BaseViewController.h"

@interface BaseNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
        self.delegate = self;
    }
    [self setNavigationBar];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setNavigationBar{
    self.navigationBar.translucent = NO;
    self.navigationBar.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.navigationBar.layer.shadowOpacity = 0.4;
    self.navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
    
    if ([kSystemVersion floatValue] >= 9.0) {
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc]init]];
        //设置navigationBar的颜色 
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithHex:0xFE4606]];
        [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHex:0x333333],NSFontAttributeName:[UIFont p_boldFontWithSize:18]};
        [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
        [[UITableViewCell appearance] setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //每次当navigation中的界面切换，设为空。本次赋值只在程序初始化时执行一次
    static UIViewController *lastController = nil;
    
    //若上个view不为空
    if (lastController != nil)
    {
        //若该实例实现了viewWillDisappear方法，则调用
        if ([lastController respondsToSelector:@selector(viewWillDisappear:)])
        {
            [lastController viewWillDisappear:animated];
        }
    }
    
    //将当前要显示的view设置为lastController，在下次view切换调用本方法时，会执行viewWillDisappear
    lastController = viewController;
    
    [viewController viewWillAppear:animated]; 
}


- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate{
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if(self.closedInteractivePopGestureRecognizer){
            navigationController.interactivePopGestureRecognizer.enabled = NO;
        }else{
            if ([navigationController.viewControllers count] == 1) {
                navigationController.interactivePopGestureRecognizer.enabled = NO;
            } else {
                navigationController.interactivePopGestureRecognizer.enabled = YES;
            }
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    self.interactivePopGestureRecognizer.delegate = nil;
    self.delegate = nil;
}


// 屏幕旋转控制
//是否跟随屏幕旋转
-(BOOL)shouldAutorotate{
    return self.topViewController.shouldAutorotate;
}
//支持旋转的方向有哪些
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.topViewController supportedInterfaceOrientations];
}
@end
