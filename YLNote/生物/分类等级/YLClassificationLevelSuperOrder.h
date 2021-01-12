//
//  YLClassificationLevelSuperOrder.h
//  YLNote
//
//  Created by tangh on 2021/1/12.
//  Copyright © 2021 tangh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YLClassificationLevelClass;
NS_ASSUME_NONNULL_BEGIN

/// 总目
@interface YLClassificationLevelSuperOrder : NSObject
@property (nonatomic,copy)NSString *orderId;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,strong)YLClassificationLevelClass *levClass; // 上一级 纲

@end

/// 目
@interface YLClassificationLevelOrder : YLClassificationLevelSuperOrder
@property (nonatomic,strong)YLClassificationLevelSuperOrder *superOrder; // 上一级 总目
@end

/// 亚目
@interface YLClassificationLevelSubOrder : YLClassificationLevelOrder
@property (nonatomic,strong)YLClassificationLevelOrder *order; // 上一级 目
@end



NS_ASSUME_NONNULL_END
