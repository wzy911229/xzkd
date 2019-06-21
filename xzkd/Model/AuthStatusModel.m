//
//  AuthStatusModel.m
//  xzkd
//
//  Created by 刘琛 on 2019/3/5.
//  Copyright © 2019年 xxy. All rights reserved.
//

#import "AuthStatusModel.h"

@implementation AuthStatusModel

- (BOOL)allAuthSuccess {
    return self.liveAuth.integerValue == 1 && self.bankAuth.integerValue == 1 && self.userInfoAuth.integerValue == 1 && self.operatorAuth.integerValue == 1 && self.mailAuth.integerValue == 1 && self.OtherAuth.integerValue == 1;
}

@end
