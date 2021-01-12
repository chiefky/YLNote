//
//  YLClassificationLevelSuperGenus.h
//  YLNote
//
//  Created by tangh on 2021/1/12.
//  Copyright © 2021 tangh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YLClassificationLevelFamily;
NS_ASSUME_NONNULL_BEGIN

/// 总属
@interface YLClassificationLevelSuperGenus : NSObject
@property (nonatomic,copy)NSString *genusId;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,strong)YLClassificationLevelFamily *levFamily;

@end

/// 属
@interface YLClassificationLevelGenus : YLClassificationLevelSuperGenus
@property (nonatomic,strong)YLClassificationLevelSuperGenus *superGenus;

@end

/// 亚属
@interface YLClassificationLevelSubGenus : YLClassificationLevelGenus
@property (nonatomic,strong)YLClassificationLevelFamily *genus;
@end

NS_ASSUME_NONNULL_END
