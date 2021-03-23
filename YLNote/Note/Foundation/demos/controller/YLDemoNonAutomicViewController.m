//
//  YLDemoNonAutomicViewController.m
//  YLNote
//
//  Created by tangh on 2021/3/23.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLDemoNonAutomicViewController.h"
#import "YLPerson.h"

@interface YLDemoNonAutomicViewController ()

@end

@implementation YLDemoNonAutomicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self testAutomicProperty];
}

/// atomic 修饰的属性是绝对安全的吗
/**
 不是，所谓的安全只是局限于 Setter、Getter 的访问器方法而言的，你对它做 Release 的操作是不会受影响的。这个时候就容易崩溃了。
 
 看一下打印结果：
 2021-01-08 17:00:13.908449+0800 YLNote[25990:15006808] 🌹<NSThread: 0x600000889a80>{number = 7, name = (null)} ageAuto : 1432
 2021-01-08 17:00:13.908452+0800 YLNote[25990:15005841] 🍑<NSThread: 0x600000844140>{number = 6, name = (null)} ageAuto : 1164
 最终的结果和我们预期的完全是不一样的，这是为什么呢？
 
 错误的分析是：因为ageAuto是atomic修饰的，所以是线程安全的，在+1的时候，只会有一个线程去操作，所以最终的打印结果必定有一个是2000。
 
 正确的分析是：其实atomic是原子的是没问题的，这个只是表示set方法是原子的，效果是类似于下面的效果
 //atomic表示的是对set方法加锁,表示在设置值的时候，只会有一个线程执行set方法
 - (void)setAgeAuto:(NSInteger)ageAuto{
 [self.lock lock];
 _ageAuto = ageAuto;
 [self.lock unlock];
 }
 */
- (void)testAutomicProperty {
    YLPerson *person = [[YLPerson alloc] init];
    //开启一个线程对intA的值+1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0;i < 1000;i ++){
            person.ageAuto = person.ageAuto + 1;
        }
        NSLog(@"🍑%@ ageAuto : %ld",[NSThread currentThread],(long)person.ageAuto);
    });
    
    //开启一个线程对intA的值+1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0;i < 1000;i ++){
            person.ageAuto = person.ageAuto + 1;
        }
        NSLog(@"🌹%@ ageAuto : %ld",[NSThread currentThread],(long)person.ageAuto);
    });
    
}

- (void)testNonAutomicProperty {
    YLPerson *person = [[YLPerson alloc] init];
    
    NSLock *lock = [[NSLock alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0;i < 1000;i ++){
            [lock lock];
            person.ageNonAuto = person.ageNonAuto + 1;
            [lock unlock];
        }
        NSLog(@"🍑%@ ageNonAuto : %ld",[NSThread currentThread],(long)person.ageNonAuto);
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0;i < 1000;i ++){
            [lock lock];
            person.ageNonAuto = person.ageNonAuto + 1;
            [lock unlock];
        }
        NSLog(@"🌹%@ ageNonAuto : %ld",[NSThread currentThread],(long)person.ageNonAuto);
    });
}

@end
