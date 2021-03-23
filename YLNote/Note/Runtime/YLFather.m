//
//  YLFather.m
//  TestDemo
//
//  Created by tangh on 2020/7/11.
//  Copyright © 2020 tangh. All rights reserved.
//

#import "YLFather.h"

@implementation YLFather

//+(void)load {
//    NSLog(@"%s",__FUNCTION__);
//}

//+(void)initialize {
//    NSLog(@"%s",__FUNCTION__);
//}

//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        ivar1 = 9;
//        self.propertyInt1 = 9;
//        self.propertyObj1 = [NSObject new];
//        NSLog(@"%s: %@,%ld,%ld",__FUNCTION__,self,ivar1,self.propertyInt1);
//    }
//    return self;
//}

+ (NSString *)defaultColor {
    return @"黄";
}

- (NSString *)gender {
    return @"男";
}

- (void)hairColor {
    NSLog(@"%s: red",__FUNCTION__);
}

@end
