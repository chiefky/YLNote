//
//  YLWebNoteManager.m
//  YLNote
//
//  Created by tangh on 2021/1/6.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLWebNoteManager.h"

@implementation YLWebNoteManager

+ (nonnull instancetype)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

//+ (NSDictionary *)allNotes {
//    return         @{
//        @"group":@"Web",
//        @"questions":@[
//                @"UIView 和 CALayer 是什么关系",
//                @"Bounds 和 Frame 的区别",
//                @"setNeedsDisplay 和 layoutIfNeeded 两者是什么关系",
//                @"谈谈对UIResponder的理解",
//                @"loadView的作用",
//                @"使用 drawRect有什么影响",
//                @"keyWindow 和 delegate的window有何区别"
//        ]
//    };
//}

+ (NSDictionary *)allNotes {
    return @{
        @"group":@"Web",
        @"questions":
            @[
                @{
                    @"description":@"JS 和 OC 互相调用的几种方式",
                    @"answer":@"testJSBridgeOC",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                @{
                                  @"description":@"使用 WKWedView 时遇到过哪些问题",
                                  @"answer":@"testWKWebViewCookie",
                                  @"class": NSStringFromClass(self),
                                  @"type": @(0)
                              }
            ]
    };
}
+ (void)testJSBridgeOC {
    
}

+ (void)testWKWebViewCookie {
    
}
@end
