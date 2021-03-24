//
//  YLFileManager.m
//  YLNote
//
//  Created by tangh on 2021/1/11.
//  Copyright © 2021 tangh. All rights reserved.
//

#import "YLFileManager.h"

@implementation YLFileManager

@end

#pragma mark - 从 NSBundle 中读取资源文件
@implementation YLFileManager (NSBundle)


// 本地JSON文件-->NSDictionary
+ (id)jsonParseWithLocalFileName:(NSString *)name {
    // 对数据进行JSON格式化并返回字典形式
    NSData *data = [YLFileManager dataWithLocalFileName:name type:@"json"];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

// File --> NSData
+ (NSData *)dataWithLocalFileName:(NSString *)name type:(NSString *)type {
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    return data;
}

@end

@implementation YLFileManager (Sandbox)
+ (NSString *)sandboxHomePath {
    return NSHomeDirectory();
}

+ (NSString *)sandboxDoucumentPath {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
}

+ (NSString *)sandboxLibraryPath {
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
}

+ (NSString *)sandboxCachePath {
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
}

+ (NSString *)sandboxTmpPath {
    return NSTemporaryDirectory();
}

#pragma mark - 从 沙盒 中读取资源文件

/// 从沙盒中读取文件
/// @param filePath 沙盒中文件路径
+ (NSDictionary *)dictionaryWithLocalFilePath:(NSString *)filePath {
//    NSString *infoFilePath = [[YLFileManager sandboxDoucumentPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSError *error = nil;
    NSDictionary *dict = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:NULL error:&error];
    NSAssert([dict isKindOfClass:[NSDictionary class]], @"Should have read a dictionary object");
    NSAssert(error == nil, @"Should not have encountered an error");

    return  error == nil ? dict : @{};
}

#pragma mark - 向沙盒中写入数据

/// 向Cache中某个文件写入数据
/// @param towriteStr 数据
/// @param path 指定文件（如：test.plist）
+ (BOOL)writeData:(NSString *)towriteStr toCatcheWithFilePath:(NSString *)path {
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    NSDictionary *dict = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:NULL error:&error];
    NSAssert([dict isKindOfClass:[NSDictionary class]], @"Should have read a dictionary object");
    NSAssert(error == nil, @"Should not have encountered an error");
    if (error) {
        NSLog(@"%@",error.description);
        return NO;
    } else {
        NSError *writeError;
        NSData *data = [NSPropertyListSerialization dataWithPropertyList:dict format:NSPropertyListXMLFormat_v1_0 options:0 error:&writeError];
        NSAssert(error == nil, @"Should not have encountered an error");
        [data writeToFile:towriteStr atomically:YES];

    }
    
    return YES;
}


@end
