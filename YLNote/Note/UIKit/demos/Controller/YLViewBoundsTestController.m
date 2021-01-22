//
//  YLViewBoundsTestController.m
//  YLNote
//
//  Created by tangh on 2021/1/13.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLViewBoundsTestController.h"
#import "UIView+Tools.h"

@interface YLViewBoundsTestController ()
@property (nonatomic,strong)UIImageView *viewA;
@property (nonatomic,strong)UIView *view_a;
@property (nonatomic,strong)UIView *view_b;
@property (nonatomic,strong)UIView *view_m;

@end

@implementation YLViewBoundsTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
//    [self.viewA printSubViewsWithLevel:1];
    
    NSLog(@"********************初始值**************************");
    NSLog(@"100: %@,%@",NSStringFromCGRect(self.viewA.bounds),NSStringFromCGRect(self.viewA.frame));
    [self getSub:self.viewA andLevel:0];
}

- (void)setupUI {
    self.viewA.image = [UIImage imageNamed:@"a.png"];
    [self.view addSubview:self.viewA];
    self.viewA.frame = CGRectMake(20, 100, 300,300);

    [self.viewA addSubview:self.view_a];
    self.view_a.frame = CGRectMake(20, 20, 100, 100);
    
    [self.viewA addSubview:self.view_b];
    self.view_b.frame = CGRectMake(150, 20, 100, 100);

    [self.view_a addSubview:self.view_m];
    self.view_m.frame = CGRectMake(20, 20, 60, 60);
    
    UIButton *changeBounds = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeBounds setTitle:@"修改ViewA的bounds" forState:UIControlStateNormal];
    [changeBounds addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];
    changeBounds.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:changeBounds];
    changeBounds.frame = CGRectMake(40, 500, 260, 40);
}

// 递归获取子视图
- (void)getSub:(UIView *)view andLevel:(int)level {
    NSArray *subviews = [view subviews];
    
    // 如果没有子视图就直接返回
    if ([subviews count] == 0) return;
    
    for (UIView *subview in subviews) {
        
        // 根据层级决定前面空格个数，来缩进显示
        NSString *blank = @"";
        for (int i = 1; i < level; i++) {
            blank = [NSString stringWithFormat:@"  %@", blank];
        }
        
        // 打印子视图类名
        NSLog(@"%@%ld: %@,%@", blank, subview.tag, NSStringFromCGRect(subview.bounds),NSStringFromCGRect(subview.frame));
        
        // 递归获取此视图的子视图
        [self getSub:subview andLevel:(level+1)];
        
    }
    
}
#pragma mark - Action

/** 修改一个View的bounds，观察其自身变化，以及内部子控件的变化
 测试用例：
 1.创建一个UIView A,添加到视图控制器上，定义其bounds == {{0, 0}, {300, 300}}
 2.创建两个子View a,b 分别添加到视图A上，指定a.bounds = {{0, 0}, {100, 100}}，b.bounds = {{0, 0}, {100, 100}}
 3.创建另一个子view m 添加到视图a上，指定m.bouns = {{0, 0}, {60, 60}}
 4.改变A 的bounds观察 a,b,m的变化
 

 2021-01-13 19:36:13.449620+0800 YLNote[68712:18425850] ********************初始值**************************
 2021-01-13 19:36:13.449788+0800 YLNote[68712:18425850] 100: {{0, 0}, {300, 300}},{{20, 100}, {300, 300}}
 2021-01-13 19:36:13.449949+0800 YLNote[68712:18425850] 201: {{0, 0}, {100, 100}},{{20, 20}, {100, 100}}
 2021-01-13 19:36:13.450080+0800 YLNote[68712:18425850] 300: {{0, 0}, {60, 60}},{{20, 20}, {60, 60}}
 2021-01-13 19:36:13.450179+0800 YLNote[68712:18425850] 202: {{0, 0}, {100, 100}},{{150, 20}, {100, 100}}
 2021-01-13 19:36:27.385379+0800 YLNote[68712:18425850] ********************修改bounds.x后**************************
 2021-01-13 19:36:27.385543+0800 YLNote[68712:18425850] 100: {{-50, 0}, {300, 300}},{{20, 100}, {300, 300}}
 2021-01-13 19:36:27.385644+0800 YLNote[68712:18425850] 201: {{0, 0}, {100, 100}},{{20, 20}, {100, 100}}
 2021-01-13 19:36:27.385777+0800 YLNote[68712:18425850] 300: {{0, 0}, {60, 60}},{{20, 20}, {60, 60}}
 2021-01-13 19:36:27.385889+0800 YLNote[68712:18425850] 202: {{0, 0}, {100, 100}},{{150, 20}, {100, 100}}
 
 2021-01-13 19:40:49.702887+0800 YLNote[68889:18436007] ********************初始值**************************
 2021-01-13 19:40:49.703081+0800 YLNote[68889:18436007] 100: {{0, 0}, {300, 300}},{{20, 100}, {300, 300}}
 2021-01-13 19:40:49.703191+0800 YLNote[68889:18436007] 201: {{0, 0}, {100, 100}},{{20, 20}, {100, 100}}
 2021-01-13 19:40:49.703328+0800 YLNote[68889:18436007] 300: {{0, 0}, {60, 60}},{{20, 20}, {60, 60}}
 2021-01-13 19:40:49.703463+0800 YLNote[68889:18436007] 202: {{0, 0}, {100, 100}},{{150, 20}, {100, 100}}
 2021-01-13 19:40:58.704139+0800 YLNote[68889:18436007] ********************修改bounds.width后**************************
 2021-01-13 19:40:58.704412+0800 YLNote[68889:18436007] 100: {{0, 0}, {240, 300}},{{50, 100}, {240, 300}}
 2021-01-13 19:40:58.704569+0800 YLNote[68889:18436007] 201: {{0, 0}, {100, 100}},{{20, 20}, {100, 100}}
 2021-01-13 19:40:58.704696+0800 YLNote[68889:18436007] 300: {{0, 0}, {60, 60}},{{20, 20}, {60, 60}}
 2021-01-13 19:40:58.704852+0800 YLNote[68889:18436007] 202: {{0, 0}, {100, 100}},{{150, 20}, {100, 100}}
结论：
 1.修改自身的point，影响内部空件的布局位置，但所有view的frame都不会改变，子view的bounds也不会变，因为修改的是子控件的坐标系的坐标原点
 2.修改自身的size，影响自身的布局位置和控件大小，自身的frame和bounds都会变，子view的都不变，因为只是修改了坐标系的大小
 */
- (void)changeAction {
    NSLog(@"********************修改bounds后**************************");
    CGRect preBounds = self.viewA.bounds;
    self.viewA.bounds = CGRectMake(preBounds.origin.x, preBounds.origin.y, preBounds.size.width-60, preBounds.size.height);
    NSLog(@"100: %@,%@",NSStringFromCGRect(self.viewA.bounds),NSStringFromCGRect(self.viewA.frame));
    [self getSub:self.viewA andLevel:0];

}


#pragma mark - lazy
- (UIImageView *)viewA {
    if (!_viewA) {
        _viewA = [UIImageView new];
        _viewA.tag = 100;
        _viewA.backgroundColor = [UIColor systemPinkColor];
    }
    return _viewA;
}

- (UIView *)view_a {
    if (!_view_a) {
        _view_a = [UIView new];
        _view_a.tag = 201;
        _view_a.backgroundColor = [UIColor yellowColor];
        _view_a.alpha = 0.6;

    }
    return _view_a;
}

- (UIView *)view_b {
    if (!_view_b) {
        _view_b = [UIView new];
        _view_b.tag = 202;
        _view_b.backgroundColor = [UIColor blueColor];
        _view_b.alpha = 0.6;
    }
    return _view_b;
}

- (UIView *)view_m {
    if (!_view_m) {
        _view_m = [UIView new];
        _view_m.tag = 300;
        _view_m.backgroundColor = [UIColor purpleColor];
    }
    return _view_m;
}


@end
