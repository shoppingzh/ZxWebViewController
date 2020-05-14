//
//  ZxWebErrorView.m
//  ZxWebViewControllerDemo
//
//  Created by xpzheng on 2020/5/13.
//  Copyright © 2020 xpzheng. All rights reserved.
//

#import "ZxWebErrorView.h"
#import <Masonry/Masonry.h>
#import "ZxNavigateBarView.h"

@interface ZxWebErrorView()

@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation ZxWebErrorView

- (instancetype)init {
    if (self = [super init]) {
        if (@available(iOS 13.0, *)) {
            self.backgroundColor = [UIColor systemBackgroundColor];
        } else {
            self.backgroundColor = [UIColor whiteColor];
        }
        
        [self addSubview:self.errorImageView];
        [self addSubview:self.errorLabel];
        [self addSubview:self.tipsLabel];
        [self addSubview:self.closeBtn];
        
        self.errorCode = -1;
    }
    return self;
}

- (instancetype)initWithErrorCode:(NSInteger)errorCode {
    if (self = [self init]) {
        self.errorCode = _errorCode;
    }
    return self;
}

- (void)layoutSubviews {
    [self.errorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).mas_offset(-60);
    }];
    [self.errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.errorImageView.mas_centerX);
        make.top.equalTo(self.errorImageView.mas_bottom).mas_offset(20);
    }];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.errorImageView.mas_centerX);
        make.top.equalTo(self.errorLabel.mas_bottom).mas_offset(10);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.errorImageView.mas_centerX);
        make.top.equalTo(self.tipsLabel.mas_bottom).mas_offset(10);
    }];
}

- (UIImageView *)errorImageView {
    if (!_errorImageView) {
        _errorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"web_error"]];
    }
    return _errorImageView;
}

- (UILabel *)errorLabel {
    if (!_errorLabel) {
        _errorLabel = [[UILabel alloc] init];
        _errorLabel.font = [UIFont systemFontOfSize:20];
        _errorLabel.textColor = [UIColor colorWithRed:.3 green:.3 blue:.3 alpha:1];
    }
    return _errorLabel;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.textColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1];
        _tipsLabel.font = [UIFont systemFontOfSize:12];
        [_tipsLabel setText:@"轻触页面进行刷新"];
    }
    return _tipsLabel;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setTitle:@"返回上一层" forState:UIControlStateNormal];
        [_closeBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        if (@available(iOS 13.0, *)) {
            [_closeBtn setTitleColor:[UIColor linkColor] forState:UIControlStateNormal];
        } else {
            [_closeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }
        [_closeBtn addTarget:self action:@selector(hideSelf:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (IBAction)hideSelf:(id)sender {
    [self setHidden:YES];
}

# pragma mark - APIs

- (void)setErrorCode:(NSInteger)errorCode {
    _errorCode = errorCode;
    self.errorLabel.text = [NSString stringWithFormat:@"网络发生错误(%ld)", errorCode];
}

@end
