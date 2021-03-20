//
//  UIView+Skin.m
//  YLNote
//
//  Created by tangh on 2021/2/19.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "UIView+Skin.h"


@implementation UIView (Skin)
+ (UIImage *)setSkinImageWithStr:(NSString *)str
{
     // 获取plist里面的数据
    NSDictionary * dict = nil;//[NSString getDicWithKey:@"Skin.plist"];
    if ([dict.allKeys containsObject:@"selectColor"])
    {
        NSString * key = [dict objectForKey:@"selectColor"];
        return [UIImage imageNamed:[NSString stringWithFormat:@"%@_%@", str, key]];
    }
    
    return nil;
}
+ (UIColor *)setSkinColorWithStr:(NSString *)str
{
    NSDictionary * dict = nil;// [NSString getDicWithKey:@"Skin.plist"];
    if ([dict.allKeys containsObject:@"selectColor"])
    {
        NSString * key = [dict objectForKey:@"selectColor"];
        NSDictionary * dic = [dict objectForKey:key];
        NSString * colorStr = [dic objectForKey:@"color"];
//        return [UIColor sam_colorWithHex:colorStr];
    }
    return [UIColor clearColor];
}
@end
