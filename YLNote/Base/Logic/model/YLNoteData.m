//
//  YLNoteData.m
//  YLNote
//
//  Created by tangh on 2021/3/22.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLNoteData.h"
#import <YYModel/YYModel.h>


@implementation YLNoteSectionData

- (instancetype)initWithSection:(NSUInteger)index status:(BOOL)status data:(YLNoteGroup *)data {
    self = [super init];
    if (self) {
        self.unfoldStatus = status;
        self.index = index;
        self.group = data;
    }
    return self;
}


+ (NSDictionary *) modelContainerPropertyGenericClass {
    return @{@"group": [YLNoteGroup class]};
}

@end


@implementation YLNoteGroup

//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{@"name":@"name"};
//}

+ (NSDictionary *) modelContainerPropertyGenericClass {
    return @{@"questions": [YLQuestion class]};
}

- (instancetype)initWithName:(NSString *)groupName questions:(NSArray *)array {

    self = [super init];
    if (self) {
        self.name = groupName;
        self.questions = [NSArray arrayWithArray:array];
    }
    return self;
}

@end


@implementation YLQuestion
//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{
//        @"title":@"title",
//        @"article":@"article",
//        @"demo":@"demo"
//    };
//}

+ (NSDictionary *) modelContainerPropertyGenericClass {
    return @{
        @"demo": [YLQuestionDemo class],
        @"article": [YLQuestionArticle class],
        
    };
}

@end


@implementation YLQuestionArticle

@end


@implementation YLQuestionDemo

@end

