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
        if (@available(iOS 13.0, *)) {
            self.backgroundColor = [UIColor systemGray6Color];
        } else {
            self.backgroundColor = [UIColor lightGrayColor];
        }
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
    [((UIButton*)self.backView) setEnabled:backEnabled];
    [self setHidden:!_backEnabled && !_forwardEnabled];
}

- (void)setForwardEnabled:(bool)forwardEnabled {
    _forwardEnabled = forwardEnabled;
    [((UIButton*)self.forwardView) setEnabled:forwardEnabled];
    [self setHidden:!_backEnabled && !_forwardEnabled];
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [self operateBtn: @"\U0000ea95"];
    }
    return _backView;
}

- (UIView *)forwardView {
    if (!_forwardView) {
        _forwardView = [self operateBtn:@"\U0000e6b7"];
    }
    return _forwardView;
}

- (UIButton*) operateBtn: (NSString*) title {
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"iconfont" size:16];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    return btn;
}

#pragma mark - 覆写setHidden
- (void)setHidden:(BOOL)hidden {
    // 隐藏: 随时可隐藏 显示: 只有后退/前进按钮其中一个可用时才可以显示
    if (hidden || self.backEnabled || self.forwardEnabled) {
        [super setHidden:hidden];
    }
}

@end
