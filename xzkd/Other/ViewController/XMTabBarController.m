//
//  XMTabBarController.m
//  WorkerNews
//
//  Created by JiaCong Zhu on 2019/1/21.
//  Copyright © 2019 XiMu. All rights reserved.
//

#import "XMTabBarController.h"
#import "CustomTabBar.h"
#import "XMTabBarButton.h"


@interface XMTabBarController ()
@property (nonatomic, strong) NSMutableArray<XMTabBarButton *>   *buttonArray;
@property (nonatomic, strong) CustomTabBar  *cTabBar;
@end

@implementation XMTabBarController

+ (instancetype)defaultTabBarController {
    static XMTabBarController *tbc = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tbc = [[XMTabBarController alloc] init];
    });
    return tbc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_createTabBar];

}

// 使用CustomTabBar 来拦截系统自带的 UITabBarButton
- (CustomTabBar *)cTabBar {
    if (!_cTabBar) {
        _cTabBar = [[CustomTabBar alloc] init];
        _cTabBar.frame = self.tabBar.bounds;
        _cTabBar.shadowImage = [UIImage new];
        _cTabBar.translucent = NO;
        [self setValue:_cTabBar forKey:@"tabBar"];
    }
    return _cTabBar;
}

// 清除当前按钮
- (void)p_clearTabBarButton {
    for (UIView *view in self.cTabBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")] || [view isKindOfClass:[XMTabBarButton class]]) {
            [view removeFromSuperview];
        }
    }
}

- (void)p_createTabBar {
    [self p_clearTabBarButton];
    NSArray *tabArray = @[@{@"title" : @"精选",
                            @"icon" : @"tab_icon_home",
                            @"icon_selected" : @"tab_icon_home_selected",
                            @"vcClass" : [UIViewController class]},
                          @{@"title" : @"账单",
                            @"icon" : @"tab_icon_bill",
                            @"icon_selected" : @"tab_icon_bill_selected",
                            @"vcClass" : [UIViewController class]},
                          @{@"title" : @"活动",
                            @"icon" : @"tab_icon_activity",
                            @"icon_selected" : @"tab_icon_activity_selected",
                            @"vcClass" : [UIViewController class]},
                          @{@"title" : @"我",
                            @"icon" : @"tab_icon_mine",
                            @"icon_selected" : @"tab_icon_mine_selected",
                            @"vcClass" : [UIViewController class]}];
    
    // 自定义按钮添加
    CGFloat buttonWidth = kScreenWidth / (tabArray.count);
    self.buttonArray = [[NSMutableArray alloc] init];
    NSMutableArray *vcArray = [[NSMutableArray alloc] init];
    [tabArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XMTabBarButton *button = [[XMTabBarButton alloc] initWithTitle:obj[@"title"] icon:[UIImage imageNamed:obj[@"icon"]] selectedIcon:[UIImage imageNamed:obj[@"icon_selected"]]];
        button.frame = CGRectMake(CGRectGetMaxX(self.buttonArray.lastObject.frame), 0, buttonWidth, self.cTabBar.bounds.size.height);
        button.tag = self.buttonArray.count;
        [button addTarget:self action:@selector(tabBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.cTabBar addSubview:button];
        [self.buttonArray addObject:button];
        
        // ViewController创建
        id vcClass = obj[@"vcClass"];
        if ([vcClass isKindOfClass:[UIViewController class]]) {
            UIViewController *ctrl = vcClass;
            ctrl.title = obj[@"title"];
            BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:ctrl];
            [vcArray addObject:navi];
        }else {
            
            BaseViewController *vc = [[vcClass alloc] init];
            vc.title = obj[@"title"];
            BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:vc];
            [vcArray addObject:navi];
        }
    }];
    self.viewControllers = [vcArray copy];
   
}

// 标签按钮点击
- (void)tabBarButtonAction:(XMTabBarButton *)button {
    self.selectedIndex = button.tag;
    for (UIButton *button in self.buttonArray) {
        button.selected = NO;
    }
    button.selected = YES;
}

// 索引变化
- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [super setSelectedIndex:selectedIndex];
    for (XMTabBarButton *button in self.buttonArray) {
        button.selected = selectedIndex == button.tag;
    }
}

// 状态栏颜色控制
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
