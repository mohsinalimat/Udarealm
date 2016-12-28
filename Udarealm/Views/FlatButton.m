//
//  FlatButton.m
//  Doubi
//
//  Created by 熊国锋 on 16/5/30.
//  Copyright © 2016年 Nanjing Viroyal. All rights reserved.
//

#import "FlatButton.h"
#import "UIImage+YuCloud.h"


@interface FlatButton ()

@property (nonatomic, strong)   UILabel             *titleView;

@end

@implementation FlatButton

+ (instancetype)button {
    return [self buttonWithType:UIButtonTypeCustom];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    
    return self;
}

- (UILabel *)titleView {
    if (!_titleView) {
        _titleView = [[UILabel alloc] init];
        _titleView.font = self.titleFont;
        _titleView.textColor = self.titleColor;
        _titleView.adjustsFontSizeToFitWidth = YES;
        
        [self addSubview:_titleView];
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.lessThanOrEqualTo(self.mas_width);
        }];
    }
    
    return _titleView;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = [titleFont copy];
    if (_titleView) {
        [_titleView setFont:_titleFont];
    }
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = [titleColor copy];
    if (_titleView) {
        [_titleView setTextColor:_titleColor];
    }
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
    self.titleLabel.hidden = YES;
    
    [self.titleView setText:title];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.cornerRadius) {
        self.layer.cornerRadius = self.cornerRadius;
        self.layer.masksToBounds = YES;
    }
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsMake(4, 8, 4, 8);
}

- (CGSize)intrinsicContentSize {
    CGSize textSize = [self.titleView intrinsicContentSize];
    
    UIEdgeInsets layoutMargins = [self layoutMargins];
    
    return CGSizeMake(textSize.width + layoutMargins.left + layoutMargins.right,
                      textSize.height + layoutMargins.top + layoutMargins.bottom);
}

@end
