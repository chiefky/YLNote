//
//  YLPerson.m
//  YLNote
//
//  Created by tangh on 2021/1/9.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLPerson.h"

@implementation YLPerson

+ (instancetype)personWithName:(NSString *)name birthday:(nonnull NSDate *)birthday {
    YLPerson *person = [[YLPerson alloc] init];
    person.name = name;
    person.birthday = birthday;
    person.gender = 0;
    return person;
}

/// 遵循NSCoping协议必须实现该方法
/// @param zone zone
- (id)copyWithZone:(NSZone *)zone {
    YLPerson *person = [[[self class] alloc] init]; // 注意此处是【self class】
    person.name = self.name;
    person.birthday = self.birthday;
    person.gender = self.gender;
    return person;
}
#pragma mark - hash方法重写
//- (NSUInteger)hash {
//    NSLog(@"hash = %@", self);
//    return [super hash];
//}

/// hash方法的最佳实践
- (NSUInteger)hash {
    NSUInteger hsh = [self.name hash] ^ [self.birthday hash];
    NSLog(@"hash = %ld", hsh);
    return hsh;
}

#pragma mark - 比较对象是否相等
- (BOOL)isEqual:(id)object {
    if (self == object) { // 判断是否是同一个对象
        return YES;
    }
    if (![object isKindOfClass:[YLPerson class]]) { // 判断是否是同一类型, 这样不仅可以提高判等的效率, 还可以避免隐式类型转换带来的潜在风险
        return NO;
    }
    
    return [self isEqualToPerson:object];
}

- (BOOL)isEqualToPerson:(YLPerson *)person {
    if (!person) {
        return NO;
    }
    
    BOOL equalName = (!self.name && !person.name) || [self.name isEqualToString:person.name];
    BOOL equalBirthday = (!self.birthday && !person.birthday) || [self.birthday isEqualToDate:person.birthday];
    BOOL equalGender = self.gender == person.gender;

    return equalName && equalBirthday && equalGender;
}


@end
