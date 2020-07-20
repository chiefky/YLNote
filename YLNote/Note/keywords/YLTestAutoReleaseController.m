//
//  YLTestAutoReleaseController.m
//  TestDemo
//
//  Created by tangh on 2020/7/3.
//  Copyright © 2020 tangh. All rights reserved.
//

#import "YLTestAutoReleaseController.h"

@interface YLTestAutoReleaseController ()

@end

/// 在没有手动加AutoreleasePool的情况下，Autorelease对象是在当前的runloop迭代结束时释放的，而它能够释放的原因是系统在每个runloop迭代中都加入了自动释放池Push和Pop；由于这个vc在loadView之后便add到了window层级上，所以viewDidLoad和viewWillAppear是在同一个runloop调用的，因此在viewWillAppear中，这个autorelease的变量依然有值。
/*
 每当进行一次objc_autoreleasePoolPush调用时，runtime向当前的AutoreleasePoolPage中add进一个哨兵对象，值为0（也就是个nil），那么这一个page就变成了下面的样子：

 objc_autoreleasePoolPush的返回值正是这个哨兵对象的地址，被objc_autoreleasePoolPop(哨兵对象)作为入参，于是：

1. 根据传入的哨兵对象地址找到哨兵对象所处的page
2. 在当前page中，将晚于哨兵对象插入的所有autorelease对象都发送一次-release消息，并向回移动next指针到正确位置
3. 补充2：从最新加入的对象一直向前清理，可以向前跨越若干个page，直到哨兵所在的page
 */
@implementation YLTestAutoReleaseController

__weak id reference = nil;
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    NSString *str = [NSString stringWithFormat:@"hello world"];
    // str是一个autorelease对象，设置一个weak的引用来观察它
    reference = str;
    NSLog(@"%s:%@", __FUNCTION__, reference); // Console: sunnyxx

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s:%@", __FUNCTION__, reference); // Console: sunnyxx
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%s:%@", __FUNCTION__, reference); // Console: sunnyxx
}

@end
