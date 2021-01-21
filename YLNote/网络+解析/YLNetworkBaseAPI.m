//
//  YLNetworkBaseAPI.m
//  YLNote
//
//  Created by tangh on 2021/1/20.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLNetworkBaseAPI.h"
#import <objc/runtime.h>
#import "YLEncode.h"
#import "YLNetErrorCode.h"

@implementation YLNetworkBaseAPI


@end

@interface YLNetworkAPIResponse ()
@property (nonatomic, copy) NSDictionary *data; //原始的数据

@end

@implementation YLNetworkAPIResponse

YLENCODE_DECODER();

- (id)initWithDictionary:(NSDictionary *)dict {
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    YLNetworkAPIResponse *response = [[YLNetworkAPIResponse alloc] init];
    response.code = [dict[@"code"] integerValue];
    response.msg = dict[@"msg"];
    response.data = dict[@"data"];
    return response;
}

@end
