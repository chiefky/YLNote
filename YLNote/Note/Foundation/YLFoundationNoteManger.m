//
//  YLFoundationNoteManger.m
//  YLNote
//
//  Created by tangh on 2021/1/6.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLFoundationNoteManger.h"

@implementation YLFoundationNoteManger

+ (nonnull instancetype)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

+ (NSDictionary *)allNotes {
    return
    @{
        @"group":@"Foundation",
        @"methods":@[
                @"nil、NIL、NSNULL区别",
                @"实现一个线程安全的 NSMutableArray",
                @"原子属性atomic的内部实现，是否绝对安全",
                @"实现 isEqual 和 hash 方法",
                @"id 和 instanceType 有什么区别",
                @"self和super的区别",
                @"@synthesize和@dynamic分别有什么作用",
                @"typeof 和 __typeof，typeof区别",
                @"struct和class的区别,值类型和引用类型"
        ]
    };
}

@end
