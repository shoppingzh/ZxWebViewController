//
//  ZxNavigateBarView.h
//  ZxWebViewControllerDemo
//
//  Created by xpzheng on 2020/5/13.
//  Copyright © 2020 xpzheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZxNavigateBarView : UIView

@property (nonatomic, strong, readonly) UIView *backView;
@property (nonatomic, strong, readonly) UIView *forwardView;
@property (nonatomic, assign) bool backEnabled;
@property (nonatomic, assign) bool forwardEnabled;

@end

NS_ASSUME_NONNULL_END
