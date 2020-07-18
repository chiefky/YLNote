//
//  YLHitTestViewController.m
//  TestDemo
//
//  Created by tangh on 2020/7/16.
//  Copyright © 2020 tangh. All rights reserved.
//

#import "YLHitTestViewController.h"
#import <objc/runtime.h>
#import <Masonry/Masonry.h>

// 判断point是否在扩大后的的响应区
BOOL yl_pointMethod(id self, SEL _cmd, CGPoint point, UIEvent *event) {
    if ([self isKindOfClass:[UIView class]]) {
            //获取当前button的实际大小
        CGRect bounds = ((UIView *)self).bounds;
          //原热区 扩大1.2倍
          CGFloat widthDelta = bounds.size.width * 1.2;
          CGFloat heightDelta = bounds.size.height * 1.2;
          //扩大bounds
        CGRect newBouns = CGRectMake(bounds.origin.x, bounds.origin.y, widthDelta, heightDelta);
          //如果点击的点 在 新的bounds里，就返回YES
//        NSLog(@"是否在热区%@",@(CGRectContainsPoint(newBouns, point)));
          return CGRectContainsPoint(newBouns, point);

    }
    return false;

}

/// 修改响应链控件（修改hitTest方法）
/// @param selector hitTest
/// @param point 点
/// @param event 事件
UIView *yl_hitMethod(id self,SEL selector, CGPoint point, UIEvent *event) {
    if ([self isKindOfClass:[UIView class]]) {
        NSArray<UIView*> *subViews = ((UIView *)self).subviews;
        // 如果有x子视图
        if (subViews.count > 0) {
            // 这里还有问题，取不到子view
            for (UIView *subView in subViews) {
                if (subView.subviews.count == 0) {
                    if ([subView pointInside:point withEvent:event]) {
                        return subView;
                    }
                } else {
                    return [subView hitTest:point withEvent:event];
                }
            }
        } else {
            // 如果没有子视图
            BOOL inHotArea = [self pointInside:point withEvent:event];
            return inHotArea ? self : (((UIView *)self).superview);
        }
       
    }
    return nil;
}

@interface YLHitTestViewController ()

@end

@implementation YLHitTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"扩大响应区1.2x";
    [self setupUI];
}

- (void)setupUI {
 
    UIView *actionView = [UIView new];
    actionView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:actionView];
    [actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.height.mas_equalTo(90);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [actionView addGestureRecognizer:tap];
    
//    UIView *redView = [UIView new];
//    redView.backgroundColor = [UIColor redColor];
//    [actionView addSubview:redView];
//    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(0);
//        make.width.height.mas_equalTo(40);
//    }];
//
    [self testChangeResponderArea:actionView];
}

/// 扩大按钮点击区域
/// @param object <#object description#>
- (void)testChangeResponderArea:(UIView *)object {
     // 1.创建一个子类
    NSString *sonClassName = [NSString stringWithFormat:@"YLSubClass_%@",NSStringFromClass([object class])];
    Class sonClass = objc_allocateClassPair([object class], sonClassName.UTF8String, 0);
    objc_registerClassPair(sonClass);
    
    // 2.重写hitTest方法
    SEL hitSel = @selector(hitTest:withEvent:);
    Method hitMethod = class_getInstanceMethod([object class], hitSel);
    const char *hitType = method_getTypeEncoding(hitMethod);
    class_addMethod(sonClass, hitSel, (IMP)yl_hitMethod, hitType);
    
    // 2.重写pointInside方法
   SEL pointSel = @selector(pointInside:withEvent:);
   Method pointMethod = class_getInstanceMethod([object class], pointSel);
   const char *pointType = method_getTypeEncoding(pointMethod);
   class_addMethod(sonClass, pointSel, (IMP)yl_pointMethod, pointType);
    
    // 修改isaz指针
    object_setClass(object, sonClass);
}

#pragma mark -Action

- (void)tapAction:(UITapGestureRecognizer *)sender {
    NSLog(@"我被点击了 = %@",NSStringFromCGRect(sender.view.frame));
    
}
@end
