//
//  YLNoteData.h
//  YLNote
//
//  Created by tangh on 2021/3/22.
//  Copyright © 2021 tangh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YLNoteGroup,YLQuestion,YLQuestionArticle,YLQuestionDemo;

typedef NS_ENUM(NSUInteger, YLDemoVCStyle) {
    YLDemoVCStyle_oc = 0,
    YLDemoVCStyle_swift = 1
};

NS_ASSUME_NONNULL_BEGIN


@interface YLNoteSectionData : NSObject

@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, assign) BOOL unfoldStatus; // 展开状态 Yes:展开
@property (nonatomic, strong) YLNoteGroup *group;

- (instancetype)initWithSection:(NSUInteger)index status:(BOOL)status data:(YLNoteGroup *)data;

@end


@interface YLNoteGroup : NSObject

@property (nonatomic, copy) NSString *name; // group名称
@property (nonatomic, copy) NSArray<YLQuestion*> *questions;// demo方法名

- (instancetype)initWithName:(NSString *)groupName questions:(nullable NSArray *)array;

@end


@interface YLQuestion : NSObject

@property (nonatomic, copy) NSString *title;// 问题描述
@property (nonatomic, assign) BOOL hasDemo; // 是否有demo,没有 demo 直接执行function函数
@property (nonatomic, strong) YLQuestionDemo *demo; // 问题对应的demo类
@property (nonatomic, strong) YLQuestionArticle *article; // 问题对应的article类
@property (nonatomic, copy) NSString *function; // 函数名

@end


@interface YLQuestionArticle : NSObject

@property (nonatomic, copy) NSString *artTitle; // 文章标题
@property (nonatomic, copy) NSString *fileName; // 文件名称

@end


@interface YLQuestionDemo : NSObject

@property (nonatomic, copy) NSString *className; // demo类名
@property (nonatomic, assign) YLDemoVCStyle style; // VC 类型 oc:0 , swift:1
@property (nonatomic, assign) BOOL useXib; // 使用xib

@end



NS_ASSUME_NONNULL_END
