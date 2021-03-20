//
//  YLWebNoteManager.m
//  YLNote
//
//  Created by tangh on 2021/1/6.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLWebNoteManager.h"
#import "YLNote-Swift.h"
#import "YLWindowLoader.h"

@implementation YLWebNoteManager

+ (nonnull instancetype)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

+ (NSDictionary *)allNotes {
    return @{
        @"group":@"Web",
        @"questions":
            @[
                @{
                    @"description":@"所有相关demo",
                    @"answer":@"testDemos",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                @{
                    @"description":@"JS和native互相调用的几种方式",
                    @"answer":@"testJStoNative",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                @{
                    @"description":@"微信环境h5页面登录实现流程",
                    @"answer":@"testWeChatAuthon",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                @{
                    @"description":@"WKWebView Cookie",
                    @"answer":@"testCookie",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                
                
            ]
    };
}

+ (void)testDemos {
    UIViewController *currentVC = [YLWindowLoader getCurrentVC];
    YLWKWebListViewController *vc = [[YLWKWebListViewController alloc] init];
    if (currentVC.navigationController) {
        [currentVC.navigationController pushViewController:vc animated:YES];
    } else {
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:currentVC];
        [navi pushViewController:vc animated:YES];
    }
}


+ (void)testJStoNative {
    UIViewController *currentVC = [YLWindowLoader getCurrentVC];
    YLArticleMDViewController *vc = [[YLArticleMDViewController alloc] initWithMarkdown:@"Web-JS交互"];
    
    if (currentVC.navigationController) {
        [currentVC.navigationController pushViewController:vc animated:YES];
    } else {
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:currentVC];
        [navi pushViewController:vc animated:YES];
    }
}

+ (void)testWeChatAuthon {
    UIViewController *currentVC = [YLWindowLoader getCurrentVC];
    YLArticleMDViewController *vc = [[YLArticleMDViewController alloc] initWithMarkdown:@"Web-WeChatAuthon"];
    
    if (currentVC.navigationController) {
        [currentVC.navigationController pushViewController:vc animated:YES];
    } else {
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:currentVC];
        [navi pushViewController:vc animated:YES];
    }
}

+ (void)testCookie {
    UIViewController *currentVC = [YLWindowLoader getCurrentVC];
    YLArticleMDViewController *vc = [[YLArticleMDViewController alloc] initWithMarkdown:@"Web-Cookie"];
    
    if (currentVC.navigationController) {
        [currentVC.navigationController pushViewController:vc animated:YES];
    } else {
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:currentVC];
        [navi pushViewController:vc animated:YES];
    }
}

@end
