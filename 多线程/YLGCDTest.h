//
//  YLGCDTest.h
//  Demo20200420
//
//  Created by tangh on 2020/6/20.
//  Copyright © 2020 tangh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLGCDTest : NSObject

/// 主队列，同步 + 异步
+ (void)sAsyncMainQueue;
/// 主队列，异步 + 同步
+ (void)asSyncMainQueue;

// 主队列，同步 + 同步
+ (void)sSyncMainQueue;

/// 主队列，异步 + 异步
+ (void)asAsyncMainQueue;

#pragma mark - 串行队列
/// 同一个串行队列，同步 + 异步
+ (void)sAsyncSerialQueue;

/// 同一个串行队列，异步 + 同步
+ (void)asSyncSerialQueue;

// 同一个串行队列，同步 + 同步
+ (void)sSyncSerialQueue;

/// 同一个串行队列，异步 + 异步
+ (void)asAsyncSerialQueue;

#pragma mark - 并行队列
/// 同一个并行队列，同步 + 异步
+ (void)sAsyncConcurrentQueue;

/// 同一个并行队列，异步 + 同步
+ (void)asSyncConcurrentQueue;

// 同一个并行队列，同步 + 同步
+ (void)sSyncConcurrentQueue;

/// 同一个并行队列，异步 + 异步
+ (void)asAsyncConcurrentQueue;

#pragma mark - 多线程同步方式
/**
 * 方式一：队列组 dispatch_group_async + dispatch_group_notify
 */
+ (void)groupNotify;

/**
 * 方式二：队列组 dispatch_group_enter、dispatch_group_leave + dispatch_group_notify
 */
+ (void)groupEnterAndLeave;

/**
 * 方式三：队列组 dispatch_group_async + dispatch_group_wait
 */
+ (void)groupWait;


@end

NS_ASSUME_NONNULL_END
