//
//  UIView+Tools.m
//  YLNote
//
//  Created by tangh on 2021/1/13.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "UIView+Tools.h"


@implementation UIView (Tools)

// 递归获取子视图
- (void)printSubViewsWithLevel:(NSUInteger)level {
    NSArray *subviews = [self subviews];
    
    // 如果没有子视图就直接返回
    if ([subviews count] == 0) {
        return;
    }
    
    for (UIView *subview in subviews) {
        
        // 根据层级决定前面空格个数，来缩进显示
        NSString *blank = @"";
        for (int i = 1; i < level; i++) {
            blank = [NSString stringWithFormat:@"  %@", blank];
        }
        
        // 打印子视图类名
        NSLog(@"%@%ld: %@", blank, level, NSStringFromCGRect(subview.bounds));
        
        // 递归获取此视图的子视图
        [subview printSubViewsWithLevel:level+1];
        
    }
    
}

@end
