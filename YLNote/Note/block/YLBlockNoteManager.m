//
//  YLBlockNoteManager.m
//  YLNote
//
//  Created by tangh on 2021/1/6.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLBlockNoteManager.h"

@implementation YLBlockNoteManager
//+ (NSDictionary *)allNotes {
//    return
//  @{
//      @"group":@"block",
//      @"questions":@[
//              @"testBlock:Block相关"]
//
//  };
//
//}

+ (NSDictionary *)allNotes {
    return @{
        @"group":@"block",
        @"questions":
            @[
                @{
                    @"description":@"Block相关",
                    @"answer":@"testBlock",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                }
            ]
    };
}
@end
