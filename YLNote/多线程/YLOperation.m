//
//  YLOperation.m
//  Demo20200420
//
//  Created by tangh on 2020/6/24.
//  Copyright © 2020 tangh. All rights reserved.
//

#import "YLOperation.h"
#import <UIKit/UIKit.h>

// 用NSURLConnection为例，operation 在子线程开启start时，由于子线程默认未开启runloop无法保活子线程，start返回后线程就被销毁了。所以需要开启子线程runloop 并是runloop一直run,或者在start时直接切到主线程执行任务；
@interface YLOperation ()<NSURLConnectionDelegate>

@property (nonatomic, readwrite, getter=isExecuting) BOOL executing;
@property (nonatomic, readwrite, getter=isFinished) BOOL finished;

@end


@implementation YLOperation
// 因为父类的属性是Readonly的，重载时如果需要setter的话则需要手动合成。
@synthesize executing = _executing;
@synthesize finished = _finished;

- (void)dealloc {
    NSLog(@"%@ dealloc",self);
}

#pragma mark - 并发子类
- (void)setExecuting:(BOOL)executing {
    //调用KVO通知
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    //调用KVO通知
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isExecuting {
    return _executing;
}

- (void)setFinished:(BOOL)finished {
    if (_finished != finished) {
        [self willChangeValueForKey:@"isFinished"];
        _finished = finished;
        [self didChangeValueForKey:@"isFinished"];
    }
}

- (BOOL)isFinished {
    return _finished;
}

- (void)start {
    @autoreleasepool{
        self.executing = YES;
        if (self.cancelled) {
            [self done];
            return;
        }
        // 任务。。。
        [self downloadImage];
    }
}

- (void)done {
    self.finished = YES;
    self.executing = NO;
}

// 表示是并发的
- (BOOL)isAsynchronous {
    return YES;
}

// 下载任务
- (void)downloadImage {
    
    NSLog(@"start开启时currentThread: %@",[NSThread currentThread]);
    NSString *urlString = [NSString stringWithFormat:@"https://c-ssl.duitang.com/uploads/item/201609/25/20160925122455_rxEyB.jpeg"];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request
                                                                  delegate:self];
    // 不在主线程，手动开启runloop
    if (![NSThread isMainThread]) {
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [connection scheduleInRunLoop:runLoop forMode:NSRunLoopCommonModes];
        [runLoop run];
    }
    
    [connection start];
    
}

#pragma mark - NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSLog(@"%s",__func__);
    // to do something...
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"%s",__func__);
    
    // to do something...
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"%s",__func__);
    
    [self done];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%s",__func__);
    
    [self done];
}

#pragma mark - 非并发子类
//// 非并发子类重写main方法
//- (void)main {
//    if (!self.isCancelled) {
//            for (int i = 0; i < 2; i++) {
//                [NSThread sleepForTimeInterval:2];
//                NSLog(@"操作%d---%@",i, [NSThread currentThread]);
//            }
//        }
//
//}
@end
