//
//  YLKingdom.h
//  YLNote
//
//  Created by tangh on 2021/1/11.
//  Copyright © 2021 tangh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YLClassificationLevelDomain;
NS_ASSUME_NONNULL_BEGIN

/// 界
@interface YLClassificationLevelKingdom : NSObject

@property (nonatomic,copy)NSString *kingdomId;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,strong)YLClassificationLevelDomain *levDomain;

@end

NS_ASSUME_NONNULL_END
