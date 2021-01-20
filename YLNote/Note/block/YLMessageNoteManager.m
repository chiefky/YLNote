//
//  YLMessageNoteManager.m
//  YLNote
//
//  Created by tangh on 2021/1/6.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLMessageNoteManager.h"
#import "YLBlockViewController.h"
#import "YLWindowLoader.h"

@implementation YLMessageNoteManager
//+ (NSDictionary *)allNotes {
//    return
//  @{
//      @"group":@"block",
//      @"questions":@[
//              @"testBlock:Block相关"]
//
//  };
//
//}

+ (NSDictionary *)allNotes {
    return @{
        @"group":@"消息传递",
        @"questions":
            @[
                @{
                    @"description":@"KVC",
                    @"answer":@"testKVC",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                @{
                    @"description":@"KVO",
                    @"answer":@"testKVO",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                @{
                    @"description":@"Block",
                    @"answer":@"testBlock",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                @{
                    @"description":@"delegate",
                    @"answer":@"testDelegate",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                @{
                    @"description":@"NSNotification",
                    @"answer":@"testNotification",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                }
                
            ]
    };
}

#pragma mark - block
+ (void)testBlock {
    UIViewController *currentVC = [YLWindowLoader getCurrentVC];
    YLBlockViewController *bkVC = [[YLBlockViewController alloc] init];
    if (currentVC.navigationController) {
        [currentVC.navigationController pushViewController:bkVC animated:YES];
    } else {
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:currentVC];
        [navi pushViewController:bkVC animated:YES];
    }

}


@end
