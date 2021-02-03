//
//  YLCircleView.m
//  YLNote
//
//  Created by tangh on 2021/1/22.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLCircleView.h"
/**
 当开发者打算派生自己的UI控件时首先定义一个继承View基类的子类然后重写View类的一个或多个方法通常可以被用户重写的方法如下。

 initWithFrame:前面已经见到程序创建UI控件时常常会调用该方法执行初始化因此如果你需要对UI控件执行一些额外的初始化即可通过重写该方法来实现。

 initWithCoder:程序通过在nib文件中加载完该控件后会自动调用该方法。因此如果程序需要在nib文件中加载该控件后执行自定义初始化则可通过重写该方法来实现。

 drawRect:如果程序需要自行绘制该控件的内容则可通过重写该方法来实现。

 layoutSubviews如果程序需要对该控件所包含的子控件布局进行更精确的控制可通过重写该方法来实现。

 didAddSubview:当该控件添加子控件完成时将会激发该方法。

 willRemoveSubview:当该控件将要删除子控件时将会激发该方法。

 willMoveToSuperview:当该控件将要添加到其父控件中时将会激发该方法。

 didMoveToSuperview当把该控件添加到父控件完成时将会激发该方法。

 willMoveToWindow: 当该控件将要添加到窗口中时将会激发该方法。

 didMoveToWindow当把该控件添加到窗口完成时将会激发该方法。

 touchesBegan:withEvent:当用户手指开始触碰该控件时将会激发该方法。

 touchesMoved:withEvent:当用户手指在该控件上移动时将会激发该方法。

 touchesEnded:withEvent:当用户手指结束触碰该控件时将会激发该方法。

 touchesCancelled:withEvent:用户取消触碰该控件时将会激发该方法。

 */
@implementation YLCircleView
@synthesize color; // 自动添加实例变量color

- (void)drawRect:(CGRect)rect {
    // Drawing code
    NSLog(@"%s",__func__);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    [self.color setFill];
    [path fill];
}

- (void)setColor:(UIColor *)mcolor {
    if (!CGColorEqualToColor(mcolor.CGColor, color.CGColor)) {
        color = mcolor;
//        [self setNeedsDisplay];
    }
}

- (UIColor *)color {
    if (!color) {
        color = [UIColor redColor];
    }
    return color;
}

@end

@interface YLTouchView () {
    // 定义两个变量记录当前触碰点的坐标
    int  curX;
    int  curY;
}

@end

@implementation YLTouchView
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s",__FUNCTION__);
}
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s",__FUNCTION__);
     // 获取触碰事件的UITouch事件
     UITouch *touch = [touches anyObject];
     // 得到触碰事件在当前组件上的触碰点
     CGPoint lastTouch = [touch locationInView:self];
     // 获取触碰点的坐标
     curX = lastTouch.x;
     curY = lastTouch.y;
     // 通知该组件重绘
     [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // 获取绘图上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 设置填充颜色
    CGContextSetFillColorWithColor(ctx, [[UIColor redColor] CGColor]);
    // 以触碰点为圆心绘制一个圆形
    CGContextFillEllipseInRect(ctx, CGRectMake(curX - 10, curY - 10, 20, 20));
}

@end
