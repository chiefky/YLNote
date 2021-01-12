//
//  YLAlertManager.m
//  YLNote
//
//  Created by tangh on 2021/1/11.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLAlertManager.h"
#import "YLWindowLoader.h"


@implementation YLAlertManager

/// 显示警示弹窗「带ok 按钮」
/// @param title 标题
/// @param content 警示信息
/// @param action 按钮标题
/// @param handler 确认按钮响应事件
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)content actionTitle:(NSString *)action handler:(void (^)(UIAlertAction * _Nonnull))handler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:action style:UIAlertActionStyleCancel handler:handler];
    [alert addAction:cancelAction];
    UIViewController *currentVC = [YLWindowLoader getCurrentVC];
    if (currentVC) {
        [currentVC presentViewController:alert animated:YES completion:nil];
    }
}

/// 显示警示弹窗「安卓toast风格」
/// @param content 警示信息
/// @param seconds 弹窗显示时长
+ (void)showToastWithMessage:(NSString *)content senconds:(NSUInteger)seconds {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:content preferredStyle:UIAlertControllerStyleAlert];
    UIViewController *currentVC = [YLWindowLoader getCurrentVC];
    if (currentVC) {
        [currentVC presentViewController:alert animated:YES completion:^{
            // seconds秒后消失
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alert dismissViewControllerAnimated:YES completion:nil];
            });
        }];
    }
}

@end
