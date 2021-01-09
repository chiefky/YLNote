//
//  YLAnimationNoteManager.m
//  YLNote
//
//  Created by tangh on 2021/1/6.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLAnimationNoteManager.h"

@implementation YLAnimationNoteManager

//+ (NSDictionary *)allNotes {
//    return  @{
//        @"group":@"动画",
//        @"questions":@[
//                @"testRunloop_timrt:isa指针换"]
//        
//    };
//}

+ (NSDictionary *)allNotes {
    return @{
        @"group":@"动画",
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
