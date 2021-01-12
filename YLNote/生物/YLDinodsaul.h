//
//  YLDinodsaul.h
//  YLNote
//
//  Created by tangh on 2021/1/11.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLOrganism.h"

NS_ASSUME_NONNULL_BEGIN

@interface YLDinodsaul : YLOrganism<NSCopying>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *organismId;// 生物体ID

/// 测试demo
- (void)testClass;

@end

NS_ASSUME_NONNULL_END
