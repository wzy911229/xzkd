//
//  XZAddressBookPopverViewController.h
//  xzkd
//
//  Created by zhiyu on 2019/6/18.
//  Copyright © 2019 xxy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XZAddressBookPopverViewDelegate <NSObject>

@optional

- (void)addressBookPopverViewDidSelectLinkMan:(NSDictionary *)selectInfo;

@end
NS_ASSUME_NONNULL_BEGIN

@interface XZAddressBookPopverViewController : UIViewController
@property (nonatomic,strong) NSDictionary * selectInfo ;
@property(nonatomic, weak) id <XZAddressBookPopverViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
