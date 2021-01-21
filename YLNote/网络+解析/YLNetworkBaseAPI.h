//
//  YLNetworkBaseAPI.h
//  YLNote
//
//  Created by tangh on 2021/1/20.
//  Copyright © 2021 tangh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLNetErrorCode.h"

NS_ASSUME_NONNULL_BEGIN

@interface YLNetworkBaseAPI : NSObject

@end

@interface YLNetworkBaseAPIRequest : NSObject

@end


@interface YLNetworkAPIResponse : NSObject<NSCoding>

@property (nonatomic,assign) NSInteger code;
@property (nonatomic,copy) NSString *msg;
@property (nonatomic,copy,readonly) NSDictionary *data; //原始的数据,约定必须是map

- (nullable id)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
