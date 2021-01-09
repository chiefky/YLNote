//
//  YLKVONoteManager.m
//  YLNote
//
//  Created by tangh on 2021/1/6.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLKVONoteManager.h"

@implementation YLKVONoteManager
//+ (NSDictionary *)allNotes {
//    return  @{
//        @"group":@"KVO",
//        @"questions":@[@"testIsa_swizzing:isa指针换"]
//    };
//}

+ (NSDictionary *)allNotes {
    return @{
        @"group":@"KVO",
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
