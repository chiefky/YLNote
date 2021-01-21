//
//  NSObject+Parser.m
//  YLNote
//
//  Created by tangh on 2021/1/21.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "NSObject+Parser.h"


@implementation NSObject (Parser)

//+ (NSDictionary *)yl_dictionaryWithJSON:(id)json {
//    if (!json || json == (id)kCFNull) return nil;
//    NSDictionary *dic = nil;
//    NSData *jsonData = nil;
//    if ([json isKindOfClass:[NSDictionary class]]) {
//        dic = json;
//    } else if ([json isKindOfClass:[NSString class]]) {
//        jsonData = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
//    } else if ([json isKindOfClass:[NSData class]]) {
//        jsonData = json;
//    }
//    if (jsonData) {
//        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
//        if (![dic isKindOfClass:[NSDictionary class]]) dic = nil;
//    }
//    return dic;
//}
//
//+ (instancetype)yl_modelWithJSON:(id)json {
//    NSDictionary *dic = [self yl_dictionaryWithJSON:json];
//    return [self yl_modelWithDictionary:dic];
//}
//
//+ (instancetype)yl_modelWithDictionary:(NSDictionary *)dictionary {
//    if (!dictionary || dictionary == (id)kCFNull) return nil;
//    if (![dictionary isKindOfClass:[NSDictionary class]]) return nil;
//
//    Class cls = [self class];
//    NSObject *one = [cls new];
//    if ([one yl_modelSetWithDictionary:dictionary]) return one;
//    return nil;
//}
//
//- (BOOL)yl_modelSetWithJSON:(id)json {
//    NSDictionary *dic = [NSObject yl_dictionaryWithJSON:json];
//    return [self yl_modelSetWithDictionary:dic];
//}


@end
