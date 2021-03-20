//
//  TestCookieViewController.m
//  YLNote
//
//  Created by tangh on 2021/3/20.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "TestCookieViewController.h"
#import <WebKit/WebKit.h>
#import "YLCookieManager.h"

@interface TestCookieViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,strong) WKWebViewConfiguration *webConfig;
@end

@implementation TestCookieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
     NSString *string = @"/oauth2/v2/authorize?access_type=offline&response_type=code&client_id=100253825&lang=zh-cn&redirect_uri=hms%3A%2F%2Fredirect_url&scope=https%3A%2F%2Fwww.huawei.com%2Fauth%2Faccount%2Fbase.profile+https%3A%2F%2Fsmarthome.com%2Fauth%2Fsmarthome%2Fskill+https%3A%2F%2Fsmarthome.com%2Fauth%2Fsmarthome%2Fdevices&state=state&display=mobile";
    NSArray *cookiesArray = [YLCookieManager updateCookies:self.webView];
    
    NSString *string2 = [NSString stringWithFormat:@"https://login.vmall.com%@",string];
    
    //request首次携带Cookie
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:string2]];
    
    for (NSHTTPCookie *cookie in cookiesArray) {
        NSDictionary *cookieDict = [cookie dictionaryWithValuesForKeys:@[NSHTTPCookieName,
                                                                         NSHTTPCookieValue,
                                                                         NSHTTPCookieDomain,
                                                                         NSHTTPCookiePath]];
        NSString *cookieStr = @"";
        for (NSString *cookieKey in cookieDict.allKeys) {
            NSString *keyValue = [NSString stringWithFormat:@"%@=%@;",cookieKey,[cookieDict objectForKey:cookieKey]];
            cookieStr = [cookieStr stringByAppendingString:keyValue];
        }
        // cookie 写入request
        [request addValue:cookieStr forHTTPHeaderField:@"Cookie"];
    }
 
    // 跨域Cookie注入
    NSDictionary *cookieNewDict = [request allHTTPHeaderFields];
    NSString *cookieNewStr = [NSString stringWithFormat:@"document.cookie = '%@';", [cookieNewDict objectForKey:@"Cookie"]];
    WKUserContentController* userContentController = WKUserContentController.new;
    WKUserScript *cookieInScript = [[WKUserScript alloc] initWithSource:cookieNewStr
                                                              injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                           forMainFrameOnly:NO];
    [userContentController addUserScript:cookieInScript];
    self.webView.configuration.userContentController = userContentController;
    
    // 延迟再次更新Cookie
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [YLCookieManager updateCookies:self.webView];
        [self.webView loadRequest:request];
    });
}


- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:self.webConfig];
        [self.view addSubview:self.webView];
    }
    
    return _webView;
}
 
- (WKWebViewConfiguration *)webConfig {
    if (!_webConfig) {
        _webConfig = [[WKWebViewConfiguration alloc] init];
    }
    return _webConfig;
}


@end
