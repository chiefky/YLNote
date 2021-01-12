//
//  YLPerson.h
//  YLNote
//
//  Created by tangh on 2021/1/9.
//  Copyright © 2021 tangh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLPerson : NSObject <NSCopying>
@property (atomic, assign) NSInteger ageAuto;   //有一个atomic的属性,表示是原子的
@property (nonatomic, assign) NSInteger ageNonAuto;   //有一个nonatomic的属性,表示是非原子的

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong)NSDate *birthday;
@property (nonatomic, assign) BOOL gender; // 0: 男，1：女

+ (instancetype)personWithName:(NSString *)name birthday:(nonnull NSDate *)birthday;

@end

NS_ASSUME_NONNULL_END
