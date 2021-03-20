//
//  YLCookieManager.m
//  YLNote
//
//  Created by tangh on 2021/3/20.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLCookieManager.h"

@implementation YLCookieManager

+ (void)saveCookies:(WKWebView *)webView handle:(void (^)(BOOL isSuccessful))saveResponse {
    if (@available(iOS 11.0, *)) {
        WKHTTPCookieStore *shareCookie = webView.configuration.websiteDataStore.httpCookieStore;
        [shareCookie getAllCookies:^(NSArray<NSHTTPCookie *> * _Nonnull cookiesArray) {
             [self dealSaveCookie:cookiesArray handle:saveResponse];
        }];
    } else {
        // Fallback on earlier versions
        NSHTTPCookieStorage * shareCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        [self dealSaveCookie:[shareCookie cookies] handle:saveResponse];
    }
    
   
}
 
 
+ (void)dealSaveCookie:(NSArray<NSHTTPCookie *> *)cookiesArray handle:(void (^)(BOOL isSuccessful))saveResponse {
    NSMutableArray *TempCookies = [NSMutableArray array];
    
    [TempCookies addObjectsFromArray:cookiesArray];
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject:TempCookies];
    [[NSUserDefaults standardUserDefaults] setObject:cookiesData forKey:@"webCookie"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (saveResponse) {
        saveResponse(YES);
    }
}

+ (NSArray *)updateCookies:(WKWebView *)webView {
    NSMutableArray *localCookies =[NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: @"webCookie"]];
 
    for (NSHTTPCookie *cookie in localCookies) {
        if (@available(iOS 11.0, *)) {
            WKHTTPCookieStore *cookieStore = webView.configuration.websiteDataStore.httpCookieStore;
            [cookieStore setCookie:cookie completionHandler:nil];
        } else {
            NSHTTPCookieStorage * shareCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            [shareCookie setCookie:cookie];
        }
    }
 
    return localCookies;
}

@end
