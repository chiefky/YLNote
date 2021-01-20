//
//  NSArray+Tools.m
//  YLNote
//
//  Created by tangh on 2021/1/18.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "NSArray+Tools.h"


@implementation NSArray (Tools)

@end

@implementation NSArray (Safe)

- (id)yl_safeObjectAtIndex:(NSUInteger)index{
    if (self.count == 0) {
        return nil;
    }
    if (index >= self.count) {
        return nil;
    }
    
    return [self objectAtIndex:index];
}

@end
