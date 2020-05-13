//
//  ZxWebViewController.m
//  ZxWebViewControllerDemo
//
//  Created by xpzheng on 2020/5/12.
//  Copyright © 2020 xpzheng. All rights reserved.
//

#import "ZxWebViewController.h"
#import <Masonry.h>
#import "WebViewUtil.h"
#import "ZxNavigateBarView.h"

@interface ZxWebViewController () <WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) ZxNavigateBarView *navigateBarView;

@property (nonatomic, copy) NSString *url;
/** 加载错误的url */
@property (nonatomic, copy) NSString *errorUrl;
/** 开始滚动的y轴坐标 */
@property (nonatomic, assign) CGFloat startScrollY;

@end

@implementation ZxWebViewController

- (instancetype)initWithUrl:(NSString *)url {
    if (self = [super init]) {
        _url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"WebView UI初始化");
    
    [self setupView];
    [self setupOptions];
    
    
    [self load:self.url];
}

# pragma mark - APIs

- (void)reload {
    [self.webView reload];
}

- (void)goBack {
    [self.webView goBack];
}

- (void)goForward {
    [self.webView goForward];
}

- (void)load:(NSString *)url {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}


# pragma mark - 初始化

- (void) setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.navigateBarView];
    [self.view addSubview:self.errorView];
    // 调整子view的层级
    [self.view bringSubviewToFront:self.progressView];
    
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.top.mas_equalTo(self.view.mas_top);
            make.bottom.mas_equalTo(self.view.mas_bottom);
        }
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.mas_equalTo(self.view.mas_top);
        }
        
        make.height.mas_equalTo(1);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    [self.navigateBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        if (@available(iOS 11, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
        make.height.mas_equalTo(44);
    }];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void) setupOptions {
    self.showProgress = YES;
}

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *conf = [[WKWebViewConfiguration alloc] init];
        conf.allowsInlineMediaPlayback = YES;
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:conf];
        
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.scrollView.delegate = self; // 监听webView的滚动事件
        
        // 监听标题、进度、前进、后退
        [_webView addObserver:self forKeyPath:NSStringFromSelector(@selector(title)) options:NSKeyValueObservingOptionNew context:nil];
        [_webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionNew context:nil];
        [_webView addObserver:self forKeyPath:NSStringFromSelector(@selector(canGoBack)) options:NSKeyValueObservingOptionNew context:nil];
        [_webView addObserver:self forKeyPath:NSStringFromSelector(@selector(canGoForward)) options:NSKeyValueObservingOptionNew context:nil];
        
        // 注入cookie
        WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:[WebViewUtil getCookieScript] injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [_webView.configuration.userContentController addUserScript:cookieScript];
    }
    return _webView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.backgroundColor = [UIColor colorWithRed:.0956 green:.0564 blue:1 alpha:.1];
    }
    return _progressView;
}

- (UIView *)errorView {
    if (!_errorView) {
        _errorView = [[ZxWebErrorView alloc] init];
        [_errorView setHidden:YES];
        
        [_errorView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadWhenError:)]];
    }
    return _errorView;
}

- (ZxNavigateBarView *)navigateBarView {
    if (!_navigateBarView) {
        _navigateBarView = [[ZxNavigateBarView alloc] init];
        [_navigateBarView setHidden:YES];
        [_navigateBarView.backView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userGoBack:)] ];
        [_navigateBarView.forwardView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userGoForward:)] ];
        
    }
    return _navigateBarView;
}

- (IBAction)userGoBack:(id)sender {
    [self goBack];
}

- (IBAction)userGoForward:(id)sender {
    [self goForward];
}

# pragma mark - 参数设置

- (void)setShowProgress:(bool)showProgress {
    _showProgress = showProgress;
    self.progressView.alpha = showProgress ? 1 : 0;
}

# pragma mark - WebView Navigation delegate (cookie同步/错误处理)
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    [self.progressView setHidden:NO];
    
    // 同步cookie(可能来自于native，但绝不是来自于WKWebView，因为WkWebView有自己的cookie存储)
    NSMutableURLRequest *request;
    if ([navigationAction.request isKindOfClass:[NSMutableURLRequest class]]) {
        request = (NSMutableURLRequest*)navigationAction.request;
    } else {
        request = navigationAction.request.mutableCopy;
    }
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:request.URL];
    request.allHTTPHeaderFields = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"错误：didFailNavigation");
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self didLoadError:error];
    NSLog(@"错误：didFailProvisionalNavigation");
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    [self.errorView setHidden:YES];
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    [self.errorView setHidden:YES];
}

# pragma mark - 加载错误与重试

// 加载发生错误
- (void) didLoadError: (NSError *) error {
    NSLog(@"%@", error);
    if ([error.domain isEqualToString: NSURLErrorDomain]) {
        NSDictionary *userInfo = error.userInfo;
        self.errorUrl = userInfo[NSURLErrorFailingURLStringErrorKey];
    }
    NSLog(@"加载过程发生错误：%@", error.userInfo);
    NSLog(@"当前错误URL：%@", self.errorUrl);
    
    [self.progressView setHidden:YES];
    if ([self.errorView isKindOfClass:[ZxWebErrorView class]]) {
        ((ZxWebErrorView *) self.errorView).errorCode = error.code;
    }
    [self.errorView setHidden:NO];
}

- (IBAction)reloadWhenError: (id) sender {
    [self load:self.errorUrl];
}

# pragma mark - WebView UI delegate (alert/comfirm/prompt/新开窗口)

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertUI = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertUI addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertUI animated:YES completion:nil];
    completionHandler();
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    UIAlertController *alertUI = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertUI addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alertUI addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alertUI animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    UIAlertController *alertUI = [UIAlertController alertControllerWithTitle:@"" message:prompt preferredStyle:UIAlertControllerStyleAlert];
    [alertUI addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setText:defaultText];
    }];
    [alertUI addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField =  [alertUI.textFields objectAtIndex:0];
        NSString *text = defaultText;
        if (textField) {
            text = textField.text;
        }
        completionHandler(text);
    }]];
    [alertUI addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(nil);
    }]];
    [self presentViewController:alertUI animated:YES completion:nil];
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    // isMainFrame: 是否在当前窗口打开链接(否则为子窗口)
    if ([navigationAction.targetFrame isMainFrame]) {
        [self.webView loadRequest:navigationAction.request];
    } else {
        ZxWebViewController *zxWebViewUI = [[ZxWebViewController alloc] initWithUrl:navigationAction.request.URL.absoluteString];
        [self.navigationController pushViewController:zxWebViewUI animated:YES];
    }
    return nil;
}

# pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    CGPoint point = scrollView.contentOffset;
    self.startScrollY = point.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = scrollView.contentOffset;
    CGFloat y = point.y;
    CGFloat offset = y - _startScrollY;
    if (offset > 50) {
        [self.navigateBarView setHidden:YES];
    }
    if (offset < -50) {
        [self.navigateBarView setHidden:NO];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // nop
}


# pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self.webView) {
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(title))]) {
            self.title = self.webView.title;
        } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]) {
            [self.progressView setProgress:self.webView.estimatedProgress];
            [self.progressView setHidden:self.webView.estimatedProgress >= 1];
        } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(canGoBack))]) {
            self.navigateBarView.backEnabled = self.webView.canGoBack;
        } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(canGoForward))]){
            self.navigateBarView.forwardEnabled = self.webView.canGoForward;
        }
    }
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(title))];
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(canGoBack))];
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(canGoForward))];
    
}


@end
