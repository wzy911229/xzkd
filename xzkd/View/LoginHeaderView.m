//
//  LoginHeaderView.m
//  xzkd
//
//  Created by 小咸鱼 on 2019/3/2.
//  Copyright © 2019 xxy. All rights reserved.
//

#import "LoginHeaderView.h"
@interface LoginHeaderView ()
@property (nonatomic, strong) UIImageView   *bgImageView;
@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UILabel       *amountLabel;
@property (nonatomic, strong) UILabel       *durationLabel;
@end

@implementation LoginHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_createSubViews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self p_createSubViews];
}

- (void)configBackgroundImage:(NSString *)bgImage
                        title:(NSString *)title
                       amount:(NSString *)amount
                     duration:(NSString *)duration {
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:bgImage] placeholderImage:Image(@"login_bg")];
    self.titleLabel.text = title;
    self.amountLabel.text = amount;
    if (!kStringIsEmpty(duration)) {
        NSMutableAttributedString *mString = [[NSMutableAttributedString alloc] initWithString:kFormat(@"借款期间：%@", duration)];
        [mString setAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} range:NSMakeRange(5, duration.length - 1)];
        self.durationLabel.attributedText = mString;
    }
    self.titleLabel.hidden = kStringIsEmpty(title);
    self.amountLabel.hidden = kStringIsEmpty(amount);
    self.durationLabel.hidden = kStringIsEmpty(duration);
}

- (void)p_createSubViews {
    self.backgroundColor = [UIColor greenColor];
    [self addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.bgImageView addSubview:self.titleLabel];
    [self.bgImageView addSubview:self.amountLabel];
    [self.bgImageView addSubview:self.durationLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgImageView).offset(SCALE(80));
        make.height.mas_equalTo(SCALE(17));
        make.centerX.mas_equalTo(self.bgImageView);
    }];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(SCALE(19));
        make.height.mas_equalTo(SCALE(37));
        make.centerX.mas_equalTo(self.bgImageView);
    }];
    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.amountLabel.mas_bottom).offset(SCALE(20));
        make.height.mas_equalTo(SCALE(20));
        make.centerX.mas_equalTo(self.bgImageView);
    }];
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:@"借款期间：7-45天"];
    [aString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(5, 4)];
    self.durationLabel.attributedText = aString;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:Image(@"login_bg")];
    }
    return _bgImageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont p_numberBoldFontSize:18];
        _titleLabel.textColor = [UIColor colorWithHex:0xFFE65B];
        _titleLabel.text = @"授信额度";
    }
    return _titleLabel;
}

- (UILabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.font = [UIFont p_numberBoldFontSize:41];
        _amountLabel.textColor = [UIColor whiteColor];
        _amountLabel.text = @"8000元";
    }
    return _amountLabel;
}

- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc] init];
        _durationLabel.font = [UIFont p_numberBoldFontSize:20];
        _durationLabel.textColor = [UIColor colorWithHex:0xFFE65B];
    }
    return _durationLabel;
}
@end
