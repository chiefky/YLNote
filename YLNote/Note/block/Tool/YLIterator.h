//
//  YLIterator.h
//  YLNote
//
//  Created by tangh on 2021/1/18.
//  Copyright © 2021 tangh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 累加器
@interface YLIterator : NSObject

@property (nonatomic,strong) NSString *result;

// 返回值为block的方法，block的返回值为这个类的本身，参数为NSString
- (YLIterator*(^)(NSString *parameter))add;

@end



@interface NSObject (Iterator)

+ (NSString *)iteratorResult:(void(^)(YLIterator* iterator))block;

@end


NS_ASSUME_NONNULL_END
