//
//  XZAddressBookPopverViewController.m
//  xzkd
//
//  Created by zhiyu on 2019/6/18.
//  Copyright © 2019 xxy. All rights reserved.
//

#import "XZAddressBookPopverViewController.h"

@interface XZAddressBookPopverViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *parents;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIButton *kinsfolk;
@property (weak, nonatomic) IBOutlet UIButton *friend;
@property (weak, nonatomic) IBOutlet UIButton *lover;
@property (weak, nonatomic) IBOutlet UITextField *textfield;




@end

@implementation XZAddressBookPopverViewController {
    NSInteger _selectTag;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popPopver)];
    recognizer.delegate = self;
    
    [self.view addGestureRecognizer:recognizer];
    [_textfield setTextColor:kLabelGrayColor];
    if (_selectInfo) {
        _textfield.text = _selectInfo[@"name"];
    }
    [SVProgressHUD  setMinimumDismissTimeInterval:0.5];

}


- (void)popPopver{
    [self.view removeFromSuperview];
}

- (IBAction)onPressParents:(UIButton *)sender {
    [self selectBtn:sender.tag];

}

- (IBAction)onPressKinsfolk:(UIButton *)sender {
    [self selectBtn:sender.tag];
    
}
- (IBAction)onPressFriend:(UIButton *)sender {
    [self selectBtn:sender.tag];

}
- (IBAction)onPressLover:(UIButton *)sender {
    [self selectBtn:sender.tag];

}


- (IBAction)onPressSure:(id)sender {
    
    if (!_selectTag) {
        [SVProgressHUD showInfoWithStatus:@"请先选择联系人关系"];
        return;
    }
    
    NSString *contact_sign = @"";
  
    switch (_selectTag) {
        case 1001:
            contact_sign = @"父母亲";
            break;
        case 1002:
            contact_sign = @"配偶";
            break;
        case 1003:
            contact_sign = @"同事";
            break;
        case 1004:
            contact_sign = @"亲友";
            break;
        default:
            break;
        
        
    }
   
    NSMutableDictionary *resultInfo = [NSMutableDictionary dictionary];

    
    NSString* phone = @"";
    
    if(_selectInfo[@"phoneList"] && [_selectInfo[@"phoneList"] isKindOfClass:[NSArray class]]){
        NSArray * phoneList = _selectInfo[@"phoneList"];
        phone = phoneList[0];
    }
    
    [resultInfo setObject:contact_sign forKey:@"contact_sign"];
    [resultInfo setObject:phone forKey:@"contact_phone"];
    [resultInfo setObject:_selectInfo[@"name"] forKey:@"contact_name"];

    if (_delegate && [_delegate respondsToSelector:@selector(addressBookPopverViewDidSelectLinkMan:)]) {
        [_delegate addressBookPopverViewDidSelectLinkMan:resultInfo];
        [self popPopver];
    }
    
}

- (void)setSelectInfo:(NSDictionary *)selectInfo{
    _selectInfo = selectInfo;
    _textfield.text = selectInfo[@"name"];
}


- (void)selectBtn:(NSInteger)type {
    
    NSArray * btnArray = @[_kinsfolk,_lover,_friend,_parents];
    for (UIButton * btn in btnArray) {
        if ( btn.tag == type) {
            _selectTag = btn.tag;
        }
        NSString * imageName = btn.tag == type ? @"choose" : @"unchoose";
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.contentView]) {
        return NO;
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
