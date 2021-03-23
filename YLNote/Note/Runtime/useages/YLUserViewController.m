//
//  YLUserViewController.m
//  YLNote
//
//  Created by tangh on 2020/7/31.
//  Copyright © 2020 tangh. All rights reserved.
//

#import "YLUserViewController.h"
#import "YLUser.h"
#import <MJExtension/MJExtension.h>

@interface YLUserViewController ()

@end

@implementation YLUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDictionary *dict = @{
        @"name" : @"Jack",
        @"icon" : @"lufy.png",
        @"age" : @20,
        @"height" : @"1.55",
        @"money" : @100.9,
        @"sex" : @(GenderMale),
        @"gay" : @"true"
    };
    
    YLUser *user = [YLUser mj_objectWithKeyValues:dict];
    NSLog(@"%@",user);
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
