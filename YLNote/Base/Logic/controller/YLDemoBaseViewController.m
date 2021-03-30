//
//  YLDemoBaseViewController.m
//  YLNote
//
//  Created by tangh on 2021/3/22.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLDemoBaseViewController.h"

@interface YLDemoBaseViewController ()

@end

@implementation YLDemoBaseViewController

- (void)dealloc {
    NSLog(@"%s: %s",[self.description UTF8String],__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
}

@end
