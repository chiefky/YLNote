//
//  YLUIKitNoteManger.m
//  YLNote
//
//  Created by tangh on 2021/1/6.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLUIKitNoteManger.h"
#import "YLOmnipotentDelegate.h"
#import "YLWindowLoader.h"
#import "YLAlertManager.h"
#import "YLViewBoundsTestController.h"
#import "YLLayoutTestViewController.h"
#import "YLView.h"
#import "YLLayer.h"

@implementation YLUIKitNoteManger

+ (nonnull instancetype)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

+ (NSDictionary *)allNotes {
    return @{
        @"group":@"UIKit",
        @"questions":
            @[
                @{
                    @"description":@"UIView 和 CALayer 是什么关系",
                    @"answer":@"testUIViewAndCALayer",
                    @"class": NSStringFromClass(self),
                    @"type": @(0),
                },
                @{
                    @"description":@"Bounds 和 Frame 的区别",
                    @"answer":@"testBoundsAndFrame",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                @{
                    @"description":@"setNeedsDisplay 和 setNeedsLayout 两者是什么关系",
                    @"answer":@"testSetNeedsDisplayAndSetNeedsLayout",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                @{
                    @"description":@"layoutSubviews触发条件有哪些",
                    @"answer":@"testLayoutSubviews",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                @{
                    @"description": @"谈谈对UIResponder的理解",
                    @"answer":@"testUIResponder",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                @{
                    @"description": @"loadView的作用",
                    @"answer":@"testLoadView",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                
                @{
                    @"description": @"使用 drawRect有什么影响",
                    @"answer":@"testDrawRect",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                @{
                    @"description": @"keyWindow 和 delegate的window有何区别",
                    @"answer":@"testKeyWindow",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                }
            ]
    };
}

/**
 UIView 继承 UIResponder，而 UIResponder 是响应者对象，可以对iOS 中的事件响应及传递，CALayer 没有继承自 UIResponder，所以 CALayer 不具备响应处理事件的能力。CALayer 是 QuartzCore 中的类，是一个比较底层的用来绘制内容的类，用来绘制UI

 UIView 对 CALayer 封装属性，对 UIView 设置 frame、center、bounds 等位置信息时，其实都是UIView 对 CALayer 进一层封装，使得我们可以很方便地设置控件的位置；例如圆角、阴影等属性， UIView 就没有进一步封装，所以我们还是需要去设置 Layer 的属性来实现功能。

 UIView 是 CALayer 的代理，UIView 持有一个 CALayer 的属性，并且是该属性的代理，用来提供一些 CALayer 行的数据，例如动画和绘制。
 */
/// 打印UIview 和CALayer的继承关系
+ (void)testUIViewAndCALayer {
    YLView *ylView = [[YLView alloc] init];
    YLLayer *ylLayer = [[YLLayer alloc] init];
    [[YLOmnipotentDelegate sharedOmnipotent] getSuperClassTreeForClass:[ylView class]];
    [[YLOmnipotentDelegate sharedOmnipotent] getSuperClassTreeForClass:[ylLayer class]];
}

/**
 Bounds：一般是相对于自身来说的，是控件的内部尺寸。如果你修改了 Bounds，那么子控件的相对位置也会发生改变。

 Frame ：是相对于父控件来说的，是控件的外部尺寸。
 */
+ (void)testBoundsAndFrame {
    UIViewController *currentVC = [YLWindowLoader getCurrentVC];
    YLViewBoundsTestController *articalVC = [[YLViewBoundsTestController alloc] init];
    if (currentVC.navigationController) {
        [currentVC.navigationController pushViewController:articalVC animated:YES];
    } else {

        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:currentVC];
        [navi pushViewController:articalVC animated:YES];
    
    }

}

+ (void)testLayoutSubviews {
    UIViewController *currentVC = [YLWindowLoader getCurrentVC];
    YLLayoutTestViewController *layoutVC = [[YLLayoutTestViewController alloc] init];
    if (currentVC.navigationController) {
        [currentVC.navigationController pushViewController:layoutVC animated:YES];
    } else {
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:currentVC];
        [navi pushViewController:layoutVC animated:YES];
    }
}

/// 两者的区别
+ (void)testSetNeedsDisplayAndSetNeedsLayout {
    NSString *msg = @"UIView的setNeedsDisplay和setNeedsLayout方法。首先两个方法都是异步执行的。setNeedsDisplay会调用自动调用drawRect方法，这样可以拿到UIGraphicsGetCurrentContext，就可以画画了。而setNeedsLayout会默认调用layoutSubViews，就可以处理子视图中的一些数据。\n综上两个方法都是异步执行的，layoutSubviews方便数据计算，drawRect方便视图重绘。";
    [YLAlertManager showAlertWithTitle:@"setNeedsDisplay&setNeedsLayout" message:msg actionTitle:@"OK" handler:nil];
}
+ (void)testUIResponder{
    
}

+ (void)testLoadView {
    
}

+ (void)testDrawRect {
    
}


+ (void)testKeyWindow {
    
}


@end
