//
//  YLRuntimeNoteManager.m
//  YLNote
//
//  Created by tangh on 2021/1/6.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLRuntimeNoteManager.h"

@implementation YLRuntimeNoteManager

+ (nonnull instancetype)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

+ (NSDictionary *)allNotes {
    return @{
        @"group":@"runtime",
        @"questions":
            @[
                @{
                    @"description":@"isa指针换",
                    @"answer":@"testRunloop_timrt",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                @{
                    @"title": @"https://developer.aliyun.com/article/367660"
                    
                }
            ]
    };
}
@end
