//
//  BaseWebViewController.m
//  BitKe
//
//  Created by ZhuJiaCong on 2018/7/4.
//  Copyright © 2018年 ZhuJiaCong. All rights reserved.
//

#import "BaseWebViewController.h"


#define kEmptyWebViewURL        @"about:blank"

@interface BaseWebViewController () <WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBackButton];
    if (self.titleString.length) {
        self.title = self.titleString;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    //清除urlcache
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [self p_createSubviews];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)loadWebView {
    if (kStringIsEmpty(self.urlString)) {
        return;
    }
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlString]];
    [self.webView loadRequest:request];
}

- (void)setHideLoading:(BOOL)hideLoading {
    _hideLoading = hideLoading;
    self.progressView.hidden = _hideLoading;
}

- (void)p_createSubviews{
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(2);
        make.top.mas_equalTo(self.view);
        
    }];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self loadWebView];
}
// 返回
- (void)didBack {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//
//- (void)closeBack {
//    [self.navigationController popViewControllerAnimated:YES];
//    [SVProgressHUD dismiss];
//}

- (WKWebView *)webView {
    if (!_webView) {
       
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.allowsInlineMediaPlayback = YES;
//        config.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeAll;
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
//        @weakify(self);
//        [RACObserve(_webView, estimatedProgress) subscribeNext:^(id  _Nullable x) {
//            @strongify(self);
//            CGFloat newprogress = [x doubleValue];
//            if (!self.hideLoading) {
//                if (newprogress == 1)
//                {
//                    self.progressView.hidden = YES;
//                    [self.progressView setProgress:0 animated:YES];
//                }
//                else
//                {
//                    self.progressView.hidden = NO;
//                    [self.progressView setProgress:newprogress animated:YES];
//                }
//            }
//        }];
    }
    return _webView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.tintColor = [UIColor colorWithHex:0x36B97E];
        _progressView.trackTintColor = [UIColor colorWithHex:0xf1f1f1];
    }
    return _progressView;
}


#pragma mark - WKNavigationDelegate
// 拦截外部App跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if([kSystemVersion floatValue] < 9){
        decisionHandler(WKNavigationActionPolicyAllow);
    }else{
        //返回+2的枚举值
        decisionHandler(WKNavigationActionPolicyAllow + 2);
    }
    return;
}
// 页面加载完成之后调用
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
//    NSLog(@"页面加载完成之后调用 = %@", webView.URL.absoluteString);
//}
// 在发送请求之前，决定是否跳转
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    // 解决 target='_blank' 问题
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

//// 页面开始加载时调用
//- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
//    NSLog(@"页面开始加载时调用 = %@", webView.URL.absoluteString);
//}
//// 当内容开始返回时调用
//- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
//    NSLog(@"当内容开始返回时调用 = %@", webView.URL.absoluteString);
//}
//// 页面加载失败时调用
//- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
//    NSLog(@"页面加载失败时调用 = %@", webView.URL.absoluteString);
//}
//// 接收到服务器跳转请求之后调用
//- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
//    NSLog(@"接收到服务器跳转请求之后调用 = %@", webView.URL.absoluteString);
//}
//// 在收到响应后，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
//    NSLog(@"在收到响应后，决定是否跳转 = %@", webView.URL.absoluteString);
////    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
//    //允许跳转
//    decisionHandler(WKNavigationResponsePolicyAllow);
//    //不允许跳转
//    //decisionHandler(WKNavigationResponsePolicyCancel);
//
////    NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
////    NSLog(@"allHeaderFields = %@", response.allHeaderFields);
//}
//// 即将白屏时调用
//- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
//    [webView reload];
//}
#pragma mark - WKUIDelegate
// 输入框
//- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
////    completionHandler(@"http");
//}
//// 确认框
//- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
////    completionHandler(YES);
//}
//// 警告框
//- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
//    if (message.length) {
////        self.hideLoading ? : [SVProgressHUD showImage:nil status:message];
//    }
//    completionHandler();
//}


@end

//#pragma mark - EDVModuleInteractor + WebView
//@implementation EDVModuleInteractor (WebView)
//- (void)go_webViewWithHTMLString:(NSString *)HTMLString {
//    BaseWebViewController *webVC = [[BaseWebViewController alloc] init];
//    webVC.HTMLString = HTMLString;
//    webVC.videoRegularString = nil;
//    [webVC loadWebView];
//    [self pushToVC:webVC];
//}
//
//- (void)go_webViewWithUrlString:(NSString *)urlString {
//    BaseWebViewController *webVC = [[BaseWebViewController alloc] init];
//    webVC.urlString = urlString;
//    webVC.videoRegularString = nil;
//    [webVC loadWebView];
//    [self pushToVC:webVC];
//}
//
//
//- (void)go_webViewWithUrlString:(NSString *)urlString
//             videoRegularString:(NSString *)videoRegularString
//                         platID:(NSInteger)platID {
//    BaseWebViewController *webVC = [[BaseWebViewController alloc] init];
//    webVC.urlString = urlString;
//    webVC.videoRegularString = videoRegularString;
//    webVC.platID = platID;
//    [webVC loadWebView];
//    [self pushToVC:webVC];
//}

//@end

