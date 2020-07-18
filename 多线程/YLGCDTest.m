//
//  YLGCDTest.m
//  Demo20200420
//
//  Created by tangh on 2020/6/20.
//  Copyright © 2020 tangh. All rights reserved.
//

#import "YLGCDTest.h"

@implementation YLGCDTest

#pragma mark - 主队列
/// 主队列，同步 + 异步
+ (void)sAsyncMainQueue {
    dispatch_queue_t queue = dispatch_get_main_queue();
    NSLog(@"****主队列%@，同步 + 异步 START****",queue);
    dispatch_sync(queue, ^{    // 异步执行 + 主队列
        NSLog(@"同步任务1 开始---%@",[NSThread currentThread]);      // 打印当前线程

        dispatch_async(queue, ^{  // 同步执行 + 当前主队列
            NSLog(@"嵌套异步任务1 开始---%@",[NSThread currentThread]);      // 打印当前线程
            // 追加任务
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"嵌套异步任务1 结束---%@",[NSThread currentThread]);      // 打印当前线程
        });
        NSLog(@"同步任务1 结束---%@",[NSThread currentThread]);      // 打印当前线程
    });
    NSLog(@"****主队列%@，同步 + 异步 END****\n",queue);
}

/// 主队列，异步 + 同步
+ (void)asSyncMainQueue {
    dispatch_queue_t queue = dispatch_get_main_queue();
    NSLog(@"****主队列%@，异步 + 同步 START****",queue);
    dispatch_async(queue, ^{    // 异步执行 + 主队列
        NSLog(@"异步任务1 开始---%@",[NSThread currentThread]);      // 打印当前线程

        dispatch_sync(queue, ^{  // 同步执行 + 当前主队列
            NSLog(@"嵌套同步任务1 开始---%@",[NSThread currentThread]);      // 打印当前线程
            // 追加任务
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"嵌套同步任务1 结束---%@",[NSThread currentThread]);      // 打印当前线程
        });
        NSLog(@"异步任务1 结束'hsu---%@",[NSThread currentThread]);      // 打印当前线程
    });
    NSLog(@"****主队列%@，异步 + 同步 END****",queue);
}

// 主队列，同步 + 同步
+ (void)sSyncMainQueue {
    dispatch_queue_t queue = dispatch_get_main_queue();
    NSLog(@"****主队列%@，同步 + 同步 START****",queue);

    dispatch_sync(queue, ^{    // 同步执行 + 主队列
        NSLog(@"同步任务1 开始---%@",[NSThread currentThread]);      // 打印当前线程

        dispatch_sync(queue, ^{  // 同步执行 + 当前主队列
            // 追加任务
            NSLog(@"嵌套同步任务1 开始---%@",[NSThread currentThread]);      // 打印当前线程
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"嵌套同步任务1 结束---%@",[NSThread currentThread]);      // 打印当前线程
        });
        NSLog(@"同步任务1 结束---%@",[NSThread currentThread]);      // 打印当前线程
    });
    NSLog(@"****主队列%@，同步 + 同步 END****",queue);
}

/// 主队列，异步 + 异步
+ (void)asAsyncMainQueue {
    dispatch_queue_t queue = dispatch_get_main_queue();
    NSLog(@"****主队列%@，异步 + 异步 START****",queue);
    dispatch_async(queue, ^{    // 异步执行 + 主队列
        NSLog(@"异步任务1 开始---%@",[NSThread currentThread]);      // 打印当前线程

        dispatch_async(queue, ^{  // 同步执行 + 当前主队列
            NSLog(@"嵌套异步任务1 开始---%@",[NSThread currentThread]);      // 打印当前线程
            // 追加任务
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"嵌套异步任务1 结束---%@",[NSThread currentThread]);      // 打印当前线程
        });
        NSLog(@"异步任务1 结束---%@",[NSThread currentThread]);      // 打印当前线程
    });
    NSLog(@"****主队列%@，异步 + 异步 END****",queue);
}

#pragma mark - 串行队列
/// 同一个串行队列，同步 + 异步
+ (void)sAsyncSerialQueue {
    dispatch_queue_t queue = dispatch_queue_create("test.queue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"****串行队列%@，同步 + 异步 START****",queue);
    dispatch_sync(queue, ^{    // 异步执行 + 串行队列
        NSLog(@"同步任务1 开始---%@",[NSThread currentThread]);      // 打印当前线程

        dispatch_async(queue, ^{  // 同步执行 + 当前串行队列
            NSLog(@"嵌套异步任务1 开始---%@",[NSThread currentThread]);      // 打印当前线程
            // 追加任务
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"嵌套异步任务1 结束---%@",[NSThread currentThread]);      // 打印当前线程
        });
        NSLog(@"同步任务1 结束---%@",[NSThread currentThread]);      // 打印当前线程
    });
    NSLog(@"****串行队列%@，同步 + 异步 END****\n",queue);
}

/// 同一个串行队列，异步 + 同步
+ (void)asSyncSerialQueue {
    dispatch_queue_t queue = dispatch_queue_create("test.queue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"****串行队列%@，异步 + 同步 START****",queue);
    dispatch_async(queue, ^{    // 异步执行 + 串行队列
        NSLog(@"异步任务1 开始---%@",[NSThread currentThread]);      // 打印当前线程

        dispatch_sync(queue, ^{  // 同步执行 + 当前串行队列
            NSLog(@"嵌套同步任务1 开始---%@",[NSThread currentThread]);      // 打印当前线程
            // 追加任务
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"嵌套同步任务1 结束---%@",[NSThread currentThread]);      // 打印当前线程
        });
        NSLog(@"异步任务1 结束'hsu---%@",[NSThread currentThread]);      // 打印当前线程
    });
    NSLog(@"****串行队列%@，异步 + 同步 END****",queue);
}

// 同一个串行队列，同步 + 同步
+ (void)sSyncSerialQueue {
    dispatch_queue_t queue = dispatch_queue_create("test.queue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"****串行队列%@，同步 + 同步 START****",queue);

    dispatch_sync(queue, ^{    // 同步执行 + 串行队列
        NSLog(@"同步任务1 开始---%@",[NSThread currentThread]);      // 打印当前线程

        dispatch_sync(queue, ^{  // 同步执行 + 当前串行队列
            // 追加任务
            NSLog(@"嵌套同步任务1 开始---%@",[NSThread currentThread]);      // 打印当前线程
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"嵌套同步任务1 结束---%@",[NSThread currentThread]);      // 打印当前线程
        });
        NSLog(@"同步任务1 结束---%@",[NSThread currentThread]);      // 打印当前线程
    });
    NSLog(@"****串行队列%@，同步 + 同步 END****",queue);
}

/// 同一个串行队列，异步 + 异步
+ (void)asAsyncSerialQueue {
    dispatch_queue_t queue = dispatch_queue_create("test.queue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"****串行队列%@，异步 + 异步 START****",queue);
    dispatch_async(queue, ^{    // 异步执行 + 串行队列
        NSLog(@"异步任务1 开始---%@",[NSThread currentThread]);      // 打印当前线程

        dispatch_async(queue, ^{  // 同步执行 + 当前串行队列
            NSLog(@"嵌套异步任务1 开始---%@",[NSThread currentThread]);      // 打印当前线程
            // 追加任务
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"嵌套异步任务1 结束---%@",[NSThread currentThread]);      // 打印当前线程
        });
        NSLog(@"异步任务1 结束---%@",[NSThread currentThread]);      // 打印当前线程
    });
    NSLog(@"****串行队列%@，异步 + 异步 END****",queue);
}


#pragma mark - 并行队列
/// 同一个并行队列，同步 + 异步
+ (void)sAsyncConcurrentQueue {
    dispatch_queue_t queue = dispatch_queue_create("test.queue", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"****并行队列%@，同步 + 异步 START****",queue);
    dispatch_sync(queue, ^{    // 异步执行 + 并行队列
        NSLog(@"同步任务1 开始---%@",[NSThread currentThread]);      // 打印当前线程

        dispatch_async(queue, ^{  // 同步执行 + 当前并行队列
            NSLog(@"嵌套异步任务1 开始---%@",[NSThread currentThread]);      // 打印当前线程
            // 追加任务
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"嵌套异步任务1 结束---%@",[NSThread currentThread]);      // 打印当前线程
        });
        NSLog(@"同步任务1 结束---%@",[NSThread currentThread]);      // 打印当前线程
    });
    NSLog(@"****并行队列%@，同步 + 异步 END****\n",queue);
}

/// 同一个并行队列，异步 + 同步
+ (void)asSyncConcurrentQueue {
    dispatch_queue_t queue = dispatch_queue_create("test.queue", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"****并行队列%@，异步 + 同步 START****",queue);
    dispatch_async(queue, ^{    // 异步执行 + 并行队列
        NSLog(@"异步任务1 开始---%@",[NSThread currentThread]);      // 打印当前线程

        dispatch_sync(queue, ^{  // 同步执行 + 当前并行队列
            NSLog(@"嵌套同步任务1 开始---%@",[NSThread currentThread]);      // 打印当前线程
            // 追加任务
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"嵌套同步任务1 结束---%@",[NSThread currentThread]);      // 打印当前线程
        });
        NSLog(@"异步任务1 结束'hsu---%@",[NSThread currentThread]);      // 打印当前线程
    });
    NSLog(@"****并行队列%@，异步 + 同步 END****",queue);
}

// 同一个并行队列，同步 + 同步
+ (void)sSyncConcurrentQueue {
    dispatch_queue_t queue = dispatch_queue_create("test.queue", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"****并行队列%@，同步 + 同步 START****",queue);

    dispatch_sync(queue, ^{    // 同步执行 + 并行队列
        NSLog(@"同步任务1 开始---%@",[NSThread currentThread]);      // 打印当前线程

        dispatch_sync(queue, ^{  // 同步执行 + 当前并行队列
            // 追加任务
            NSLog(@"嵌套同步任务1 开始---%@",[NSThread currentThread]);      // 打印当前线程
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"嵌套同步任务1 结束---%@",[NSThread currentThread]);      // 打印当前线程
        });
        NSLog(@"同步任务1 结束---%@",[NSThread currentThread]);      // 打印当前线程
    });
    NSLog(@"****并行队列%@，同步 + 同步 END****",queue);
}

/// 同一个并行队列，异步 + 异步
+ (void)asAsyncConcurrentQueue {
    dispatch_queue_t queue = dispatch_queue_create("test.queue", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"****并行队列%@，异步 + 异步 START****",queue);
    dispatch_async(queue, ^{    // 异步执行 + 并行队列
        NSLog(@"异步任务1 开始---%@",[NSThread currentThread]);      // 打印当前线程

        dispatch_async(queue, ^{  // 同步执行 + 当前并行队列
            NSLog(@"嵌套异步任务1 开始---%@",[NSThread currentThread]);      // 打印当前线程
            // 追加任务
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"嵌套异步任务1 结束---%@",[NSThread currentThread]);      // 打印当前线程
        });
        NSLog(@"异步任务1 结束---%@",[NSThread currentThread]);      // 打印当前线程
    });
    NSLog(@"****并行队列%@，异步 + 异步 END****",queue);
}

#pragma mark - 多线程同步方式
/**
 * 方式一：队列组 dispatch_group_async + dispatch_group_notify
 */
+ (void)groupNotify {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group =  dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步任务 1、任务 2 都执行完毕后，回到主线程执行下边任务
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程

        NSLog(@"group---end");
    });
}

/**
 * 方式二： 队列组 dispatch_group_enter、dispatch_group_leave + dispatch_group_notify
 */
+ (void)groupEnterAndLeave {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程

        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步操作都执行完毕后，回到主线程.
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
    
        NSLog(@"group---end");
    });
}

/**
 * 方式三：队列组 dispatch_group_async + dispatch_group_wait
 */
+ (void)groupWait {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group =  dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    // 等待上面的任务全部完成后，会往下继续执行（会阻塞当前线程）
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    NSLog(@"group---end");
    
}
@end
