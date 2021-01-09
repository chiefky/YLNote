//
//  YLGCDNoteManager.m
//  YLNote
//
//  Created by tangh on 2021/1/6.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLGCDNoteManager.h"

@implementation YLGCDNoteManager

//+ (NSDictionary *)allNotes{
//    return @{
//        @"group":@"多线程",
//        @"questions":@[
//                @"多个网络请求完成后执行下一步:",
//                @"多个网络请求顺序执行后执行下一步:",
//                @"多线程中的死锁",
//                @"异步操作两组数据时, 执行完第一组之后, 才能执行第二组:",
//                @"GCD执行原理",
//                @"iOS中实现多线程的几种方案，各自有什么特点",
//             ]
//    };
//
//}


+ (NSDictionary *)allNotes {
    return @{
        @"group":@"多线程",
        @"questions":
            @[
                @{
                    @"description":@"isa指针换",
                    @"answer":@"testRunloop_timrt",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                }
            ]
    };
}


@end
