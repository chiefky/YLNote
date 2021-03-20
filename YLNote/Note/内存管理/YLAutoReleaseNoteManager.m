//
//  YLAutoReleaseNoteManager.m
//  YLNote
//
//  Created by tangh on 2021/1/6.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLAutoReleaseNoteManager.h"

@implementation YLAutoReleaseNoteManager

//+ (NSDictionary *)allNotes {
//    return @{
//        @"group":@"内存管理",
//        @"questions":@[
//                @"AutoReleasePool:",
//                @"testAutorelease:",
//                @"testCopy:copy关键字",
//                @"testStrong:strong关键字",
//                @"testWeak:weak关键字",
//                @"test_unsafe_unretained:unsafe_unretained关键字",
//                @"testMemory:内存泄漏",
//                @"testAssociate:Autorelease"]
//    };
//}
+ (NSDictionary *)allNotes {
    return @{
        @"group":@"内存管理",
        @"questions":
            @[
                @{
                    @"description":@"内存缓存",
                    @"answer":@"testRunloop_timrt",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                @{
                    @"description":@"磁盘缓存",
                    @"answer":@"testRunloop_timrt",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
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
