//
//  YLTestViewController.m
//  YLNote
//
//  Created by tangh on 2020/7/27.
//  Copyright © 2020 tangh. All rights reserved.
//

#import "YLTestViewController.h"
#import "YLNotificationCenter.h"
#import "YLNotification.h"

@interface YLTestViewController ()

@end

@implementation YLTestViewController

- (void)dealloc {
//    [[YLNotificationCenter defaultCenter] removeObserver:self name:@"changeViewColor" object:nil];
    NSLog(@"%s : %@",__FUNCTION__,[YLNotificationCenter defaultCenter].observerMap);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNotification];
    // Do any additional setup after loading the view.
    UIButton *butn = [UIButton buttonWithType:UIButtonTypeSystem];
    butn.frame = CGRectMake(100, 100, 60, 40);
    butn.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:butn];
    [butn addTarget:self action:@selector(butnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addNotification {
    [[YLNotificationCenter defaultCenter] addObserverForName:@"changeFrame" object:nil queue:nil usingBlock:^(YLNotification * _Nonnull note) {
        NSLog(@"note = %@",note);
    }];
}

- (void)testNotifi {
    [[YLNotificationCenter defaultCenter] postNotificationName:@"changeFrame" object:nil userInfo:@{@"width": @(100) }];
}

#pragma mark - Action
- (void)changeColor:(YLNotification *)noti {
    if (noti) {
        NSLog(@"通知参数：%@",noti);
    } else {
        NSLog(@"通知参数：nil");

    }
}

- (void)butnAction {
    [self testNotifi];
}
@end
