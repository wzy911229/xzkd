//
//  XZAddressBookViewController.m
//  xzkd
//
//  Created by zhiyu on 2019/6/18.
//  Copyright © 2019 xxy. All rights reserved.
//

#import "XZAddressBookViewController.h"
#import "XZAddressBookView.h"
#import "XZAddressBookPopverViewController.h"
@interface XZAddressBookViewController ()<XZAddressBookViewDelegate,XZAddressBookPopverViewDelegate>

@end

@implementation XZAddressBookViewController{
    XZAddressBookView * _addressBookView ;
    XZAddressBookPopverViewController *_popVc;
    NSMutableArray * _linkMans;
    UIButton *  _sureBtn;

}

- (void)loadView {
    [super loadView];
    [self setupsubViews];
    
}
- (void)setupsubViews{
    
    //通讯录
    XZAddressBookView * addressBookView = [[XZAddressBookView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 44)];
    [addressBookView setAddressBooks:_addressBooks];
    addressBookView.delegate = self;
    [self.view addSubview:addressBookView];
    _addressBookView = addressBookView;
    
    
    //确认按钮
    UIButton *  sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:kOriginColor];
    [sureBtn addTarget:self action:@selector(onPressSureBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    _sureBtn = sureBtn;
    
    
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系人";
    self.navigationController.navigationBar.topItem.title = @"";
    [SVProgressHUD  setMinimumDismissTimeInterval:0.5];
    _linkMans = [NSMutableArray array];
}


- (void)setAddressBooks:(NSArray *)addressBooks{
    _addressBooks = addressBooks;
    [_addressBookView setAddressBooks:addressBooks];
}



- (void)onPressSureBtn {
    if (_linkMans.count < 2) {
        [SVProgressHUD showInfoWithStatus:@"必须选择两个联系人"];
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(addressBookViewControllerFinishSelectLinkMans:)]) {
        
        [_delegate addressBookViewControllerFinishSelectLinkMans:_linkMans];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)addressBookViewDidSelectCell:(NSDictionary *)selectInfo indexPath:(NSIndexPath *)indexPath {
    
    XZAddressBookPopverViewController * popVc = [[XZAddressBookPopverViewController alloc]init];
    popVc.selectInfo = selectInfo;
    popVc.delegate = self;
    [popVc.view setFrame:self.view.bounds];
    [self addChildViewController:popVc];
    [self.view addSubview:popVc.view];
}

- (void)addressBookPopverViewDidSelectLinkMan:(NSDictionary *)selectInfo {
    
    [_linkMans addObject:selectInfo];
}


@end
