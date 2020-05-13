//
//  ZxWebViewController.h
//  ZxWebViewControllerDemo
//
//  Created by xpzheng on 2020/5/12.
//  Copyright © 2020 xpzheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "ZxWebErrorView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZxWebViewController : UIViewController

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) bool showProgress;
@property (nonatomic, strong) UIView *errorView;

- (instancetype) initWithUrl: (NSString *) url;
- (void) load: (NSString *) url;
- (void) reload;
- (void) goBack;
- (void) goForward;

@end

NS_ASSUME_NONNULL_END
