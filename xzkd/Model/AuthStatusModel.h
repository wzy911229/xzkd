//
//  AuthStatusModel.h
//  xzkd
//
//  Created by 刘琛 on 2019/3/5.
//  Copyright © 2019年 xxy. All rights reserved.
//

#import <Foundation/Foundation.h>


/*
 "data": {
 "liveAuth": 0,
 "bankAuth": 0,
 "userInfoAuth": 0,
 "operatorAuth": 0 ,
 "mailAuth": 0,
 "userStuatus":0,
 "repayStatus":0,
 }
 */
NS_ASSUME_NONNULL_BEGIN

@interface AuthStatusModel : NSObject



@property (nonatomic, strong) NSNumber *liveAuth;

@property (nonatomic, strong) NSNumber *bankAuth;

@property (nonatomic, strong) NSNumber *userInfoAuth;

@property (nonatomic, strong) NSNumber *operatorAuth;

@property (nonatomic, strong) NSNumber *mailAuth;

@property (nonatomic, strong) NSNumber *userStuatus;

@property (nonatomic, strong) NSNumber *repayStatus;

@property (nonatomic, strong) NSNumber *loanStatus;

@property (nonatomic, strong) NSNumber * OtherAuth;

@property (nonatomic, assign) BOOL  allAuthSuccess;

@end

NS_ASSUME_NONNULL_END
