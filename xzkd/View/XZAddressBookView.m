//
//  XZAddressBookView.m
//  xzkd
//
//  Created by zhiyu on 2019/6/18.
//  Copyright © 2019 xxy. All rights reserved.
//

#import "XZAddressBookView.h"
#import "XZAddressBookCell.h"
@interface XZAddressBookView ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *selectArray;

@end
@implementation XZAddressBookView
static NSString *KAddressBookID = @"KAddressBookID";


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadTableView];
        [self setBackgroundColor:kBaseViewColor];
        
    }
    return self;
}


- (void)loadTableView
{
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.bounds];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0 , 0);
    [tableView setBackgroundColor:kBaseViewColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self addSubview:tableView];
    _tableView = tableView;
    
    [_tableView registerClass:[XZAddressBookCell class] forCellReuseIdentifier:KAddressBookID];

}

- (void)setAddressBooks:(NSArray *)addressBooks{
    _addressBooks = addressBooks;
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _addressBooks.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XZAddressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:KAddressBookID forIndexPath:indexPath];
    NSString *imageName = [self.selectArray containsObject:[NSNumber numberWithInteger:indexPath.row]] ? @"choose" :@"unchoose";
    [cell.imageView setImage: [UIImage imageNamed:imageName]];
    NSDictionary * addressBook = _addressBooks[indexPath.row];
    
    NSString *name = addressBook[@"name"];
    if(addressBook[@"phoneList"] && [addressBook[@"phoneList"] isKindOfClass:[NSArray class]]){
        NSArray * phoneList = addressBook[@"phoneList"];
        name = [NSString stringWithFormat:@"%@    %@",name,phoneList[0]];
    }
    
    
    [cell.textLabel setText:name];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    
    XZAddressBookCell *cell = (XZAddressBookCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSNumber * index = [NSNumber numberWithInteger:indexPath.row];
    if ([self.selectArray containsObject:index]) {
        [self.selectArray removeObject:index];
        [cell.imageView setImage:[UIImage imageNamed:@"unchoose"]];
    }else{
        
        if(self.selectArray.count >= 2){
            [SVProgressHUD showErrorWithStatus:@"最多选择两位紧急联系人"];
            return;
        }
        
        [self.selectArray addObject:index];
        [cell.imageView setImage:[UIImage imageNamed:@"choose"]];
        if (_delegate && [_delegate respondsToSelector:@selector(addressBookViewDidSelectCell:indexPath:)]) {
            [_delegate addressBookViewDidSelectCell:_addressBooks[indexPath.row] indexPath:indexPath];
        }
        
    }

}


- (NSMutableArray *)selectArray{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

@end
