//
//  YLClassificationLevelSuperFamily.h
//  YLNote
//
//  Created by tangh on 2021/1/12.
//  Copyright © 2021 tangh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YLClassificationLevelOrder;
NS_ASSUME_NONNULL_BEGIN

/// 总科
@interface YLClassificationLevelSuperFamily : NSObject
@property (nonatomic,copy)NSString *familyId;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,strong)YLClassificationLevelOrder *levOrder;

@end

/// 科
@interface YLClassificationLevelFamily : YLClassificationLevelSuperFamily
@property (nonatomic,strong)YLClassificationLevelSuperFamily *superOrder;
@end

/// 亚科
@interface YLClassificationLevelSubFamily : YLClassificationLevelFamily
@property (nonatomic,strong)YLClassificationLevelOrder *family;
@end

NS_ASSUME_NONNULL_END
