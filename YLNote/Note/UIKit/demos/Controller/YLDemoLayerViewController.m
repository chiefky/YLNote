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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

/**
 因为UIView依赖于CALayer提供的内容，而CALayer又依赖于UIView提供的容器来显示绘制的内容，所以UIView的显示可以说是CALayer要显示绘制的图形。当要显示时，CALayer会准备好一个CGContextRef(图形上下文)，然后调用它的delegate(这里就是UIView)的drawLayer:inContext:方法，并且传入已经准备好的CGContextRef对象，在drawLayer:inContext:方法中UIView又会调用自己的drawRect:方法。
     我们可以把UIView的显示比作“在电脑上使用播放器播放U盘上得电影”，播放器相当于UIView，视频解码器相当于CALayer，U盘相当于CGContextRef，电影相当于绘制的图形信息。不同的图形上下文可以想象成不同接口的U盘

 注意：当我们需要绘图到根层上时，一般在drawRect:方法中绘制，不建议在drawLayer:inContext:方法中绘图

 */
+ (void)testUIView {
    [YLAlertManager showAlertWithTitle:@"" message:@" 因为UIView依赖于CALayer提供的内容，而CALayer又依赖于UIView提供的容器来显示绘制的内容，所以UIView的显示可以说是CALayer要显示绘制的图形。当要显示时，CALayer会准备好一个CGContextRef(图形上下文)，然后调用它的delegate(这里就是UIView)的drawLayer:inContext:方法，并且传入已经准备好的CGContextRef对象，在drawLayer:inContext:方法中UIView又会调用自己的drawRect:方法。" actionTitle:@"ok" handler:nil];
}

@end
