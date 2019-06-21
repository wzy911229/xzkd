//
//  LoanConfigModel.m
//  xzkd
//
//  Created by 小咸鱼 on 2019/3/8.
//  Copyright © 2019 xxy. All rights reserved.
//

#import "LoanConfigModel.h"

@implementation LoanConfigModel

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([property.name isEqualToString:@"repayDate"]) {
        return [NSDate dateFromString:oldValue format:@"yyyy-MM-dd HH:mm:ss"];
    }
    return oldValue;
}
@end
