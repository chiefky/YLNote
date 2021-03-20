//
//  YLThirdLibNoteManager.m
//  YLNote
//
//  Created by tangh on 2021/1/21.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLThirdLibNoteManager.h"
#import "YLArticalViewController.h"
#import "YLWindowLoader.h"
#import "YLNote-Swift.h"

@implementation YLThirdLibNoteManager


+ (NSDictionary *)allNotes {
    return @{
        @"group":@"常用三方库",
        @"questions":
            @[
                @{
                    @"description":@"YYModel",
                    @"answer":@"testYYModel",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                }
            ]
    };
}

+ (void)testYYModel {
#warning 找时间自己实现一下YYModel！！！
    UIViewController *currentVC = [YLWindowLoader getCurrentVC];
    YLArticalViewController *articalVC = [[YLArticalViewController alloc] init];
    articalVC.htmlUrl = @"https://zhang759740844.github.io/2019/04/09/yymodel/";
    if (currentVC.navigationController) {
        NSLog(@"阅读文章");
        [currentVC.navigationController pushViewController:articalVC animated:YES];
    } else {
        NSLog(@"阅读文章-1");

        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:currentVC];
        [navi pushViewController:articalVC animated:YES];
    
    }

}
@end
