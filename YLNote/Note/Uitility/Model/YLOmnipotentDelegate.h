//
//  YLOmnipotentDelegate.h
//  YLNote
//
//  Created by tangh on 2021/1/13.
//  Copyright © 2021 tangh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLOmnipotentDelegate : NSObject

+ (instancetype)sharedOmnipotent;

- (void)getSuperClassTreeForClass:(Class) cls;
@end

NS_ASSUME_NONNULL_END
