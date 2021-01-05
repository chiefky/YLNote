//
//  YLNSOperationTest.m
//  Demo20200420
//
//  Created by tangh on 2020/6/24.
//  Copyright © 2020 tangh. All rights reserved.
//

#import "YLNSOperationTest.h"
#import "YLOperation.h"

@interface YLNSOperationTest ()

@property (nonatomic,assign) NSInteger ticketsCount;

@end

@implementation YLNSOperationTest

#pragma mark - NSInvocationOperation
//  单独使用NSInvocationOperation不会开启新线程，会在当前线程执行
- (void)testOperation_invocation {
    // 1.创建 NSInvocationOperation 对象
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];

    // 2.调用 start 方法开始执行操作
    [op start];
}

/**
 * 任务1
 */
- (void)task1 {
    for (int i = 0; i < 2; i++) {
        [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
        NSLog(@"①操作，任务%d---%@",i, [NSThread currentThread]); // 打印当前线程（如果当前是主线程输出就是主线程，如果当前是子线程输出就是子线程）
    }
}
// 使用‘addOperation’添加进队列，开启新线程，并发执行
- (void)testOperationQueue {
     // 1.创建队列
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        // 2.创建操作
        // 使用 NSInvocationOperation 创建操作1
        NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];

        // 使用 NSBlockOperation 创建操作3
        NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
            for (int i = 0; i < 2; i++) {
                [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
                NSLog(@"②操作，任务%d---%@",i, [NSThread currentThread]); // 打印当前线程
            }
        }];
        [op2 addExecutionBlock:^{
            for (int i = 0; i < 2; i++) {
                [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
                NSLog(@"②操作，追加任务%d---%@",i, [NSThread currentThread]); // 打印当前线程
            }
        }];

        // 3.使用 addOperation: 添加所有操作到队列中
        [queue addOperation:op1]; // [op1 start]
        [queue addOperation:op2]; // [op3 start]
}
// 使用‘addOperationWithBlock’添加进队列，开启新线程，并发执行
- (void)testOperationQueue_block {
        // 1.创建队列
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    queue.maxConcurrentOperationCount = 2; // 串行队列

        // 2.使用 addOperationWithBlock: 添加操作到队列中
        [queue addOperationWithBlock:^{
            for (int i = 0; i < 2; i++) {
                [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
                NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
            }
        }];
        [queue addOperationWithBlock:^{
            for (int i = 0; i < 2; i++) {
                [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
                NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
            }
        }];
        [queue addOperationWithBlock:^{
            for (int i = 0; i < 2; i++) {
                [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
                NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
            }
        }];

}
#pragma mark - NSBlockOperation

/// 单独使用NSBlockOperation不会开启新线程，搭配使用addExecutionBlock追加任务可能会开启新线程，是否开启取决于追加操作任务的数量；而开启的线程数是由系统来决定的。
- (void)testOperation_block {
    // 1.创建 NSBlockOperation 对象
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
//            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"* 初始操作%d---%@", i,[NSThread currentThread]); // 打印当前线程 --> 输出结果同`NSInvocationOperation`一样
        }
    }];

//     2.添加额外的操作
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"追加操作1---%@", [NSThread currentThread]);
        }
    }];

    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"追加操作2---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"追加操作3---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"追加操作4---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];

    // 3.调用 start 方法开始执行操作
    [op start];
}


#pragma mark - 添加依赖
/**
 * 操作依赖
 * 使用方法：addDependency:
 */
- (void)testOperationQueue_dependence {

    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    // 2.创建操作
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"操作1，任务%d---%@",i, [NSThread currentThread]); // 打印当前线程
        }
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"操作2，任务%d---%@",i, [NSThread currentThread]); // 打印当前线程
        }
    }];

    // 3.添加依赖
    [op2 addDependency:op1]; // 让op2 依赖于 op1，则先执行op1，在执行op2

    // 4.添加操作到队列中
    [queue addOperation:op1];
    [queue addOperation:op2];
}

#pragma mark - 线程安全
/**
 * 非线程安全：不使用 NSLock
 * 初始化火车票数量、卖票窗口(非线程安全)、并开始卖票
 */
- (void)testOperation_safe {
    NSLog(@"currentThread---%@",[NSThread currentThread]); // 打印当前线程

    self.ticketsCount = 50;

    // 1.创建 queue1,queue1 代表北京火车票售卖窗口
    NSOperationQueue *queue1 = [[NSOperationQueue alloc] init];
    queue1.maxConcurrentOperationCount = 3;

//     2.创建 queue2,queue2 代表上海火车票售卖窗口
//    NSOperationQueue *queue2 = [[NSOperationQueue alloc] init];
//    queue2.maxConcurrentOperationCount = 1;

    // 3.创建卖票操作 op1
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        [self saleTicketNotSafe:1];
    }];

    // 4.创建卖票操作 op2
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        [self saleTicketNotSafe:2];
    }];

    // 5.添加操作，开始卖票
    [queue1 addOperation:op1];
    [queue1 addOperation:op2];
}

/**
 * 售卖火车票(非线程安全)
 */
- (void)saleTicketNotSafe:(NSInteger)tag {
    while (1) {

        @synchronized (self) {
               if (self.ticketsCount > 0) {
                     //如果还有票，继续售卖
                     self.ticketsCount--;
                     NSLog(@"%@", [NSString stringWithFormat:@"* 操作%ld----:%d 窗口:%@", tag,self.ticketsCount, [NSThread currentThread]]);
                     [NSThread sleepForTimeInterval:0.2];
                 } else {
                     NSLog(@"操作%ld 所有火车票均已售完",tag);
                     break;
                 }
        }
    }
}


#pragma mark - 自定义
// 使用非并发子类，不会开启新线程，会在当前线程执行
- (void)testOperation_yuki {
    [NSThread detachNewThreadWithBlock:^{
        // 1.创建 YKOperation 对象
        YLOperation *op = [[YLOperation alloc] init];
        // 2.调用 start 方法开始执行操作
        [op start];
    }];

}

@end
