//
//  YLEncode.h
//  YLNote
//
//  Created by tangh on 2021/1/21.
//  Copyright © 2021 tangh. All rights reserved.
//

#ifndef YLEncode_h
#define YLEncode_h

#define YLENCODE_DECODER() \
- (void)encodeWithCoder:(nonnull NSCoder *)coder { \
    Class cls = [self class]; \
    while (cls != [NSObject class]) { \
        BOOL isSelfClass = (cls == [self class]); \
        unsigned int iVarCount = 0; \
        unsigned int propertyCount = 0; \
        unsigned int sharedVarCount = 0; \
        Ivar *ivarList = isSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL; \
        objc_property_t *propertyList = isSelfClass ? NULL : class_copyPropertyList(cls, &propertyCount); \
        sharedVarCount = isSelfClass ? iVarCount : propertyCount; \
         \
        for (int i = 0; i < sharedVarCount; i++) { \
            const char *varName = isSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propertyList + i)); \
            NSString *key = [NSString stringWithUTF8String:varName]; \
            id varValue = [self valueForKey:key]; \
            NSArray *filters = @[@"superclass", @"description", @"debugDescription", @"hash"]; \
            if (varValue && [filters containsObject:key] == NO) { \
                [coder encodeObject:varValue forKey:key]; \
            } \
        } \
        free(ivarList); \
        free(propertyList); \
        cls = class_getSuperclass(cls); \
    } \
} \
\
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder { \
    Class cls = [self class]; \
    while (cls != [NSObject class]) { \
        BOOL isSelfClass = (cls == [self class]); \
        unsigned int iVarCount = 0; \
        unsigned int propertyCount = 0; \
        unsigned int sharedVarCount = 0; \
        Ivar *ivarList = isSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL; \
        objc_property_t *propertyList = isSelfClass ? NULL : class_copyPropertyList(cls, &propertyCount); \
        sharedVarCount = isSelfClass ? iVarCount : propertyCount; \
        \
        for (int i = 0; i < sharedVarCount; i++) { \
            const char *varName = isSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propertyList + i)); \
            NSString *key = [NSString stringWithUTF8String:varName]; \
            id varValue = [self valueForKey:key]; \
            NSArray *filters = @[@"superclass", @"description", @"debugDescription", @"hash"]; \
            if (varValue && [filters containsObject:key] == NO) { \
                [self setValue:varValue forKey:key]; \
            } \
        } \
        free(ivarList); \
        free(propertyList); \
        cls = class_getSuperclass(cls); \
    } \
    return self; \
}

#define YLENCODE_DESCRIPTION() \
\
/* 用来打印本类的所有变量(成员变量+属性变量)，所有层级父类的属性变量及其对应的值 */  \
- (NSString *)description   \
{   \
    NSString  *despStr = @"";   \
    Class cls = [self class];   \
    while (cls != [NSObject class]) {   \
        /*判断是自身类还是父类*/  \
        BOOL bIsSelfClass = (cls == [self class]);  \
        unsigned int iVarCount = 0; \
        unsigned int propVarCount = 0;  \
        unsigned int sharedVarCount = 0;    \
        Ivar *ivarList = bIsSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL;/*变量列表，含属性以及私有变量*/   \
        objc_property_t *propList = bIsSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount);/*属性列表*/   \
        sharedVarCount = bIsSelfClass ? iVarCount : propVarCount;   \
        \
        for (int i = 0; i < sharedVarCount; i++) {  \
            const char *varName = bIsSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propList + i)); \
            NSString *key = [NSString stringWithUTF8String:varName];    \
            /*valueForKey只能获取本类所有变量以及所有层级父类的属性，不包含任何父类的私有变量(会崩溃)*/  \
            id varValue = [self valueForKey:key];   \
            NSArray *filters = @[@"superclass", @"description", @"debugDescription", @"hash"]; \
            if (varValue && [filters containsObject:key] == NO) { \
                despStr = [despStr stringByAppendingString:[NSString stringWithFormat:@"%@: %@\n", key, varValue]]; \
            }   \
        }   \
        free(ivarList); \
        free(propList); \
        cls = class_getSuperclass(cls); \
    }   \
    return despStr; \
}

/* 封装归档keyedArchiver操作 */
#define YLENCODE_ARCHIVE(__objToBeArchived__, __key__, __filePath__)    \
\
NSMutableData *data = [NSMutableData data]; \
NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];   \
[archiver encodeObject:__objToBeArchived__ forKey:__key__];    \
[archiver finishEncoding];  \
[data writeToFile:__filePath__ atomically:YES]


/* 封装反归档keyedUnarchiver操作 */
#define YLENCODE_UNARCHIVE(__objToStoreData__, __key__, __filePath__)   \
NSMutableData *dedata = [NSMutableData dataWithContentsOfFile:__filePath__]; \
NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dedata];  \
__objToStoreData__ = [unarchiver decodeObjectForKey:__key__];  \
[unarchiver finishDecoding]

/**(序列化&反序列化)背景及解决方案
 // 序列化： 将数据结构或对象转换成二进制串的过程。
 // 反序列化：将在序列化过程中所生成的二进制串转换成数据结构或者对象的过程。
 
 在iOS中一个自定义对象是无法直接存入到文件中的，必须先转化成二进制流才行。从对象到二进制数据的过程我们一般称为对象的序列化(Serialization)，也称为归档(Archive)。同理，从二进制数据到对象的过程一般称为反序列化或者反归档。
 在序列化实现中不可避免的需要实现NSCoding以及NSCopying(非必须)协议的以下方法：

 - (id)initWithCoder:(NSCoder *)coder;
 - (void)encodeWithCoder:(NSCoder *)coder;
 - (id)copyWithZone:(NSZone *)zone;
 
 似乎so easy？至少到目前为止是这样的。但是请考虑以下问题：

 若Person是个很大的类，有非常多的变量需要进行encode/decode处理呢？
 若你的工程中有很多像Person的自定义类需要做序列化操作呢？
 若Person不是直接继承自NSObject而是有多层的父类呢？(请注意，序列化的原则是所有层级的父类的属性变量也要需要序列化)；
 如果采用开始的传统的序列化方式进行序列化，在碰到以上问题时容易暴露出以下缺陷(仅仅是缺陷，不能称为问题)：

 工程代码中冗余代码很多
 父类层级复杂容易导致遗漏点一些父类中的属性变量
 那是不是有更优雅的方案来回避以上问题呢？那是必须的。这里我们将共同探讨使用runtime来实现一种接口简洁并且十分通用的iOS序列化与反序列方案。

 */
/**
 结论：
 如果需要一个稳定、功能强大的 Model 框架，Mantle 是最佳选择，它唯一的缺点就是性能比较差。 如果对功能要求并不多，但对性能有更高要求时，可以试试我的 YYModel。
 Swift 相关的几个库性能都比较差，非 Swift 项目不推荐使用。
 最后提一句，如果对性能、网络流量等有更高的要求，就不要再用 JSON 了，建议改用 protobuf/FlatBuffers 这样的方案。JSON 转换再怎么优化，在性能和流量方面还是远差于二进制格式的。
 */


///// 归档写入文件
///// @param key key
///// @param object 待归档对象（必须实现nNSCoding协议）
///// @param path 待写入文件路径
//+ (void)yl_archiveObjWithkey:(NSString *)key obj:(id)object toFile:(NSString *)path {
//    NSMutableData *data = [NSMutableData data];
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//    [archiver encodeObject:object forKey:key];
//    [archiver finishEncoding];
//    [data writeToFile:path atomically:YES];
//}
//
///// 反归档读取obj
///// @param key key
///// @param path 文件路径
//
//+ (id)yl_unarchiveObjWithkey:(NSString *)key toFile:(NSString *)path {
//
//    NSMutableData *dedata = [NSMutableData dataWithContentsOfFile:path];
//    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dedata];
//    id object = [unarchiver decodeObjectForKey:key];
//    [unarchiver finishDecoding];
//    return object;
//}



#endif /* YLEncode_h */
