//
//  YLDinosaur.m
//  YLNote
//
//  Created by tangh on 2021/1/7.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLDinosaur.h"

@interface YLDinosaur ()

@end

@implementation YLDinosaur

+ (instancetype)dinosaurWithName:(NSString *)name superorder:(NSString *)superorder suborder:(NSString *)suborder subsuborder:(NSString *)subsuborder {
    YLDinosaur *dino = [[YLDinosaur alloc] init];
    dino.name = name;
    dino.superorder = superorder;
    dino.suborder = suborder;
    dino.subsuborder = subsuborder;
    return dino;
}


- (BOOL)isEqual:(id)object {
    if (self == object) { // 判断是否是同一个对象
        return YES;
    }
    if (![object isKindOfClass:[YLDinosaur class]]) { // 判断是否是同一类型, 这样不仅可以提高判等的效率, 还可以避免隐式类型转换带来的潜在风险
        return NO;
    }
    
    return [self isEqualToDinosaur:object];
}

- (BOOL)isEqualToDinosaur:(YLDinosaur *)dinosaur {
    if (!dinosaur) {
        return NO;
    }
    
    BOOL equalName = (!self.name && !dinosaur.name) || [self.name isEqualToString:dinosaur.name];
    BOOL equalSuperorder = (!self.superorder && !dinosaur.superorder) || [self.superorder isEqualToString:dinosaur.superorder];
    
    BOOL equalSuborder = (!self.suborder && !dinosaur.suborder) || [self.suborder isEqualToString:dinosaur.suborder];

    BOOL equalSubsuborder = (!self.subsuborder && !dinosaur.subsuborder) || [self.subsuborder isEqualToString:dinosaur.subsuborder];


    return equalName && equalSuperorder && equalSuborder && equalSubsuborder ;
}

- (NSUInteger)hash {
    NSUInteger hash = [super hash];
    NSLog(@"hash = %ld", hash);
    return hash;
}


- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    YLDinosaur *di = [[[self class] alloc] init];
    di.name = self.name;
    di.superorder = self.superorder;
    di.suborder = self.suborder;
    di.subsuborder = self.subsuborder;
    return di;
}

@end
