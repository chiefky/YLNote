//
//  YLArticalViewController.m
//  YLNote
//
//  Created by tangh on 2021/1/9.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLArticalViewController.h"
#import "YLDefaultMacro.h"
#import <WebKit/WebKit.h>

@interface YLArticalViewController ()

@property (nonatomic,strong)WKWebView *wkWebView;

@end

@implementation YLArticalViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.wkWebView.frame = YLSCREEN_BOUNDS;
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.wkWebView];
    
    if (self.htmlUrl) {
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.htmlUrl]]];
    } else {
//        [self.wkWebView fa]
    }
    
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] init];
    }
    return _wkWebView;
}

@end
