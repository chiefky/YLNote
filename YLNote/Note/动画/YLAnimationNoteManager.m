//
//  YLAnimationNoteManager.m
//  YLNote
//
//  Created by tangh on 2021/1/6.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLAnimationNoteManager.h"
#import "YLNote-Swift.h"
#import "YLWindowLoader.h"

@implementation YLAnimationNoteManager

+ (NSDictionary *)allNotes {
    return @{
        @"group":@"动画",
        @"questions":
            @[
                @{
                    @"description":@"动画咩咩咩",
                    @"answer":@"testAnimation",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                }
            ]
    };
}

+ (void)testAnimation {
    UIViewController *currentVC = [YLWindowLoader getCurrentVC];
    YLAnimationViewController *animateVC = [[YLAnimationViewController alloc] init];
    if (currentVC.navigationController) {
        [currentVC.navigationController pushViewController:animateVC animated:YES];
    } else {
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:currentVC];
        [navi pushViewController:animateVC animated:YES];
    }

}
@end
