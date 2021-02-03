//
//  UIView+Tools.h
//  YLNote
//
//  Created by tangh on 2021/1/13.
//  Copyright © 2021 tangh. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Tools)

/// 按层级打印某视图的所有子视图，包括子视图的子视图。调试使用
/// @param level 指定最外层层级值
- (void)printSubViewsWithLevel:(NSUInteger)level;


@end

NS_ASSUME_NONNULL_END
