//
//  iSeeNetworkRequest.h
//  iSee
//
//  Created by 刘琛 on 2017/11/10.
//  Copyright © 2017年 刘琛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface iSeeNetworkRequest : NSObject


+ (void)getUrl:(NSString *) url params:(NSDictionary *) params success:(void (^)(id object))success failure:(void (^)(NSError *error))failure;


+ (void)postUrl:(NSString *) url params:(NSDictionary *) params success:(void (^)(id object))success failure:(void (^)(NSError *error))failure;

+ (void)postUrl:(NSString *) url
          login:(BOOL)needLogin
         params:(NSDictionary *) params
        success:(void (^)(id object))success failure:(void (^)(NSError *error))failure;


+ (void)getUrl:(NSString *) url
         login:(BOOL)needLogin
        params:(NSDictionary *) params
       success:(void (^)(id object))success failure:(void (^)(NSError *error))failure;

+ (void)getWithHeaderUrl:(NSString *) url params:(NSDictionary *) params success:(void (^)(id object))success failure:(void (^)(NSError *error))failure;

+ (void)postWithHeaderUrl:(NSString *) url params:(NSDictionary *) params success:(void (^)(id object))success failure:(void (^)(NSError *error))failure;
@end
