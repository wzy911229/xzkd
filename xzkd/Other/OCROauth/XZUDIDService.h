//
//  XZUDIDService.h
//  xzkd
//
//  Created by zhiyu on 2019/6/4.
//  Copyright © 2019 xxy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SZKDHttpResultBlock)(BOOL success, id data, NSError *responseError);

NS_ASSUME_NONNULL_BEGIN

@interface XZUDIDService : NSObject

+ (void)submiteUserInfo:(id)info result:(SZKDHttpResultBlock)resultBlock;
+ (void)submiteLivingInfo:(id)info result:(SZKDHttpResultBlock)resultBlock;
+ (void)submiteExtraInfo:(id)info result:(SZKDHttpResultBlock)resultBlock;
+ (void)requestForTaskId:(SZKDHttpResultBlock)resultBlock;
@end

NS_ASSUME_NONNULL_END
