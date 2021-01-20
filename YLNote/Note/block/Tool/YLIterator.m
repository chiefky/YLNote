//
//  YLIterator.m
//  YLNote
//
//  Created by tangh on 2021/1/18.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLIterator.h"

@interface YLIterator ()

@property (nonatomic,copy) NSString *result;

@end

@implementation YLIterator

/// 字符串拼接
- (YLIterator * _Nonnull (^)(NSString * _Nonnull))add {
    
    // 给block起个别名，然后作为返回值返回
    YLIterator*(^aliasBlock)(NSString*) = ^(NSString *param) {
        self.result = [self.result stringByAppendingString:param];
        return self;
    };
    return aliasBlock;
}
@end

@implementation NSObject (Iterator)


/// 获取累加结果
/// @param block 返回值为空，参数为迭代器的一个block
+ (NSString *)iteratorResult:(void(^)(YLIterator *))block {
    YLIterator * iterator = [[YLIterator alloc] init];
    block(iterator); // 调用block YLIterator本身作为该block的参数
    return iterator.result; // 返回迭代结果
}

@end
