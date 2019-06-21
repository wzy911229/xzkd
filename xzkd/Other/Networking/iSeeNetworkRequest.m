//
//  iSeeNetworkRequest.m
//  iSee
//
//  Created by 刘琛 on 2017/11/10.
//  Copyright © 2017年 刘琛. All rights reserved.
//

#import "iSeeNetworkRequest.h"
#import "AppDelegate.h"
#import "UserInfoModel.h"
#import <AFNetworking.h>
#define kSuccessCode    1

@implementation iSeeNetworkRequest


+ (void)getUrl:(NSString *)url login:(BOOL)needLogin params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    UserInfoModel *userInfo = [UserInfoModel mj_objectWithKeyValues: [[[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKey] mj_JSONObject]];
    if (userInfo) {
        if (userInfo.userId.length) {
            [manager.requestSerializer setValue:userInfo.userId forHTTPHeaderField:@"userId"];
        }else {
            [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"userId"];
        }
        if (userInfo.userName.length) {
            [manager.requestSerializer setValue:userInfo.userName forHTTPHeaderField:@"userName"];
        }else {
            [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"userName"];
        }
    }else {
        [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"userId"];
        [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"userName"];
    }
    
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSString *urlStr = [NSString string];
    
    if (params.count) {
        NSDictionary *pamar = [NSDictionary dictionaryWithObjectsAndKeys:params,@"body", nil];
        
    }else {
        urlStr = url;
    }
    
    [manager GET:urlStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if (success && code == kSuccessCode) {
            success(responseObject);
        } else if(failure) {
            failure([NSError errorWithDomain:MainUrl code:code userInfo:responseObject]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}


+ (void)getUrl:(NSString *) url params:(NSDictionary *) params success:(void (^)(id object))success failure:(void (^)(NSError *error))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *urlStr = [NSString string];
    
    if (params.count) {
        NSDictionary *pamar = [NSDictionary dictionaryWithObjectsAndKeys:params,@"body", nil];
        
    }else {
        urlStr = url;
    }
    
    [manager GET:urlStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if (success && code == kSuccessCode) {
            success(responseObject);
        } else if(failure) {
            failure([NSError errorWithDomain:MainUrl code:code userInfo:responseObject]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

+(void)postUrl:(NSString *)url login:(BOOL)needLogin params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    UserInfoModel *userInfo = [UserInfoModel mj_objectWithKeyValues: [[[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKey] mj_JSONObject]];
    if (userInfo) {
        if (userInfo.userId.length) {
            [manager.requestSerializer setValue:userInfo.userId forHTTPHeaderField:@"userId"];
        }else {
            [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"userId"];
        }
        if (userInfo.userName.length) {
            [manager.requestSerializer setValue:userInfo.userName forHTTPHeaderField:@"userName"];
        }else {
            [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"userName"];
        }
    }else {
        [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"userId"];
        [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"userName"];
    }
  
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if (success && code == kSuccessCode) {
            success(responseObject);
        } else if(failure) {
            failure([NSError errorWithDomain:MainUrl code:code userInfo:responseObject]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];

    
}

+ (void)postUrl:(NSString *) url params:(NSDictionary *) params success:(void (^)(id object))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if (success && code == kSuccessCode) {
            success(responseObject);
        } else if(failure) {
            failure([NSError errorWithDomain:MainUrl code:code userInfo:responseObject]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getWithHeaderUrl:(NSString *) url params:(NSDictionary *) params success:(void (^)(id object))success failure:(void (^)(NSError *error))failure {
    
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if (success && code == kSuccessCode) {
            success(responseObject);
        } else if(failure) {
            failure([NSError errorWithDomain:MainUrl code:code userInfo:responseObject]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)postWithHeaderUrl:(NSString *) url params:(NSDictionary *) params success:(void (^)(id object))success failure:(void (^)(NSError *error))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    UserInfoModel *userInfo = [UserInfoModel mj_objectWithKeyValues: [[[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKey] mj_JSONObject]];
    if (userInfo) {
        if (userInfo.userId.length) {
            [manager.requestSerializer setValue:userInfo.userId forHTTPHeaderField:@"userId"];
        }else {
            [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"userId"];
        }
        if (userInfo.userName.length) {
            [manager.requestSerializer setValue:userInfo.userName forHTTPHeaderField:@"userName"];
        }else {
            [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"userName"];
        }
    }else {
        [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"userId"];
        [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"userName"];
    }
    
    
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if (success && code == kSuccessCode) {
            success(responseObject);
        } else if(failure) {
            failure([NSError errorWithDomain:MainUrl code:code userInfo:responseObject]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


@end
