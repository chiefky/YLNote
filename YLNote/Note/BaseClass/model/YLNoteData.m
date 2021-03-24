//
//  YLNoteData.m
//  YLNote
//
//  Created by tangh on 2021/3/22.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLNoteData.h"
#import <YYModel/YYModel.h>
@implementation YLNoteData

@end

@implementation YLQuestionDemoItem

@end

@interface YLNoteGroup ()
@end
@implementation YLNoteGroup

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"groupName":@"group"};
}

+ (NSDictionary *) modelContainerPropertyGenericClass {
    return @{@"questions": [YLQuestionItem class]};
}

- (instancetype)initWithName:(NSString *)groupName questions:(nullable NSArray *)array {
    self = [super init];
    if (self) {
        self.groupName = groupName;
        self.questions = [NSArray arrayWithArray:array];
    }
    return self;
}

@end


@interface YLQuestionItem ()

@end
@implementation YLQuestionItem
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"functionName":@"answer",
             @"itemDesc":@"description",
             @"itemClass":@"class"
    };
}

+ (NSDictionary *) modelContainerPropertyGenericClass {
    return @{@"itemClass": [YLQuestionDemoItem class]};
}


@end


@implementation YLNoteSectionData

- (instancetype)initWithSection:(NSUInteger)index status:(BOOL)status data:(YLNoteGroup *)data {
    self = [super init];
    if (self) {
        self.unfoldStatus = status;
        self.index = index;
        self.groupData = data;
    }
    return self;
}


+ (NSDictionary *) modelContainerPropertyGenericClass {
    return @{@"groupData": [YLNoteGroup class]};
}

@end
