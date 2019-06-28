//
//  UIMacro.h
//  EveryDayVideo
//
//  Created by zl on 2018/12/19.
//  Copyright © 2018年 zl. All rights reserved.
//

#ifndef UIMacro_h
#define UIMacro_h

/** 创建UIimage*/
#define Image(s) [UIImage imageNamed:s]

/** 比例frame*/
#define FRAME(x,y,w,h) CGRectMake(x, y, w, h)

/** frame*/
#define kFrame(x,y,w,h) CGRectMake(SCALE(x), SCALE(y), SCALE(w), SCALE(h))

/***  比例字体 */
#define kFont(size) [UIFont systemFontOfSize:SCALE(size)]

/***  视图高度 */
#define HEIGHT(o)                         (o.frame.size.height)

/***  视图宽度 */
#define WIDTH(o)                          (o.frame.size.width)

/***  视图X坐标 */
#define X(o)                              (o.frame.origin.x)

/***  视图Y坐标 */
#define Y(o)                              (o.frame.origin.y)

/***  视图底部 */
#define BOTTOM(o)                         (o.frame.origin.y + o.frame.size.height)

/***  视图右侧坐标 */
#define RIGHT(o)                          (o.frame.origin.x + o.frame.size.width)

/***  屏幕宽高比例 */
#define SCALE(s)                          ((s) / 375.0 * kScreenWidth)
#define SCALESIZE(w,h)                         (CGSizeMake(SCALE(w), SCALE(h)))

/***  屏幕 bounds*/
#define KScreenFrame KSCREENFRAME                       ([UIScreen mainScreen].bounds)

/***  屏幕宽 */
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width

/***  屏幕高度 */
#define kScreenHeight  [[UIScreen mainScreen] bounds].size.height

/***  是否iPhoneX */
#define IS_IPHONE_X ((kScreenHeight == 812.0f) ? YES : NO)

/***  状态栏高度 */
#define Height_StatusBar ((IS_IPHONE_X==YES)?44.0f: 20.0f)

/***  导航栏高度 */
#define Height_NavBar ((IS_IPHONE_X==YES)?88.0f: 64.0f)

/***  底部状态栏高度 */
#define Height_TabBar ((IS_IPHONE_X==YES)?83.0f: 49.0f)

/** 字符串校验*/
#define kStringIsEmpty(str)     ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

/***  1pt像素点宽度 */
#define k1ptWidth (1.1 / [UIScreen mainScreen].scale)


#define kApplication [UIApplication sharedApplication]
#define kApplicationDelegate                ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define kUserDefaults                       [NSUserDefaults standardUserDefaults]
#define kNavBarHeight                       self.navigationController.navigationBar.bounds.size.height
#define kStatusBarHeight                    ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define kTabBarHeight                       self.tabBarController.tabBar.bounds.size.height
#define kSelfViewWidth                      self.view.bounds.size.width
#define kSelfViewHeight                     self.view.bounds.size.height
#define kUseViewScreenHeight                kScreenHeight - kNavBarHeight - kStatusBarHeight //view高度

#define RGB(r, g, b)                        [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kFormat(string, args...)            [NSString stringWithFormat:string, args]

#define kSystemVersion             [[UIDevice currentDevice] systemVersion]//手机系统版本号
#define kPhoneIdentifierNumber          [[UIDevice currentDevice].identifierForVendor UUIDString] //手机序列号
#define kAppNavigationController  (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController
#define kDocumentsPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0]
#define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define kAppName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define kDeviceMode [[UIDevice currentDevice] model]

//  DEVICE DETECTION
#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)
#define IS_IPHONE (!IS_IPAD)
#define IS_IPHONE_5 ( IS_IPHONE && IS_WIDESCREEN )
#pragma mark - 屏幕尺寸
#define kIphone4        ([[UIScreen mainScreen] bounds].size.height == 480.f)
#define kIphone5        ([[UIScreen mainScreen] bounds].size.height == 568.f)
#define kIphone6        ([[UIScreen mainScreen] bounds].size.height == 667.f)
#define kIphone6p       ([[UIScreen mainScreen] bounds].size.height == 736.f)
#define kIphoneX        ([[UIScreen mainScreen] bounds].size.height == 812.f)
#define kIphoneXRorMax  ([[UIScreen mainScreen] bounds].size.height == 896.f)
//  DEVICE VERSION
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define kIOS7 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")
#define kIOS8 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")


#define kAPIServerHost                                      @"你的服务器HOST地址"
#define kAESKey                                             @"AES加密密钥"
// User Defaults Key

#define UserInfoKey    @"xzkdUserInfo"
#define BaseInfoKey    @"xzkdBaseInfo"
#define kLoginCookie   @"kLoginCookie"


// SDK Keys
#define moxieId     @"2019030100005356"
//#define moxieAppKey  @"25c80769d38242d799c64aea45136f29"
#define moxieAppKey  @"0a639f790d1b492fae835fa78195135a"
// Custom

// NotificationName


// UDIDSDK_OCR KEYS
#define KUDPUBKEY  @"7d71eb2e-1886-468c-bb1b-ed2791d9f213" // 商户pubkey
#define KUDSECURITYKEY @"71d056b4-7946-4dec-842f-3a54e99c244f" // 商户secretkey



//颜色文件
#define kOriginColor [UIColor colorWithHexString:@"FE4606"]
#define kBlueColor [UIColor colorWithHexString:@"2280FF"]
#define kGrayColor [UIColor colorWithHexString:@"C5C8D1"]
#define kLabelGrayColor [UIColor colorWithHexString:@"AFB2BB"]
#define kBaseViewColor [UIColor colorWithHexString:@"f7f7f7"]

#define INTERFACE_IS_IPHONEX  (@available(iOS 11.0, *) && ([UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom > 0)?YES:NO)

#define KNavigationBarH  INTERFACE_IS_IPHONEX ? 88:64
#define KStatusBarH  INTERFACE_IS_IPHONEX ? 44:20
//网络请求
#import "NetworkAddress.h"
#define MainUrl @"http://api.xhsqianbao.com/"
//#define MainUrl @"http://mapi.91xzsd.com/"
#define APIBASEURL  @"http://api.xhsqianbao.com/"


#endif /* UIMacro_h */
