//
//  YLClass.m
//  TestDemo
//
//  Created by tangh on 2020/7/1.
//  Copyright © 2020 tangh. All rights reserved.
//

#import "YLClass.h"

@implementation YLClass

- (void)dealloc {
    NSLog(@"class: %@-%s",self,__FUNCTION__);
}

//+ (void)load {
//    NSLog(@"class: %@-%s",self,__FUNCTION__);
//}

@end
