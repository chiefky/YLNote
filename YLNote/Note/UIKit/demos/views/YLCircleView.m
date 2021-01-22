//
//  YLCircleView.m
//  YLNote
//
//  Created by tangh on 2021/1/22.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLCircleView.h"

@interface YLCircleView () {
    //    UIColor *_color;
}
@end


@implementation YLCircleView
@synthesize color;

- (void)drawRect:(CGRect)rect {
    // Drawing code
    NSLog(@"%s",__func__);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    [self.color setFill];
    [path fill];
}

- (void)setColor:(UIColor *)color {
    UIColor *tmpColor = self.color;
    if (!CGColorEqualToColor(tmpColor.CGColor, color.CGColor)) {
        color = color;
#warning  同名实例变量怎么赋值啊啊啊啊 啊
    }
    [self setNeedsDisplay];
}

- (UIColor *)color {
    if (!color) {
        color = [UIColor redColor];
    }
    return color;
}

@end
