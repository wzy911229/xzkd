//
//  XZAddressBookView.h
//  xzkd
//
//  Created by zhiyu on 2019/6/18.
//  Copyright © 2019 xxy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XZAddressBookViewDelegate <NSObject>

@optional

- (void)addressBookViewDidSelectCell:(NSDictionary *)selectInfo indexPath:(NSIndexPath *)indexPath ;

@end
NS_ASSUME_NONNULL_BEGIN

@interface XZAddressBookView : UIView
@property (nonatomic,strong)NSArray *addressBooks;
@property(nonatomic, weak) id <XZAddressBookViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
