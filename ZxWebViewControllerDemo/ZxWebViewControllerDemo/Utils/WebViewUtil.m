//
//  WebViewUtil.m
//  ZxWebViewControllerDemo
//
//  Created by xpzheng on 2020/5/12.
//  Copyright © 2020 xpzheng. All rights reserved.
//

#import "WebViewUtil.h"

@implementation WebViewUtil

+ (NSString *) getCookieScript {
    NSMutableString *script = [NSMutableString string];
    [script appendString:@"var cookieNames = document.cookie.split('; ').map(function(cookie) { return cookie.split('=')[0] } );\n"];
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        if ([cookie.value rangeOfString:@"'"].location != NSNotFound) {
            continue;
        }
        [script appendFormat:@"if (cookieNames.indexOf('%@') == -1) { document.cookie='%@'; };\n", cookie.name, [WebViewUtil getCookieInline:cookie]];
    }
    return script;
}

+ (NSString *) getCookieInline: (NSHTTPCookie *) cookie {
    NSString *desc = [NSString stringWithFormat:@"%@=%@;domain=%@;path=%@",
                        cookie.name,
                        cookie.value,
                        cookie.domain,
                        cookie.path ?: @"/"];
    if (cookie.secure) {
        desc = [desc stringByAppendingString:@";secure=true"];
    }
    return desc;
}

@end
