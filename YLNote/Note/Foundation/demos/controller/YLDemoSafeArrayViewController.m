//
//  YLDemoSafeArrayViewController.m
//  YLNote
//
//  Created by tangh on 2021/3/23.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLDemoSafeArrayViewController.h"
#import "YLSafeMutableArray.h"

@interface YLDemoSafeArrayViewController ()

@end

@implementation YLDemoSafeArrayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self testSafeArray];
}

/// 实现一个线程安全的数组
/**
 NSMutableArray是线程不安全的，当有多个线程同时对数组进行操作的时候可能导致崩溃或数据错误
 
 线程锁：使用线程锁对数组读写时进行加锁
 
 派发队列：在《Effective Objective-C 2.0..》书中第41条：多用派发队列，少用同步锁中指出：使用“串行同步队列”（serial synchronization queue），将读取操作及写入操作都安排在同一个队列里，即可保证数据同步。而通过并发队列，结合GCD的栅栏块（barrier）来不仅实现数据同步线程安全，还比串行同步队列方式更高效。
 */
- (void)testSafeArray {
    YLSafeMutableArray *safeArr = [[YLSafeMutableArray alloc] init];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (NSUInteger i = 0; i < 5; i++) {
        dispatch_async(queue, ^{
            NSLog(@"添加第%ld个",i);
            [safeArr addObject:[NSString stringWithFormat:@"我是%ld",i]];
        });
        dispatch_async(queue, ^{
            NSLog(@"删除第%ld个",i);
            [safeArr removeObjectAtIndex:i];
        });
    }
}

- (void)testSafeArray2 {
      dispatch_queue_t queue = dispatch_queue_create("Dan", NULL);
       dispatch_async(queue, ^{
        NSLog(@"current : %@", [NSThread currentThread]);
        dispatch_queue_t serialQueue = dispatch_queue_create("Dan-serial", DISPATCH_QUEUE_SERIAL);

        dispatch_sync(serialQueue, ^{
            // block 1
            NSLog(@"current 1: %@", [NSThread currentThread]);
        });

        dispatch_sync(serialQueue, ^{
            // block 2
            NSLog(@"current 2: %@", [NSThread currentThread]);
        });

        dispatch_async(serialQueue, ^{
            // block 3
            NSLog(@"current 3: %@", [NSThread currentThread]);
        });

        dispatch_async(serialQueue, ^{
            // block 4
            NSLog(@"current 4: %@", [NSThread currentThread]);
        });
    });

    // 结果如下
    //    current  : <NSThread: 0x604000263440>{number = 3, name = (null)}
    //    current 1: <NSThread: 0x604000263440>{number = 3, name = (null)}
    //    current 2: <NSThread: 0x604000263440>{number = 3, name = (null)}
    //    current 3: <NSThread: 0x604000263440>{number = 3, name = (null)}
    //    current 4: <NSThread: 0x604000263440>{number = 3, name = (null)}

}

@end
