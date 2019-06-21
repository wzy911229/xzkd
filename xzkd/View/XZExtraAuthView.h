//
//  XZExtraAuthView.h
//  xzkd
//
//  Created by zhiyu on 2019/6/18.
//  Copyright © 2019 xxy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol XZExtraAuthViewEventDelegate <NSObject>

@optional

- (void)extraAuthViewOnPressAddressBook:(UIButton*)btn;

- (void)extraAuthViewOnPressSure:(NSDictionary *)addressInfo;

@end
@interface XZExtraAuthView : UIView
@property(nonatomic, weak) id <XZExtraAuthViewEventDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
