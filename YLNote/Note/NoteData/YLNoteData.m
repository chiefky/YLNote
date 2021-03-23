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

@implementation YLNoteItemDemoClass

@end

@interface YLNoteGroup ()
@end
@implementation YLNoteGroup

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"groupName":@"group"};
}

+ (NSDictionary *) modelContainerPropertyGenericClass {
    return @{@"questions": [YLNoteItem class]};
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


@interface YLNoteItem ()

@end
@implementation YLNoteItem
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"functionName":@"answer",
             @"itemDesc":@"description",
             @"itemClass":@"class"
    };
}

+ (NSDictionary *) modelContainerPropertyGenericClass {
    return @{@"itemClass": [YLNoteItemDemoClass class]};
}


@end

