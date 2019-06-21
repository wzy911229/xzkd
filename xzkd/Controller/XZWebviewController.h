//
//  XZWebviewController.h
//  xzkd
//
//  Created by zhiyu on 2019/6/19.
//  Copyright © 2019 xxy. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XZWebviewController : BaseViewController<UIWebViewDelegate>
@property(nonatomic, copy) NSString *stringUrl;
@property(nonatomic, strong, readonly) UIWebView *webView;

/**
 *  加载URL
 */
- (void)loadUrl:(NSString *)stringUrl
;
@end

NS_ASSUME_NONNULL_END
