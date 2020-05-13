//
//  ZxNavigateBarView.m
//  ZxWebViewControllerDemo
//
//  Created by xpzheng on 2020/5/13.
//  Copyright © 2020 xpzheng. All rights reserved.
//

#import "ZxNavigateBarView.h"
#import <Masonry/Masonry.h>

@interface ZxNavigateBarView()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *forwardView;

@end

@implementation ZxNavigateBarView


- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithRed:.93 green:.94 blue:.95 alpha:1];
        
        [self addSubview:self.backView];
        [self addSubview:self.forwardView];
        
        self.backEnabled = NO;
        self.forwardEnabled = NO;
    }
    return self;
}

- (void)layoutSubviews {
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_centerX).mas_offset(-44);
    }];
    [self.forwardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_centerX).offset(44);
    }];
}

- (void)setBackEnabled:(bool)backEnabled {
    _backEnabled = backEnabled;
    ((UILabel*)self.backView).textColor = [UIColor colorWithRed:.2 green:.2 blue:.2 alpha: backEnabled ? 1 : .5];
    self.backView.userInteractionEnabled = backEnabled;
    [self setHidden:!_backEnabled && !_forwardEnabled];
}

- (void)setForwardEnabled:(bool)forwardEnabled {
    _forwardEnabled = forwardEnabled;
    ((UILabel*) self.forwardView).textColor = [UIColor colorWithRed:.2 green:.2 blue:.2 alpha: forwardEnabled ? 1 : .5];
    self.forwardView.userInteractionEnabled = forwardEnabled;
    [self setHidden:!_backEnabled && !_forwardEnabled];
}

- (UIView *)backView {
    if (!_backView) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"后退";
        _backView = label;
    }
    return _backView;
}

- (UIView *)forwardView {
    if (!_forwardView) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"前进";
        _forwardView = label;
    }
    return _forwardView;
}

@end
