//
//  YLCookieManager.h
//  YLNote
//
//  Created by tangh on 2021/3/20.
//  Copyright © 2021 tangh. All rights reserved.
//

#import <Foundation/Foundation.h>
@import WebKit;

NS_ASSUME_NONNULL_BEGIN

@interface YLCookieManager : NSObject
+ (NSArray *)updateCookies:(WKWebView *)webView;

+ (void)saveCookies:(WKWebView *)webView handle:(void (^)(BOOL isSuccessful))saveResponse;

+ (void)dealSaveCookie:(NSArray<NSHTTPCookie *> *)cookiesArray handle:(void (^)(BOOL isSuccessful))saveResponse;

@end

NS_ASSUME_NONNULL_END
