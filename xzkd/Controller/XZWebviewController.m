//
//  XZWebviewController.m
//  xzkd
//
//  Created by zhiyu on 2019/6/19.
//  Copyright © 2019 xxy. All rights reserved.
//

#import "XZWebviewController.h"

@interface XZWebviewController ()

@end

@implementation XZWebviewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"手机运营商认证";
    self.navigationController.navigationBar.topItem.title = @"";
    UIWebView *webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webview.delegate = self;
    [self.view addSubview:webview];
    _webView = webview;
    
    if (_stringUrl) {
        [self loadUrl:_stringUrl];
    }
    
    [SVProgressHUD showWithStatus:@"加载中"];
    // Do any additional setup after loading the view.
    
}

- (void)loadUrl:(NSString *)stringUrl {
    if (!_webView) {
        _stringUrl = stringUrl;
        return;
    }
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:stringUrl]]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    [SVProgressHUD dismiss];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"加载失败，请重试"];
}

@end
