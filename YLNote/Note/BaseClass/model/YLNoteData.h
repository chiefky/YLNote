//
//  YLNoteData.h
//  YLNote
//
//  Created by tangh on 2021/3/22.
//  Copyright © 2021 tangh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLNoteData : NSObject

@end

@interface YLNoteItemDemoClass : NSObject
@property (nonatomic, copy) NSString *title; // 导航标题
@property (nonatomic, copy) NSString *atrticleTitle; // 文章标题
@property (nonatomic, copy) NSString *className; // 类名
@property (nonatomic, assign) BOOL classType; // swift or OC
@property (nonatomic, assign) BOOL xibType;// 是否use xib

@end

@interface YLNoteItem : NSObject
@property (nonatomic, strong) YLNoteItemDemoClass *itemClass; // demo类
@property (nonatomic, copy) NSString *functionName;// demo方法名
@property (nonatomic, copy) NSString *itemDesc;// demo问题描述

@end

@interface YLNoteGroup : NSObject
@property (nonatomic, copy) NSString *groupName; // 问题名称
@property (nonatomic, copy) NSArray<YLNoteItem*> *questions;// demo方法名

- (instancetype)initWithName:(NSString *)groupName questions:(nullable NSArray *)array;

@end


NS_ASSUME_NONNULL_END
