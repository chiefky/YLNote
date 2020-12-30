//
//  YLNotifiTestViewController.m
//  YLNote
//
//  Created by tangh on 2020/7/27.
//  Copyright © 2020 tangh. All rights reserved.
//

#import "YLNotifiTestViewController.h"
#import "YLNotificationCenter.h"
#import "YLNotification.h"

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]

#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface YLNotifiTestViewController ()

@end

@implementation YLNotifiTestViewController
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
    [[YLNotificationCenter defaultCenter] addObserver:self selector:@selector(changeColor:) name:@"changeViewColor" object:nil];
}

- (void)testNotifi {
    [[YLNotificationCenter defaultCenter] postNotificationName:@"changeViewColor" object:nil userInfo:@{@"color": randomColor}];
}

#pragma mark - Action
- (void)changeColor:(YLNotification *)noti {
    if (noti) {
        NSLog(@"通知参数：%@",noti);
        self.view.backgroundColor = noti.userInfo[@"color"];
    } else {
        NSLog(@"通知参数：nil");

    }
}

- (void)butnAction {
    [self testNotifi];
}

@end
