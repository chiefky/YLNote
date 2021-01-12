//
//  YLDinosaur.h
//  YLNote
//
//  Created by tangh on 2021/1/7.
//  Copyright © 2021 tangh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLDinosaur : NSObject<NSCopying>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *superorder;// 总目
@property (nonatomic,copy) NSString *suborder; // 亚目
@property (nonatomic, copy) NSString *subsuborder; // 次亚目


+ (instancetype)dinosaurWithName:(NSString *)name superorder:(NSString *)superorder suborder:(NSString *)suborder subsuborder:(NSString *)subsuborder;

@end

NS_ASSUME_NONNULL_END
