//
//  UserInfoModel.h
//  xzkd
//
//  Created by 刘琛 on 2019/3/3.
//  Copyright © 2019年 xxy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 userInfo:{
    userId:0,       //用户id
    userName:""
 },
 */

@interface UserInfoModel : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSNumber *userStuatus;
@property (nonatomic, strong) NSNumber *repayStatus;
@property (nonatomic, strong) NSNumber *authStatus;
@property (nonatomic, strong) NSNumber *loanStatus;
@end

NS_ASSUME_NONNULL_END
