//
//  WebViewUtil.h
//  ZxWebViewControllerDemo
//
//  Created by xpzheng on 2020/5/12.
//  Copyright © 2020 xpzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebViewUtil : NSObject

/** 获取当前cookie脚本 */
+ (NSString *) getCookieScript;

@end

NS_ASSUME_NONNULL_END
