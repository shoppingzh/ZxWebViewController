//
//  ZxWebErrorView.h
//  ZxWebViewControllerDemo
//
//  Created by xpzheng on 2020/5/13.
//  Copyright © 2020 xpzheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZxWebErrorView : UIView

/** 错误码 */
@property (nonatomic, assign) NSInteger errorCode;
@property (nonatomic, strong) UIImageView *errorImageView;

- (instancetype) initWithErrorCode: (NSInteger) errorCode;

@end

NS_ASSUME_NONNULL_END
