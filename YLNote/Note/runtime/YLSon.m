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

@end
