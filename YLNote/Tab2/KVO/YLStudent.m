//
//  YLStudent.m
//  TestDemo
//
//  Created by tangh on 2020/7/8.
//  Copyright © 2020 tangh. All rights reserved.
//

#import "YLStudent.h"
#import "YLJSProtocol.h"

@interface YLStudent ()<YLJSProtocol>

@property (nonatomic, copy)NSString *name;

@end

@implementation YLStudent

- (NSString *)whatYouName {
    return @"我叫张三";
}

- (NSString *)name {
    return @"张三";
}



@end
