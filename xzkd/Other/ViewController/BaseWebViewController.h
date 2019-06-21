//
//  BaseWebViewController.h
//  BitKe
//
//  Created by ZhuJiaCong on 2018/7/4.
//  Copyright © 2018年 ZhuJiaCong. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>

@interface BaseWebViewController : BaseViewController
@property (nonatomic, strong, readonly) WKWebView *webView;
@property (nonatomic, copy)     NSString        *urlString;
@property (nonatomic, copy)     NSString        *titleString;
@property (nonatomic, assign)   BOOL            hideLoading;

- (void)loadWebView;

@end



//@interface EDVModuleInteractor (WebView)
//- (void)go_webViewWithHTMLString:(NSString *)HTMLString;
//- (void)go_webViewWithUrlString:(NSString *)urlString;
//- (void)go_webViewWithUrlString:(NSString *)urlString
//             videoRegularString:(NSString *)videoRegularString
//                         platID:(NSInteger)platID;
//@end
