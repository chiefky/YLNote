//
//  YLDemoLayerViewController.m
//  YLNote
//
//  Created by tangh on 2021/3/22.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLDemoLayerViewController.h"
#import "YLView.h"
#import "YLLayer.h"
#import "YLOmnipotentDelegate.h"
#import "YLAlertManager.h"

@interface YLDemoLayerViewController ()

@end

@implementation YLDemoLayerViewController
- (void)dealloc {
    NSLog(@"%@:%s",self,__FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testUIViewAndCALayer];
}

/**
 UIView 继承 UIResponder，而 UIResponder 是响应者对象，可以对iOS 中的事件响应及传递，CALayer 没有继承自 UIResponder，所以 CALayer 不具备响应处理事件的能力。CALayer 是 QuartzCore 中的类，是一个比较底层的用来绘制内容的类，用来绘制UI
 
 UIView 对 CALayer 封装属性，对 UIView 设置 frame、center、bounds 等位置信息时，其实都是UIView 对 CALayer 进一层封装，使得我们可以很方便地设置控件的位置；例如圆角、阴影等属性， UIView 就没有进一步封装，所以我们还是需要去设置 Layer 的属性来实现功能。
 
 UIView 是 CALayer 的代理，UIView 持有一个 CALayer 的属性，并且是该属性的代理，用来提供一些 CALayer 行的数据，例如动画和绘制。
 
 */
/// 打印UIview 和CALayer的继承关系
- (void)testUIViewAndCALayer {
    YLView *ylView = [[YLView alloc] init];
    YLLayer *ylLayer = [[YLLayer alloc] init];
    [[YLOmnipotentDelegate sharedOmnipotent] getSuperClassTreeForClass:[ylView class]];
    [[YLOmnipotentDelegate sharedOmnipotent] getSuperClassTreeForClass:[ylLayer class]];
}



@end
