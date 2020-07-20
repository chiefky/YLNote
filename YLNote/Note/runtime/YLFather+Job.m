//
//  YLFather+Job.m
//  TestDemo
//
//  Created by tangh on 2020/7/11.
//  Copyright © 2020 tangh. All rights reserved.
//

#import "YLFather+Job.h"
#import <objc/runtime.h>
static NSString *const kJob;

@implementation YLFather (Job)

//+(void)load {
//    NSLog(@"%s",__FUNCTION__);
//}

//+(void)initialize
//{
//    //输出0
//    NSLog(@"%d", [self class] == object_getClass(self));
//    //输出1
//    NSLog(@"%d", class_isMetaClass(object_getClass(self)));
//    //输出1
//    NSLog(@"%d", class_isMetaClass(object_getClass([self class])));
//    //输出1
//    NSLog(@"%d", object_getClass(self) == object_getClass([self class]));
//     NSLog(@"%s",__FUNCTION__);
//}


- (void)setJob:(NSString *)Job {
    objc_setAssociatedObject(self, &kJob, Job, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)job {
    return objc_getAssociatedObject(self, &kJob);
}

#pragma mark - 重写本类方法
- (NSString *)gender {
    return @"gay";
}

@end
