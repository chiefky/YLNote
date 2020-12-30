//
//  YLSon.m
//  TestDemo
//
//  Created by tangh on 2020/7/11.
//  Copyright © 2020 tangh. All rights reserved.
//

#import "YLSon.h"
#import <objc/runtime.h>
@implementation YLSon

//+(void)load {
//    NSLog(@"%s",__FUNCTION__);
//}

//+(void)initialize {
//    //输出
////    NSLog(@"%d", [self class] == object_getClass(self));
////    //输出1
////    NSLog(@"%d", class_isMetaClass(object_getClass(self)));
////    //输出1
////    NSLog(@"%d", class_isMetaClass(object_getClass([self class])));
////    //输出1
////    NSLog(@"%d", object_getClass(self) == object_getClass([self class]));
//    NSLog(@"%s",__FUNCTION__);
//}

//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        ivar1 = 10;
//        self.propertyInt1 = 10;
//        self.propertyObj1 = [NSObject new];
//    }
//    NSLog(@"%s: %@,%ld,%ld",__FUNCTION__,self,ivar1,self.propertyInt1);
//    return self;
//}

- (void)hairColor {
    NSLog(@"%s: red",__FUNCTION__);
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSLog(@"%s",__FUNCTION__);

    return false;
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    NSLog(@"%s",__FUNCTION__);

    return false;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"%s",__FUNCTION__);

    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSLog(@"%s",__FUNCTION__);

     //查找父类签名
       NSMethodSignature *methodSignature = [super methodSignatureForSelector:aSelector];

       if (methodSignature == nil)
       {
           methodSignature = [NSMethodSignature signatureWithObjCTypes:"v@:"];
       }
       return methodSignature;
}

// invocation 调用
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    NSLog(@"%s",__FUNCTION__);

    SEL sel = anInvocation.selector;

    YLFather *person = YLFather.new;

    if ([person respondsToSelector:sel])
    {
        [anInvocation invokeWithTarget:person];
    } else {
        NSLog(@"真的找不到 %@ 的方法实现！！！",NSStringFromSelector(sel));
    }
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    NSLog(@"程序crash了");
}

@end
