//
//  InitializeModel.h
//  xzkd
//
//  Created by 刘琛 on 2019/3/3.
//  Copyright © 2019年 xxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseConfigModel.h"
#import "UserInfoModel.h"
#import "AppVersionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface InitializeModel : NSObject

@property (nonatomic, strong) BaseConfigModel   *baseConfig;
@property (nonatomic, strong) UserInfoModel     *userInfo;
@property (nonatomic, strong) AppVersionModel   *appVersion;

@end

NS_ASSUME_NONNULL_END
