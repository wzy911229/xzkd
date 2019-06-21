//
//  MultistagePickerView.h
//  iSee
//
//  Created by 刘琛 on 2019/2/25.
//  Copyright © 2019年 刘琛. All rights reserved.
//  多级选择器符合json结构

#import <UIKit/UIKit.h>
typedef void (^MultistagePickerViewSuccessBlock)(NSString *selectedStr, NSArray *resultArray);
typedef void (^MultistagePickerViewFailureBlock)(void);


@interface MultistagePickerView : UIView

/*
 数据结构
 {
    "child": {
        "child": [
            {
                "configName": "C",
                "configCode": "CCode"
            }
        ],
        "configName": "B",
        "configCode": "BCode"
    },
    "configName": "A",
    "configCode": "ACode"
 }
 
    configCode 具体参数值
    child      下级转轮数组
 */

+ (void)ShowMultistagePickerInView:(UIView *) view
                          dataList:(NSArray *) dataList
                           success:(MultistagePickerViewSuccessBlock) success
                           failure:(MultistagePickerViewFailureBlock) fail;

//1-2-1 0-0-0 //选中单元格标识
+ (void)ShowMultistagePickerInView:(UIView *) view
                          dataList:(NSArray *) dataList
                       selectedStr:(NSString *) selectedStr
                           success:(MultistagePickerViewSuccessBlock) success
                           failure:(MultistagePickerViewFailureBlock) fail;

@end

