//
//  YLUIKitNoteManger.m
//  YLNote
//
//  Created by tangh on 2021/1/6.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLUIKitNoteManger.h"

@implementation YLUIKitNoteManger

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
        @"group":@"UIKit",
        @"questions":
            @[
                @{
                    @"description":@"UIView 和 CALayer 是什么关系",
                    @"answer":@"testUIViewAndCALayer",
                    @"class": NSStringFromClass(self),
                    @"type": @(0),
                },
                @{
                    @"description":@"Bounds 和 Frame 的区别",
                    @"answer":@"testBoundsAndFrame",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                @{
                    @"description":@"setNeedsDisplay 和 layoutIfNeeded 两者是什么关系",
                    @"answer":@"testSetNeedsDisplayAndlayoutIfNeeded",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                @{
                    @"description": @"谈谈对UIResponder的理解",
                    @"answer":@"testUIResponder",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                @{
                    @"description": @"loadView的作用",
                    @"answer":@"testLoadView",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                
                @{
                    @"description": @"使用 drawRect有什么影响",
                    @"answer":@"testDrawRect",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                },
                @{
                    @"description": @"keyWindow 和 delegate的window有何区别",
                    @"answer":@"testKeyWindow",
                    @"class": NSStringFromClass(self),
                    @"type": @(0)
                }
            ]
    };
}


+ (void)testUIViewAndCALayer {
}

+ (void)testBoundsAndFrame {
    
}

+ (void)testSetNeedsDisplayAndlayoutIfNeeded {
    
}
+ (void)testUIResponder{
    
}

+ (void)testLoadView {
    
}

+ (void)testDrawRect {
    
}


+ (void)testKeyWindow {
    
}


@end
