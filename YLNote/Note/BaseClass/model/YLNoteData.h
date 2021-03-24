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

@interface YLQuestionDemoItem : NSObject
@property (nonatomic, copy) NSString *title; // 导航标题
@property (nonatomic, copy) NSString *atrticleTitle; // 文章标题
@property (nonatomic, copy) NSString *className; // 类名
@property (nonatomic, assign) BOOL classType; // swift or OC
@property (nonatomic, assign) BOOL xibType;// 是否use xib

@end

@interface YLQuestionItem : NSObject
@property (nonatomic, strong) YLQuestionDemoItem *demoItem; // 问题对应的demo类
@property (nonatomic, copy) NSString *functionName;// demo方法名
@property (nonatomic, copy) NSString *itemDesc;// demo问题描述

@end

@interface YLNoteGroup : NSObject
@property (nonatomic, copy) NSString *groupName; // 问题名称
@property (nonatomic, copy) NSArray<YLQuestionItem*> *questions;// demo方法名

- (instancetype)initWithName:(NSString *)groupName questions:(nullable NSArray *)array;

@end

@interface YLNoteSectionData : NSObject

@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, assign) BOOL unfoldStatus; // 展开状态 Yes:展开
@property (nonatomic, strong) YLNoteGroup *groupData;

- (instancetype)initWithSection:(NSUInteger)index status:(BOOL)status data:(YLNoteGroup *)data;

@end


NS_ASSUME_NONNULL_END
