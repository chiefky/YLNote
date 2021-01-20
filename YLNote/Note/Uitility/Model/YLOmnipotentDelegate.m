//
//  YLOmnipotentDelegate.m
//  YLNote
//
//  Created by tangh on 2021/1/13.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLOmnipotentDelegate.h"
#import <objc/runtime.h>

@implementation YLOmnipotentDelegate

+ (instancetype)sharedOmnipotent {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

/**
 测试用例：
 1.定义一个结果变量printResult（string型，用来存储输出结果）
 2.将结果变量初始值设为传入参数类类名：printResult = cls string
 3.定义一个临时变量tmpCls,并指向当前类： tmpCls = cls
 4.while循环获取当前类的父类，并赋值给临时变量，同时获取临时变量的类名拼接至结果变量: tmp = cls super,printResult += ->tmpCls string
 5.结束条件： tmpCLs == NSObject
 */
/// 获取当前类的继承关系
/// @param cls 类名
- (void)getSuperClassTreeForClass:(Class) cls {
    NSString *printResult = NSStringFromClass(cls);
    Class tmpCls = cls;
    while (1) {
        tmpCls = class_getSuperclass(tmpCls);
        printResult = [printResult stringByAppendingString:[NSString stringWithFormat:@" ->%@",NSStringFromClass(tmpCls)]];
        if ([NSStringFromClass(tmpCls) isEqualToString:@"NSObject"]) {
            NSLog(@"cls 继承关系：%@",printResult);
            break;
        }
    }
//    for (int i = 0; i < 5; i++) {
//        NSString *printStr = i > 0
//        NSLog(@"Following the isa pointer %d times gives %p class type %@", i, currentClass,NSStringFromClass(currentClass));
//        currentClass = class_getSuperclass(currentClass);
//    }

//    NSLog(@"NSObject's SuperClass is %@",class_getSuperclass([NSObject class]));
}


@end
