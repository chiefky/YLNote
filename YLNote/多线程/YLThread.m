//
//  YLThread.m
//  Demo20200420
//
//  Created by tangh on 2020/5/27.
//  Copyright © 2020 tangh. All rights reserved.
//

#import "YLThread.h"

@implementation YLThread

- (void)dealloc {
    NSLog(@"%@被释放了",self.name);
}

@end

