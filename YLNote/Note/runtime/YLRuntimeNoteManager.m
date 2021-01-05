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
    return
    @{
        @"group":@"runtime",
        @"methods":@[
                @"testSonInitalize:子类的'+initialize'",
                @"testCategoryInitalize:分类的'+initialize'",
                @"testSonOverwrite:子类方法重写",
                @"testCategoryOverwrite:分类方法重写（原理同Initalize）",
                @"testCategory_associate_ivas:获取所有实例变量",
                @"testCategory_associate_protertys:获取所有属性",
                @"testCategory_associate_methds:获取所有实例方法",
                @"testCategory_associate_class_methds:获取所有类方法",
                @"testClassMethod:用类对象调实例方法",
                @"testMsg_resolve:动态解析",
                @"testMsg_forwarding:消息转发",
        ]};
}

@end
