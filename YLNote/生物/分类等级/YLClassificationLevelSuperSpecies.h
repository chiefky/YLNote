//
//  YLClassificationLevelSuperSpecies.h
//  YLNote
//
//  Created by tangh on 2021/1/12.
//  Copyright © 2021 tangh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YLClassificationLevelGenus;

NS_ASSUME_NONNULL_BEGIN

/// 总种
@interface YLClassificationLevelSuperSpecies : NSObject
@property (nonatomic,copy)NSString *speciesId;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,strong)YLClassificationLevelGenus *levGenus;

@end

/// 种
@interface YLClassificationLevelSpecies : YLClassificationLevelSuperSpecies
@property (nonatomic,strong)YLClassificationLevelSuperSpecies *superSpecies;

@end

/// 亚种
@interface YLClassificationLevelSubSpecies : YLClassificationLevelSpecies
@property (nonatomic,strong)YLClassificationLevelGenus *genus;
@end

NS_ASSUME_NONNULL_END
