//
//  AppVersionModel.h
//  xzkd
//
//  Created by 刘琛 on 2019/3/3.
//  Copyright © 2019年 xxy. All rights reserved.
//

#import <Foundation/Foundation.h>


/*
 appVersion:{
    version:'1.3.2',
    mobileId:'wweefsfsdewf',
    osType:'ios'
 }
 */

NS_ASSUME_NONNULL_BEGIN

@interface AppVersionModel : NSObject

@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *mobileId;
@property (nonatomic, strong) NSString *osType;

@end

NS_ASSUME_NONNULL_END
