//
//  XMTabBarButton.m
//  WorkerNews
//
//  Created by JiaCong Zhu on 2019/1/21.
//  Copyright © 2019 XiMu. All rights reserved.
//

#import "XMTabBarButton.h"


@interface XMTabBarButton ()

@property (nonatomic, strong) UIImageView   *iconView;
@property (nonatomic, strong) UILabel       *textLabel;

@end

@implementation XMTabBarButton
- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon selectedIcon:(UIImage *)selectedIcon {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.iconView.image = icon;
        self.iconView.highlightedImage = selectedIcon;
        self.textLabel.text = title;
    }
    return self;
}
- (instancetype)initWithTitle:(NSString *)title iconURL:(NSURL *)iconURL selectedIconURL:(NSURL *)selectedIconURL {
    self = [self initWithFrame:CGRectZero];
    if (self) {
    
        self.textLabel.text = title;
        SDWebImageManager *sdManager = [SDWebImageManager sharedManager];
        [self.iconView sd_setImageWithURL:iconURL];
        [sdManager loadImageWithURL:selectedIconURL options:SDWebImageHighPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            self.iconView.highlightedImage = image;
        }];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_createSubViews];
    }
    return self;
}

- (void)p_createSubViews {
    [self addSubview:self.iconView];
    [self addSubview:self.textLabel];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.top.mas_equalTo(self).offset(8);
        make.centerX.mas_equalTo(self);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.iconView.mas_bottom).offset(4);
        make.height.mas_equalTo(10);
    }];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.iconView.highlighted = selected;
    self.textLabel.textColor = selected ? [UIColor colorWithHex:0x3070DC] : [UIColor colorWithHex:0x666666];
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
    }
    return _iconView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont p_fontWithSize:10];
        _textLabel.textColor = [UIColor colorWithHex:0x999999];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

@end
