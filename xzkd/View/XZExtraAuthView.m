//
//  XZExtraAuthView.m
//  xzkd
//
//  Created by zhiyu on 2019/6/18.
//  Copyright © 2019 xxy. All rights reserved.
//

#import "XZExtraAuthView.h"
#import "MOFSPickerManager.h"


@interface InsetsTextField : UITextField
- (CGRect)textRectForBounds:(CGRect)bounds;
- (CGRect)editingRectForBounds:(CGRect)bounds;
@end
@implementation InsetsTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 0 );
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 0 );
}

@end

@implementation XZExtraAuthView {
    UIButton * _addressbtn;
    InsetsTextField * _textField;
    UIButton *  _linkman;
    UIButton *  _sureBtn;
    NSString * _selectAddress;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self setBackgroundColor:kBaseViewColor];
        
    }
    return self;
}

- (void)setupSubviews {
    
    //地址选择
    UIButton * addressbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addressbtn setTitle:@"所在地区" forState:UIControlStateNormal];
    [addressbtn setTitleColor:kLabelGrayColor forState:UIControlStateNormal];
    [addressbtn setBackgroundColor:[UIColor whiteColor]];
    addressbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [addressbtn setImage:[UIImage imageNamed:@"allow"] forState:UIControlStateNormal];
    [addressbtn addTarget:self action:@selector(onPressAddressBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addressbtn];
    _addressbtn = addressbtn;
    
    //详细地址输入
    InsetsTextField * textField = [[InsetsTextField alloc]init];
    [textField setPlaceholder:@"请输入详细地址（如道路、门牌、楼栋等）"];
    [textField setBackgroundColor:[UIColor whiteColor]];
    [textField setTextColor:kLabelGrayColor];
    [self addSubview:textField];
    
    _textField = textField;
    
    
    //紧急联系人
    UIButton *  linkman= [UIButton buttonWithType:UIButtonTypeCustom];
    
    [linkman setTitle:@"获取紧急联系人" forState:UIControlStateNormal];
    [linkman addTarget:self action:@selector(onPressLinkmanBtn) forControlEvents:UIControlEventTouchUpInside];
    [linkman setBackgroundColor:[UIColor whiteColor]];
    [linkman setTitleColor:kOriginColor forState:UIControlStateNormal];
    [self addSubview:linkman];
    _linkman = linkman;
    
    //确认按钮
    UIButton *  sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:kOriginColor];
    [sureBtn addTarget:self action:@selector(onPressSureBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureBtn];
    _sureBtn = sureBtn;
    
    [self updateConstraints];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
     CGFloat btnWidth = _addressbtn.bounds.size.width;
     CGFloat imageWidth = _addressbtn.imageView.bounds.size.width;
    _addressbtn.imageEdgeInsets = UIEdgeInsetsMake(0, btnWidth- imageWidth - 10, 0, -imageWidth );
    _addressbtn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth +10, 0, imageWidth);
}


- (void)updateConstraints{
    [super updateConstraints];
    [_addressbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(1);
        make.right.left.equalTo(self);
        make.height.mas_equalTo(44);
        
    }];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self);
        make.top.mas_equalTo(self->_addressbtn.mas_bottom).offset(1);
        make.height.mas_equalTo(44);
    }];
    
    [_linkman mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.mas_equalTo(self->_textField.mas_bottom).offset(20);
        make.height.mas_equalTo(44);
    }];
    
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(44);
    }];
    
    
}



- (void)onPressAddressBtn {

    [_textField resignFirstResponder];
    __block __weak typeof(_addressbtn) _weakaddressBtn = _addressbtn;

    [[MOFSPickerManager shareManger] showMOFSAddressPickerWithTitle:nil cancelTitle:@"取消" commitTitle:@"完成" commitBlock:^(NSString *address, NSString *zipcode) {
        [_weakaddressBtn setTitle:address forState:UIControlStateNormal];
        self->_selectAddress = address;
    } cancelBlock:nil];
}


- (void)onPressLinkmanBtn {
    
    if (_delegate && [_delegate respondsToSelector:@selector(extraAuthViewOnPressAddressBook:)]) {
        [_delegate extraAuthViewOnPressAddressBook:_linkman];
    }
    
}

- (void)onPressSureBtn {
    if (!_selectAddress) {
        [SVProgressHUD showInfoWithStatus:@"请选择地区"];
        return;
    }
    
    if ([_textField.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请输入详细地址"];
        return;
    }
    
    NSString * addressInfo = [NSString stringWithFormat:@"%@-%@",_selectAddress,_textField.text];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:addressInfo forKey:@"user_address"];
    if (_delegate && [_delegate respondsToSelector:@selector(extraAuthViewOnPressSure:)]) {
        [_delegate extraAuthViewOnPressSure: dict];
    }
    
}


// 设置颜色
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

