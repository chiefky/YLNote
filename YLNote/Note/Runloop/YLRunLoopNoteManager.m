//
//  YLRunLoopNoteManager.m
//  YLNote
//
//  Created by tangh on 2021/1/6.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLRunLoopNoteManager.h"

@implementation YLRunLoopNoteManager

+ (NSDictionary *)allNotes {
    return @{
        @"group":@"Runloop",
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
