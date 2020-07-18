//
//  YLThreadSync.h
//  Demo20200420
//
//  Created by tangh on 2020/6/21.
//  Copyright © 2020 tangh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLThreadSync : NSObject

/// 信号量基本使用
+ (void)semaphoreCount;

+ (void)syncQueueTask;

/// 信号量控制多异步任务同步执行
+ (void)semaphoreSyncTask;

/// 异步队列组 + 信号量 （多异步任务异步执行，最终回到主线程）
+ (void)semaphoreGroup;

@end

@interface YLThreadSync (Lock)

#pragma mark - 普通互斥锁
- (void)testSynchronized;
- (void)testNSLock;
- (void)testPthread;

#pragma mark - 递归锁
- (void)testNSRecursiveLock;
- (void)testPthread_recursive;

#pragma mark - 条件锁
- (void)testPthread_cond;
- (void)testNSCondition;
- (void)testNSConditionLock;

#pragma mark - 读写锁
- (void)test_rwLock_barrier; // 栅栏
- (void)testPthread_rwlock;

#pragma mark - 自旋锁
- (void)testOSSpinLock;
- (void)test_unfair_lock;

@end

NS_ASSUME_NONNULL_END
