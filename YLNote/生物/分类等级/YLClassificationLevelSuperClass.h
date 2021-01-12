//
//  YLClassificationLevelSuperClass.h
//  YLNote
//
//  Created by tangh on 2021/1/12.
//  Copyright © 2021 tangh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YLClassificationLevelPhylum;

NS_ASSUME_NONNULL_BEGIN

/// 总纲
@interface YLClassificationLevelSuperClass : NSObject

@property (nonatomic,copy)NSString *classId;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,strong)YLClassificationLevelPhylum *levPhylum; // 上一级 门

@end

/// 纲
@interface YLClassificationLevelClass : YLClassificationLevelSuperClass
@property (nonatomic,strong)YLClassificationLevelSuperClass *superClass; // 上一级 总纲
@end

/// 亚纲
@interface YLClassificationLevelSubClass : YLClassificationLevelClass
@property (nonatomic,strong)YLClassificationLevelClass *levClass; // 上一级 纲
@end


NS_ASSUME_NONNULL_END
