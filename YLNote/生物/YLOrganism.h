//
//  YLOrganism.h
//  YLNote
//
//  Created by tangh on 2021/1/11.
//  Copyright © 2021 tangh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YLClassificationLevelSuperSpecies;

NS_ASSUME_NONNULL_BEGIN

@interface YLOrganism : NSObject

//@property (nonatomic,strong)YLClassificationLevelDomain *levDomain; // 域
//@property (nonatomic,strong)YLClassificationLevelKingdom *levKingdom; // 界
//@property (nonatomic,strong)YLClassificationLevelPhylum *levPhylum; // 门
//@property (nonatomic,strong)YLClassificationLevelClass *levClass; // 纲
//@property (nonatomic,strong)YLClassificationLevelOrder *levOrder; // 目
//@property (nonatomic,strong)YLClassificationLevelFamily *levFamily; // 科
//@property (nonatomic,strong)YLClassificationLevelGenus *levGenus; // 属
@property (nonatomic,strong)YLClassificationLevelSuperSpecies *levSpecices; // 种

@end

NS_ASSUME_NONNULL_END
