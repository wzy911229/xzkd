//
//  XZAddressBookViewController.h
//  xzkd
//
//  Created by zhiyu on 2019/6/18.
//  Copyright © 2019 xxy. All rights reserved.
//

#import "ViewController.h"
@protocol XZAddressBookViewControllerDelegate <NSObject>

@optional

- (void)addressBookViewControllerFinishSelectLinkMans:(NSArray *)LinkMans;

@end
NS_ASSUME_NONNULL_BEGIN

@interface XZAddressBookViewController : BaseViewController
@property (nonatomic,strong)NSArray *addressBooks;
@property(nonatomic, weak) id <XZAddressBookViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
