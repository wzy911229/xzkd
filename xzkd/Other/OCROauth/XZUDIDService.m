//
//  XZUDIDService.m
//  xzkd
//
//  Created by zhiyu on 2019/6/4.
//  Copyright © 2019 xxy. All rights reserved.
//

#import "XZUDIDService.h"
#import <AFNetworking.h>
#import "UserInfoModel.h"
#import "iSeeNetworkRequest.h"

@implementation XZUDIDService

+ (instancetype)XZUDIDService {
    static XZUDIDService *_staticInstance;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        if (!_staticInstance) {
            _staticInstance = [[self alloc] init];
        }
    });
    return _staticInstance;
}

+ (void)submiteUserInfo:(NSDictionary *)info result:(nonnull SZKDHttpResultBlock)resultBlock {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:info];
    [dict removeObjectForKey:@"sdk_idcard_front_photo"];
    [dict removeObjectForKey:@"sdk_idcard_portrait_photo"];
    [dict removeObjectForKey:@"sdk_idcard_back_photo"];

    NSString * url = kFormat(@"%@%@", APIBASEURL, kCardOCR);

    [iSeeNetworkRequest postUrl:  url login:YES  params:dict success:^(id object) {
        resultBlock(YES,object,nil);
    } failure:^(NSError *error) {
         resultBlock(NO,nil,error);
    }];
}

+ (void)submiteLivingInfo:(id)info result:(nonnull SZKDHttpResultBlock)resultBlock {
    NSString * url = kFormat(@"%@%@", APIBASEURL, kLivingOCR);
   
    [iSeeNetworkRequest postUrl:url login:YES params:info  success:^(id object) {
        resultBlock(YES,object,nil);
    } failure:^(NSError *error) {
        resultBlock(NO,nil,error);
    }];
}

+ (void)submiteExtraInfo:(id)info result:(SZKDHttpResultBlock)resultBlock {
    
    NSString * url = kFormat(@"%@%@", APIBASEURL, kExtraOCR);
    [iSeeNetworkRequest postUrl:url login:YES params:info  success:^(id object) {
        resultBlock(YES,object,nil);
    } failure:^(NSError *error) {
        resultBlock(NO,nil,error);
    }];
}


+ (void)requestForTaskId:(SZKDHttpResultBlock)resultBlock {
    NSString * url = kFormat(@"%@%@", APIBASEURL, kGetTaskID);
    [iSeeNetworkRequest getUrl:url login:YES params:nil success:^(id object) {
        resultBlock(YES,object,nil);
    } failure:^(NSError *error) {
        resultBlock(NO,nil,error);
    }];

}
@end
