//
//  NSArray+Tools.h
//  YLNote
//
//  Created by tangh on 2021/1/18.
//  Copyright © 2021 tangh. All rights reserved.
//



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Tools)

@end

@interface NSArray (Safe)

- (id)yl_safeObjectAtIndex:(NSUInteger)index;

@end
NS_ASSUME_NONNULL_END
