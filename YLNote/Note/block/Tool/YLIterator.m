//
//  YLIterator.m
//  YLNote
//
//  Created by tangh on 2021/1/18.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLIterator.h"

@interface YLIterator ()


@end

@implementation YLIterator

- (YLIterator * _Nonnull (^)(NSString * _Nonnull))add {
#warning 这里block是堆区还是栈区block，参数放在什么位置
        // 给block起个别名，然后作为返回值返回
//        YLIterator*(^aliasBlock)(NSString*) = ^(NSString *param) {
//            self.result = [self.result stringByAppendingString:param];
//            return self;
//        };
//        return aliasBlock;
    return ^(NSString *param) {
        self.result = [self.result stringByAppendingString:param];
        return self;
    };
    
}

- (NSString *)result {
    if (!_result) {
        _result = @"";
    }
    return _result;
}

@end

@implementation NSObject (Iterator)


/// 获取累加结果
///// @param block 返回值为空，参数为迭代器的一个block
+ (NSString *)iteratorResult:(void(^)(YLIterator *))block {
    YLIterator * iterator = [[YLIterator alloc] init];
    block(iterator); // 调用block YLIterator本身作为该block的参数
    return iterator.result;
}


@end
