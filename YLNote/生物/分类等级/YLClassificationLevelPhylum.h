//
//  YLClassificationLevelPhylum.h
//  YLNote
//
//  Created by tangh on 2021/1/12.
//  Copyright © 2021 tangh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YLClassificationLevelKingdom;

NS_ASSUME_NONNULL_BEGIN

/// 门
@interface YLClassificationLevelPhylum : NSObject

@property (nonatomic,copy)NSString *phylumId;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,strong)YLClassificationLevelKingdom *levKingdom;

@end


/// 亚门
@interface YLClassificationLevelSubPhylum : YLClassificationLevelPhylum
@property (nonatomic,strong)YLClassificationLevelPhylum *phylum;
@end



NS_ASSUME_NONNULL_END
